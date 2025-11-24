#!mainFile "../../dev_main.opy"

rule "[mccree/fan_hammer.opy]: Launch Fan the Hammer damage":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_MCCREE_FAN_THE_HAMMER_DAMAGE/OW2_MCCREE_FAN_THE_HAMMER_DAMAGE) - eventDamage)

rule "[mccree/fan_hammer.opy]: Refund 1 Ammo on headshot":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventWasCriticalHit

    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)

# rule "[cassidy/fan_hammer.opy]: Launch reload time":
    # @Event eachPlayer
    # @Hero cassidy
    # @Condition eventPlayer.getAmmo() == 0
    
    # wait(1, Wait.ABORT_WHEN_FALSE)
    # eventPlayer.setReloadEnabled(true)
    # eventPlayer.forceButtonPress(Button.RELOAD)
    # waitUntil(not eventPlayer.isReloading(), Math.INFINITY)
    # eventPlayer.setReloadEnabled(false)


# rule "[cassidy/fan_hammer.opy]: Normal reload":
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