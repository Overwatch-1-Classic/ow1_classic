#!mainFile "../../dev_main.opy"

globalvar GENJI_LEDGE_DASH = createWorkshopSetting(bool, "Genji", "Ledgedash bug", false) # I added this because im unsure if we should include this in the code or not.

playervar genji_ledge_dash

rule "[genji/agility.opy]: Genji ledge dash bug recreation":
    @Event eachPlayer
    @Hero genji
    @Condition GENJI_LEDGE_DASH == true
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.genji_ledge_dash = true
    waitUntil((not eventPlayer.isUsingAbility1()) or eventPlayer.isOnWall(), Math.INFINITY)
    wait()
    if eventPlayer.isOnWall():
        waitUntil(not eventPlayer.isOnWall(), 0.15)
        if (not eventPlayer.isOnWall()) and (distance(raycast(eventPlayer.getPosition(), eventPlayer.getPosition() + (eventPlayer.getFacingDirection() * 2), null, null, false).getHitPosition(), raycast(eventPlayer.getPosition() + vect(0, 1.5, 0), (eventPlayer.getPosition() + vect(0, 1.5, 0)) + (eventPlayer.getFacingDirection() * 2), null, null, false).getHitPosition()) > 1.8):
            eventPlayer.stopForcingButton(Button.JUMP)
            eventPlayer.applyImpulse(eventPlayer.getVelocity(), OW1_GENJI_LEDGE_DASH_FORWARD_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
            wait()
    eventPlayer.genji_ledge_dash = false

rule "[genji/agility.opy]: double jump reset":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnWall()

    if eventPlayer.genji_ledge_dash and GENJI_LEDGE_DASH:
        waitUntil(not (eventPlayer.isOnWall() or eventPlayer.genji_ledge_dash), 2)
        wait(0.16)
    else:
    waitUntil(not eventPlayer.isOnWall(), Math.INFINITY)
    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
    # eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, TICK_DURATION)

# Im unsure if we should include this in the code, if we included ledge dash it would make genji extremely op, and ledge dash isnt an intended part of the game. 