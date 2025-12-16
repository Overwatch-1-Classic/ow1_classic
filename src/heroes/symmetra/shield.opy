#!mainFile "../../dev_main.opy"

playervar shield_pvar
#!defineMember _shield shield_pvar [0]
#!defineMember _shield_target shield_pvar [1]
#!defineMember _is_shielded shield_pvar [2]
#!defineMember _shield_visual_effect shield_pvar [3]
#!defineMember _symmetra_shields shield_pvar [4]

rule "[symmetra/_shield.opy]: set symmetras shield":
    @Event eachPlayer
    @Hero symmetra
    @Condition any([not i._shield for i in getLivingPlayers(eventPlayer.getTeam()).exclude(eventPlayer)])
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition (any([eventPlayer.isInViewAngle(i.getEyePosition(), 45) and distance(eventPlayer.getEyePosition(), 
                i.getEyePosition()) < OW1_SYMMETRA_SHIELDS_RANGE and isInLoS(eventPlayer.getEyePosition(), 
                i.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) for i in [i for i in ([player for player in getLivingPlayers(eventPlayer.getTeam()) if not player._is_shielded]).exclude(eventPlayer) 
                if i.hasSpawned()]]))
    @Condition len([player for player in getLivingPlayers(eventPlayer.getTeam()) if player.hasSpawned()]) > 1
    @Condition eventPlayer.isAlive()
    
    eventPlayer._shield_target = (sorted([i for i in getLivingPlayers(eventPlayer.getTeam()).exclude(eventPlayer) if i.hasSpawned() and distance(eventPlayer.getEyePosition(), 
        i.getEyePosition()) < OW1_SYMMETRA_SHIELDS_RANGE and not i._shield], lambda i: distance(raycast(eventPlayer.getEyePosition(), 
        eventPlayer.getEyePosition() + 10 * eventPlayer.getFacingDirection(), 
        getPlayers(eventPlayer.getTeam()), 
        eventPlayer, 
        true).getHitPosition(), i.getEyePosition())))[0]
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), eventPlayer._shield_target.getEyePosition(), 1)

    eventPlayer._shield_target.addHealthPool(Health.SHIELDS, OW1_SYMMETRA_EXTRA_SHIELDS, true, false)
    eventPlayer._shield_target._symmetra_shields = getLastCreatedHealthPool()
    eventPlayer._shield_target._is_shielded = true

    smallMessage(eventPlayer._shield_target, "+25 Shield From {}".format(eventPlayer))

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_SYMETTRA_SHIELDS_COOLDOWN)
    if eventPlayer.getAmmo(0) >= 100:
        eventPlayer.setAmmo(0, 99)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.RELOAD)
    wait(0.5)
    if eventPlayer.isReloading():
        eventPlayer.cancelPrimaryAction()
    if eventPlayer.getAmmo(0) >= 99:
        eventPlayer.setAmmo(0, 100)
    eventPlayer.allowButton(Button.ABILITY_1)

    wait(OW1_SYMMETTRA_SHIELDS_DURATION)
    eventPlayer._shield_target._is_shielded = false
    removeHealthPool(eventPlayer._shield_target._symmetra_shields)

    # createInWorldText(getAllPlayers(), " \n\n\n\n\n\n     ︿\n〈      〉\n     ﹀ \n     [{0}]".format(buttonString(Button.ABILITY_2)), 
        # updateEveryTick(eventPlayer.getPosition()) + (vect(0, 1 + distance(eventPlayer.getEyePosition(), 
        # eventPlayer.getPosition()) * -0.06, 0)), 
        # 2, 
        # Clip.NONE, 
        # WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
        # eventPlayer.getTeam(), 
        # SpecVisibility.DEFAULT)