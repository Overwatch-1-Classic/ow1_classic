#!mainFile "../../dev_main.opy"


rule "[winston/barrier.opy]: OW1 Winston barrier health":
    @Event eachPlayer
    @Hero winston
    # @Condition not eventPlayer.setAbility2Enabled(false)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setMaxHealth(percent(OW1_WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))

/*
rule "[winston/barrier.opy]: Disallow barrier when using":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    # wait(1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, Math.INFINITY)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_WINSTON_BARRIER_COOLDOWN) # This is very stupid because what if the barrier broke?
*/