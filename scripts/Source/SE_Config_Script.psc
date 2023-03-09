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
            GlobalVariable Property SE_iBellyScalingVar_Global Auto
            {Wich value to use for belly inflation (0-5)}

            GlobalVariable Property SE_fBellyScalingStart_Global Auto
            {Belly will start growing when value is equal or greater than this}

            GlobalVariable Property SE_fBellyMultiplier_Global Auto
            {The value selected for belly node will be multiplied by this before applying to scale}

            GlobalVariable Property SE_bScaleBellyMultiplier_Global Auto
            {Reduce belly scale multiplier by number of souls (good for balancing purposes)}

            GlobalVariable Property SE_fBellyScaleOffset_Global Auto
            {Modify scaling result by this value}

            GlobalVariable Property SE_iBreastScalingVar_Global Auto
            {Wich value to use for breast inflation (0-5)}

            GlobalVariable Property SE_fBreastScalingStart_Global Auto
            {Breasts will start growing when value is equal or greater than this}

            GlobalVariable Property SE_fBreastMultiplier_Global Auto
            {The value selected for breast node will be multiplied by this before applying to scale}

            GlobalVariable Property SE_bScaleBreastMultiplier_Global Auto
            {Reduce breast scale multiplier by number of souls (good for balancing purposes)}

            GlobalVariable Property SE_fBreastScaleOffset_Global Auto
            {Modify scaling result by this value}

            GlobalVariable Property SE_iButtScalingVar_Global Auto
            {Wich value to use for ass inflation (0-5)}

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
    int Property storageMode Auto Hidden ;TODO: The mode can be changed at soul stone once per day or at end of previous mode.
    int Property bellyScalingVar Auto Hidden
    int Property breastScalingVar Auto Hidden
    int Property buttScalingVar Auto Hidden

;/// Default Values ///;
    bool default_EnableCapacityModifiers = true
    bool default_EnableCapacityEffects = true
    bool default_AllowDangerousScale = true
    bool default_SheLikesIt = true
    bool default_SheLovesIt = true
    bool default_ApplyAnimations = true
    bool default_ScaleBellyMultiplier = true
    bool default_ScaleBreastMultiplier = true
    bool default_ScaleButtMultiplier = true
    bool default_Dbg = false
    float default_SynergyLevel = 0.0
    float default_MaxSynergy = 0.0
    float default_MaxCapacity = 0.0
    float default_FirstStageScale = 25.0
    float default_SecondStageScale = 50.0
    float default_ThirthStageScale = 75.0
    float default_BurstScale = 100.0
    float default_Stretch = 1.0
    float default_MultiplierScalePorcentage = 10.0
    float default_BellyScalingStart = 0.0
    float default_BellyMultiplier = 0.300
    float default_BellyScaleOffset = 1.0
    float default_BreastScalingStart = 0.0
    float default_BreastMultiplier = 0.030
    float default_BreastScaleOffset = 1.0
    float default_ButtScalingStart = 0.0
    float default_ButtMultiplier = 0.030
    float default_ButtScaleOffset = 1.0
    int default_BellyScalingVar = 1
    int default_BreastScalingVar = 1
    int default_ButtScalingVar = 1

;/// Enumerators[] ///;
    string[] StorageModes
    string[] ScalingVars

    ; Creation
    Function SetEnums()
        StorageModes = new string[3]
            StorageModes[0] = "Disabled"
            StorageModes[1] = "Digest"
            StorageModes[2] = "Gestation"
        ScalingVars = new string[6]
            ; Values for Scaling vars are:
            ScalingVars[0] = "Disabled" ; disable this node from scaling
            ScalingVars[1] = "Soul charge level" ; use soul charge level as scaling var for this node
            ScalingVars[2] = "Synergy level" ; use synergy level as scaling var for this node
            ScalingVars[3] = "Mode progress" ; use special var based on synergy gained by digestion or used by gestation
            ScalingVars[4] = "Max charge level" ; use max capacity of soul charge level as scaling var for this node
            ScalingVars[5] = "Max synergy level" ; use max acumulated synergy as scaling var for this node
    EndFunction

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

    ; Used by state options to define options description
    string Function Description()
        string descriptionA = ""
        string descriptionB = ""
        string descriptionC = ""

        return descriptionA + descriptionB + descriptionC
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
        SE_iStorageMode_Global.SetValue(storageMode as float)
        SE_iBellyScalingVar_Global.SetValue(bellyScalingVar as float)
        SE_iBreastScalingVar_Global.SetValue(breastScalingVar as float)
        SE_iButtScalingVar_Global.SetValue(buttScalingVar as float)

        Debug.Notification("SEater: Settings saved")
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
        storageMode = SE_iStorageMode_Global.GetValue() as int
        bellyScalingVar = SE_iBellyScalingVar_Global.GetValue() as int
        breastScalingVar = SE_iBreastScalingVar_Global.GetValue() as int
        buttScalingVar = SE_iButtScalingVar_Global.GetValue() as int

        Debug.Notification("SEater: Settings loaded")
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
        SetEnums()
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
            AddTextOptionST("stats_Mode", "Mode", StorageModes[storageMode])
            ;AddTextOptionST("stats_ChargeLevel", "Charge Level", Storage.GetTotalChargeLevel()) ;TODO: Missing state

            ;Stored Souls
            SetCursorPosition(1)
            AddHeaderOption("Stored Souls")
            AddTextOptionST("stats_TotalNumberOfSouls", "Total number of souls", Storage.GetNumberOfSouls())
            AddTextOptionST("stats_NumberOfPetty", "Number of petty souls", numberOfSouls[0])
            AddTextOptionST("stats_NumberOfLesser", "Number of lesser souls", numberOfSouls[1])
            AddTextOptionST("stats_NumberOfCommon", "Number of common souls", numberOfSouls[2])
            AddTextOptionST("stats_NumberOfGreater", "Number of greater souls", numberOfSouls[3])
            AddTextOptionST("stats_NumberOfGrand", "Number of grand souls", numberOfSouls[4])

        elseif(a_page == "Storage")
            SetCursorPosition(0)
            SetCursorFillMode(LEFT_TO_RIGHT)
            AddSliderOptionST("storage_MultiplierReduction", "Multiplier reduction", multiplierScalePorcentage, "{0}%")

        elseif(a_page == "Visual")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)

            ;Scaling
            SetCursorPosition(1)
            AddHeaderOption("Belly Scaling")
            AddMenuOptionST("visual_Belly_ScalingValue", "Scaling value", ScalingVars[bellyScalingVar]) ;TODO: Missing state
            AddSliderOptionST("visual_Belly_ScalingStart", "Scaling start", bellyScalingStart, "{1}") ;TODO: Missing state
            AddSliderOptionST("visual_Belly_Multiplier", "Multiplier", bellyMultiplier, "{3}") ;TODO: Missing state
            AddSliderOptionST("visual_Belly_Offset", "Offset", bellyScaleOffset, "{2}") ;TODO: Missing state
            AddToggleOptionST("visual_Belly_ReduceMultiplier", "Reduce multiplier", scaleBellyMultiplier) ;TODO: Missing state
            AddEmptyOption()

            AddHeaderOption("Breast Scaling")
            AddMenuOptionST("visual_Breast_ScalingValue", "Scaling value", ScalingVars[breastScalingVar]) ;TODO: Missing state
            AddSliderOptionST("visual_Breast_ScalingStart", "Scaling start", breastScalingStart, "{1}") ;TODO: Missing state
            AddSliderOptionST("visual_Breast_Multiplier", "Multiplier", breastMultiplier, "{3}") ;TODO: Missing state
            AddSliderOptionST("visual_Breast_Offset", "Offset", breastScaleOffset, "{2}") ;TODO: Missing state
            AddToggleOptionST("visual_Breast_ReduceMultiplier", "Reduce multiplier", scaleBreastMultiplier) ;TODO: Missing state
            AddEmptyOption()

            AddHeaderOption("Butt Scaling")
            AddMenuOptionST("visual_Butt_ScalingValue", "Scaling value", ScalingVars[buttScalingVar]) ;TODO: Missing state
            AddSliderOptionST("visual_Butt_ScalingStart", "Scaling start", buttScalingStart, "{1}") ;TODO: Missing state
            AddSliderOptionST("visual_Butt_Multiplier", "Multiplier", buttMultiplier, "{3}") ;TODO: Missing state
            AddSliderOptionST("visual_Butt_Offset", "Offset", buttScaleOffset, "{2}") ;TODO: Missing state
            AddToggleOptionST("visual_Butt_ReduceMultiplier", "Reduce multiplier", scaleButtMultiplier) ;TODO: Missing state

        elseif(a_page == "System")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddToggleOptionST("system_DebugMode", "Debug mode", dbg)
            AddTextOptionST("system_Version", "Version", GetVersionString())
            
            SetCursorPosition(1)
            AddTextOptionST("system_ResetSettings", "Reset settings", "") ;TODO: Missing state

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
        State stats_Synergy
            string Function Description()
                string descriptionA = "Used to forge larger souls at gestation mode.\n"
                string descriptionB = "Can recharge by digesting souls, breaking soulgems or over time while not carrying souls"
                string descriptionC = "but only digest increases maximum synergy."

                return descriptionA + descriptionB + descriptionC
            EndFunction
            
            Event OnSelectST()
                Debug.MessageBox(Description())
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State stats_Mode
            string Function Description()
                string descriptionA = "The state of storage. Define what happen with unclaimed stored souls.\n"
                string descriptionB = ""
                
                If (storageMode == "Digest")
                    descriptionB = "Digest: The smaller piece of soul are converted into synergy."
                elseif (storageMode == "Gestation")
                    descriptionB = "Gestation: Synergy are used to turn weakest soul into larger souls."
                else
                    descriptionB = "Disabled: Souls cann't be stored and any atempt to absorb will fail"
                EndIf

                return descriptionA + descriptionB
            EndFunction

            Event OnSelectST()
                Debug.MessageBox(Description())
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State stats_TotalNumberOfSouls

            Event OnSelectST()
                Debug.MessageBox("Total number of stored souls")
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored souls")
            EndEvent
        EndState

        State stats_NumberOfPetty

            Event OnSelectST()
                Debug.MessageBox("Total number of stored petty souls")
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored petty souls")
            EndEvent
        EndState

        State stats_NumberOfLesser

            Event OnSelectST()
                Debug.MessageBox("Total number of stored lesser souls")
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored lesser souls")
            EndEvent
        EndState

        State stats_NumberOfCommon

            Event OnSelectST()
                Debug.MessageBox("Total number of stored common souls")
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored common souls")
            EndEvent
        EndState

        State stats_NumberOfGreater

            Event OnSelectST()
                Debug.MessageBox("Total number of stored greater souls")
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored greater souls")
            EndEvent
        EndState

        State stats_NumberOfGrand

            Event OnSelectST()
                Debug.MessageBox("Total number of stored grand souls")
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored grand souls")
            EndEvent
        EndState

    ;Storage
        State storage_MultiplierReduction

            Event OnSliderOpenST()
                SetSliderDialogStartValue(multiplierScalePorcentage)
                SetSliderDialogDefaultValue(default_MultiplierScalePorcentage)
                SetSliderDialogRange(0, 100)
                SetSliderDialogInterval(1)
            EndEvent

            Event OnSliderAcceptST(float value)
                multiplierScalePorcentage = value
                SetSliderOptionValueST(multiplierScalePorcentage, "{0}%")
            EndEvent

            Event OnDefaultST()
                multiplierScalePorcentage = default_MultiplierScalePorcentage
                SetSliderOptionValueST(multiplierScalePorcentage, "{0}%")
            EndEvent

            Event OnHighlightST()
                SetInfoText("For each stored soul, scaling multipliers will be reduced by this porcentage (if enabled) (0-100)")
            EndEvent
        EndState

    ;Visual
;//////////////////////////////////////////////// BELLY ///////////////////////////////////////////////////////;
        State visual_Belly_ScalingValue
            Event OnMenuOpenST()
                SetMenuDialogStartIndex(bellyScalingVar)
                SetMenuDialogDefaultIndex(default_BellyScalingVar)
                SetMenuDialogOptions(ScalingVars)
            EndEvent

            Event OnMenuAcceptST(int value)
                bellyScalingVar = value
                SetMenuOptionValueST(ScalingVars[bellyScalingVar])

                If (value == 0)
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Belly_ScalingStart")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Belly_Multiplier")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Belly_Offset")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Belly_ReduceMultiplier")
                else
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Belly_ScalingStart")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Belly_Multiplier")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Belly_Offset")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Belly_ReduceMultiplier")
                EndIf
            EndEvent

            Event OnDefaultST()
                bellyScalingVar = default_BellyScalingVar
                SetMenuOptionValueST(ScalingVars[bellyScalingVar])
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Belly_ScalingStart
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Belly_Multiplier
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Belly_Offset
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Belly_ReduceMultiplier
            Event OnSelectST()
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState
;//////////////////////////////////////////////// BREAST ///////////////////////////////////////////////////////;
        State visual_Breast_ScalingValue
            Event OnMenuOpenST()
                SetMenuDialogStartIndex(breastScalingVar)
                SetMenuDialogDefaultIndex(default_BreastScalingVar)
                SetMenuDialogOptions(ScalingVars)
            EndEvent

            Event OnMenuAcceptST(int value)
                breastScalingVar = value
                SetMenuOptionValueST(ScalingVars[breastScalingVar])

                If (value == 0)
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Breast_ScalingStart")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Breast_Multiplier")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Breast_Offset")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Breast_ReduceMultiplier")
                else
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Breast_ScalingStart")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Breast_Multiplier")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Breast_Offset")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Breast_ReduceMultiplier")
                EndIf
            EndEvent

            Event OnDefaultST()
                breastScalingVar = default_BreastScalingVar
                SetMenuOptionValueST(ScalingVars[breastScalingVar])
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Breast_ScalingStart
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Breast_Multiplier
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Breast_Offset
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Breast_ReduceMultiplier
            Event OnSelectST()
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState
;//////////////////////////////////////////////// BUTT ///////////////////////////////////////////////////////;
        State visual_Butt_ScalingValue
            Event OnMenuOpenST()
                SetMenuDialogStartIndex(buttScalingVar)
                SetMenuDialogDefaultIndex(default_ButtScalingVar)
                SetMenuDialogOptions(ScalingVars)
            EndEvent

            Event OnMenuAcceptST(int value)
                buttScalingVar = value
                SetMenuOptionValueST(ScalingVars[buttScalingVar])

                If (value == 0)
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Butt_ScalingStart")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Butt_Multiplier")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Butt_Offset")
                    SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "visual_Butt_ReduceMultiplier")
                else
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Butt_ScalingStart")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Butt_Multiplier")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Butt_Offset")
                    SetOptionFlagsST(OPTION_FLAG_NONE, false, "visual_Butt_ReduceMultiplier")
                EndIf
            EndEvent

            Event OnDefaultST()
                buttScalingVar = default_ButtScalingVar
                SetMenuOptionValueST(ScalingVars[buttScalingVar])
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Butt_ScalingStart
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Butt_Multiplier
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Butt_Offset
            Event OnSliderOpenST()
            EndEvent

            Event OnSliderAcceptST(float value)
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState

        State visual_Butt_ReduceMultiplier
            Event OnSelectST()
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText("")
            EndEvent
        EndState


    ;System
        State system_DebugMode
            Event OnSelectST()
                {Called when a non-interactive state option has been selected.}
                dbg = !dbg
                SetToggleOptionValueST(dbg)
            EndEvent

            Event OnDefaultST()
                {Called when resetting a state option to its default value.}
                dbg = default_Dbg
                SetToggleOptionValueST(dbg)
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