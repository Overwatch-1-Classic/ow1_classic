#!mainFile "../../dev_main.opy"

rule "[reaper/step.opy]: Cant use wrath mid-air":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInAir()

    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isInAir(), Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_2)

rule "[reaper/step.opy]: Slower teleport":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2()

    waitUntil(not eventPlayer.isUsingAbility2())
    eventPlayer.setStatusEffect(null, Status.ROOTED, OW1_REAPER_SHADOW_STEP_DELAY)
    #took this code from someone, code is H9WJ9 or https://workshop.codes/H9WJ9
    # eventPlayer.startCamera(eventPlayer + worldVector(vect(-0.3, 0.5, -0.5), eventPlayer, Transform.ROTATION), + Vector.UP * 1.5 + eventPlayer.getFacingDirection() * -2, eventPlayer + eventPlayer.getFacingDirection() * 1000)
    # wait(OW1_REAPER_SHADOW_STEP_DELAY)
    # eventPlayer.stopCamera()