Scriptname SE_Config_Script extends SKI_ConfigBase 
{Script for Soul Eater MCM}

import StringUtil

;/// Properties ///;
    SE_StorageManager_Script Property Storage Auto
    SE_ScaleManager_Script Property Scale Auto

    ;TODO: Check Properties usage
    ; Settings
        ; Stats
            ;TODO: Absorb Stats and skills (most read only)

            float Property synergyLevel Auto Hidden
            {Increases over time. digesting souls or breaking filled soulgems accelerate charge}

            float Property maxSynergy Auto Hidden
            {Increase with SynergyLevel while and only in digest mode}

            int Property storageMode Auto Hidden ;TODO: The mode can be changed at soul stone once per day or at end of previous mode.
            {What happening with unclaimed stored souls (0-2)}

            int[] Property numberOfSouls Auto Hidden
            {Number of stored souls, ordered by soul size (0-4) = (petty-grand)}

            float Property maxCapacity Auto Hidden ;Unused
            {The max amount of souls charge which can be hold inside caster}

            float Property bellySize Auto Hidden ;Unused
            {The current belly size (set by this mod)}

            float Property maxBellySize Auto Hidden ;Unused
            {The current belly size at 100% capacity}

            float Property breastSize Auto Hidden ;Unused
            {The current breast size (set by this mod)}

            float Property maxBreastSize Auto Hidden ;Unused
            {The current max breast size (based on maxBellySize)}

            float Property burstChance Auto Hidden ;Unused
            {The chance for bursting are checked every time belly size increases}

        ; Storage
            ;TODO: Settings related to storage

            bool Property enableCapacityModifiers Auto Hidden ;Unused
            {Apply Buffs/Debuffs based on fulles stage}

            bool Property enableCapacityEffects Auto Hidden ;Unused
            {Apply effects based on fulles stage}

            float Property firstStageScale Auto Hidden ;Unused
            {% of capacity usage considered small (0-100)}

            float Property secondStageScale Auto Hidden ;Unused
            {% of capacity usage considered medium (0-100)}

            float Property thirthStageScale Auto Hidden ;Unused
            {% of capacity usage considered high (0-100)}

            bool Property allowDangerousScale Auto Hidden ;Unused
            {Trespassing max capacity can kill}

            float Property burstScale Auto Hidden ;Unused
            {% above max capacity where burst chance reach 100% (0-100)}

            float Property stretch Auto Hidden ;Unused
            {If at ThirthStage, increase max capacity by this value over time (set 0 to disable)}

        ; Visual
            ;TODO: Settings related to effects and scale proportions

            bool Property sheLikesIt Auto Hidden ;Unused
            {Scaling triggers specials dialogs and buffs}

            bool Property sheLovesIt Auto Hidden ;Unused
            {Scaling triggers pleasure effects like arousal and moan sounds (require SLFramework and SLAroused)}

            bool Property applyAnimations Auto Hidden ;Unused
            {Include animations when applying effects or/and dialogues}

            ; Belly Scaling
                ;TODO: Belly scales with storage usage at both storage modes

                bool Property enableBellyScaling Auto Hidden ;Unused
                {Toggle belly scaling}

                float Property bellyMinSize Auto Hidden ;Unused
                {Belly size will be scaled above this}

                float Property bellyBaseMaxSize Auto Hidden ;Unused
                {The size of belly at 100% capacity without stretches}

                float Property bellyStretch Auto Hidden ;Unused
                {The value to add to bellyMaxSize for each stretch}

                float Property bellyMultiplier Auto Hidden ;TODO: recheck
                {Multiply belly scale by this value}

            ; Breast Scaling
                ;TODO: Breast scales over time while carrying souls at both storage modes

                bool Property enableBreastScaling Auto Hidden ;Unused
                {Toggle breast scaling}

                float Property breastMinSize Auto Hidden ;Unused
                {Breast size will be scaled above this}

                float Property bellyToBreastMaxSize Auto Hidden ;Unused
                {Scale of maxBellySize to use as maxBreastSize}

                float Property breastIncrementValue Auto Hidden ;Unused
                {Value to add to breast scale over time while carrying souls}

                float Property breastDecrementValue Auto Hidden ;Unused
                {Value to subtract from breast scale over time while not carrying souls}

                float Property breastMultiplier Auto Hidden ;TODO: recheck
                {Multiply breast scale by this value}

            ; Butt Scaling
                ;TODO: implement butt scaling?
        
        ; System
            ;TODO: Misc settings

            bool Property dbg Auto Hidden
            {Toggle debug notifications}

            int Property Version = 25 AutoReadOnly ;TODO: <- Change before tests
            {Mod version}

            string Property VersionString = "0.1.25" AutoReadOnly ;TODO: <- Change before tests
            {Mod version (string)}

;/// Variables ///;
    bool confirmReset = false

    ; Settings Default Values
        ; Stats
            float default_synergyLevel = 0.0
            float default_maxSynergy = 0.0
            int default_storageMode = 0
            float default_maxCapacity = 30.0

        ; Storage
            bool default_enableCapacityModifiers = true
            bool default_enableCapacityEffects = true
            float default_firstStageScale = 25.0
            float default_secondStageScale = 50.0
            float default_thirthStageScale = 75.0
            bool default_allowDangerousScale = true
            float default_burstScale = 100.0
            float default_stretch = 1.0

        ; Visual
            bool default_sheLikesIt = true
            bool default_sheLovesIt = true
            bool default_applyAnimations = true

            ; Belly Scaling
                bool default_enableBellyScaling = false
                float default_bellyMinSize = 1.00
                float default_bellyBaseMaxSize = 3.00
                float default_bellyStretch = 0.08
                float default_bellyMultiplier = 1.00

            ; Breast Scaling
                bool default_enableBreastScaling = false
                float default_breastMinSize = 1.00
                float default_bellyToBreastMaxSize = 0.112
                float default_breastIncrementValue = 0.010
                float default_breastDecrementValue = 0.050
                float default_breastMultiplier = 1.00

        ; System
            bool default_dbg = false

;/// Menu Entries ///;
    string[] StorageModes

    ; Creation
    Function SetEntries()
        StorageModes = new string[3]
            StorageModes[0] = "Disabled"
            StorageModes[1] = "Digest"
            StorageModes[2] = "Gestation"
    EndFunction

;/// Functions ///;
    ; Returns mod version string
    string Function GetVersionString()
        return VersionString
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
        string descriptionA = "Missing description!"
        string descriptionB = ""
        string descriptionC = ""

        return descriptionA + descriptionB + descriptionC
    EndFunction

    int Function GetVersion()
        return Version
    EndFunction

    ; Set all settings to its default_ values
    Function ResetSettings()
        ;Storage
        enableCapacityModifiers = default_enableCapacityModifiers
        enableCapacityEffects = default_enableCapacityEffects
        firstStageScale = default_firstStageScale
        secondStageScale = default_secondStageScale
        thirthStageScale = default_thirthStageScale
        allowDangerousScale = default_allowDangerousScale
        burstScale = default_burstScale
        stretch = default_stretch

        ;Visual
        sheLikesIt = default_sheLikesIt
        sheLovesIt = default_sheLovesIt
        applyAnimations = default_applyAnimations

        ;Belly Scaling
        enableBellyScaling = default_enableBellyScaling
        bellyMinSize = default_bellyMinSize
        bellyBaseMaxSize = default_bellyBaseMaxSize
        bellyStretch = default_bellyStretch
        bellyMultiplier = default_bellyMultiplier

        ;Breast Scaling
        enableBreastScaling = default_enableBreastScaling
        breastMinSize = default_breastMinSize
        bellyToBreastMaxSize = default_bellyToBreastMaxSize
        breastIncrementValue = default_breastIncrementValue
        breastDecrementValue = default_breastDecrementValue
        breastMultiplier = default_breastMultiplier

        ;System
        dbg = default_dbg
    EndFunction

    ; Reset all stats and progress
    Function ResetStats()
        ;TODO: Remove spells and powers from player
        synergyLevel = default_synergyLevel
        maxSynergy = default_maxSynergy
        numberOfSouls = new int[5]
        numberOfSouls[0] = 0
        numberOfSouls[1] = 0
        numberOfSouls[2] = 0
        numberOfSouls[3] = 0
        numberOfSouls[4] = 0
        storageMode = default_storageMode
        maxCapacity = default_maxCapacity
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