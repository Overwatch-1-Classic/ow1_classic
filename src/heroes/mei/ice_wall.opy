#!mainFile "../../dev_main.opy"

rule "[mei/pillar.opy]: OW1 Mei pillar health":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setMaxHealth(percent(OW1_MEI_ICEWALL_HP/OW2_MEI_ICEWALL_HP))
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))

# rule "[mei/pillar.opy]: Icewall Cooldown":
    # @Event eachPlayer
    # @Hero mei
    # @Condition eventPlayer.isUsingAbility2()
    # @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    # waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    # eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)