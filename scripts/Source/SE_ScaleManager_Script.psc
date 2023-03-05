Scriptname SE_ScaleManager_Script extends SE_MainQuest_Script
{Inflate/Deflate and other effects related to scale}

;/// Properties ///;

;/// Variables ///;
float bellyMultiplier
float breastMultiplier
float buttMultiplier

;/// Functions ///;

    ; Update nodes scaling with their respective scaling vars
    Function UpdateScale()
        if(Config.dbg)
            Debug.Notification("SEater: Updating scales...")
        endif

        ;TODO: Scaling methods
        if(Config.bellyScalingVar == "Soul charge level")
            UpdateBelly(Storage.GetTotalChargeLevel())
        elseif(Config.bellyScalingVar == "Synergy level")
            UpdateBelly(Config.synergyLevel)
        elseif(Config.bellyScalingVar == "Mode progress")
            ;TODO: Digest/Gestation progress
        elseif(Config.bellyScalingVar == "Max charge level")
            UpdateBelly(Config.maxCapacity)
        elseif(Config.bellyScalingVar == "Max synergy level")
            UpdateBelly(Config.maxSynergy)
        Else
            UpdateBelly(-1) ; For unregistering this node
        endIf
        
        if(Config.breastScalingVar == "Soul charge level")
            UpdateBreast(Storage.GetTotalChargeLevel())

        elseif(Config.breastScalingVar == "Synergy level")
            UpdateBreast(Config.synergyLevel)
        elseif(Config.breastScalingVar == "Mode progress")
            ;TODO: Digest/Gestation progress
        elseif(Config.breastScalingVar == "Max charge level")
            UpdateBreast(Config.maxCapacity)
        elseif(Config.breastScalingVar == "Max synergy level")
            UpdateBreast(Config.maxSynergy)
        Else
            UpdateBreast(-1) ; For unregistering this node
        endIf

        if(Config.buttScalingVar == "Soul charge level")
            UpdateButt(Storage.GetTotalChargeLevel())
        elseif(Config.buttScalingVar == "Synergy level")
            UpdateButt(Config.synergyLevel)
        elseif(Config.buttScalingVar == "Mode progress")
            ;TODO: Digest/Gestation progress
        elseif(Config.buttScalingVar == "Max charge level")
            UpdateButt(Config.maxCapacity)

        elseif(Config.buttScalingVar == "Max synergy level")
            UpdateButt(Config.maxSynergy)
        Else
            UpdateButt(-1) ; For unregistering this node
        endIf
    EndFunction

    ; Updates belly node by passed value
    Function UpdateBelly(float referenceValue)
        if(referenceValue < 0)
            SLIF_Main.unregisterNode(PlayerRef, "slif_belly", Config.ModName)

            if(Config.dbg)
                Debug.Notification("initial ref value < 0: belly node unregistered")
            endif
        else
            if(Config.dbg)
                Debug.Notification("Updating belly node, initial ref: " + referenceValue)
            endif

            bellyMultiplier = Config.bellyMultiplier

            if(Config.scaleBellyMultiplier)
                int index = 0
                While (index < Storage.GetNumberOfSouls())
                    bellyMultiplier *= (Config.multiplierScalePorcentage - 100) * -0.01
                    index += 1
                EndWhile
            EndIf

            referenceValue -= Config.bellyScalingStart
            referenceValue *= bellyMultiplier
            referenceValue += Config.bellyScaleOffset

            if(Config.dbg)
                Debug.Notification("Result ref: " + referenceValue)
            endif

            if(referenceValue < 0)
                referenceValue = 0 ; can't be below 0

                if(Config.dbg)
                    Debug.Notification("ref value fixed to 0")
                endif
            endif

            SLIF_Main.Inflate(PlayerRef, Config.ModName, "slif_belly", referenceValue)
        endif
    EndFunction

    ; Updates breasts node by passed value
    Function UpdateBreast(float referenceValue)
        if(referenceValue < 0)
            SLIF_Main.unregisterNode(PlayerRef, "slif_breast", Config.ModName)

            if(Config.dbg)
                Debug.Notification("initial ref value < 0: breast node unregistered")
            endif
        else
            if(Config.dbg)
                Debug.Notification("Updating breast node, initial ref: " + referenceValue)
            endif

            breastMultiplier = Config.breastMultiplier

            if(Config.scaleBreastMultiplier)
                
                int index = 0
                While (index < Storage.GetNumberOfSouls())
                    breastMultiplier *= (Config.multiplierScalePorcentage - 100) * -0.01
                    index += 1
                EndWhile
            EndIf

            referenceValue -= Config.breastScalingStart
            referenceValue *= breastMultiplier
            referenceValue += Config.breastScaleOffset

            if(Config.dbg)
                Debug.Notification("Result ref: " + referenceValue)
            endif
        
            if(referenceValue < 0)
                referenceValue = 0 ; can't be below 0

                if(Config.dbg)
                    Debug.Notification("ref value fixed to 0")
                endif
            endif

            SLIF_Main.Inflate(PlayerRef, Config.ModName, "slif_breast", referenceValue)
        endif
    EndFunction

    ; Updates butt node by passed value
    Function UpdateButt(float referenceValue)
        if(referenceValue < 0)
            SLIF_Main.unregisterNode(PlayerRef, "slif_butt", Config.ModName)

            if(Config.dbg)
                Debug.Notification("initial ref value < 0: butt node unregistered")
            endif
        else
            if(Config.dbg)
                Debug.Notification("Updating butt node, initial ref: " + referenceValue)
            endif

            buttMultiplier = Config.buttMultiplier

            if(Config.scaleButtMultiplier)
                
                int index = 0
                While (index < Storage.GetNumberOfSouls())
                    buttMultiplier *= (Config.multiplierScalePorcentage - 100) * -0.01
                    index += 1
                EndWhile
            EndIf

            referenceValue -= Config.buttScalingStart
            referenceValue *= buttMultiplier
            referenceValue += Config.buttScaleOffset

            if(Config.dbg)
                Debug.Notification("Result ref: " + referenceValue)
            endif
        
            if(referenceValue < 0)
                referenceValue = 0 ; can't be below 0

                if(Config.dbg)
                    Debug.Notification("ref value fixed to 0")
                endif
            endif

            SLIF_Main.Inflate(PlayerRef, Config.ModName, "slif_butt", referenceValue)
        endif
    EndFunction

;/// Events ///;
    ;/.../;