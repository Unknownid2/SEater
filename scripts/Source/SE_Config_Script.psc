Scriptname SE_Config_Script extends SKI_ConfigBase 
{Script for Soul Eater MCM}

import StringUtil

;/// Variables ///;
    bool confirmReset = false

    ; Settings Default Values
        ; Stats
            float default_synergyLevel = 0.0
            float default_maxSynergy = 0.0
            int default_storageMode = 0
            float default_maxCapacity = 30.0
            int default_numberOfStretches = 0

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

;/// Properties ///;
    SE_StorageManager_Script Property Storage Auto
    SE_ScaleManager_Script Property Scale Auto
    int Property bellyScalingOptionsFlag Hidden
        int Function Get()
            If (enableBellyScaling)
                return OPTION_FLAG_NONE
            Else
                return OPTION_FLAG_DISABLED
            EndIf
        EndFunction

        Function Set(int value)
            SetOptionFlagsST(value, false, visual_Belly_MinSize)
            SetOptionFlagsST(value, false, visual_Belly_BaseMaxSize)
            SetOptionFlagsST(value, false, visual_Belly_StretchValue)
            SetOptionFlagsST(value, false, visual_Belly_Multiplier)
        EndFunction
    EndProperty

    int Property breastScalingOptionsFlag Hidden
        int Function Get()
            If (enableBreastScaling)
                return OPTION_FLAG_NONE
            Else
                return OPTION_FLAG_DISABLED
            EndIf
        EndFunction

        Function Set(int value)
            SetOptionFlagsST(value, false, visual_Breast_MinSize)
            SetOptionFlagsST(value, false, visual_Breast_MaxSizeScale)
            SetOptionFlagsST(value, false, visual_Breast_Increment)
            SetOptionFlagsST(value, false, visual_Breast_Decrement)
            SetOptionFlagsST(value, false, visual_Breast_Multiplier)
        EndFunction
    EndProperty

    ;TODO: Check Properties usage
    ; Settings
        ; Stats
            ;TODO: Absorb Stats and skills (most read only)

            float Property burstChance Auto Hidden ;Unused
            {The chance for bursting are checked every time belly size increases}

            int Property numberOfStretches Auto Hidden
            {The number of stretches increases over time at 100% capacity usage or more}

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

            float Property stretch Auto Hidden
            {increase max capacity by this value over time while equal or above 100% usage (set 0 to disable)}

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

                bool Property enableBellyScaling Auto Hidden
                {Toggle belly scaling}

                float Property bellyMinSize Auto Hidden
                {Belly size will be scaled above this}

                float Property bellyBaseMaxSize Auto Hidden
                {The size of belly at 100% capacity without stretches}

                float Property bellyStretch Auto Hidden
                {The value to add to bellyMaxSize for each stretch}

                float Property bellyMultiplier Auto Hidden
                {Multiply belly scale by this value}

            ; Breast Scaling
                ; Breast scales over time while carrying souls at both storage modes

                bool Property enableBreastScaling Auto Hidden
                {Toggle breast scaling}

                float Property breastMinSize Auto Hidden
                {Breast size will be scaled above this}

                float Property bellyToBreastMaxSize Auto Hidden
                {Scale of maxBellySize to use as maxBreastSize}

                float Property breastIncrementValue Auto Hidden
                {Value to add to breast scale over time while carrying souls}

                float Property breastDecrementValue Auto Hidden
                {Value to subtract from breast scale over time while not carrying souls}

                float Property breastMultiplier Auto Hidden
                {Multiply breast scale by this value}

            ; Butt Scaling
                ;TODO: implement butt scaling?
        
        ; System
            ;TODO: Misc settings

            bool Property dbg Auto Hidden
            {Toggle debug notifications}

            int Property Version = 27 AutoReadOnly ;TODO: <- Change before tests
            {Mod version}

            string Property VersionString = "0.1.27" AutoReadOnly ;TODO: <- Change before tests
            {Mod version (string)}
    
    ;Full Settings
        ;Stats
            float Property synergyLevel Hidden ;TODO: "Increases over time" part
            {Increases over time. digesting souls or breaking filled soulgems accelerate charge}
                float Function Get()
                    return Storage.synergyLevel
                EndFunction
            EndProperty

            float Property maxSynergy Hidden
            {Increase with SynergyLevel while and only in digest mode}
                float Function Get()
                    return Storage.maxSynergy
                EndFunction
            EndProperty

            float Property maxCapacity Hidden
            {The max amount of souls charge which can be hold inside caster belly}
                float Function Get()
                    return default_maxCapacity + (numberOfStretches * stretch)
                EndFunction
            EndProperty

            int Property storageMode Hidden ;TODO: Use storage effect instead.
            {What happening with unclaimed stored souls (0-2)}
                int Function Get()
                    return Storage.storageMode
                EndFunction
            EndProperty

            int[] Property numberOfSouls Hidden
            {Number of stored souls, ordered by soul size (0-4) = (petty-grand)}
                int[] Function Get()
                    return Storage.numberOfSouls
                EndFunction
            EndProperty

            float Property bellySize Hidden
            {The current belly size (set by this mod)}
                float Function Get()
                    return Scale.bellySize
                EndFunction
            EndProperty

            float Property maxBellySize Hidden
            {The current belly size at 100% capacity}
                float Function Get()
                    return bellyBaseMaxSize + (numberOfStretches * bellyStretch)
                EndFunction
            EndProperty

            float Property breastSize Hidden
            {The current breast size (set by this mod)}
                float Function Get()
                    return Scale.breastSize
                EndFunction
            EndProperty

            float Property maxBreastSize Hidden
            {The current max breast size (based on maxBellySize)}
                float Function Get()
                    return bellyToBreastMaxSize * maxBellySize
                EndFunction
            EndProperty

;/// Menu Entries ///;
    string[] StorageModes

    ; Creation
    Function SetEntries()
        StorageModes = new string[3]
            StorageModes[0] = "Disabled"
            StorageModes[1] = "Digest"
            StorageModes[2] = "Gestation"
    EndFunction

;/// Options States ///;
    string stats_Synergy = "Stats_Synergy"
    string stats_CapacityUsage = "Stats_CapacityUsage"
    string stats_BellySize = "Stats_BellySize"
    string stats_MaxBellySize = "Stats_MaxBellySize"
    string stats_BreastSize = "Stats_BreastSize"
    string stats_MaxBreastSize = "Stats_MaxBreastSize"
    string stats_Stretches = "Stats_Stretches"
    string stats_Mode = "Stats_Mode"
    string stats_TotalNumberOfSouls = "Stats_TotalNumberOfSouls"
    string stats_NumberOfPetty = "Stats_NumberOfPetty"
    string stats_NumberOfLesser = "Stats_NumberOfLesser"
    string stats_NumberOfCommon = "Stats_NumberOfCommon"
    string stats_NumberOfGreater = "Stats_NumberOfGreater"
    string stats_NumberOfGrand = "Stats_NumberOfGrand"

    string storage_CapacityIncreaseAmount = "Storage_CapacityIncreaseAmount"

    string visual_Belly_Enable = "Visual_Belly_Enable"
    string visual_Belly_MinSize = "Visual_Belly_MinSize"
    string visual_Belly_BaseMaxSize = "Visual_Belly_BaseMaxSize"
    string visual_Belly_StretchValue = "Visual_Belly_StretchValue"
    string visual_Belly_Multiplier = "Visual_Belly_Multiplier"
    string visual_Breast_Enable = "Visual_Breast_Enable"
    string visual_Breast_MinSize = "Visual_Breast_MinSize"
    string visual_Breast_MaxSizeScale = "Visual_Breast_MaxSizeScale"
    string visual_Breast_Increment = "Visual_Breast_Increment"
    string visual_Breast_Decrement = "Visual_Breast_Decrement"
    string visual_Breast_Multiplier = "Visual_Breast_Multiplier"

    string system_DebugMode = "System_DebugMode"
    string system_Version = "System_Version"
    string system_ResetSettings = "System_ResetSettings"
    string system_ResetStats = "System_ResetStats"

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
        Storage.synergyLevel = default_synergyLevel
        Storage.maxSynergy = default_maxSynergy
        Storage.numberOfSouls = new int[5]
        Storage.storageMode = default_storageMode
        numberOfStretches = default_numberOfStretches
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
        SetEntries()
        Debug.Notification("SEater: Ready!")
    EndEvent
    
    Event OnConfigOpen()
        {Called when this config menu is opened}
    EndEvent
    
    Event OnConfigClose()
        {Called when this config menu is closed}
        Scale.UpdateScale()
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
            AddTextOptionST(stats_Synergy, "Synergy", FormatFloat(synergyLevel, 1) + "/" + FormatFloat(maxSynergy, 1))
            AddTextOptionST(stats_CapacityUsage, "Capacity Usage", FormatFloat(Storage.GetCapacityUsage(), 1) + "%")
            AddTextOptionST(stats_BellySize, "Belly size", FormatFloat(bellySize, 2))
            AddTextOptionST(stats_MaxBellySize, "Max belly size", FormatFloat(maxBellySize, 2))
            AddTextOptionST(stats_BreastSize, "Breast size", FormatFloat(breastSize, 2))
            AddTextOptionST(stats_MaxBreastSize, "Max breast size", FormatFloat(maxBreastSize, 2))
            AddTextOptionST(stats_Stretches, "Stretches", numberOfStretches)

            ;Stored Souls
            SetCursorPosition(1)
            AddTextOptionST(stats_Mode, "Mode", StorageModes[storageMode])
            AddHeaderOption("Stored Souls")
            AddTextOptionST(stats_TotalNumberOfSouls, "Total number of souls", Storage.GetNumberOfSouls())
            AddTextOptionST(stats_NumberOfPetty, "Number of petty souls", numberOfSouls[0])
            AddTextOptionST(stats_NumberOfLesser, "Number of lesser souls", numberOfSouls[1])
            AddTextOptionST(stats_NumberOfCommon, "Number of common souls", numberOfSouls[2])
            AddTextOptionST(stats_NumberOfGreater, "Number of greater souls", numberOfSouls[3])
            AddTextOptionST(stats_NumberOfGrand, "Number of grand souls", numberOfSouls[4])

        elseif(a_page == "Storage")
            SetCursorPosition(0)
            SetCursorFillMode(LEFT_TO_RIGHT)
            AddSliderOptionST(storage_CapacityIncreaseAmount, "Capacity increase amount", stretch, "{1}")

        elseif(a_page == "Visual")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)

            ;Scaling
            SetCursorPosition(1)
            AddHeaderOption("Belly Scaling")
            AddToggleOptionST(visual_Belly_Enable, "Enable", enableBellyScaling)
            AddSliderOptionST(visual_Belly_MinSize, "Min size", bellyMinSize, "{2}", bellyScalingOptionsFlag)
            AddSliderOptionST(visual_Belly_BaseMaxSize, "Base max size", bellyBaseMaxSize, "{2}", bellyScalingOptionsFlag)
            AddSliderOptionST(visual_Belly_StretchValue, "Stretch value", bellyStretch, "{2}", bellyScalingOptionsFlag)
            AddSliderOptionST(visual_Belly_Multiplier, "Multiplier", bellyMultiplier, "{2}", bellyScalingOptionsFlag)
            AddEmptyOption()

            AddHeaderOption("Breast Scaling")
            AddToggleOptionST(visual_Breast_Enable, "Enable", enableBreastScaling)
            AddSliderOptionST(visual_Breast_MinSize, "Min size", breastMinSize, "{2}", breastScalingOptionsFlag)
            AddSliderOptionST(visual_Breast_MaxSizeScale, "Max size scale", bellyToBreastMaxSize, "{3}", breastScalingOptionsFlag)
            AddSliderOptionST(visual_Breast_Increment, "Increment", breastIncrementValue, "{3}", breastScalingOptionsFlag)
            AddSliderOptionST(visual_Breast_Decrement, "Decrement", breastDecrementValue, "{3}", breastScalingOptionsFlag)
            AddSliderOptionST(visual_Breast_Multiplier, "Multiplier", breastMultiplier, "{2}", breastScalingOptionsFlag)
            AddEmptyOption()

        elseif(a_page == "System")
            confirmReset = false
            SetCursorPosition(1)
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddToggleOptionST(system_DebugMode, "Debug mode", dbg)
            AddTextOptionST(system_Version, "Version", GetVersionString())
            
            SetCursorPosition(0)
            AddTextOptionST(system_ResetSettings, "Reset settings", "")
            AddTextOptionST(system_ResetStats, "Reset stats", "")
        else
            ;TODO: Initial page
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
        State Stats_Synergy
            string Function Description()
                string descriptionA = "Used to forge larger souls at gestation mode.\n"
                string descriptionB = "Recharges over time while not carrying souls, "
                string descriptionC = "digesting souls increases maximum synergy."

                return descriptionA + descriptionB + descriptionC
            EndFunction
            
            Event OnSelectST()
                Debug.MessageBox(Description())
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State Stats_CapacityUsage
            string Function Description()
                string descriptionA = "Stored soul charges: " + FormatFloat(Storage.GetTotalChargeLevel(), 1)
                string descriptionB = "\nMax Capacity: " + FormatFloat(maxCapacity, 1)

                return descriptionA + descriptionB
            EndFunction

            Event OnSelectST()
                Debug.MessageBox(Description())
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Soul charge capacity usage %")
            EndEvent
        EndState

        State Stats_BellySize
            Event OnSelectST()
                Debug.MessageBox("The current belly size (set by this mod* Doesn't represent final size!).")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("The current belly size (set by this mod* Doesn't represent final size!).")
            EndEvent
        EndState

        State Stats_MaxBellySize
            Event OnSelectST()
                Debug.MessageBox("The maximum belly size player can reach.\nGoing too far from this value can be fatal!")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("The maximum belly size player can reach.\nGoing too far from this value can be fatal!")
            EndEvent
        EndState

        State Stats_BreastSize
            Event OnSelectST()
                Debug.MessageBox("The current breast size (set by this mod* Doesn't represent final size!).")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("The current breast size (set by this mod* Doesn't represent final size!).")
            EndEvent
        EndState

        State Stats_MaxBreastSize
            Event OnSelectST()
                Debug.MessageBox("The maximum breast size player can reach.\nIt increases based on maximum belly size.")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("The maximum breast size player can reach.\nIt increases based on maximum belly size.")
            EndEvent
        EndState

        State Stats_Stretches
            Event OnSelectST()
                Debug.MessageBox("The number of times maximum capacity has increased.")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("The number of times maximum capacity has increased.")
            EndEvent
        EndState

        State Stats_Mode
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
                Debug.MessageBox(Description() + "\nCheat: enable debug mode to change manually")

                If (dbg)
                    Storage.storageMode += 1

                    If (storageMode > 2)
                        Storage.storageMode = 0
                    EndIf
                EndIf
            EndEvent

            Event OnDefaultST()
            EndEvent

            Event OnHighlightST()
                SetInfoText(Description())
            EndEvent
        EndState

        State Stats_TotalNumberOfSouls

            Event OnSelectST()
                Debug.MessageBox("Total number of stored souls")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored souls")
            EndEvent
        EndState

        State Stats_NumberOfPetty

            Event OnSelectST()
                Debug.MessageBox("Total number of stored petty souls")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored petty souls")
            EndEvent
        EndState

        State Stats_NumberOfLesser

            Event OnSelectST()
                Debug.MessageBox("Total number of stored lesser souls")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored lesser souls")
            EndEvent
        EndState

        State Stats_NumberOfCommon

            Event OnSelectST()
                Debug.MessageBox("Total number of stored common souls")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored common souls")
            EndEvent
        EndState

        State Stats_NumberOfGreater

            Event OnSelectST()
                Debug.MessageBox("Total number of stored greater souls")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored greater souls")
            EndEvent
        EndState

        State Stats_NumberOfGrand

            Event OnSelectST()
                Debug.MessageBox("Total number of stored grand souls")
            EndEvent

            Event OnDefaultST()
                ; Nothing
            EndEvent

            Event OnHighlightST()
                SetInfoText("Total number of stored grand souls")
            EndEvent
        EndState

    ;Storage
        State Storage_CapacityIncreaseAmount
            Event OnSliderOpenST()
                SetSliderDialogStartValue(stretch)
                SetSliderDialogDefaultValue(default_stretch)
                SetSliderDialogRange(0.0, 30.0)
                SetSliderDialogInterval(0.1)
            EndEvent

            Event OnSliderAcceptST(float value)
                stretch = value
                SetSliderOptionValueST(stretch, "{1}")
            EndEvent

            Event OnDefaultST()
                stretch = default_stretch
                SetSliderOptionValueST(stretch, "{1}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("At 100% Capacity usage or more, maximum soul charges capacity will increase by this value.")
            EndEvent
        EndState

    ;Visual
        ;//////////////////////////////////////////////// BELLY ///////////////////////////////////////////////////////;
        State Visual_Belly_Enable

            Event OnSelectST()
                enableBellyScaling = !enableBellyScaling
                SetToggleOptionValueST(enableBellyScaling)

                If (enableBellyScaling)
                    bellyScalingOptionsFlag = OPTION_FLAG_NONE
                Else
                    bellyScalingOptionsFlag = OPTION_FLAG_DISABLED
                EndIf
            EndEvent

            Event OnDefaultST()
                enableBellyScaling = default_enableBellyScaling
                SetToggleOptionValueST(enableBellyScaling)
            EndEvent

            Event OnHighlightST()
                SetInfoText("Toggle belly scaling")
            EndEvent
        EndState

        State Visual_Belly_MinSize
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyMinSize)
                SetSliderDialogDefaultValue(default_bellyMinSize)
                SetSliderDialogRange(0.00, 20.00)
                SetSliderDialogInterval(0.05)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyMinSize = value
                SetSliderOptionValueST(bellyMinSize, "{2}")
            EndEvent

            Event OnDefaultST()
                bellyMinSize = default_bellyMinSize
                SetSliderOptionValueST(bellyMinSize, "{2}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Belly will grow from and above this value")
            EndEvent
        EndState

        State Visual_Belly_BaseMaxSize
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyBaseMaxSize)
                SetSliderDialogDefaultValue(default_bellyBaseMaxSize)
                SetSliderDialogRange(0.00, 20.00)
                SetSliderDialogInterval(0.05)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyBaseMaxSize = value
                SetSliderOptionValueST(bellyBaseMaxSize, "{2}")
            EndEvent

            Event OnDefaultST()
                bellyBaseMaxSize = default_bellyBaseMaxSize
                SetSliderOptionValueST(bellyBaseMaxSize, "{2}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("The size of belly at 100% capacity without stretches")
            EndEvent
        EndState

        State Visual_Belly_StretchValue
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyStretch)
                SetSliderDialogDefaultValue(default_bellyStretch)
                SetSliderDialogRange(0.00, 1.00)
                SetSliderDialogInterval(0.01)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyStretch = value
                SetSliderOptionValueST(bellyStretch, "{2}")
            EndEvent

            Event OnDefaultST()
                bellyStretch = default_bellyStretch
                SetSliderOptionValueST(bellyStretch, "{2}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("The value to add to belly max size wheen stretching")
            EndEvent
        EndState

        State Visual_Belly_Multiplier
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyMultiplier)
                SetSliderDialogDefaultValue(default_bellyMultiplier)
                SetSliderDialogRange(0.00, 10.00)
                SetSliderDialogInterval(0.01)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyMultiplier = value
                SetSliderOptionValueST(bellyMultiplier, "{2}")
            EndEvent

            Event OnDefaultST()
                bellyMultiplier = default_bellyMultiplier
                SetSliderOptionValueST(bellyMultiplier, "{2}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Multiply belly scale by this")
            EndEvent
        EndState
        ;//////////////////////////////////////////////// BREAST ///////////////////////////////////////////////////////;
        State Visual_Breast_Enable
            Event OnSelectST()
                enableBreastScaling = !enableBreastScaling
                SetToggleOptionValueST(enableBreastScaling)

                If (enableBreastScaling)
                    breastScalingOptionsFlag = OPTION_FLAG_NONE
                Else
                    breastScalingOptionsFlag = OPTION_FLAG_DISABLED
                EndIf
            EndEvent

            Event OnDefaultST()
                enableBreastScaling = default_enableBreastScaling
                SetToggleOptionValueST(enableBreastScaling)
            EndEvent

            Event OnHighlightST()
                SetInfoText("Toggle breast scaling")
            EndEvent
        EndState

        State Visual_Breast_MinSize
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastMinSize)
                SetSliderDialogDefaultValue(default_breastMinSize)
                SetSliderDialogRange(0.00, 20.00)
                SetSliderDialogInterval(0.05)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastMinSize = value
                SetSliderOptionValueST(breastMinSize, "{2}")
            EndEvent

            Event OnDefaultST()
                breastMinSize = default_breastMinSize
                SetSliderOptionValueST(breastMinSize, "{2}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Breast will grow from and above this value")
            EndEvent
        EndState

        State Visual_Breast_MaxSizeScale
            Event OnSliderOpenST()
                SetSliderDialogStartValue(bellyToBreastMaxSize)
                SetSliderDialogDefaultValue(default_bellyToBreastMaxSize)
                SetSliderDialogRange(0.000, 1.000)
                SetSliderDialogInterval(0.001)
            EndEvent

            Event OnSliderAcceptST(float value)
                bellyToBreastMaxSize = value
                SetSliderOptionValueST(bellyToBreastMaxSize, "{3}")
            EndEvent

            Event OnDefaultST()
                bellyToBreastMaxSize = default_bellyToBreastMaxSize
                SetSliderOptionValueST(bellyToBreastMaxSize, "{3}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Multiplier of max belly size to use as max breast size (include stretches)")
            EndEvent
        EndState

        State Visual_Breast_Increment
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastIncrementValue)
                SetSliderDialogDefaultValue(default_breastIncrementValue)
                SetSliderDialogRange(0.000, 1.000)
                SetSliderDialogInterval(0.001)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastIncrementValue = value
                SetSliderOptionValueST(breastIncrementValue, "{3}")
            EndEvent

            Event OnDefaultST()
                breastIncrementValue = default_breastIncrementValue
                SetSliderOptionValueST(breastIncrementValue, "{3}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Value to add to breast scale over time while carrying souls")
            EndEvent
        EndState

        State Visual_Breast_Decrement
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastDecrementValue)
                SetSliderDialogDefaultValue(default_breastDecrementValue)
                SetSliderDialogRange(0.000, 1.000)
                SetSliderDialogInterval(0.001)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastDecrementValue = value
                SetSliderOptionValueST(breastDecrementValue, "{3}")
            EndEvent

            Event OnDefaultST()
                breastDecrementValue = default_breastDecrementValue
                SetSliderOptionValueST(breastDecrementValue, "{3}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Value to subtract from breast scale over time while not carrying souls")
            EndEvent
        EndState

        State Visual_Breast_Multiplier
            Event OnSliderOpenST()
                SetSliderDialogStartValue(breastMultiplier)
                SetSliderDialogDefaultValue(default_breastMultiplier)
                SetSliderDialogRange(0.00, 10.00)
                SetSliderDialogInterval(0.01)
            EndEvent

            Event OnSliderAcceptST(float value)
                breastMultiplier = value
                SetSliderOptionValueST(breastMultiplier, "{2}")
            EndEvent

            Event OnDefaultST()
                breastMultiplier = default_breastMultiplier
                SetSliderOptionValueST(breastMultiplier, "{2}")
            EndEvent

            Event OnHighlightST()
                SetInfoText("Multiply breast scale by this")
            EndEvent
        EndState

    ;System
        State System_DebugMode
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

        State System_Version
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

        State System_ResetSettings
            Event OnSelectST()
                If (confirmReset)
                    ResetSettings()
                    SetOptionFlagsST(OPTION_FLAG_DISABLED)
                    Debug.MessageBox("Close all menus")
                Else
                    confirmReset = true
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

        State System_ResetStats
            Event OnSelectST()
                If (confirmReset)
                    ResetStats()
                    SetOptionFlagsST(OPTION_FLAG_DISABLED)
                    Debug.MessageBox("Close all menus")
                Else
                    confirmReset = true
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