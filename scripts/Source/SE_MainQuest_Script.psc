Scriptname SE_MainQuest_Script extends Quest
{Soul Eater main script}

;/// Properties ///;
    SE_Config_Script Property Config Auto
    SE_StorageManager_Script Property Storage Auto
    SE_ScaleManager_Script Property Scale Auto
    Faction Property CreatureFaction Auto
    MagicEffect Property SoulTrapFFActor Auto
    Actor Property PlayerRef Auto
    GlobalVariable Property GameDaysPassed Auto

;/// Entries ///;
    string[] Property SoulSizes Auto
        int Property SoulSizes_Petty = 1 AutoReadOnly Hidden
        int Property SoulSizes_Lesser = 2 AutoReadOnly Hidden
        int Property SoulSizes_Common = 3 AutoReadOnly Hidden
        int Property SoulSizes_Greater = 4 AutoReadOnly Hidden
        int Property SoulSizes_Grand = 5 AutoReadOnly Hidden

;/// Variables ///;
    float lastUpdate ; Number of days were the last update event are made

;/// Functions ///;

    ; Returns number of hours 'till last check
    float Function GetElapsedTime()
        float daysPassed = GameDaysPassed.GetValue() - lastUpdate
        lastUpdate = GameDaysPassed.GetValue()

        return daysPassed * 24
    endFunction

    ; Return Soul size of target actor
    int Function GetSoulSize(Actor target)
        int targetLevel = target.GetLevel()
        if(target.IsInFaction(CreatureFaction))
            if(targetLevel <= 3)
                return SoulSizes_Petty
            elseif(targetLevel >= 4 && targetLevel <= 15)
                return SoulSizes_Lesser
            elseif(targetLevel >= 16 && targetLevel <= 27)
                return SoulSizes_Common
            elseif(targetLevel >= 28 && targetLevel <= 37)
                return SoulSizes_Greater
            else
                return SoulSizes_Grand
            endif
        
        else
            return SoulSizes_Grand
        endIf
    endFunction

    ; Return Soul charge level of given soul size (30.00 = 3000)
    float Function GetSoulChargeBySize(int soulSize)

        if(soulSize == SoulSizes_Petty)
            return 2.50
        elseif(soulSize == SoulSizes_Lesser)
            return 5.00
        elseif(soulSize == SoulSizes_Common)
            return 10.00
        elseif(soulSize == SoulSizes_Greater)
            return 20.00
        else
            return 30.00
        endif
    endFunction
    
    ; Return Soul charge by target (30.00 = 3000)
    float Function GetSoulChargeByTarget(Actor target)
        int targetSoulSize = GetSoulSize(target)
        return GetSoulChargeBySize(targetSoulSize)
    endFunction

    ; Atempt to absorb soul and return true if sucessfull
    bool Function AbsorbSoul(Actor victim)
        if(Config.dbg)
            Debug.Notification("SEater: Atempt to absorb soul...")
            Debug.Notification("SEater: Victim = " + victim.GetDisplayName())
        endif

        if(PlayerRef.GetActorBase().GetSex() == 1 && Config.storageMode > 0)
            if(victim.HasMagicEffect(SoulTrapFFActor))
                Debug.Notification("Failed to absorb. Target soul already catch by another spell")
                return false
            else
                if(victim.IsDead())
                    int soulSize = GetSoulSize(victim)
                    if(Config.dbg)
                        Debug.Notification("SEater: Absorb Sucessfull")
                        Debug.Notification("SEater: SoulSize = " + soulSize)
                    endIf

                    ;FIXME: Call events on child scripts together
                    OnSoulAbsorbed(soulSize)
                    return true
                else
                    if(Config.dbg)
                        Debug.Notification("SEater: Failed to absorb. Victim still alive")
                    endif

                    return false
                endif
            endif
        Else
            Debug.Notification("Failed to absorb. Caster can't be impregnated")
        endif
    EndFunction

    ; Atempt to expel soul to empty soulgem and return true if sucessfull
    bool Function ExpelSoul()
        ;TODO: Check if caster has souls to expel
            ;TODO: Dialogue box for player to select wich soul want to expel or ...
            ;TODO: Expel the smallest soul
        ;TODO: Check if caster has soulgems larger enough to expel into them (expel petty souls into grand soul gems doesn't work!)
        return false
    EndFunction

    ; Call this to test mod functions
    Function TestMod()
        ;TODO: tests behavior
            ; Add all spells, powers and items to player
            ; Scale belly to max than shrink
            ; Scale breast to max than shrink
            ; Repeat for digest and gestation modes:
                ; Add random number of souls to storage
                ; Update events some times
                ; Emptie storage
                ; Update events some times
    EndFunction

;/// Events ///;

    ; Called at Main Quest startup
    Event OnInit()
        lastUpdate = GameDaysPassed.GetValue()
        RegisterForSingleUpdateGameTime(1.0)
    EndEvent

    ; Called each in-game hour if this mod is active, no matter if are carrying souls or not.
    ;/ ! DO NOT OVERRIDE THIS EVENT ! /;
    Event OnUpdateGameTime()
        If (self != none)
            self.OnTimerUpdate(GetElapsedTime())
            RegisterForSingleUpdateGameTime(1.0)
        EndIf
    EndEvent

    ; Called every in-game hour while this mod is active, no matter if are carrying souls or not.
    Event OnTimerUpdate(float timePast)
        If (Config.dbg)
            Debug.Notification("SEater: TimerUpdate(Main) + " + timePast)
        EndIf
    EndEvent
    
    ; Called when a new soul are absorbed successfully
    event OnSoulAbsorbed(int absorbedSoulSize)
        if(Config.dbg)
            Debug.Notification("SEater: OnSoulAbsorbed(Main)")
        endif
        
        Storage.OnSoulAbsorbed(absorbedSoulSize)
        ;TODO: Apply effects
        ;TODO: Apply Buffs/Debuffs
    endEvent

    ; Called after successfully dispel a soul to a soul gem
    Event OnSoulExpeled(int expeledSoulSize)
        ;TODO: Need Implementation
    EndEvent

    ; Called when belly size increases
    Event OnGrowth()
        if(Config.dbg)
            Debug.Notification("SEater: OnGrowth(Main)")
        endif

        Scale.OnGrowth()
    EndEvent

    ; Called when belly size decreases
    Event OnShrink()
        if(Config.dbg)
            Debug.Notification("SEater: OnShrink(Main)")
        endif

        Scale.OnShrink()
    EndEvent