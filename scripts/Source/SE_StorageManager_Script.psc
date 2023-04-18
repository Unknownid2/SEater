Scriptname SE_StorageManager_Script extends SE_MainQuest_Script
{Add/remove souls, Manage souls and gatter storage data}

;/// Properties ///;
    MagicEffect Property StorageEffect Auto
    Spell Property StorageSpell Auto
    float Property synergyLevel Auto Hidden
    float Property maxSynergy Auto Hidden

    ;TODO: The mode can be changed at soul stone once per day or at end of previous mode.
    int Property storageMode Auto Hidden
    int[] Property numberOfSouls Auto

;/// Entries ///;
    string[] Property StorageModes Auto
        int Property StorageModes_Disabled = 0 AutoReadOnly Hidden
        int Property StorageModes_Digest = 1 AutoReadOnly Hidden
        int Property StorageModes_Gestation = 2 AutoReadOnly Hidden

;/// Variables ///;
    float targetSynergy ; Used to track gestation at Gestate()

;/// Functions ///;

    ; Return true if has any soul remaining
    bool Function HasSouls()
        int index = 0
        While (index < numberOfSouls.Length)
            If (numberOfSouls[index] > 0)
                index = numberOfSouls.Length
                return true
            EndIf

            index += 1
        EndWhile
        return false
    EndFunction

    ; Return total number of stored souls
    int Function GetNumberOfSouls()
        If (HasSouls())
            int totalNumberOfSouls = 0
            int index = 0
            While (index < numberOfSouls.Length)
                totalNumberOfSouls += numberOfSouls[index]
                index += 1
            EndWhile

            return totalNumberOfSouls
        Else
            return 0
        EndIf
    endFunction

    ; Return the weakest stored soul (or 0 if empty)
    int Function GetWeakest()

        int index = 0
        While (index < numberOfSouls.Length && numberOfSouls[index] == 0)
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
        While (index >= 0 && numberOfSouls[index] == 0)
            index -= 1
        EndWhile

        if(Config.dbg)
            Debug.Notification("SEater: " + (index + 1) + " is the strongest soul inside player")
        endIf

        return index + 1
    EndFunction

    ; Return total stored soul charge level
    float Function GetTotalChargeLevel()
        If (HasSouls())
            float totalChargeLevel = 0
            int index = 0
            While (index < numberOfSouls.Length)
                totalChargeLevel += numberOfSouls[index] * GetSoulChargeBySize(index + 1)
                index += 1
            EndWhile

            return totalChargeLevel
        Else
            return 0.0
        EndIf
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
        numberOfSouls[soulSize - 1] = numberOfSouls[soulSize - 1] + 1
    endFunction

    ; Remove a single soul of given size from caster
    Function RemoveSoul(int soulSize)
        numberOfSouls[soulSize - 1] = numberOfSouls[soulSize - 1] - 1
    EndFunction

    ; Digest targetSoul and return it's synergy. The remains of the soul returns to player in small sizes
    float Function Digest(int targetSoul)
        targetSynergy = 0 ; Resets if switch from gestation to digest!
        if(targetSoul >= SoulSizes_Petty)
            RemoveSoul(targetSoul)
            While (targetSoul > SoulSizes_Petty)
                If(targetSoul == SoulSizes_Grand)
                    RemoveSoul(SoulSizes_Common)
                endIf
                
                targetSoul -= 1
                AddSoul(targetSoul)
            EndWhile
            
            if(Config.dbg)
                Debug.Notification("SEater: Digest proceeds")
            endIf

            return 2.5
        else
            If (Config.dbg)
                Debug.Notification("SEater: failed to digest. Player's womb is empty")
            EndIf

            return 0
        endIf
    EndFunction

    ; Grows up souls using synergy. Return true if results in labor
    bool Function Gestate(int targetSoul)
        if(targetSoul >= SoulSizes_Petty)
            float targetSoulCharge = GetSoulChargeBySize(targetSoul)
            targetSynergy += 2.5
            if(targetSynergy >= targetSoulCharge)
                if(synergyLevel >= targetSynergy || synergyLevel >= 10.00 && targetSoul < 5)
                    RemoveSoul(targetSoul)
                    AddSoul(targetSoul + 1)
                    if(targetSoul == SoulSizes_Greater)
                        synergyLevel -= 10.00
                    else
                        synergyLevel -= targetSoulCharge
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
        elseif(Config.dbg)
            Debug.Notification("SEater: Failed to gestate, there no souls to grow.")
        endIf

        return false
    EndFunction

    ; Try stretch
    Function Stretch()
        If (GetCapacityUsage() >= 100.0)
            Config.numberOfStretches += 1

            If (Config.dbg)
                Debug.Notification("Stretching belly...")
            EndIf
        EndIf
    EndFunction

    ;TODO: Calculate the estimated time for completion of digestion (or -1 if not at digest mode)
    ;float Function GetDigestionTime()
    ;    float estDigestionTime = -1.0
    ;
    ;    If (storageMode == StorageModes_Digest)
    ;        float totalChargeLevel = GetTotalChargeLevel()
    ;
    ;        If (totalChargeLevel > 0)
    ;            estDigestionTime = (totalChargeLevel / 2.5) * 3.0
    ;        Else
    ;            estDigestionTime = 0.0
    ;        EndIf
    ;    EndIf
    ;
    ;    return estDigestionTime
    ;EndFunction

    ;TODO: Calculate the estimated time for completion of gestation (or -1 if not at gestation mode)
    ;float Function GetGestationTime()
    ;    float estGestationTime = -1.0
    ;
    ;    If (storageMode == StorageModes_Gestation)
    ;        float synergyRemain = synergyLevel / 2.5
    ;    EndIf
    ;
    ;    return estGestationTime
    ;EndFunction

;/// Events ///;

    ; Called every in-game hour while this mod is active, no matter if are carrying souls or not.
    Event OnTimerUpdate(float timePast)
        If (Config.dbg)
            Debug.Notification("SEater: TimerUpdate(Storage) + " + timePast)
        EndIf
    EndEvent

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
            Debug.Notification("Processing " + updateLoops + " storage updates")
        endif

        bool inLabor

        While (updateLoops >= 1)
            Stretch()

            If (storageMode == StorageModes_Digest)
                synergyLevel += Digest(GetWeakest())

                If (synergyLevel > maxSynergy)
                    maxSynergy = synergyLevel
                EndIf

                If (HasSouls() == false)
                    storageMode = StorageModes_Gestation
                    updateLoops = 0
                EndIf
            ElseIf (storageMode == StorageModes_Gestation)
                If (Gestate(GetWeakest()))
                    inLabor = true ; storageMode will come back to disabled or digest after labor
                    updateLoops = 0
                EndIf
            Else
                updateLoops = 0
            EndIf

            updateLoops -= 1
        EndWhile

        If (storageMode != StorageModes_Disabled)
            Scale.UpdateScale()
        EndIf

        If (inLabor)
            ;TODO: Gestation Finish (birth all souls)
            ;TODO: Cast spell to handle labor effects
            If (Config.dbg)
                Debug.Notification("SEater: No enough synergy, advancing to labor...")
                Debug.Notification("Not Implemented yet!")
            EndIf
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