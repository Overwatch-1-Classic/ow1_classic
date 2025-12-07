#!mainFile "../../dev_main.opy"

# rule "[genji/agility.opy]: double jump reset":
    # @Event eachPlayer
    # @Hero genji
    # @Condition eventPlayer.isOnWall()

    # waitUntil(not eventPlayer.isOnWall(), Math.INFINITY)
    # eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
    # eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, TICK_DURATION)