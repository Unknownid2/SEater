Scriptname SE_ScaleManager_Script extends SE_MainQuest_Script
{Inflate/Deflate and other effects related to scale}

import SLIF_Main

;/// Variables ///;
bool inflateBreasts
float currentBellySize
float currentBreastSize
float normalBreastSize ; The size of breasts without minSize

;/// Properties ///;
float Property bellySize Hidden
    float Function Get()
        return currentBellySize
    EndFunction

    Function Set(float value)
        ;TODO: Scaling methods
        If (value > Config.bellyMinSize)
            currentBellySize = UpdateBelly(value)
        Else
            currentBellySize = Config.bellyMinSize
            If (IsRegistered(PlayerRef, Config.ModName))
                UnregisterNode(PlayerRef, "slif_belly", Config.ModName)

                if(Config.dbg)
                    Debug.Notification("SEater: Belly scale disabled or bellow min")
                    Debug.Notification("belly node unregistered.")
                endif
            EndIf
        EndIf
    EndFunction
EndProperty

float Property breastSize Hidden
    float Function Get()
        return currentBreastSize
    EndFunction

    Function Set(float value)
        If (value > Config.breastMinSize)
            currentBreastSize = UpdateBreast(value)
        Else
            currentBreastSize = Config.breastMinSize
            If (IsRegistered(PlayerRef, Config.ModName))
                UnregisterNode(PlayerRef, "slif_breast", Config.ModName)

                if(Config.dbg)
                    Debug.Notification("SEater: Breast scale disabled or bellow min")
                    Debug.Notification("breast node unregistered.")
                endif
            EndIf
        EndIf
    EndFunction
EndProperty

;/// Functions ///;

    ; Check and update node scales
    Function UpdateScale()
        if(Config.dbg)
            Debug.Notification("SEater: Checking size values...")
        endif

        If (Config.enableBellyScaling)
            float capacityUsage = Storage.GetCapacityUsage()
            float newValue = 0.0
            If (capacityUsage > 0)
                newValue = capacityUsage / 100
                newValue *= Config.maxBellySize
                newValue += Config.bellyMinSize
                bellySize = newValue
            Else
                bellySize = Config.bellyMinSize
            EndIf
        Else
            bellySize = -1.00
        EndIf

        inflateBreasts = Storage.GetNumberOfSouls() > 0 && Config.enableBreastScaling
    EndFunction

    ; Updates belly node within slif, then returns the new value
    float Function UpdateBelly(float newSize)
        float increment
        If (newSize > currentBellySize)
            parent.OnGrowth()
            increment = (newSize - currentBellySize) * 0.1
        ElseIf (newSize < currentBellySize)
            parent.OnShrink()
            increment = (currentBellySize - newSize) * 0.1
        EndIf

        If (Config.dbg)
            Debug.Notification("SEater: Updating belly")
            Debug.Notification("Value = " + newSize)
            Debug.Notification("Increment = " + increment)
        EndIf

        Inflate(PlayerRef, Config.ModName, "slif_belly", newSize, -1, -1, "", -1.0, -1.0, Config.bellyMultiplier, increment)
        return newSize
    EndFunction

    ; Updates breast nodes withing slif, then returns the new value
    float Function UpdateBreast(float newSize)
        If (Config.dbg)
            Debug.Notification("SEater: Updating breast")
            Debug.Notification("Value = " + newSize)
        EndIf

        Inflate(PlayerRef, Config.ModName, "slif_breast", newSize, -1, -1, "", -1.0, -1.0, Config.breastMultiplier)
        return newSize
    EndFunction

;/// Events ///;
    Event OnTimerUpdate(float timePast)
        If (Config.dbg)
            Debug.Notification("SEater: TimerUpdate(Scale) + " + timePast)
        EndIf

        float newValue = 0.0

        If (inflateBreasts)
            If (Config.dbg)
                Debug.Notification("SEater: breasts growing")
            EndIf

            ; Inflation/Growth
            If (breastSize < Config.maxBreastSize + Config.breastMinSize) ; fixed: max scales are count above min size*
                newValue = Config.breastIncrementValue
                newValue *= timePast
                newValue += normalBreastSize ; Use the value without minSize instead
                normalBreastSize = newValue ; Then update before applying minSize
                newValue += Config.breastMinSize
                breastSize = newValue
            Else
                If (Config.dbg)
                    Debug.Notification("SEater: breasts at max size!")
                EndIf

                breastSize = Config.maxBreastSize + Config.breastMinSize
            EndIf
        ElseIf (Config.enableBreastScaling)
            If (Config.dbg)
                Debug.Notification("SEater: breasts shrinking")
            EndIf

            ; Deflation/Shrinkage
            If (breastSize > Config.breastMinSize)
                newValue = Config.breastDecrementValue
                newValue *= timePast
                newValue = normalBreastSize - newValue ; Use the value without minSize instead
                normalBreastSize = newValue ; Then update before applying minSize
                newValue += Config.breastMinSize
                breastSize = newValue
            Else
                If (Config.dbg)
                    Debug.Notification("SEater: breasts back to normal size.")
                EndIf

                breastSize = Config.breastMinSize
            EndIf
        Else
            breastSize = -1.00
        EndIf
    EndEvent

    Event OnGrowth()
        if(Config.dbg)
            Debug.Notification("SEater: OnGrowth(Scale)")
        endif
    EndEvent

    Event OnShrink()
        if(Config.dbg)
            Debug.Notification("SEater: OnShrink(Scale)")
        endif
    EndEvent