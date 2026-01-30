#!mainFile "../../dev_main.opy"

rule "[dva/gun.opy]: OW1 DVa movement penalty when shooting":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not isUsingDefenseMatrix(eventPlayer)
    
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*((1-OW1_DVA_MOVE_PENALTY)/(1-OW2_DVA_MOVE_PENALTY)))
    waitUntil((not eventPlayer.isFiringPrimaryFire()) or eventPlayer.isUsingAbility1(), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/((1-OW1_DVA_MOVE_PENALTY)/(1-OW2_DVA_MOVE_PENALTY)))