Scriptname SE_MainQuest_Script extends Quest
{Soul Eater Main Script}

;/// Properties ///;
    Faction Property CreatureFaction Auto

;/// Constants (Enums) ///;
    int Property SoulSize_Petty = 1 AutoReadOnly Hidden
    int Property SoulSize_Lesser = 2 AutoReadOnly Hidden
    int Property SoulSize_Common = 3 AutoReadOnly Hidden
    int Property SoulSize_Greater = 4 AutoReadOnly Hidden
    int Property SoulSize_Grand = 5 AutoReadOnly Hidden

;/// Variables ///;
    ;/.../;

;/// Functions ///;

    ; Returns Soul size of target actor (1-5 = Petty-Grand)
    int Function GetSoulSize(Actor target)
        int targetLevel = target.GetLevel()

        if(target.IsInFaction(CreatureFaction))

            if(targetLevel <= 3)
                return SoulSize_Petty
            elseif(targetLevel >= 4 && targetLevel <= 15)
                return SoulSize_Lesser
            elseif(targetLevel >= 16 && targetLevel <= 27)
                return SoulSize_Common
            elseif(targetLevel >= 28 && targetLevel <= 37)
                return SoulSize_Greater
            else
                return SoulSize_Grand
            endif
        else
            return SoulSize_Grand
        endIf
    EndFunction

;/// Events ///;
    ;/.../;