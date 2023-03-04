Scriptname SE_Config_Script extends SKI_ConfigBase 
{Script for Soul Eater MCM}

;/// Settings ///;
    ; Stats
        ;TODO: Absorb Stats and skills (most read only)

        GlobalVariable Property fSynergyLevel Auto ; Used to forge larger souls at gestation mode
        {Increases over time. digesting souls or breaking filled soulgems accelerate charge}

        GlobalVariable Property fMaxSynergy Auto
        {Increase with SynergyLevel while and only in digest mode}

        GlobalVariable Property iStorageMode Auto ;TODO: Change between modes
        {What happening with unclaimed stored souls (1= Digest, 2= Gestation)}

        GlobalVariable[] Property iNumberOfSouls Auto
        {Total number of souls. Shorted by size (index 0-4 = petty-grand)}

        GlobalVariable Property fMaxCapacity Auto
        {The max amount of souls charge which can be hold inside caster belly}

    ; Storage
        ;TODO: Settings related to storage

        GlobalVariable Property bCapacityModifiers Auto
        {Apply Buffs/Debuffs based on fulles stage}

        GlobalVariable Property bCapacityEffects Auto
        {Apply effects based on fulles stage}

        GlobalVariable Property fFirstStage Auto
        {% of capacity usage considered small (0-100)}

        GlobalVariable Property fSecondStage Auto
        {% of capacity usage considered medium (0-100)}

        GlobalVariable Property fThirthStage Auto
        {% of capacity usage considered high (0-100)}

        GlobalVariable Property bAllowDangerousScale Auto
        {Trespassing max capacity can kill}

        GlobalVariable Property fBurstScale Auto
        {% above max capacity where burst chance reach 100% (0-100)}

        GlobalVariable Property fStretch Auto
        {If at ThirthStage, increase max capacity by this value over time (set 0 to disable)}

    ; Visual
        ;TODO: Settings related to effects and scale proportions

        GlobalVariable Property bSheLikesIt Auto
        {Scaling triggers specials monologs and buffs}

        GlobalVariable Property bSheLovesIt Auto
        {Scaling triggers pleasure effects like arousal and moan sounds}

        GlobalVariable Property bApplyAnimations Auto
        {Include animations when applying effects or/and dialogues}

            ; Scaling
            ; Values for Scaling vars are:
            ; 0 = Disabled - disable this node from scaling
            ; 1 = Soul charge level - use soul charge level as scaling var for this node
            ; 2 = Synergy level - use synergy level as scaling var for this node
            ; 3 = Mode progress - use special var based on synergy gained by digestion or used by gestation
            ; 4 = Max charge level - use max capacity of soul charge level as scaling var for this node
            ; 5 = Max synergy level - use max acumulated synergy as scaling var for this node
            GlobalVariable Property iBellyScalingVar Auto
            {Wich value to use for belly inflation (refer to values above)}

            GlobalVariable Property iBellyScalingStage Auto
            {From which usage stage to belly start growing (0 = disabled, 1 = small, 2 = medium, 3 = high)}

            GlobalVariable Property fBellyScale Auto
            {The value selected for belly node will be divided by this before applying to scale}

            GlobalVariable Property iBreastScalingVar Auto
            {Wich value to use for breast inflation (refer to values above)}

            GlobalVariable Property iBreastScalingStage Auto
            {From which usage stage to breasts start growing (0 = disabled, 1 = small, 2 = medium, 3 = high)}

            GlobalVariable Property fBreastScale Auto
            {The value selected for breast node will be divided by this before applying to scale}

            GlobalVariable Property iButtScalingVar Auto
            {Wich value to use for ass inflation (refer to values above)}

            GlobalVariable Property iButtScalingStage Auto
            {From which usage stage to ass start growing (0 = disabled, 1 = small, 2 = medium, 3 = high)}

            GlobalVariable Property fButtScale Auto
            {The value selected for ass node will be divided by this before applying to scale}

    ; System
        ;TODO: Misc settings

        GlobalVariable Property bDbg Auto
        {Toggle debug notifications}

        GlobalVariable Property iInstalledVersion Auto
        {Used to track updates}

        int Property Version = 17 AutoReadOnly ;TODO: <- Change before tests
        {Mod version}

;/// Properties ///;
    SE_StorageManager_Script Property Storage Auto

    bool Property enableCapacityModifiers Auto Hidden ;Unused
    bool Property enableCapacityEffects Auto Hidden ;Unused
    bool Property allowDangerousScale Auto Hidden ;Unused
    bool Property sheLikesIt Auto Hidden ;Unused
    bool Property sheLovesIt Auto Hidden ;Unused
    bool Property applyAnimations Auto Hidden ;Unused
    bool Property dbg Auto Hidden
    float Property synergyLevel Auto Hidden
    float Property maxSynergy Auto Hidden
    float Property maxCapacity Auto Hidden ;Unused
    float Property firstStageScale Auto Hidden ;Unused
    float Property secondStageScale Auto Hidden ;Unused
    float Property thirthStageScale Auto Hidden ;Unused
    float Property burstScale Auto Hidden ;Unused
    float Property stretch Auto Hidden ;Unused
    float Property bellyScale Auto Hidden ;Unused
    float Property breastScale Auto Hidden ;Unused
    float Property buttScale Auto Hidden ;Unused
    int[] Property numberOfSouls Auto Hidden
    string Property storageMode Auto Hidden ;FIXME: change ref property type
    string Property bellyScalingVar Auto Hidden ;Unused
    string Property bellyScalingStage Auto Hidden ;Unused
    string Property breastScalingVar Auto Hidden ;Unused
    string Property breastScalingStage Auto Hidden ;Unused
    string Property buttScalingVar Auto Hidden ;Unused
    string Property buttScalingStage Auto Hidden ;Unused

;/// Functions ///;
    ; Returns mod version string
    string Function GetVersionString()
        return "0.1.17" ;TODO: <- Change before tests
    EndFunction

    int Function GetVersion()
        return Version
    EndFunction

    Function SaveSettings()
        bDbg.SetValue(dbg as float)
        fSynergyLevel.SetValue(synergyLevel)
        fMaxSynergy.SetValue(maxSynergy)
        
        if(storageMode == "Digest")
            iStorageMode.SetValue(1)
        else
            iStorageMode.SetValue(2)
        endIf

        int index = 0
        While (index < numberOfSouls.Length)
            iNumberOfSouls[index].SetValue(numberOfSouls[index] as float)
            index += 1
        EndWhile

        if(dbg)
            Debug.Notification("SEater: Settings saved")
        endif
    EndFunction

    Function LoadSettings()
        dbg = bDbg.GetValue() as bool
        synergyLevel = fSynergyLevel.GetValue()
        maxSynergy = fMaxSynergy.GetValue()

        if(iStorageMode.GetValue() == 1)
            storageMode = "Digest"
        else
            storageMode = "Gestation"
        endIf

        int index = 0
        While (index < iNumberOfSouls.Length)
            numberOfSouls[index] = iNumberOfSouls[index].GetValue() as int
            index += 1
        EndWhile

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
        iInstalledVersion.SetValue(Version)
        Debug.Notification("SEater: Updated")
        Debug.Notification("Version = " + GetVersionString())
    EndEvent
    
    ; Called when a new page is selected, including the initial empty page
    Event OnPageReset(string a_page)
        if(a_page == "Stats")
            SetCursorPosition(0)
            SetCursorFillMode(LEFT_TO_RIGHT)
            AddTextOptionST("stats_Synergy", "Synergy", synergyLevel + "/" + maxSynergy)
            AddTextOptionST("stats_Mode", "Mode", storageMode) ;TODO: Missing state
            ;AddTextOptionST("stats_ChargeLevel", "Charge Level", Storage.GetTotalChargeLevel()) ;TODO: Missing state

            ;Stored Souls
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddHeaderOption("Stored Souls")
            SetCursorFillMode(LEFT_TO_RIGHT)
            AddTextOptionST("stats_NumberOfPetty", "Number of petty souls", numberOfSouls[0]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfLesser", "Number of lesser souls", numberOfSouls[1]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfCommon", "Number of common souls", numberOfSouls[2]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfGreater", "Number of greater souls", numberOfSouls[3]) ;TODO: Missing state
            AddTextOptionST("stats_NumberOfGrand", "Number of grand souls", numberOfSouls[4]) ;TODO: Missing state
            AddTextOptionST("stats_TotalNumberOfSouls", "Total number of souls", Storage.GetNumberOfSouls()) ;TODO: Missing state
        elseif(a_page == "Storage")
        elseif(a_page == "Visual")
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