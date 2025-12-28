#!mainFile "../../dev_main.opy"

globalvar ARMOUR_PACK_TEAM_1
globalvar ARMOUR_PACK_TEAM_2

playervar armour_pack_pvar
#!defineMember armour_pack_effects armour_pack_pvar[0]
#!defineMember armour_pack_overhealth armour_pack_pvar[1]
#!defineMember player_armour_pack_health armour_pack_pvar[2]
#!defineMember nearby_armour_pack armour_pack_pvar[3]
#!defineMember nearby_player armour_pack_pvar[4]
#!defineMember use_armour_pack armour_pack_pvar[5]
#!defineMember armour_pack_position armour_pack_pvar[6]
#!defineMember armour_pack_effect armour_pack_pvar[7]
#!defineMember armour_pack_vector armour_pack_pvar[8]
#!defineMember armour_pack_timeout armour_pack_pvar[9]
playervar armour_pack_player_left

rule "[torbjorn/armour_pack.opy]: Throw armour pack":
    @Event eachPlayer
    @Hero torbjorn
    @Condition not eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.scrap >= OW1_TORBJORN_SCRAP_ALLOW
    @Condition eventPlayer.isAlive()
    
    eventPlayer.scrap -= OW1_TORBJORN_SCRAP_ALLOW
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.ORANGE, eventPlayer, 100) # Sound effects
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.SPHERE, Color.YELLOW, eventPlayer.armour_pack_position, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.armour_pack_effect = getLastCreatedEntity()
    eventPlayer.armour_pack_position = eventPlayer.getEyePosition()
    smallMessage(getPlayers(eventPlayer.getTeam()), "Armour pack created by {}".format(eventPlayer))
    if eventPlayer.getVerticalFacingAngle() <= -88.99 or eventPlayer.getVerticalFacingAngle() >= 88.99:
        if eventPlayer.getVerticalFacingAngle() <= -88.99:
            eventPlayer.armour_pack_vector = Vector.UP * 25
        else:
            eventPlayer.armour_pack_vector = Vector.DOWN * 25
    else:
        eventPlayer.armour_pack_vector = (normalize(eventPlayer.getFacingDirection() + Vector.UP * 0.09)) * 25
    eventPlayer.armour_pack_timeout = 0
    while raycast(eventPlayer.armour_pack_position, eventPlayer.armour_pack_position + eventPlayer.armour_pack_vector / 61.881, getLivingPlayers(eventPlayer.getTeam()), eventPlayer, true).getHitPosition() == eventPlayer.armour_pack_position + eventPlayer.armour_pack_vector / 61.881 and eventPlayer.armour_pack_timeout <= 5:
        eventPlayer.armour_pack_vector -= vect(0, 0.098 * 206.995 / 62.5, 0)
        eventPlayer.armour_pack_position += eventPlayer.armour_pack_vector / 62.5
        eventPlayer.armour_pack_timeout += TICK_DURATION
        wait()
    destroyEffect(eventPlayer.armour_pack_effect[0])
    eventPlayer.use_armour_pack.append(eventPlayer.armour_pack_position)
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.SPHERE, Color.YELLOW, eventPlayer.use_armour_pack[eventPlayer.use_armour_pack.index(evalOnce(eventPlayer.use_armour_pack.last()))], 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.armour_pack_effects.append(getLastCreatedEntity())
    wait(0.136)


rule "[torbjorn/armour_pack.opy]: Get player's armour packs and append them":
    @Event eachPlayer
    @Team 1
    @Hero torbjorn
    @Condition len(eventPlayer.use_armour_pack) > 0
    @Condition (any([not player in ARMOUR_PACK_TEAM_1 for player in eventPlayer.use_armour_pack]))
    
    do:
        ARMOUR_PACK_TEAM_1.append(eventPlayer.use_armour_pack.exclude(ARMOUR_PACK_TEAM_1))
        wait(0.1) # Doesn't waste as much workshop load
    while RULE_CONDITION


rule "[torbjorn/armour_pack.opy]: Get player's armour packs and append them 2":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition len(eventPlayer.use_armour_pack) > 0
    @Condition (any([not player in ARMOUR_PACK_TEAM_2 for player in eventPlayer.use_armour_pack]))
    
    do:
        ARMOUR_PACK_TEAM_2.append(eventPlayer.use_armour_pack.exclude(ARMOUR_PACK_TEAM_2))
        wait(0.1) # Doesn't waste as much workshop load
    while RULE_CONDITION


rule "[torbjorn/armour_pack.opy]: Update closest armour pack":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned()
    @Condition len(getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())) > 0
    @Condition len(ARMOUR_PACK_TEAM_1) > 0
    @Condition eventPlayer.isAlive()
    
    do:
        wait(TICK_DURATION*3, Wait.ABORT_WHEN_FALSE)
        eventPlayer.nearby_armour_pack = sorted(ARMOUR_PACK_TEAM_1, lambda player: distance(eventPlayer.getPosition(), player))[0]
        eventPlayer.nearby_player = [player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if eventPlayer.nearby_armour_pack in player.use_armour_pack]
    while RULE_CONDITION


rule "[torbjorn/armour_pack.opy]: Update nearby armour pack 2":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.hasSpawned()
    @Condition len(getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())) > 0
    @Condition len(ARMOUR_PACK_TEAM_2) > 0
    @Condition eventPlayer.isAlive()
    
    do:
        wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
        eventPlayer.nearby_armour_pack = sorted(ARMOUR_PACK_TEAM_2, lambda player: distance(eventPlayer.getPosition(), player))[0]
        eventPlayer.nearby_player = getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())[ARMOUR_PACK_TEAM_2.index(eventPlayer.nearby_armour_pack)]
    while RULE_CONDITION


rule "[torbjorn/armour_pack.opy]: Give scrap armour":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.hasSpawned()
    @Condition len(getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())) > 0
    @Condition distance(eventPlayer.getPosition(), eventPlayer.nearby_armour_pack) < 1
    @Condition any([eventPlayer.nearby_armour_pack in player.use_armour_pack for player in getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())])
    @Condition eventPlayer.nearby_armour_pack != vect(0, 0, 0)
    @Condition eventPlayer.nearby_armour_pack != 0
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) < eventPlayer._hp_shields + OW1_TORBJORN_SCRAP_ARMOR
    #@Condition eventPlayer.armour_pack_overhealth < 75
    
    wait(TICK_DURATION*3, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.nearby_player == eventPlayer:
        smallMessage(eventPlayer, "+75 Armour From your Armour pack")
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.ORANGE, eventPlayer, 100) # vfx + sound effects
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT , Color.ORANGE, eventPlayer, 30)
    else:
        smallMessage(eventPlayer.nearby_player, "{} used your Armour Pack".format(eventPlayer))
        smallMessage(eventPlayer, "+75 Armour From {}'s Armour Pack".format(eventPlayer.nearby_player))
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.ORANGE, eventPlayer, 100) # vfx + sound effects
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT , Color.ORANGE, eventPlayer, 30)
    removeHealthPool(eventPlayer.player_armour_pack_health)
    eventPlayer.armour_pack_overhealth = OW1_TORBJORN_SCRAP_ARMOR
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.armour_pack_overhealth, false, true)
    eventPlayer.player_armour_pack_health = getLastCreatedHealthPool()
    destroyEffect(eventPlayer.nearby_player.armour_pack_effects[eventPlayer.nearby_player.use_armour_pack.index(eventPlayer.nearby_armour_pack)])
    eventPlayer.nearby_player.use_armour_pack[eventPlayer.nearby_player.use_armour_pack.index(eventPlayer.nearby_armour_pack)] = vect(0, -500, 0)
    if eventPlayer.getTeam() == Team.1:
        ARMOUR_PACK_TEAM_1.remove(eventPlayer.nearby_armour_pack)
    else:
        ARMOUR_PACK_TEAM_2.remove(eventPlayer.nearby_armour_pack)


rule "[torbjorn/armour_pack.opy]: Clean up everything if torbjorn player left":
    @Event playerLeft
    @Hero torbjorn
    
    ARMOUR_PACK_TEAM_1.remove(eventPlayer.use_armour_pack)
    ARMOUR_PACK_TEAM_2.remove(eventPlayer.use_armour_pack)
    for eventPlayer.armour_pack_player_left in range(-1, evalOnce(len(eventPlayer.armour_pack_effects))):
        destroyEffect(eventPlayer.armour_pack_effects[eventPlayer.armour_pack_player_left])