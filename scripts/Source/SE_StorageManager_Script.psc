Scriptname SE_StorageManager_Script extends SE_MainQuest_Script
{Add/remove souls, Manage souls and gatter storage data}

;/// Properties ///;
    MagicEffect Property StorageEffect Auto
    Spell Property StorageSpell Auto

;/// Variables ///;
    float targetSynergy ; Used to track gestation at Gestate()

;/// Functions ///;

    ; Return total number of stored souls
    int Function GetNumberOfSouls()
        int totalNumberOfSouls = 0

        int index = 0
        While (index < Config.numberOfSouls.Length)
            totalNumberOfSouls += Config.numberOfSouls[index]
            index += 1
        EndWhile

        return totalNumberOfSouls
    endFunction

    ; Return the weakest stored soul (or 0 if empty)
    int Function GetWeakest()

        int index = 0
        While (index < Config.numberOfSouls.Length && Config.numberOfSouls[index] == 0)
            index += 1
        EndWhile

        If (index > 4)
            return 0
        EndIf

        if(Config.dbg)
            Debug.Notification("SEater: " + (index + 1) + " is the weakest soul inside player")
        endIf

        return index + 1
    EndFunction

    ; Return the strongest stored soul (or 0 if empty)
    int Function GetStrongest()
        int index = 4
        While (index >= 0 && Config.numberOfSouls[index] == 0)
            index -= 1
        EndWhile

        if(Config.dbg)
            Debug.Notification("SEater: " + (index + 1) + " is the strongest soul inside player")
        endIf

        return index + 1
    EndFunction

    ; Return total stored soul charge level
    float Function GetTotalChargeLevel()
        float totalChargeLevel = 0
        int index = 0
        While (index < Config.numberOfSouls.Length)
            totalChargeLevel += Config.numberOfSouls[index] * GetSoulChargeBySize(index + 1)
            index += 1
        EndWhile

        return totalChargeLevel
    endFunction

    ; Returns capacity usage (0-100)
    float Function GetCapacityUsage()
        float storageUsage = GetTotalChargeLevel()

        If (storageUsage > 0)
            return (storageUsage / Config.maxCapacity) * 100
        Else
            return storageUsage
        EndIf
    EndFunction

    ; Add a single soul of given size inside caster
    Function AddSoul(int soulSize)
        Config.numberOfSouls[soulSize - 1] = Config.numberOfSouls[soulSize - 1] + 1
    endFunction

    ; Remove a single soul of given size from caster
    Function RemoveSoul(int soulSize)
        Config.numberOfSouls[soulSize - 1] = Config.numberOfSouls[soulSize - 1] - 1
    EndFunction

    ; Digest weakest soul, rechargin synergy. The remains of the soul returns to player in small sizes
    Function Digest()
        int targetSoul = GetWeakest()
        targetSynergy = 0 ; Resets if switch from gestation to digest!
        if(targetSoul > 0)
            RemoveSoul(targetSoul)
            While (targetSoul > 1)
                If(targetSoul == 5)
                    RemoveSoul(3)
                endIf
                
                targetSoul -= 1
                AddSoul(targetSoul)
            EndWhile
            
            Config.synergyLevel += 2.5
            if(Config.dbg)
                Debug.Notification("SEater: Digest proceeds")
            endIf
        elseif(Config.dbg)
            Debug.Notification("SEater: failed to digest. Player's womb is empty")
        endIf
    EndFunction

    ; Grows up souls using synergy. Return true if results in labor
    bool Function Gestate()
        int targetSoul = GetWeakest()
        if(targetSoul > 0)
            float targetSoulCharge = GetSoulChargeBySize(targetSoul)
            float synergy = Config.synergyLevel
            targetSynergy += 2.5
            if(targetSynergy >= targetSoulCharge)
                if(synergy >= targetSynergy || synergy >= 10.00 && targetSoul < 5)
                    RemoveSoul(targetSoul)
                    AddSoul(targetSoul + 1)
                    if(targetSoul == 4)
                        synergy -= 10.00
                    else
                        synergy -= targetSoulCharge
                    endIf
                    
                    if(Config.dbg)
                        Debug.Notification("SEater: Gestation proceeds")
                    endIf
                Else
                    if(Config.dbg)
                        Debug.Notification("SEater: Gestation ends")
                    endIf
                    return true
                endIf

                ; Target synergy will be reset after gestation progress/end (even if 10x higher than last processed soul)
                targetSynergy = 0
            elseif(Config.dbg)
                Debug.Notification("SEater: Gestation hold")
            endIf

            Config.synergyLevel = synergy
        elseif(Config.dbg)
            Debug.Notification("SEater: Failed to gestate, there no souls to grow.")
        endIf

        return false
    EndFunction

;/// Events ///;

    ; Called when a new soul are absorbed successfully
    Event OnSoulAbsorbed(int absorbedSoulSize)

        if(Config.dbg)
            Debug.Notification("SEater: OnSoulAbsorbed(Storage)")
        endif

        AddSoul(absorbedSoulSize)
        if(!PlayerRef.HasMagicEffect(StorageEffect))
            PlayerRef.AddSpell(StorageSpell)
        endIf

        ;TODO: Check if absorbedSoulSize exets storage capacity
        Scale.UpdateScale()
    EndEvent

    ; Called while StorageEffect are active on player
    Event OnStorageUpdate(float updateLoops)
        if(Config.dbg)
            Debug.Notification("SEater: OnStorageUpdate")
            Debug.Notification("Processing " + updateLoops + " Updates")
        endif

        If (Config.storageMode == 1)
            while(updateLoops > 1)
                Digest()
                updateLoops -= 1
            EndWhile

            Scale.UpdateScale()

            if(Config.synergyLevel > Config.maxSynergy)
                Config.maxSynergy = Config.synergyLevel
            endIf
        elseif (Config.storageMode == 2)
            bool inLabor
            while(updateLoops > 1)
                inLabor = Gestate()
                updateLoops -= 1
            EndWhile

            Scale.UpdateScale()

            if(inLabor)
                ;TODO: Gestation Finish (birth all souls)
                if(Config.dbg)
                    Debug.Notification("SEater: Not enough synergy, advancing to labor...")
                    Debug.Notification("Not Implemented yet!")
                endif    
            endIf
        EndIf
    EndEvent

    ;TODO: Called after successfully dispel a soul to a soul gem
    Event OnSoulExpeled(int expeledSoulSize)
        if(Config.dbg)
            Debug.Notification("SEater: OnSoulExpeled")
        endif
        RemoveSoul(expeledSoulSize)
        Scale.UpdateScale()
    EndEvent