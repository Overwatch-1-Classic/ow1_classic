#!mainFile "../../dev_main.opy"

# rule "[mccree/fan_hammer.opy]: Launch Fan the Hammer damage":
    # @Event playerDealtDamage
    # @Hero cassidy
    # @Condition eventAbility == Button.SECONDARY_FIRE

    # damage(victim, attacker, eventDamage*(OW1_MCCREE_FAN_THE_HAMMER_DAMAGE/OW2_MCCREE_FAN_THE_HAMMER_DAMAGE) - eventDamage)

# rule "[mccree/fan_hammer.opy]: Fan the hammer lower firerate":
    # @Event eachPlayer
    # @Hero cassidy
    # @Condition eventPlayer.isFiringSecondaryFire()

    # do:
        # eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        # wait(TICK_DURATION*2)
        # eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
        # eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    # while RULE_CONDITION
    
# rule "[mccree/fan_hammer.opy]: Launch reload time":
    # @Event eachPlayer
    # @Hero cassidy
    # @Condition eventPlayer.getAmmo() == 0
    
    # wait(1, Wait.ABORT_WHEN_FALSE)
    # eventPlayer.setReloadEnabled(true)
    # eventPlayer.forceButtonPress(Button.RELOAD)
    # waitUntil(not eventPlayer.isReloading(), Math.INFINITY)
    # eventPlayer.setReloadEnabled(false)


# rule "[mccree/fan_hammer.opy]: Normal reload":
    # @Event eachPlayer
    # @Hero cassidy
    # @Condition eventPlayer.getAmmo(0)
    # @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    
    # eventPlayer.setReloadEnabled(true)
    # eventPlayer.forceButtonPress(Button.RELOAD)
    # waitUntil(not eventPlayer.isReloading(), Math.INFINITY)
    # eventPlayer.setReloadEnabled(false)

    # if eventPlayer.isHoldingButton(Button.RELOAD) not eventPlayer.isReloading():
        # eventPlayer.forceButtonPress(Button.RELOAD)