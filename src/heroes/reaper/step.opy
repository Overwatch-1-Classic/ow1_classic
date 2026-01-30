#!mainFile "../../dev_main.opy"

rule "[reaper/step.opy]: Cant use Shadow Step Cant mid-air":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInAir()

    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isInAir(), Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_2)

rule "[reaper/step.opy]: Slower Shadow step teleport":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.ULTIMATE)
    waitUntil(not eventPlayer.isUsingAbility2())
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, OW1_REAPER_SHADOW_STEP_CAST_TIME-OW2_REAPER_SHADOW_STEP_CAST_TIME)
    eventPlayer.setStatusEffect(null, Status.ROOTED, OW1_REAPER_SHADOW_STEP_CAST_TIME-OW2_REAPER_SHADOW_STEP_CAST_TIME)
    wait(OW1_REAPER_SHADOW_STEP_CAST_TIME-OW2_REAPER_SHADOW_STEP_CAST_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.ULTIMATE)
    startFiring()

rule "[reaper/step.opy]: Cancel Shadow Step if is jumping":
    @Event eachPlayer
    @Hero reaper
    @Condition not eventPlayer.isFiringPrimaryFire() and not eventPlayer.isUsingUltimate() and not eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isInAir()

    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)