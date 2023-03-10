Scriptname SE_MainQuest_Script extends Quest
{Soul Eater main script}

;/// Properties ///;
    SE_Config_Script Property Config Auto
    SE_StorageManager_Script Property Storage Auto
    SE_ScaleManager_Script Property Scale Auto
    Faction Property CreatureFaction Auto
    MagicEffect Property SoulTrapFFActor Auto
    Actor Property PlayerRef Auto

;/// Variables ///;

;/// Functions ///;

    ; Return Soul size of target actor
    int Function GetSoulSize(Actor target)
        int targetLevel = target.GetLevel()
        if(target.IsInFaction(CreatureFaction))
            if(targetLevel <= 3)
                return 1
            elseif(targetLevel >= 4 && targetLevel <= 15)
                return 2
            elseif(targetLevel >= 16 && targetLevel <= 27)
                return 3
            elseif(targetLevel >= 28 && targetLevel <= 37)
                return 4
            else
                return 5
            endif
        
        else
            return 5
        endIf
    endFunction

    ; Return Soul charge level of given soul size (30.00 = 3000)
    float Function GetSoulChargeBySize(int soulSize)

        if(soulSize == 1)
            return 2.50
        elseif(soulSize == 2)
            return 5.00
        elseif(soulSize == 3)
            return 10.00
        elseif(soulSize == 4)
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

                    ;FIXME: Call events on child scripts together in one line
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

;/// Events ///;
    
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