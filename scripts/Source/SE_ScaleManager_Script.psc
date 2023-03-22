Scriptname SE_ScaleManager_Script extends SE_MainQuest_Script
{Inflate/Deflate and other effects related to scale}

import SLIF_Main

;/// Variables ///;
    bool inflateBreasts
    float normalBreastSize ; The size of breasts without minSize
    float diffSize ; The difference between current belly size and new belly size
    float targetSize ; The target belly size for slow interpolation
    
;/// Properties ///;
    float currentBellySize
    float Property bellySize Hidden
        float Function Get()
            return currentBellySize
        EndFunction

        Function Set(float value)
            ;TODO: Scaling methods
            If (value > Config.bellyMinSize)
                If (value > currentBellySize)
                    parent.OnGrowth()
                ElseIf (value < currentBellySize)
                    parent.OnShrink()
                EndIf

                targetSize = value
                UpdateBelly()
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

    float currentBreastSize
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

    ; Updates belly node within slif, then update currentBellySize
    Function UpdateBelly()
        diffSize = targetSize - currentBellySize

        If (diffSize > 0.1)
            currentBellySize += 0.1
            RegisterForSingleUpdate(0.33)
        ElseIf (diffSize < -0.1)
            currentBellySize -= 0.1
            RegisterForSingleUpdate(0.33)
        Else
            currentBellySize = targetSize

            If (Config.dbg)
                Debug.Notification("SEater: Belly updated")
                Debug.Notification("Final size = " + targetSize)
            EndIf
        EndIf

        Inflate(PlayerRef, Config.ModName, "slif_belly", currentBellySize * Config.bellyMultiplier)
    EndFunction

    ; Updates breast nodes withing slif, then returns the new value
    float Function UpdateBreast(float newSize)
        If (Config.dbg)
            Debug.Notification("SEater: Updating breasts")
            Debug.Notification("Value = " + newSize)
        EndIf

        Inflate(PlayerRef, Config.ModName, "slif_breast", newSize * Config.breastMultiplier)
        return newSize
    EndFunction

;/// Events ///;
    Event OnUpdate()
        If (self != none)
            UpdateBelly()
        EndIf
    EndEvent
    
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