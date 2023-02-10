Scriptname SE_StorageEffect_Script extends ActiveMagicEffect 
{Hook for Invoking Soul events}

    ;/// Properties ///;
    GlobalVariable Property GameDaysPassed Auto
    SE_StorageManager_Script Property Storage Auto

    ;/// Variables ///;
    float lastUpdate ; Number of days were the last update event are made

    ;/// Functions ///;

    ; Returns number of updates past 'till last update
    float Function TimePast()
        float daysPassed = GameDaysPassed.GetValue() - lastUpdate
        return daysPassed * 8
    endFunction

    ;/// Events ///;

    ; when first soul gets stored, this effect starts
    event OnEffectStart(Actor akTarget, Actor akCaster)
        Debug.Notification("SEater: " + akTarget.GetDisplayName() + " has becomes a soul storage")
        lastUpdate = GameDaysPassed.GetValue()
        RegisterForSingleUpdateGameTime(3)
    endEvent

    ; Called each 3 in-game hours past while this effect is active
    event OnUpdateGameTime()
        ; First check
        if(Storage.GetNumberOfSouls() == 0)
            Dispel()
        else
            Storage.OnStorageUpdate(TimePast())
            lastUpdate = GameDaysPassed.GetValue()

            ; Second check
            if(Storage.GetNumberOfSouls() == 0)
                Dispel()
            else
                RegisterForSingleUpdateGameTime(3)
            endIf
        endIf
    endEvent

    ; when uninstall mod or storage gets empty, this effect stops
    event OnEffectFinish(Actor akTarget, Actor akCaster)
        Debug.Notification("SEater: the last soul within " + akTarget.GetDisplayName() + "'s womb has fallen into oblivion.")
    endEvent