Scriptname SE_AbsorbSoulEffect_Script extends ActiveMagicEffect 
{Script for "Absorb Soul" and "Extract Soul" visual effects}

;/// Properties ///;
    SE_MainQuest_Script Property Main Auto
    SE_Config_Script Property Config Auto

    ImageSpaceModifier property TrapImod auto
    {IsMod applied when we trap a soul}

    sound property TrapSoundFX auto ; create a sound property we'll point to in the editor
    {Sound played when we trap a soul}

    VisualEffect property TargetVFX auto
    {Visual Effect on Target aiming at Caster}

    VisualEffect property CasterVFX auto
    {Visual Effect on Caster aming at Target}

    EffectShader property CasterFXS auto
    {Effect Shader on Caster during Soul trap}

    EffectShader property TargetFXS auto
    {Effect Shader on Target during Soul trap}
    
    bool Property Enchant Auto ;TODO: Enchantements
    {this effect comes from a enchanted weapon?}

;/// Variables ///;
    Actor trapedVictim
    Actor trapCaster
    bool deadAlready

;/// Events ///;

    ; Event received when this effect is first started (OnInit may not have been run yet!)
    Event OnEffectStart(Actor target, Actor caster)
        if(Config.dbg)
            Debug.Notification("SEater: OnEffectStart")
        endif
        
        trapedVictim = target
        trapCaster = caster

        if(Enchant)
            deadAlready = trapedVictim.IsDead()
        endif
    EndEvent

    Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
        string hitBy = akSource.GetName()

        If (Config.dbg)
            Debug.Notification("SEater: target hit by " + hitBy)
        EndIf

        If (hitBy == "Soul Trap")
            Dispel()
        EndIf
    EndEvent

    ; Event received when this effect is finished (effect may already be deleted, calling
    ; functions on this effect will fail)
    Event OnEffectFinish(Actor target, Actor caster)
        bool dbg = Config.dbg
        if(dbg)
            Debug.Notification("SEater: OnEffectFinish")
        endif

        if(trapedVictim) ;!= null
            if(deadAlready)
                Debug.Notification("Failed to absorb. " + trapedVictim.GetDisplayName() + " is already dead") ;Caste by a arrow projectile
            else
                if(Main.AbsorbSoul(trapedVictim)) ; Absorb soul sucessfull
                    if(dbg)
                        Debug.Notification("SEater: Applying SoulTrap effects...")
                    endif

                    TrapSoundFX.play(trapCaster) ; play TrapSoundFX sound from player
                    TrapImod.apply() ; apply isMod at full strength
                    TargetVFX.Play(trapedVictim,4.7,trapCaster) ; Play TargetVFX and aim them at the player
                    CasterVFX.Play(trapCaster,5.9,trapedVictim)
                    TargetFXS.Play(trapedVictim,2) ; Play Effect Shaders
                    CasterFXS.Play(trapCaster,3)
                elseif(dbg)
                    Debug.Notification("SEater: Absorb soul check failed or came back false")
                endif
            endif
        endif
    EndEvent