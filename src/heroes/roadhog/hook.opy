#!mainFile "../../dev_main.opy"

globalvar ROADHOG_HOOK_V1 = createWorkshopSetting(bool, "Roadhog", "Hook 1.0", false) # I added this because im unsure if we should include this in the code or not.

playervar hook_pvar
#!defineMember _is_hooking hook_pvar[0]
#!defineMember _hooked_enemy hook_pvar[1]
#!defineMember _hook_effect hook_pvar[2]
#!defineMember hook_timer hook_pvar[3]
playervar hook_direction
playervar hook_position

subroutine startHook
subroutine endHook

macro hideHookEffects():
    destroyEffect(eventPlayer._hook_effect)
    eventPlayer._hook_effect = null


rule "[roadhog/hook.opy]: Move hooked enemies closer":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1()

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    if distance(victim, attacker) <= OW2_ROADHOG_HOOK_PROXIMITY + 1:
        victim.teleport(
            raycast(
                victim.getPosition(), 
                victim.getPosition() + (OW2_ROADHOG_HOOK_PROXIMITY - OW1_ROADHOG_HOOK_PROXIMITY)*directionTowards(victim, attacker), 
                null, 
                null, 
                false).getHitPosition()) # i know this feels weird, and its buggy but its more accurate
    # victim.setStatusEffect(null, Status.STUNNED, 0.1)

rule "[roadhog/hook.opy]: OW1 hook damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    damage(
        victim, 
        attacker, 
        (OW1_ROADHOG_HOOK_DAMAGE/OW2_ROADHOG_HOOK_DAMAGE) * eventDamage - eventDamage)

rule "[roadhog/hook.opy]: Hook direction":
    @Event eachPlayer
    @Hero roadhog
    @Condition ROADHOG_HOOK_V1 == true
    @Condition eventPlayer.isUsingAbility1()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.hook_direction = eventPlayer.getFacingDirection()


rule "[roadhog/hook.opy]: Hook 1.0 vfx + hook effect": # Thanks for Wadetata for this hook 1.0 Code!
    @Event eachPlayer
    @Hero roadhog
    @Condition ROADHOG_HOOK_V1 == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.isUsingUltimate()
    @Condition eventPlayer.isAlive()
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isFiringSecondaryFire()
    
    if isCCd(eventPlayer):
        return

    startHook()

    eventPlayer.hook_direction = eventPlayer.getFacingDirection()
    eventPlayer.hook_position = eventPlayer.getEyePosition()

    createBeam(getAllPlayers(), Beam.GRAPPLE,   
        eventPlayer.getEyePosition() + worldVector(vect(0.2, -0.2, 0), 
        eventPlayer, 
        Transform.ROTATION), 
        eventPlayer.hook_position, 
        Color.WHITE, 
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer._hook_effect = getLastCreatedEntity()

    while distance(eventPlayer.hook_position, raycast(eventPlayer.hook_position, eventPlayer.hook_position + eventPlayer.hook_direction, getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition()) > 0.5 and distance(evalOnce(eventPlayer.getEyePosition()), eventPlayer.hook_position) < 20 and distance(eventPlayer.hook_position, (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).concat(vect(0, 0, 0)), lambda i: distance(i.getPosition() + vect(0, 1, 0), eventPlayer.hook_position)))[0] + vect(0, 1, 0)) > 2:
        eventPlayer.hook_position = raycast(eventPlayer.hook_position, eventPlayer.hook_position + eventPlayer.hook_direction, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition()
        wait()
    eventPlayer._hooked_enemy = (sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer.hook_position, player.getPosition() + vect(0, 1, 0)) < 2.5 and player.hasSpawned() and distance(raycast(eventPlayer.hook_position, player.getPosition() + vect(0, 1, 0), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), null, false).getHitPosition(), raycast(eventPlayer.hook_position, player.getPosition() + vect(0, 1, 0), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition()) < 0.1], lambda i: distance(i.getPosition() + vect(0, 1, 0), eventPlayer.hook_position)))[0]
    hideHookEffects()

    # if entityExists(eventPlayer._hooked_enemy):
        # if eventPlayer._hooked_enemy.getCurrentHero() == Hero.BASTION and eventPlayer._hooked_enemy.isUsingAbility1() and not eventPlayer.current_configuration == Configuration.TANK:
            # eventPlayer.forceButtonPress(Button.ABILITY_1)
            # eventPlayer.cancelPrimaryAction()
        hideHookEffects()
        eventPlayer._hooked_enemy.setFacing(directionTowards(eventPlayer._hooked_enemy.getEyePosition(), eventPlayer.getEyePosition()), Relativity.TO_WORLD)
        eventPlayer._hooked_enemy.startFacing(directionTowards(eventPlayer._hooked_enemy.getEyePosition(), eventPlayer.getEyePosition()), 100, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        wait()
        
        createBeam(getAllPlayers(), Beam.GRAPPLE, 
            eventPlayer.getEyePosition() + worldVector(vect(0.2, -0.2, 0), 
            eventPlayer, 
            Transform.ROTATION), 
            eventPlayer._hooked_enemy.getPosition() + vect(0, 1, 0), 
            Color.WHITE, 
            EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._hook_effect = getLastCreatedEntity()

        eventPlayer._hooked_enemy.setStatusEffect(eventPlayer, Status.STUNNED, OW1_ROADHOG_HOOK_STUN)
        damage(eventPlayer._hooked_enemy, eventPlayer, OW1_ROADHOG_HOOK_DAMAGE)
        wait(0.5)
        if eventPlayer._hooked_enemy.isAlive():
            eventPlayer._hooked_enemy.applyImpulse(OW1_ROAHOD_HOOK_VELOCITY_CORRECTION, 
            magnitude(OW1_ROAHOD_HOOK_VELOCITY_CORRECTION), 
            Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.hook_timer = getTotalTimeElapsed()
            while eventPlayer.isAlive() and not eventPlayer.isUsingUltimate() and getTotalTimeElapsed() - eventPlayer.hook_timer < 2 and (distance(eventPlayer._hooked_enemy.getPosition(), eventPlayer.getPosition()) > 3 or (distance(eventPlayer._hooked_enemy.getPosition(), eventPlayer.getPosition()) > 4 and eventPlayer._hooked_enemy.getSpeed() < 2)):
                eventPlayer._hooked_enemy.applyImpulse(OW1_ROAHOD_HOOK_VELOCITY_CORRECTION, 
                magnitude(OW1_ROAHOD_HOOK_VELOCITY_CORRECTION), 
                Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                wait()
            if not eventPlayer.isUsingUltimate():
                eventPlayer._hooked_enemy.startForcingPosition(eventPlayer._hooked_enemy.getPosition(), false)
                eventPlayer._hooked_enemy.setStatusEffect(eventPlayer, Status.ROOTED, 0.02)
            wait(0.1)
    endHook()

def startHook():
    @Name "[roadhog/hook.opy]: startHook()"

    eventPlayer._is_hooking = true
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setReloadEnabled(false)
    eventPlayer.setMoveSpeed(percent(OW1_ROADHOG_HOOK_SPEED_PENALTY*eventPlayer._base_movement_scalar))
    wait(OW1_ROADHOG_HOOK_CAST_TIME)
    # eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setMoveSpeed(100)

def endHook():
    @Name "[roadhog/hook.opy]: endHook()"

    hideHookEffects()
    eventPlayer.setPrimaryFireEnabled(true)
    startFiring()
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setReloadEnabled(true)
    eventPlayer._is_hooking = false
    eventPlayer._hooked_enemy.stopFacing()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ROADHOG_HOOK_COOLDOWN_TIME)
    wait(0.1)
    eventPlayer._hooked_enemy.stopForcingPosition()
    eventPlayer._hooked_enemy.clearStatusEffect(Status.STUNNED)