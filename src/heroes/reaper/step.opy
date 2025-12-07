#!mainFile "../../dev_main.opy"

rule "[reaper/step.opy]: Cant use step mid-air":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInAir()

    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isInAir(), Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_2)

rule "[reaper/step.opy]: Cancel if is jumping":
    @Event eachPlayer
    @Hero reaper
    @Condition not eventPlayer.isFiringPrimaryFire() and not eventPlayer.isUsingUltimate() and not eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isInAir()

    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)