#!mainFile "../../dev_main.opy"


rule "[dva/booster.opy]: Disallow melee,shooting":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    startFiring()

# rule "[dva/booster.opy]: Cancel booster if melee pressed":
    # @Event eachPlayer
    # @Hero dva
    # @Condition eventPlayer.isUsingAbility1()
    # @Condition eventPlayer.isHoldingButton(Button.MELEE)
    
    # eventPlayer.forceButtonPress(Button.ABILITY_1)
    # eventPlayer.allowButton(Button.MELEE)
    # eventPlayer.forceButtonPress(Button.MELEE)
    # eventPlayer.disallowButton(Button.MELEE)


rule "[dva/booster.opy]: Reduce boosters damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility == Button.ABILITY_1

    heal(victim, null, OW2_DVA_BOOSTERS_DAMAGE - OW1_DVA_BOOSTERS_DAMAGE)