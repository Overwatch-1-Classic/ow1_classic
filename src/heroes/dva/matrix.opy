#!mainFile "../../dev_main.opy"

rule "[dva/matrix.opy]: set defense matrix cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_DVA_MATRIX_COOLDOWN)

rule "[dva/matrix.opy]: setup defense matrix":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(OW1_DVA_MATRIX_DURATION)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)