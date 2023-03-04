Scriptname SE_ScaleManager_Script extends SE_MainQuest_Script
{Inflate/Deflate and other effects related to scale}

;/// Properties ///;
    SLIF_Main Property slif Auto

;/// Variables ///;
    ;/.../;

;/// Functions ///;

    ; Update nodes scaling with their respective scaling vars
    Function UpdateScale()
        ;TODO: Scaling methods
        ;TODO: slif.Inflate()
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

        endIf
    EndFunction

    ; Updates belly node by passed value
    Function UpdateBelly(float referenceValue)
    EndFunction

    ; Updates breasts node by passed value
    Function UpdateBreast(float referenceValue)
    EndFunction

    ; Updates butt node by passed value
    Function UpdateButt(float referenceValue)
    EndFunction

;/// Events ///;
    ;/.../;