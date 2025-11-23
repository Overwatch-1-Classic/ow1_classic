#!mainFile "../../dev_main.opy"

playervar matrix_pvar

macro matrixSetup():
    eventPlayer.matrix_pvar = true
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(OW1_DVA_MATRIX_DURATION)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.matrix_pvar = false

rule "[dva/matrix.opy]: set defense matrix cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_DVA_MATRIX_COOLDOWN)

rule "[dva/matrix.opy]: Cant cancel defense matrix":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) # I know its only ability two, but it wont hurt if we included secondary fire. nice QoL

    matrixSetup()


rule "[dva/matrix.opy]: Reset Matrix if user presses secondary fire":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.matrix_pvar
    @Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    matrixSetup()
