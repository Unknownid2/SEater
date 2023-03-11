Scriptname SE_Config_Script extends SKI_ConfigBase 
{Script for Soul Eater MCM}

import StringUtil


;/// Settings ///;
    ; Stats
        ;TODO: Absorb Stats and skills (most read only)

        GlobalVariable Property SE_fSynergyLevel_Global Auto ; Used to forge larger souls at gestation mode
        {Increases over time. digesting souls or breaking filled soulgems accelerate charge}








































        int Property Version = 25 AutoReadOnly ;TODO: <- Change before tests
        {Mod version}

;/// Properties ///;
    SE_StorageManager_Script Property Storage Auto
    SE_ScaleManager_Script Property Scale Auto
    bool Property ConfirmReset = false Auto Hidden

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
    int default_StorageMode = 0

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
        return "0.1.25" ;TODO: <- Change before tests
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

    ; Set all settings to its default_ values
    Function ResetSettings()
        enableCapacityModifiers = default_EnableCapacityModifiers
        enableCapacityEffects = default_EnableCapacityEffects
        allowDangerousScale = default_AllowDangerousScale
        sheLikesIt = default_SheLikesIt
        sheLovesIt = default_SheLovesIt
        applyAnimations = default_ApplyAnimations
        scaleBellyMultiplier = default_ScaleBellyMultiplier
        scaleBreastMultiplier = default_ScaleBreastMultiplier
        scaleButtMultiplier = default_ScaleButtMultiplier
        dbg = default_Dbg
        maxCapacity = default_MaxCapacity
        firstStageScale = default_FirstStageScale
        secondStageScale = default_SecondStageScale
        thirthStageScale = default_ThirthStageScale
        burstScale = default_BurstScale
        stretch = default_Stretch
        multiplierScalePorcentage = default_MultiplierScalePorcentage
        bellyScalingStart = default_BellyScalingStart
        bellyMultiplier = default_BellyMultiplier
        bellyScaleOffset = default_BellyScaleOffset
        breastScalingStart = default_BreastScalingStart
        breastMultiplier = default_BreastMultiplier
        breastScaleOffset = default_BreastScaleOffset
        buttScalingStart = default_ButtScalingStart
        buttMultiplier = default_ButtMultiplier
        buttScaleOffset = default_ButtScaleOffset
        bellyScalingVar = default_BellyScalingVar
        breastScalingVar = default_BreastScalingVar
        buttScalingVar = default_ButtScalingVar
    EndFunction

    ; Reset all stats and progress
    Function ResetStats()
        ;TODO: Remove spells and powers from player
        synergyLevel = default_SynergyLevel
        maxSynergy = default_MaxSynergy
        numberOfSouls = new int[5]
        numberOfSouls[0] = 0
        numberOfSouls[1] = 0
        numberOfSouls[2] = 0
        numberOfSouls[3] = 0
        numberOfSouls[4] = 0
        storageMode = default_StorageMode
    EndFunction

    ; Enable/Greyout specific scaling node options (Belly, Breast or Butt) (0 = Disable, 1 = Enable)
    Function ToggleScalingOptions(string node, float value)
        If (node == "Belly")
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
        Elseif (node == "Breast")
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
        Else
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
        EndIf
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

        SetEnums()
        Debug.Notification("SEater: Ready!")
    EndEvent
    
    Event OnConfigOpen()
        {Called when this config menu is opened}
    EndEvent
    
    Event OnConfigClose()
        {Called when this config menu is closed}
        Scale.UpdateScale()
        ConfirmReset = false
    EndEvent
    
    Event OnVersionUpdate(int aVersion)
        {Called when aVersion update of this script has been detected}
        ;TODO: Update code (if needed)
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
            ToggleScalingOptions("Belly", bellyScalingVar)
            ToggleScalingOptions("Breast", breastScalingVar)
            ToggleScalingOptions("Butt", buttScalingVar)

            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)

            ;Scaling
            SetCursorPosition(1)
            AddHeaderOption("Belly Scaling")
            AddMenuOptionST("visual_Belly_ScalingValue", "Scaling value", ScalingVars[bellyScalingVar])
            AddSliderOptionST("visual_Belly_ScalingStart", "Scaling start", bellyScalingStart, "{1}")
            AddSliderOptionST("visual_Belly_Multiplier", "Multiplier", bellyMultiplier, "{3}")
            AddSliderOptionST("visual_Belly_Offset", "Offset", bellyScaleOffset, "{2}")
            AddToggleOptionST("visual_Belly_ReduceMultiplier", "Reduce multiplier", scaleBellyMultiplier)
            AddEmptyOption()

            AddHeaderOption("Breast Scaling")
            AddMenuOptionST("visual_Breast_ScalingValue", "Scaling value", ScalingVars[breastScalingVar])
            AddSliderOptionST("visual_Breast_ScalingStart", "Scaling start", breastScalingStart, "{1}")
            AddSliderOptionST("visual_Breast_Multiplier", "Multiplier", breastMultiplier, "{3}")
            AddSliderOptionST("visual_Breast_Offset", "Offset", breastScaleOffset, "{2}")
            AddToggleOptionST("visual_Breast_ReduceMultiplier", "Reduce multiplier", scaleBreastMultiplier)
            AddEmptyOption()

            AddHeaderOption("Butt Scaling")
            AddMenuOptionST("visual_Butt_ScalingValue", "Scaling value", ScalingVars[buttScalingVar])
            AddSliderOptionST("visual_Butt_ScalingStart", "Scaling start", buttScalingStart, "{1}")
            AddSliderOptionST("visual_Butt_Multiplier", "Multiplier", buttMultiplier, "{3}")
            AddSliderOptionST("visual_Butt_Offset", "Offset", buttScaleOffset, "{2}")
            AddToggleOptionST("visual_Butt_ReduceMultiplier", "Reduce multiplier", scaleButtMultiplier)

        elseif(a_page == "System")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddToggleOptionST("system_DebugMode", "Debug mode", dbg)
            AddTextOptionST("system_Version", "Version", GetVersionString())
            
            SetCursorPosition(1)
            AddTextOptionST("system_ResetSettings", "Reset settings", "")
            AddTextOptionST("system_ResetStats", "Reset stats", "")
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
                string descriptionC = " but only digest increases maximum synergy."

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
                
                If (storageMode == 1)
                    descriptionB = "Digest: The smaller piece of soul are converted into synergy."
                elseif (storageMode == 2)
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
            string Function Description()
                string descriptionA = "Wich value to use for belly inflation.\n"
                string descriptionB = ""

                If (bellyScalingVar == 1)
                    descriptionB = "Soul charge level: Use soul charge level to scale belly."
                elseif(bellyScalingVar == 2)
                    descriptionB = "Synergy level: use synergy level to scale belly."
                elseif(bellyScalingVar == 3)
                    descriptionB = "Mode progress: Use synergy changes to scale belly."
                    descriptionB = "Not implemented yet." ;TODO: remove after implementation
                elseif(bellyScalingVar == 4)
                    descriptionB = "Max charge level: Use storage max capacity to scale belly."
                elseif(bellyScalingVar == 5)
                    descriptionB = "Max synergy level: Use max acumulated synergy to scale belly."
                else
                    descriptionB = "Disabled: Do not use any value and disable belly scaling."
                EndIf
        
                return descriptionA + descriptionB
            EndFunction

            Event OnMenuOpenST()
                SetMenuDialogStartIndex(bellyScalingVar)
                SetMenuDialogDefaultIndex(default_BellyScalingVar)
                SetMenuDialogOptions(ScalingVars)
            EndEvent

            Event OnMenuAcceptST(int value)
                bellyScalingVar = value
                SetMenuOptionValueST(ScalingVars[bellyScalingVar])

                ToggleScalingOptions("Belly", value)
            EndEvent

            Event OnDefaultST()
                bellyScalingVar = default_BellyScalingVar
                SetMenuOptionValueST(ScalingVars[bellyScalingVar])
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State visual_Belly_ScalingStart
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyScalingStart)
                SetSliderDialogDefaultValue(default_BellyScalingStart)
                SetSliderDialogRange(0.0, 100.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyScalingStart = value
                SetSliderOptionValueST(bellyScalingStart, "{1}")
            EndEvent

            Event OnDefaultST()
                bellyScalingStart = default_BellyScalingStart
                SetSliderOptionValueST(bellyScalingStart, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Belly will start growing when selected value is equal or greater than this.")
            EndEvent
        EndState

        State visual_Belly_Multiplier
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyMultiplier)
                SetSliderDialogDefaultValue(default_BellyMultiplier)
                SetSliderDialogRange(0.000, 1.000)
                SetSliderDialogInterval(0.001)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyMultiplier = value
                SetSliderOptionValueST(bellyMultiplier, "{3}")
            EndEvent

            Event OnDefaultST()
                bellyMultiplier = default_BellyMultiplier
                SetSliderOptionValueST(bellyMultiplier, "{3}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Multiply belly scale by this")
            EndEvent
        EndState

        State visual_Belly_Offset
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyScaleOffset)
                SetSliderDialogDefaultValue(default_BellyScaleOffset)
                SetSliderDialogRange(-30.0, 30.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyScaleOffset = value
                SetSliderOptionValueST(bellyScaleOffset, "{1}")
            EndEvent

            Event OnDefaultST()
                bellyScaleOffset = default_BellyScaleOffset
                SetSliderOptionValueST(bellyScaleOffset, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Base scale value (Modify scaling result by this value)")
            EndEvent
        EndState

        State visual_Belly_ReduceMultiplier
            Event OnSelectST()
                scaleBellyMultiplier = !scaleBellyMultiplier
                SetToggleOptionValueST(scaleBellyMultiplier)
            EndEvent

            Event OnDefaultST()
                scaleBellyMultiplier = default_ScaleBellyMultiplier
                SetToggleOptionValueST(scaleBellyMultiplier)
            EndEvent

            Event OnHighlightST()
                SetInfoText("Reduce belly scale multiplier by number of souls (good for balancing purposes).")
            EndEvent
        EndState
        ;//////////////////////////////////////////////// BREAST ///////////////////////////////////////////////////////;
        State visual_Breast_ScalingValue
            string Function Description()
                string descriptionA = "Wich value to use for breast inflation.\n"
                string descriptionB = ""

                If (bellyScalingVar == 1)
                    descriptionB = "Soul charge level: Use soul charge level to scale breast."
                elseif(bellyScalingVar == 2)
                    descriptionB = "Synergy level: use synergy level to scale breast."
                elseif(bellyScalingVar == 3)
                    descriptionB = "Mode progress: Use synergy changes to scale breast."
                    descriptionB = "Not implemented yet." ;TODO: remove after implementation
                elseif(bellyScalingVar == 4)
                    descriptionB = "Max charge level: Use storage max capacity to scale breast."
                elseif(bellyScalingVar == 5)
                    descriptionB = "Max synergy level: Use max acumulated synergy to scale breast."
                else
                    descriptionB = "Disabled: Do not use any value and disable breast scaling."
                EndIf
        
                return descriptionA + descriptionB
            EndFunction

            Event OnMenuOpenST()
                SetMenuDialogStartIndex(breastScalingVar)
                SetMenuDialogDefaultIndex(default_BreastScalingVar)
                SetMenuDialogOptions(ScalingVars)
            EndEvent

            Event OnMenuAcceptST(int value)
                breastScalingVar = value
                SetMenuOptionValueST(ScalingVars[breastScalingVar])

                ToggleScalingOptions("Breast", value)
            EndEvent

            Event OnDefaultST()
                breastScalingVar = default_BreastScalingVar
                SetMenuOptionValueST(ScalingVars[breastScalingVar])
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State visual_Breast_ScalingStart
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastScalingStart)
                SetSliderDialogDefaultValue(default_BreastScalingStart)
                SetSliderDialogRange(0.0, 100.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastScalingStart = value
                SetSliderOptionValueST(breastScalingStart, "{1}")
            EndEvent

            Event OnDefaultST()
                breastScalingStart = default_BreastScalingStart
                SetSliderOptionValueST(breastScalingStart, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Breast will start growing when selected value is equal or greater than this.")
            EndEvent
        EndState

        State visual_Breast_Multiplier
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastMultiplier)
                SetSliderDialogDefaultValue(default_BreastMultiplier)
                SetSliderDialogRange(0.000, 1.000)
                SetSliderDialogInterval(0.001)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastMultiplier = value
                SetSliderOptionValueST(breastMultiplier, "{3}")
            EndEvent

            Event OnDefaultST()
                breastMultiplier = default_BreastMultiplier
                SetSliderOptionValueST(breastMultiplier, "{3}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Multiply breast scale by this")
            EndEvent
        EndState

        State visual_Breast_Offset
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastScaleOffset)
                SetSliderDialogDefaultValue(default_BreastScaleOffset)
                SetSliderDialogRange(-30.0, 30.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastScaleOffset = value
                SetSliderOptionValueST(breastScaleOffset, "{1}")
            EndEvent

            Event OnDefaultST()
                breastScaleOffset = default_BreastScaleOffset
                SetSliderOptionValueST(breastScaleOffset, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Base scale value (Modify scaling result by this value)")
            EndEvent
        EndState

        State visual_Breast_ReduceMultiplier
            Event OnSelectST()
                scaleBreastMultiplier = !scaleBreastMultiplier
                SetToggleOptionValueST(scaleBreastMultiplier)
            EndEvent

            Event OnDefaultST()
                scaleBreastMultiplier = default_ScaleBreastMultiplier
                SetToggleOptionValueST(scaleBreastMultiplier)
            EndEvent

            Event OnHighlightST()
                SetInfoText("Reduce breast scale multiplier by number of souls (good for balancing purposes)")
            EndEvent
        EndState
        ;//////////////////////////////////////////////// BUTT ///////////////////////////////////////////////////////;
        State visual_Butt_ScalingValue
            string Function Description()
                string descriptionA = "Wich value to use for butt inflation.\n"
                string descriptionB = ""

                If (bellyScalingVar == 1)
                    descriptionB = "Soul charge level: Use soul charge level to scale butt."
                elseif(bellyScalingVar == 2)
                    descriptionB = "Synergy level: use synergy level to scale butt."
                elseif(bellyScalingVar == 3)
                    descriptionB = "Mode progress: Use synergy changes to scale butt."
                    descriptionB = "Not implemented yet." ;TODO: remove after implementation
                elseif(bellyScalingVar == 4)
                    descriptionB = "Max charge level: Use storage max capacity to scale butt."
                elseif(bellyScalingVar == 5)
                    descriptionB = "Max synergy level: Use max acumulated synergy to scale butt."
                else
                    descriptionB = "Disabled: Do not use any value and disable butt scaling."
                EndIf
        
                return descriptionA + descriptionB
            EndFunction

            Event OnMenuOpenST()
                SetMenuDialogStartIndex(buttScalingVar)
                SetMenuDialogDefaultIndex(default_ButtScalingVar)
                SetMenuDialogOptions(ScalingVars)
            EndEvent

            Event OnMenuAcceptST(int value)
                buttScalingVar = value
                SetMenuOptionValueST(ScalingVars[buttScalingVar])

                ToggleScalingOptions("Butt", value)
            EndEvent

            Event OnDefaultST()
                buttScalingVar = default_ButtScalingVar
                SetMenuOptionValueST(ScalingVars[buttScalingVar])
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State visual_Butt_ScalingStart
            Event OnSliderOpenST()
                SetSliderDialogStartValue(buttScalingStart)
                SetSliderDialogDefaultValue(default_ButtScalingStart)
                SetSliderDialogRange(0.0, 100.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                buttScalingStart = value
                SetSliderOptionValueST(buttScalingStart, "{1}")
            EndEvent

            Event OnDefaultST()
                buttScalingStart = default_ButtScalingStart
                SetSliderOptionValueST(buttScalingStart, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Butt will start growing when selected value is equal or greater than this.")
            EndEvent
        EndState

        State visual_Butt_Multiplier
            Event OnSliderOpenST()
                SetSliderDialogStartValue(buttMultiplier)
                SetSliderDialogDefaultValue(default_ButtMultiplier)
                SetSliderDialogRange(0.000, 1.000)
                SetSliderDialogInterval(0.001)
            EndEvent

            Event OnSliderAcceptST(float value)
                buttMultiplier = value
                SetSliderOptionValueST(buttMultiplier, "{3}")
            EndEvent

            Event OnDefaultST()
                buttMultiplier = default_ButtMultiplier
                SetSliderOptionValueST(buttMultiplier, "{3}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Multiply butt scale by this")
            EndEvent
        EndState

        State visual_Butt_Offset
            Event OnSliderOpenST()
                SetSliderDialogStartValue(buttScaleOffset)
                SetSliderDialogDefaultValue(default_ButtScaleOffset)
                SetSliderDialogRange(-30.0, 30.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                buttScaleOffset = value
                SetSliderOptionValueST(buttScaleOffset, "{1}")
            EndEvent

            Event OnDefaultST()
                buttScaleOffset = default_ButtScaleOffset
                SetSliderOptionValueST(buttScaleOffset, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Base scale value (Modify scaling result by this value)")
            EndEvent
        EndState

        State visual_Butt_ReduceMultiplier
            Event OnSelectST()
                scaleButtMultiplier = !scaleButtMultiplier
                SetToggleOptionValueST(scaleButtMultiplier)
            EndEvent

            Event OnDefaultST()
                scaleButtMultiplier = default_ScaleButtMultiplier
                SetToggleOptionValueST(scaleButtMultiplier)
            EndEvent

            Event OnHighlightST()
                SetInfoText("Reduce butt scale multiplier by number of souls (good for balancing purposes)")
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
            Event OnSelectST()
                ; Nothing
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Build: " + GetVersion())
            EndEvent
        EndState

        State system_ResetSettings
            Event OnSelectST()
                If (ConfirmReset)
                    ResetSettings()
                    SetTextOptionValueST("")
                    Debug.MessageBox("Close all menus")
                Else
                    ConfirmReset = true
                    SetTextOptionValueST("Confirm?")
                EndIf
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Reset all mod settings to its default values.")
            EndEvent
        EndState

        State system_ResetStats
            Event OnSelectST()
                If (ConfirmReset)
                    ResetStats()
                    SetTextOptionValueST("")
                    Debug.MessageBox("Close all menus")
                Else
                    ConfirmReset = true
                    SetTextOptionValueST("Confirm?")
                EndIf
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Reset all player stats")
            EndEvent
        EndState