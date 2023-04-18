Scriptname SE_ScaleManager_Script extends SE_MainQuest_Script
{Inflate/Deflate and other effects related to scale}

import SLIF_Main

;/// Variables ///;
    float rawBreastSize ; The size of breasts without minSize
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

        If (Config.enableBreastScaling)
            breastSize = rawBreastSize + Config.breastMinSize
        Else
            breastSize = -1.0 ; Unregister
        EndIf
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

        ;FIXME: This doesn't work well after waiting/sleep
        If (Storage.HasSouls())
            ; Inflation/Growth
            If (Config.dbg)
                Debug.Notification("SEater: Breasts growing")
            EndIf

            If (rawBreastSize < Config.maxBreastSize)
                float growthRate = Config.breastIncrementValue * timePast
                rawBreastSize += growthRate
            Else
                If (Config.dbg)
                    Debug.Notification("SEater: Breasts at max size!")
                EndIf

                rawBreastSize = Config.maxBreastSize ; for caping size in case of adjusts mid size
            EndIf
        Else
            ; Deflation/Shrinkage
            If (Config.dbg)
                Debug.Notification("SEater: Breasts shrinking")
            EndIf

            If (rawBreastSize > 0.0)
                float shrinkRate = Config.breastDecrementValue * timePast
                rawBreastSize -= shrinkRate
            Else
                If (Config.dbg)
                    Debug.Notification("SEater: Breasts at normal size.")
                EndIf

                rawBreastSize = 0.0
            EndIf
        EndIf
        
        If (Config.enableBreastScaling)
            breastSize = rawBreastSize + Config.breastMinSize
        Else
            breastSize = -1.0 ; Unregister
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