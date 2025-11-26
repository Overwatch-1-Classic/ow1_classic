#!mainFile "../../dev_main.opy"

rule "[genji/dash.opy]: Genji melee combo": 
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isMeleeing()
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    
    eventPlayer.setAbilityCooldown(Button.MELEE, 0)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
    eventPlayer.forceButtonPress(Button.ABILITY_1)