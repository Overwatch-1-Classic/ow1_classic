#!mainFile "../../dev_main.opy"

rule "[lifeweaver/platform.opy]: Launch OW2 Lifeweaver petal health":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0

    eventPlayer.setMaxHealth(percent(OW1_LIFEWEAVER_PETAL_HP/OW2_LIFEWEAVER_PETAL_HP))
    waitUntil(eventPlayer.isUsingAbility1(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))