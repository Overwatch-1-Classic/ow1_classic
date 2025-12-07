#!mainFile "../../dev_main.opy"

rule "[mccree/roll.opy]: Cant roll mid air or jump":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isInAir()

    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isInAir(), Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_1)

rule "[mccree/roll.opy]: increase damage reduction during roll":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setDamageReceived(percent(OW1_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION/OW2_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setDamageReceived(100)
