Scriptname SE_Config_Script extends SKI_ConfigBase 
{Script for Soul Eater MCM}

    ;/// Properties ///;

    ;/// Settings ///;

    ; Stats
    ;TODO: Absorb Stats and skills

    ; Storage
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
    ;TODO: Effects and scale proportions
    GlobalVariable Property bSheLikesIt Auto
    {Scaling triggers specials monologs and buffs}

    GlobalVariable Property bSheLovesIt Auto
    {Scaling triggers pleasure effects like arousal and moan sounds}

    GlobalVariable Property bApplyAnimations Auto
    {Include animations when applying effects or/and dialogues}

    ; System
    GlobalVariable Property bDbg Auto
    GlobalVariable Property iInstalledVersion Auto
    int Property Version = 17 AutoReadOnly ; <- Change before tests

    ;/// Variables ///;
    bool dbg

    ;/// Functions ///;

    ; Returns mod version string
    string Function GetVersionString()
        return "0.1.17" ; <- Change before tests
    EndFunction

    int Function GetVersion()
        return Version
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
        Debug.Notification("SEater: Ready!")
    EndEvent
    
    event OnConfigOpen()
        {Called when this config menu is opened}
        dbg = bDbg.GetValue() as bool
    endEvent
    
    event OnConfigClose()
        {Called when this config menu is closed}
        bDbg.SetValue(dbg as float)
    endEvent
    
    event OnVersionUpdate(int aVersion)
        {Called when aVersion update of this script has been detected}
        ;TODO: Update code (if needed)
        iInstalledVersion.SetValue(Version)
        Debug.Notification("SEater: Updated")
        Debug.Notification("Version = " + GetVersionString())
    endEvent
    
    event OnPageReset(string a_page)
        {Called when a new page is selected, including the initial empty page}
        if(a_page == "Stats")
        elseif(a_page == "Storage")
        elseif(a_page == "Visual")
        elseif(a_page == "System")
            SetCursorPosition(0)
            SetCursorFillMode(TOP_TO_BOTTOM)
            AddToggleOptionST("system_bDbg", "Debug mode", dbg)
            AddTextOption("Version = ", GetVersionString())
        endif
    endEvent
    
    event OnOptionHighlight(int a_option)
        {Called when highlighting an option}
        Debug.Notification("SEater: OnOptionHighlight not implemented yet")
    endEvent
    
    event OnOptionSelect(int a_option)
        {Called when a non-interactive option has been selected}
        Debug.Notification("SEater: OnOptionSelect not implemented yet")
    endEvent
    
    event OnOptionDefault(int a_option)
        {Called when resetting an option to its default value}
        Debug.Notification("SEater: OnOptionDefault not implemented yet")
    endEvent
    
    event OnOptionSliderOpen(int a_option)
        {Called when a slider option has been selected}
        Debug.Notification("SEater: OnOptionSliderOpen not implemented yet")
    endEvent
    
    event OnOptionSliderAccept(int a_option, float a_value)
        {Called when a new slider value has been accepted}
        Debug.Notification("SEater: OnOptionSliderAccept not implemented yet")
    endEvent
    
    event OnOptionMenuOpen(int a_option)
        {Called when a menu option has been selected}
        Debug.Notification("SEater: OnOptionMenuOpen not implemented yet")
    endEvent
    
    event OnOptionMenuAccept(int a_option, int a_index)
        {Called when a menu entry has been accepted}
        Debug.Notification("SEater: OnOptionMenuAccept not implemented yet")
    endEvent
    
    event OnOptionColorOpen(int a_option)
        {Called when a color option has been selected}
        Debug.Notification("SEater: OnOptionColorOpen not implemented yet")
    endEvent
    
    event OnOptionColorAccept(int a_option, int a_color)
        {Called when a new color has been accepted}
        Debug.Notification("SEater: OnOptionColorAccept not implemented yet")
    endEvent
    
    event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
        {Called when a key has been remapped}
        Debug.Notification("SEater: OnOptionKeyMapChange not implemented yet")
    endEvent
    
    ; @since 4
    event OnOptionInputOpen(int a_option)
        {Called when a text input option has been selected}
        Debug.Notification("SEater: OnOptionInputOpen not implemented yet")
    endEvent
    
    ; @since 4
    event OnOptionInputAccept(int a_option, string a_input)
        {Called when a new text input has been accepted}
        Debug.Notification("SEater: OnOptionInputAccept not implemented yet")
    endEvent
    
    ; @since 2
    event OnSliderOpenST()
        {Called when a slider state option has been selected}
        Debug.Notification("SEater: OnSliderOpenST not implemented yet")
    endEvent
    
    ; @since 2
    event OnSliderAcceptST(float a_value)
        {Called when a new slider state value has been accepted}
        Debug.Notification("SEater: OnSliderAcceptST not implemented yet")
    endEvent
    
    ; @since 2
    event OnMenuOpenST()
        {Called when a menu state option has been selected}
        Debug.Notification("SEater: OnMenuOpenST not implemented yet")
    endEvent
    
    ; @since 2
    event OnMenuAcceptST(int a_index)
        {Called when a menu entry has been accepted for this state option}
        Debug.Notification("SEater: OnMenuAcceptST not implemented yet")
    endEvent
    
    ; @since 2
    event OnColorOpenST()
        {Called when a color state option has been selected}
        Debug.Notification("SEater: OnColorOpenST not implemented yet")
    endEvent
    
    ; @since 2
    event OnColorAcceptST(int a_color)
        {Called when a new color has been accepted for this state option}
        Debug.Notification("SEater: OnColorAcceptST not implemented yet")
    endEvent
    
    ; @since 2
    event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
        {Called when a key has been remapped for this state option}
        Debug.Notification("SEater: OnKeyMapChangeST not implemented yet")
    endEvent
    
    ; @since 4
    event OnInputOpenST()
        {Called when a text input state option has been selected}
        Debug.Notification("SEater: OnInputOpenST not implemented yet")
    endEvent
    
    ; @since 4
    event OnInputAcceptST(string a_input)
        {Called when a new text input has been accepted for this state option}
        Debug.Notification("SEater: OnInputAcceptST not implemented yet")
    endEvent

    ;/// States ///;

    State system_bDbg

        event OnSelectST()
            {Called when a non-interactive state option has been selected.}
            dbg = !dbg
            SetToggleOptionValueST(dbg)
        endEvent
    
        event OnDefaultST()
            {Called when resetting a state option to its default value.}
            dbg = false
            SetToggleOptionValueST(false)
        endEvent
    
        event OnHighlightST()
            {Called when highlighting a state option.}
            SetInfoText("Toggle debug notifications")
        endEvent

    EndState