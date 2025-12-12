#!mainFile "../../dev_main.opy"

# Huge thanks for Mathemann69 for making this wonderful soul orb code! https://workshop.codes/3KRMX
# Rewrote in overpy & optimized by viper#18545

playervar soul_orb_pvar
#!defineMember soul_orb_available soul_orb_pvar [0]
#!defineMember soul_orb_effect soul_orb_pvar [1]
#!defineMember array_victim soul_orb_pvar [2]
playervar position 
playervar acceleration_speed 

rule "[reaper/soul_orb.opy]: Create soul orb if player dies":
    @Event eachPlayer
    @Condition isHeroBeingPlayed(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))
    @Condition eventPlayer.isDead()
    
    wait(0.25)
    if not ruleCondition:
        return
    eventPlayer.array_victim = getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())) if OW1_REAPER_SOUL_ORB_VISUAL_ARRAY == 0 else getPlayers(getPlayersOnHero(Hero.REAPER, 
        getOppositeTeam(eventPlayer.getTeam())).getTeam()) if OW1_REAPER_SOUL_ORB_VISUAL_ARRAY == 1 else getPlayers(getOppositeTeam(getPlayersOnHero(Hero.REAPER, 
        getOppositeTeam(eventPlayer.getTeam())).getTeam())) if OW1_REAPER_SOUL_ORB_VISUAL_ARRAY == 2 else getAllPlayers()
    eventPlayer.position = eventPlayer.getEyePosition()
    eventPlayer.soul_orb_available = true
    createEffect(eventPlayer.array_victim, Effect.ORB, Color.RED, eventPlayer.position, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.soul_orb_effect = getLastCreatedEntity()
    waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    if eventPlayer.soul_orb_available:
        eventPlayer.soul_orb_available = false
        destroyEffect(eventPlayer.soul_orb_effect)
        stopChasingVariable(eventPlayer.position)
        stopChasingVariable(eventPlayer.acceleration_speed)
        eventPlayer.acceleration_speed = OW1_REAPER_SOUL_ORB_SPEED

rule "[reaper/soul_orb.opy]: Remove soul orbs if no reaper":
    @Event eachPlayer
    @Condition not isHeroBeingPlayed(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))
    
    wait(0.25)
    if not ruleCondition:
        return
    eventPlayer.soul_orb_available = false
    destroyEffect(eventPlayer.soul_orb_effect)
    stopChasingVariable(eventPlayer.position)
    stopChasingVariable(eventPlayer.acceleration_speed)
    eventPlayer.acceleration_speed = OW1_REAPER_SOUL_ORB_SPEED


rule "[reaper/soul_orb.opy]: Accelerate orbs to Reaper":
    @Event eachPlayer
    @Condition eventPlayer.soul_orb_available
    @Condition eventPlayer.isDead()
    @Condition isHeroBeingPlayed(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))
    @Condition distance(eventPlayer.position, getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))) <= OW1_REAPER_SOUL_ORB_RADIUS
    @Condition isInLoS(eventPlayer.position, getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())))
    
    eventPlayer.acceleration_speed = OW1_REAPER_SOUL_ORB_SPEED
    chaseAtRate(eventPlayer.position, updateEveryFrame(getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())).getPosition() + Vector.UP), eventPlayer.acceleration_speed)
    chaseAtRate(eventPlayer.acceleration_speed, Math.INFINITY, OW1_REAPER_SOUL_ORB_ACCELERATION)
    eventPlayer.soul_orb_effect = getLastCreatedEntity()


rule "[reaper/soul_orb.opy]: Collect orb":
    @Event eachPlayer
    @Condition eventPlayer.soul_orb_available
    @Condition distance(eventPlayer.position, getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))) <= 1.5
    @Condition getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())).isAlive()
    @Condition isHeroBeingPlayed(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))
    
    # eventPlayer.teleport(vect(0, Math.INFINITY, 0))
    heal(getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())), getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())), OW1_REAPER_SOUL_ORB_HEALING)
    destroyEffect(eventPlayer.soul_orb_effect)
    eventPlayer.soul_orb_available = false
    stopChasingVariable(eventPlayer.position)
    stopChasingVariable(eventPlayer.acceleration_speed)
    eventPlayer.acceleration_speed = OW1_REAPER_SOUL_ORB_SPEED

