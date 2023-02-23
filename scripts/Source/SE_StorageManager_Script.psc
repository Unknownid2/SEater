Scriptname SE_StorageManager_Script extends SE_MainQuest_Script
{Add/remove souls, Manage souls and gatter storage data}

    ;/// Properties ///;
    MagicEffect Property StorageEffect Auto
    Spell Property StorageSpell Auto

    GlobalVariable[] Property iNumberOfSouls Auto
    {Total number of souls (index 0-4 = petty-grand)}

    GlobalVariable Property fMaxCapacity Auto
    {The max amount of souls charge which can be hold inside caster body}

    GlobalVariable Property iStorageMode Auto
    {What happening with unclaimed stored souls (1= Digest, 2= Gestation)}

    ;/// Variables ///;
    float targetSynergy ; Used to track gestation at Gestate()

    ;/// Functions ///;

    ; Return total number of stored souls
    int Function GetNumberOfSouls()
        int totalNumberOfSouls = 0
        int index = 0
        While (index < iNumberOfSouls.Length)
            totalNumberOfSouls += iNumberOfSouls[index].GetValue() as int
            index += 1
        EndWhile

        return totalNumberOfSouls
    endFunction

    ; Return the weakest stored soul (or 0 if empty)
    int Function GetWeakest()
        int index = 0
        While (index < iNumberOfSouls.Length && iNumberOfSouls[index].GetValue() == 0)
            index += 1
        EndWhile

        If (index > 4)
            return 0
        EndIf

        if(Config.bDbg.GetValue() > 0)
            Debug.Notification("SEater: " + (index + 1) + " is the weakest soul inside player")
        endIf

        return index + 1
    EndFunction

    ; Return the strongest stored soul (or 0 if empty)
    int Function GetStrongest()
        int index = 4
        While (index >= 0 && iNumberOfSouls[index].GetValue() == 0)
            index -= 1
        EndWhile

        if(Config.bDbg.GetValue() > 0)
            Debug.Notification("SEater: " + (index + 1) + " is the strongest soul inside player")
        endIf

        return index + 1
    EndFunction

    ; Return total stored soul charge level
    float Function GetTotalChargeLevel()
        float totalChargeLevel = 0
        int index = 0
        While (index < iNumberOfSouls.Length)
            totalChargeLevel += iNumberOfSouls[index].GetValue() * GetSoulChargeBySize(index + 1)
            index += 1
        EndWhile

        return totalChargeLevel
    endFunction

    ; Returns capacity usage (0-100)
    float Function GetCapacityUsage()
        float storageUsage = GetTotalChargeLevel()
        float maxCapacity = fMaxCapacity.GetValue()
        return (storageUsage / maxCapacity) * 100
    EndFunction

    ; Add a single soul of given size inside caster
    Function AddSoul(int soulSize)
        iNumberOfSouls[soulSize - 1].Mod(1)
    endFunction

    ; Remove a single soul of given size from caster
    Function RemoveSoul(int soulSize)
        iNumberOfSouls[soulSize - 1].Mod(-1)
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
            
            fSynergyLevel.mod(2.5)
            if(Config.bDbg.GetValue() > 0)
                Debug.Notification("SEater: Digest proceeds")
            endIf
        elseif(Config.bDbg.GetValue() > 0)
            Debug.Notification("SEater: failed to digest. Player's womb is empty")
        endIf
    EndFunction

    ; Grows up souls using synergy. Return true if results in labor
    bool Function Gestate()
        int targetSoul = GetWeakest()
        bool dbg = Config.bDbg.GetValue() as bool
        if(targetSoul > 0)
            float targetSoulCharge = GetSoulChargeBySize(targetSoul)
            float synergy = fSynergyLevel.GetValue()
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
                    
                    if(dbg)
                        Debug.Notification("SEater: Gestation proceeds")
                    endIf
                Else
                    if(dbg)
                        Debug.Notification("SEater: Gestation ends")
                    endIf
                    return true
                endIf

                ; Target synergy will be reset after gestation progress/end (even if 10x higher than last processed soul)
                targetSynergy = 0
            elseif(dbg)
                Debug.Notification("SEater: Gestation hold")
            endIf

            fSynergyLevel.SetValue(synergy)
        elseif(dbg)
            Debug.Notification("SEater: Failed to gestate, there no souls to grow.")
        endIf

        return false
    EndFunction

    ;/// Events ///;

    ; Called when a new soul are absorbed successfully
    Event OnSoulAbsorbed(int absorbedSoulSize)
        if(Config.bDbg.GetValue() > 0)
            Debug.Notification("SEater: OnSoulAbsorbed")
        endif

        AddSoul(absorbedSoulSize)
        if(!PlayerRef.HasMagicEffect(StorageEffect))
            PlayerRef.AddSpell(StorageSpell)
        endIf

        ;TODO: Check if absorbedSoulSize exets storage capacity
    EndEvent

    ; Called while StorageEffect are active on player
    Event OnStorageUpdate(float updateLoops)
        if(Config.bDbg.GetValue() > 0)
            Debug.Notification("SEater: OnStorageUpdate")
            Debug.Notification("Processing " + updateLoops + " Updates")
        endif

        If (iStorageMode.GetValue() == 1)
            while(updateLoops > 1)
                Digest()
                updateLoops -= 1
            EndWhile

            if(fSynergyLevel.GetValue() > fMaxSynergy.GetValue())
                fMaxSynergy.SetValue(fSynergyLevel.GetValue())
            endIf
        else
            bool inLabor
            while(updateLoops > 1)
                inLabor = Gestate()
                updateLoops -= 1
            EndWhile

            if(inLabor)
                ;TODO: Gestation Finish (birth all souls)
                if(Config.bDbg.GetValue() > 0)
                    Debug.Notification("SEater: Not enough synergy, advancing to labor...")
                    Debug.Notification("Not Implemented yet!")
                endif    
            endIf
        EndIf
    EndEvent

    ;TODO: Called after successfully dispel a soul to a soul gem
    Event OnSoulExpeled(int expeledSoulSize)
        if(Config.bDbg.GetValue() > 0)
            Debug.Notification("SEater: OnSoulExpeled")
        endif
        RemoveSoul(expeledSoulSize)
    EndEvent