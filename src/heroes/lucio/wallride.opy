#!mainFile "../../dev_main.opy"

globalvar LUCIO_WALLRIDE = createWorkshopSetting(bool, "Lucio", "Launch Wallride", true) # I added this because lucio is in such a horrible state

rule "[lucio/wallride.opy]: Launch wallride":
    @Event eachPlayer
    @Hero lucio
    @Condition LUCIO_WALLRIDE == true
    @Condition eventPlayer.isOnWall()
    
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW1_LUCIO_WALLRIDE_SPEED_PENALTY))
    waitUntil(not eventPlayer.isOnWall(), 3)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW1_LUCIO_WALLRIDE_SPEED_PENALTY))
    if eventPlayer.isOnWall():
        eventPlayer.forceButtonPress(Button.CROUCH)
        wait()
        if eventPlayer.isOnWall():
            eventPlayer.forceButtonPress(Button.JUMP)
    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, 3.2, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)