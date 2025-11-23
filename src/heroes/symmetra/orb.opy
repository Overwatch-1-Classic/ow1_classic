#!mainFile "../../dev_main.opy"

rule "[symmetra/orb.opy]: set turret speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setProjectileSpeed(1000)
    eventPlayer.setMoveSpeed(47.778) # artillary based on
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setProjectileSpeed(100)

rule "[symmetra/orb.opy]: symmetra allow turrets":
    @Event eachPlayer
    @Hero symmetra
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 6 * eventPlayer.getFacingDirection(), null, eventPlayer, false).getHitPosition()) < 5
    
    eventPlayer.setAbility1Enabled(true)
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START

rule "[symmetra/orb.opy]: symettra disallow turrets":
    @Event eachPlayer
    @Hero symmetra
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 6 * eventPlayer.getFacingDirection(), null, eventPlayer, false).getHitPosition()) > 5
    
    eventPlayer.setAbility1Enabled(false)
    if eventPlayer.isUsingAbility1():
        eventPlayer.cancelPrimaryAction()
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START

rule "[symmetra/orb.opy]: slow down while deploying":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isUsingAbility1()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW1_SYMMETRA_ORB_SLOW_DOWN_DEPLOY))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW1_SYMMETRA_ORB_SLOW_DOWN_DEPLOY))