#!mainFile "../../dev_main.opy"

rule "[genji/deflect.opy]: Genji Deflect Fix": 
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2()
    
    eventPlayer.disallowButton(Button.ABILITY_2) # this doesnt do anything, but back then you couldnt cancel deflect
    wait(OW1_GENJI_DEFLECT_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)