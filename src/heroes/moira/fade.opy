#!mainFile "../../dev_main.opy"

rule "[moira/biotic_orb.opy]: Set Fade jump height":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setJumpVerticalSpeed(percent(OW1_MOIRA_FADE_JUMP_HEIGHT/OW2_MOIRA_FADE_JUMP_HEIGHT))
    waitUntil(not eventPlayer.isUsingAbility1())
    eventPlayer.setJumpVerticalSpeed(100)