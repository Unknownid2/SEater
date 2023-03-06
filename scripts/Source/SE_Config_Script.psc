Scriptname SE_Config_Script extends SKI_ConfigBase 
{Script for Soul Eater MCM}

import StringUtil


;/// Settings ///;
    ; Stats
        ;TODO: Absorb Stats and skills (most read only)

        GlobalVariable Property SE_fSynergyLevel_Global Auto ; Used to forge larger souls at gestation mode
        {Increases over time. digesting souls or breaking filled soulgems accelerate charge}

        GlobalVariable Property SE_fMaxSynergy_Global Auto
        {Increase with SynergyLevel while and only in digest mode}

        GlobalVariable Property SE_iStorageMode_Global Auto ;TODO: Change between modes
        {What happening with unclaimed stored souls (1= Digest, 2= Gestation, 0 = Disabled)}
        
        GlobalVariable Property SE_iNumberOfPetty_Global Auto
        {Number of stored petty souls}

        GlobalVariable Property SE_iNumberOfLesser_Global Auto
        {Number of stored lesser souls}

        GlobalVariable Property SE_iNumberOfCommon_Global Auto
        {Number of stored common souls}

        GlobalVariable Property SE_iNumberOfGreater_Global Auto
        {Number of stored greater souls}

        GlobalVariable Property SE_iNumberOfGrand_Global Auto
        {Number of stored grand souls}

        GlobalVariable Property SE_fMaxCapacity_Global Auto
        {The max amount of souls charge which can be hold inside caster belly}

    ; Storage
        ;TODO: Settings related to storage

        GlobalVariable Property SE_bCapacityModifiers_Global Auto
        {Apply Buffs/Debuffs based on fulles stage}

        GlobalVariable Property SE_bCapacityEffects_Global Auto
        {Apply effects based on fulles stage}

        GlobalVariable Property SE_fFirstStage_Global Auto
        {% of capacity usage considered small (0-100)}

        GlobalVariable Property SE_fSecondStage_Global Auto
        {% of capacity usage considered medium (0-100)}

        GlobalVariable Property SE_fThirthStage_Global Auto
        {% of capacity usage considered high (0-100)}

        GlobalVariable Property SE_bAllowDangerousScale_Global Auto
        {Trespassing max capacity can kill}

        GlobalVariable Property SE_fBurstScale_Global Auto
        {% above max capacity where burst chance reach 100% (0-100)}

        GlobalVariable Property SE_fStretch_Global Auto
        {If at ThirthStage, increase max capacity by this value over time (set 0 to disable)}

        GlobalVariable Property SE_fMultiplierReduction_Global Auto
        {Porcentage of scale multiplier to be reduced with each stored soul (if enabled) (0-100)}

    ; Visual
        ;TODO: Settings related to effects and scale proportions

        GlobalVariable Property SE_bSheLikesIt_Global Auto
        {Scaling triggers specials monologs and buffs}

        GlobalVariable Property SE_bSheLovesIt_Global Auto
        {Scaling triggers pleasure effects like arousal and moan sounds}

        GlobalVariable Property SE_bApplyAnimations_Global Auto
        {Include animations when applying effects or/and dialogues}

        ; Scaling
            ; Values for Scaling vars are:
            ; 0 = Disabled - disable this node from scaling
            ; 1 = Soul charge level - use soul charge level as scaling var for this node
            ; 2 = Synergy level - use synergy level as scaling var for this node
            ; 3 = Mode progress - use special var based on synergy gained by digestion or used by gestation
            ; 4 = Max charge level - use max capacity of soul charge level as scaling var for this node
            ; 5 = Max synergy level - use max acumulated synergy as scaling var for this node
            GlobalVariable Property SE_iBellyScalingVar_Global Auto
            {Wich value to use for belly inflation (refer to values above)}

            GlobalVariable Property SE_fBellyScalingStart_Global Auto
            {Belly will start growing when value is equal or greater than this}

            GlobalVariable Property SE_fBellyMultiplier_Global Auto
            {The value selected for belly node will be multiplied by this before applying to scale}

            GlobalVariable Property SE_bScaleBellyMultiplier_Global Auto
            {Reduce belly scale multiplier by number of souls (good for balancing purposes)}

            GlobalVariable Property SE_fBellyScaleOffset_Global Auto
            {Modify scaling result by this value}

            GlobalVariable Property SE_iBreastScalingVar_Global Auto
            {Wich value to use for breast inflation (refer to values above)}

            GlobalVariable Property SE_fBreastScalingStart_Global Auto
            {Breasts will start growing when value is equal or greater than this}

            GlobalVariable Property SE_fBreastMultiplier_Global Auto
            {The value selected for breast node will be multiplied by this before applying to scale}

            GlobalVariable Property SE_bScaleBreastMultiplier_Global Auto
            {Reduce breast scale multiplier by number of souls (good for balancing purposes)}

            GlobalVariable Property SE_fBreastScaleOffset_Global Auto
            {Modify scaling result by this value}

            GlobalVariable Property SE_iButtScalingVar_Global Auto
            {Wich value to use for ass inflation (refer to values above)}

            GlobalVariable Property SE_fButtScalingStart_Global Auto
            {Butt will start growing when value is equal or greater than this}

            GlobalVariable Property SE_fButtMultiplier_Global Auto
            {The value selected for ass node will be multiplied by this before applying to scale}

            GlobalVariable Property SE_bScaleButtMultiplier_Global Auto
            {Reduce butt scale multiplier by number of souls (good for balancing purposes)}

            GlobalVariable Property SE_fButtScaleOffset_Global Auto
            {Modify scaling result by this value}

    ; System
        ;TODO: Misc settings

        GlobalVariable Property SE_bDbg_Global Auto
        {Toggle debug notifications}

        GlobalVariable Property SE_iInstalledVersion_Global Auto
        {Used to track updates}

        int Property Version = 21 AutoReadOnly ;TODO: <- Change before tests
        {Mod version}

;/// Properties ///;
    SE_StorageManager_Script Property Storage Auto

    ;TODO: Check Properties usage
    bool Property enableCapacityModifiers Auto Hidden ;Unused
    bool Property enableCapacityEffects Auto Hidden ;Unused
    bool Property allowDangerousScale Auto Hidden ;Unused
    bool Property sheLikesIt Auto Hidden ;Unused
    bool Property sheLovesIt Auto Hidden ;Unused
    bool Property applyAnimations Auto Hidden ;Unused
    bool Property scaleBellyMultiplier Auto Hidden
    bool Property scaleBreastMultiplier Auto Hidden
    bool Property scaleButtMultiplier Auto Hidden
    bool Property dbg Auto Hidden
    float Property synergyLevel Auto Hidden
    float Property maxSynergy Auto Hidden
    float Property maxCapacity Auto Hidden ;Unused
    float Property firstStageScale Auto Hidden ;Unused
    float Property secondStageScale Auto Hidden ;Unused
    float Property thirthStageScale Auto Hidden ;Unused
    float Property burstScale Auto Hidden ;Unused
    float Property stretch Auto Hidden ;Unused
    float Property multiplierScalePorcentage Auto Hidden
    float Property bellyScalingStart Auto Hidden
    float Property bellyMultiplier Auto Hidden
    float Property bellyScaleOffset Auto Hidden
    float Property breastScalingStart Auto Hidden
    float Property breastMultiplier Auto Hidden
    float Property breastScaleOffset Auto Hidden
    float Property buttScalingStart Auto Hidden
    float Property buttMultiplier Auto Hidden
    float Property buttScaleOffset Auto Hidden
    int[] Property numberOfSouls Auto Hidden
    string Property storageMode Auto Hidden
    string Property bellyScalingVar Auto Hidden
    string Property breastScalingVar Auto Hidden
    string Property buttScalingVar Auto Hidden

;/// Functions ///;
    ; Returns mod version string
    string Function GetVersionString()
        return "0.1.21" ;TODO: <- Change before tests
    EndFunction

    ; Cuts decimals after dot and return the result as string
    string Function FormatFloat(float value, int maxDecimals)
        string formation = value
        string result = ""

        int index = 0
        int dotIndex = Find(formation, ".")
        While (index < GetLength(formation))
            result += GetNthChar(formation, index)

            If (index - dotIndex >= maxDecimals)
                index = GetLength(formation)
            EndIf

            index += 1
        EndWhile

        return result
    EndFunction

    int Function GetVersion()
        return Version
    EndFunction

    Function SaveSettings()
        SE_bDbg_Global.SetValue(dbg as float)
        SE_bScaleBellyMultiplier_Global.SetValue(scaleBellyMultiplier as float)
        SE_bScaleBreastMultiplier_Global.SetValue(scaleBreastMultiplier as float)
        SE_bScaleButtMultiplier_Global.SetValue(scaleButtMultiplier as float)
        SE_fSynergyLevel_Global.SetValue(synergyLevel)
        SE_fMaxSynergy_Global.SetValue(maxSynergy)
        SE_fMultiplierReduction_Global.SetValue(multiplierScalePorcentage)
        SE_fBellyScalingStart_Global.SetValue(bellyScalingStart)
        SE_fBreastScalingStart_Global.SetValue(breastScalingStart)
        SE_fButtScalingStart_Global.SetValue(buttScalingStart)
        SE_fBellyMultiplier_Global.SetValue(bellyMultiplier)
        SE_fBreastMultiplier_Global.SetValue(breastMultiplier)
        SE_fButtMultiplier_Global.SetValue(buttMultiplier)
        SE_fBellyScaleOffset_Global.SetValue(bellyScaleOffset)
        SE_fBreastScaleOffset_Global.SetValue(breastScaleOffset)
        SE_fButtScaleOffset_Global.SetValue(buttScaleOffset)
        SE_iNumberOfPetty_Global.SetValue(numberOfSouls[0] as float)
        SE_iNumberOfLesser_Global.SetValue(numberOfSouls[1] as float)
        SE_iNumberOfCommon_Global.SetValue(numberOfSouls[2] as float)
        SE_iNumberOfGreater_Global.SetValue(numberOfSouls[3] as float)
        SE_iNumberOfGrand_Global.SetValue(numberOfSouls[4] as float)
        
        if(storageMode == "Digest")
            SE_iStorageMode_Global.SetValue(1)
        elseif(storageMode == "Gestation")
            SE_iStorageMode_Global.SetValue(2)
        else
            SE_iStorageMode_Global.SetValue(0)
        endIf

        if(bellyScalingVar == "Soul charge level")
            SE_iBellyScalingVar_Global.SetValue(1)
        elseif(bellyScalingVar == "Synergy level")
            SE_iBellyScalingVar_Global.SetValue(2)
        elseif(bellyScalingVar == "Mode progress")
            SE_iBellyScalingVar_Global.SetValue(3)
        elseif(bellyScalingVar == "Max charge level")
            SE_iBellyScalingVar_Global.SetValue(4)
        elseif(bellyScalingVar == "Max synergy level")
            SE_iBellyScalingVar_Global.SetValue(5)
        else
            SE_iBellyScalingVar_Global.SetValue(0)
        endif

        if(breastScalingVar == "Soul charge level")
            SE_iBreastScalingVar_Global.SetValue(1)
        elseif(breastScalingVar == "Synergy level")
            SE_iBreastScalingVar_Global.SetValue(2)
        elseif(breastScalingVar == "Mode progress")
            SE_iBreastScalingVar_Global.SetValue(3)
        elseif(breastScalingVar == "Max charge level")
            SE_iBreastScalingVar_Global.SetValue(4)
        elseif(breastScalingVar == "Max synergy level")
            SE_iBreastScalingVar_Global.SetValue(5)
        else
            SE_iBreastScalingVar_Global.SetValue(0)
        endif

        if(buttScalingVar == "Soul charge level")
            SE_iButtScalingVar_Global.SetValue(1)
        elseif(buttScalingVar == "Synergy level")
            SE_iButtScalingVar_Global.SetValue(2)
        elseif(buttScalingVar == "Mode progress")
            SE_iButtScalingVar_Global.SetValue(3)
        elseif(buttScalingVar == "Max charge level")
            SE_iButtScalingVar_Global.SetValue(4)
        elseif(buttScalingVar == "Max synergy level")
            SE_iButtScalingVar_Global.SetValue(5)
        else
            SE_iButtScalingVar_Global.SetValue(0)
        endif

        if(dbg)
            Debug.Notification("SEater: Settings saved")
        endif
    EndFunction

    Function LoadSettings()
        dbg = SE_bDbg_Global.GetValue() as bool
        scaleBellyMultiplier = SE_bScaleBellyMultiplier_Global.GetValue() as bool
        scaleBreastMultiplier = SE_bScaleBreastMultiplier_Global.GetValue() as bool
        scaleButtMultiplier = SE_bScaleButtMultiplier_Global.GetValue() as bool
        synergyLevel = SE_fSynergyLevel_Global.GetValue()
        maxSynergy = SE_fMaxSynergy_Global.GetValue()
        multiplierScalePorcentage = SE_fMultiplierReduction_Global.GetValue()
        bellyScalingStart = SE_fBellyScalingStart_Global.GetValue()
        breastScalingStart = SE_fBreastScalingStart_Global.GetValue()
        buttScalingStart = SE_fButtScalingStart_Global.GetValue()
        bellyMultiplier = SE_fBellyMultiplier_Global.GetValue()
        breastMultiplier = SE_fBreastMultiplier_Global.GetValue()
        buttMultiplier = SE_fButtMultiplier_Global.GetValue()
        bellyScaleOffset = SE_fBellyScaleOffset_Global.GetValue()
        breastScaleOffset = SE_fBreastScaleOffset_Global.GetValue()
        buttScaleOffset = SE_fButtScaleOffset_Global.GetValue()
        numberOfSouls = new int[5]
        numberOfSouls[0] = SE_iNumberOfPetty_Global.GetValue() as int
        numberOfSouls[1] = SE_iNumberOfLesser_Global.GetValue() as int
        numberOfSouls[2] = SE_iNumberOfCommon_Global.GetValue() as int
        numberOfSouls[3] = SE_iNumberOfGreater_Global.GetValue() as int
        numberOfSouls[4] = SE_iNumberOfGrand_Global.GetValue() as int

        if(SE_iStorageMode_Global.GetValue() == 1)
            storageMode = "Digest"
        elseif(SE_iStorageMode_Global.GetValue() == 2)
            storageMode = "Gestation"
        Else
            storageMode = "Disabled"
        endIf

        if(SE_iBellyScalingVar_Global.GetValue() == 1)
            bellyScalingVar = "Soul charge level"
        elseif(SE_iBellyScalingVar_Global.GetValue() == 2)
            bellyScalingVar = "Synergy level"
        elseif(SE_iBellyScalingVar_Global.GetValue() == 3)
            bellyScalingVar = "Mode progress"
        elseif(SE_iBellyScalingVar_Global.GetValue() == 4)
            bellyScalingVar = "Max charge level"
        elseif(SE_iBellyScalingVar_Global.GetValue() == 5)
            bellyScalingVar = "Max synergy level"
        else
            bellyScalingVar = "Disabled"
        endif

        if(SE_iBreastScalingVar_Global.GetValue() == 1)
            breastScalingVar = "Soul charge level"
        elseif(SE_iBreastScalingVar_Global.GetValue() == 2)
            breastScalingVar = "Synergy level"
        elseif(SE_iBreastScalingVar_Global.GetValue() == 3)
            breastScalingVar = "Mode progress"
        elseif(SE_iBreastScalingVar_Global.GetValue() == 4)
            breastScalingVar = "Max charge level"
        elseif(SE_iBreastScalingVar_Global.GetValue() == 5)
            breastScalingVar = "Max synergy level"
        else
            breastScalingVar = "Disabled"
        endif

        if(SE_iButtScalingVar_Global.GetValue() == 1)
            buttScalingVar = "Soul charge level"
        elseif(SE_iButtScalingVar_Global.GetValue() == 2)
            buttScalingVar = "Synergy level"
        elseif(SE_iButtScalingVar_Global.GetValue() == 3)
            buttScalingVar = "Mode progress"
        elseif(SE_iButtScalingVar_Global.GetValue() == 4)
            buttScalingVar = "Max charge level"
        elseif(SE_iButtScalingVar_Global.GetValue() == 5)
            buttScalingVar = "Max synergy level"
        else
            buttScalingVar = "Disabled"
        endif

        if(dbg)
            Debug.Notification("SEater: Settings loaded")
        endIf
    EndFunction

;/// Events ///;
    ;TODO: MCM menu

    ; Called when this config menu is initialized
    Event OnConfigInit()
        Debug.Notification("SEater: Initializing...")
        Debug.Notification("Version = " + GetVersionString())
    EndEvent

    ; Called when this config menu registered at the control panel
    Event OnConfigRegister()

        LoadSettings()
        Debug.Notification("SEater: Ready!")
    EndEvent
    
    Event OnConfigOpen()
        {Called when this config menu is opened}
        LoadSettings()
    EndEvent
    
    Event OnConfigClose()
        {Called when this config menu is closed}
        SaveSettings()
    EndEvent
    
    Event OnVersionUpdate(int aVersion)
        {Called when aVersion update of this script has been detected}
        ;TODO: Update code (if needed)
        SE_iInstalledVersion_Global.SetValue(Version)
        Debug.Notification("SEater: Updated")
        Debug.Notification("Version = " + GetVersionString())
    EndEvent
    
    ; Called when a new page is selected, including the initial empty page
    Event OnPageReset(string a_page)
        if(a_page == "Stats")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddTextOptionST("stats_Synergy", "Synergy", FormatFloat(synergyLevel, 1) + "/" + FormatFloat(maxSynergy, 1))
            AddTextOptionST("stats_Mode", "Mode", storageMode) ;TODO: Missing state
            ;AddTextOptionST("stats_ChargeLevel", "Charge Level", Storage.GetTotalChargeLevel()) ;TODO: Missing state

            ;Stored Souls
            SetCursorPosition(1)
            AddHeaderOption("Stored Souls")
            AddTextOptionST("stats_TotalNumberOfSouls", "Total number of souls", Storage.GetNumberOfSouls()) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfPetty", "Number of petty souls", numberOfSouls[0]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfLesser", "Number of lesser souls", numberOfSouls[1]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfCommon", "Number of common souls", numberOfSouls[2]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfGreater", "Number of greater souls", numberOfSouls[3]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfGrand", "Number of grand souls", numberOfSouls[4]) ;TODO: Missing state

        elseif(a_page == "Storage")
            SetCursorPosition(0)
            SetCursorFillMode(LEFT_TO_RIGHT)
            AddSliderOptionST("storage_MultiplierReduction", "Multiplier reduction", multiplierScalePorcentage, "{0}%") ;TODO: Missing state

        elseif(a_page == "Visual")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)

            ;Scaling
            SetCursorPosition(1)
            AddHeaderOption("Belly Scaling")
            AddMenuOptionST("visual_Belly_ScalingValue", "Scaling value", bellyScalingVar) ;TODO: Missing state
            AddSliderOptionST("visual_Belly_ScalingStart", "Scaling start", bellyScalingStart, "{1}") ;TODO: Missing state
            AddSliderOptionST("visual_Belly_Multiplier", "Multiplier", bellyMultiplier, "{3}") ;TODO: Missing state
            AddSliderOptionST("visual_Belly_Offset", "Offset", bellyScaleOffset, "{2}") ;TODO: Missing state
            AddToggleOptionST("visual_Belly_ReduceMultiplier", "Reduce multiplier", scaleBellyMultiplier) ;TODO: Missing state
            AddEmptyOption()

            AddHeaderOption("Breast Scaling")
            AddMenuOptionST("visual_Breast_ScalingValue", "Scaling value", breastScalingVar) ;TODO: Missing state
            AddSliderOptionST("visual_Breast_ScalingStart", "Scaling start", breastScalingStart, "{1}") ;TODO: Missing state
            AddSliderOptionST("visual_Breast_Multiplier", "Multiplier", breastMultiplier, "{3}") ;TODO: Missing state
            AddSliderOptionST("visual_Breast_Offset", "Offset", breastScaleOffset, "{2}") ;TODO: Missing state
            AddToggleOptionST("visual_Breast_ReduceMultiplier", "Reduce multiplier", scaleBreastMultiplier) ;TODO: Missing state
            AddEmptyOption()

            AddHeaderOption("Butt Scaling")
            AddMenuOptionST("visual_Butt_ScalingValue", "Scaling value", buttScalingVar) ;TODO: Missing state
            AddSliderOptionST("visual_Butt_ScalingStart", "Scaling start", buttScalingStart, "{1}") ;TODO: Missing state
            AddSliderOptionST("visual_Butt_Multiplier", "Multiplier", buttMultiplier, "{3}") ;TODO: Missing state
            AddSliderOptionST("visual_Butt_Offset", "Offset", buttScaleOffset, "{2}") ;TODO: Missing state
            AddToggleOptionST("visual_Butt_ReduceMultiplier", "Reduce multiplier", scaleButtMultiplier) ;TODO: Missing state

        elseif(a_page == "System")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddToggleOptionST("system_DebugMode", "Debug mode", dbg)
            AddTextOptionST("system_Version", "Version", GetVersionString())

        endif
    EndEvent
    
    Event OnOptionHighlight(int a_option)
        {Called when highlighting an option}
        Debug.Notification("SEater: OnOptionHighlight not implemented yet")
    EndEvent
    
    Event OnOptionSelect(int a_option)
        {Called when a non-interactive option has been selected}
        Debug.Notification("SEater: OnOptionSelect not implemented yet")
    EndEvent
    
    Event OnOptionDefault(int a_option)
        {Called when resetting an option to its default value}
        Debug.Notification("SEater: OnOptionDefault not implemented yet")
    EndEvent
    
    Event OnOptionSliderOpen(int a_option)
        {Called when a slider option has been selected}
        Debug.Notification("SEater: OnOptionSliderOpen not implemented yet")
    EndEvent
    
    Event OnOptionSliderAccept(int a_option, float a_value)
        {Called when a new slider value has been accepted}
        Debug.Notification("SEater: OnOptionSliderAccept not implemented yet")
    EndEvent
    
    Event OnOptionMenuOpen(int a_option)
        {Called when a menu option has been selected}
        Debug.Notification("SEater: OnOptionMenuOpen not implemented yet")
    EndEvent
    
    Event OnOptionMenuAccept(int a_option, int a_index)
        {Called when a menu entry has been accepted}
        Debug.Notification("SEater: OnOptionMenuAccept not implemented yet")
    EndEvent
    
    Event OnOptionColorOpen(int a_option)
        {Called when a color option has been selected}
        Debug.Notification("SEater: OnOptionColorOpen not implemented yet")
    EndEvent
    
    Event OnOptionColorAccept(int a_option, int a_color)
        {Called when a new color has been accepted}
        Debug.Notification("SEater: OnOptionColorAccept not implemented yet")
    EndEvent
    
    Event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
        {Called when a key has been remapped}
        Debug.Notification("SEater: OnOptionKeyMapChange not implemented yet")
    EndEvent
    
    ; @since 4
    Event OnOptionInputOpen(int a_option)
        {Called when a text input option has been selected}
        Debug.Notification("SEater: OnOptionInputOpen not implemented yet")
    EndEvent
    
    ; @since 4
    Event OnOptionInputAccept(int a_option, string a_input)
        {Called when a new text input has been accepted}
        Debug.Notification("SEater: OnOptionInputAccept not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnSliderOpenST()
        {Called when a slider state option has been selected}
        Debug.Notification("SEater: OnSliderOpenST not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnSliderAcceptST(float a_value)
        {Called when a new slider state value has been accepted}
        Debug.Notification("SEater: OnSliderAcceptST not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnMenuOpenST()
        {Called when a menu state option has been selected}
        Debug.Notification("SEater: OnMenuOpenST not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnMenuAcceptST(int a_index)
        {Called when a menu entry has been accepted for this state option}
        Debug.Notification("SEater: OnMenuAcceptST not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnColorOpenST()
        {Called when a color state option has been selected}
        Debug.Notification("SEater: OnColorOpenST not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnColorAcceptST(int a_color)
        {Called when a new color has been accepted for this state option}
        Debug.Notification("SEater: OnColorAcceptST not implemented yet")
    EndEvent
    
    ; @since 2
    Event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
        {Called when a key has been remapped for this state option}
        Debug.Notification("SEater: OnKeyMapChangeST not implemented yet")
    EndEvent
    
    ; @since 4
    Event OnInputOpenST()
        {Called when a text input state option has been selected}
        Debug.Notification("SEater: OnInputOpenST not implemented yet")
    EndEvent
    
    ; @since 4
    Event OnInputAcceptST(string a_input)
        {Called when a new text input has been accepted for this state option}
        Debug.Notification("SEater: OnInputAcceptST not implemented yet")
    EndEvent

;/// Options States ///;
    ;Stats
        ;TODO: Incomplete state
        State stats_Synergy
            Event OnSelectST()
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
            EndEvent
        EndState

    ;Storage
        ;/.../;

    ;Visual
        ;/.../;

    ;System
        State system_DebugMode
            Event OnSelectST()
                {Called when a non-interactive state option has been selected.}
                dbg = !dbg
                SetToggleOptionValueST(dbg)
            EndEvent

            Event OnDefaultST()
                {Called when resetting a state option to its default value.}
                dbg = false
                SetToggleOptionValueST(false)
            EndEvent

            Event OnHighlightST()
                {Called when highlighting a state option.}
                SetInfoText("Toggle debug notifications")
            EndEvent
        EndState

        State system_Version
            ;TODO: Incomplete state
            Event OnSelectST()
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
            EndEvent
        EndState