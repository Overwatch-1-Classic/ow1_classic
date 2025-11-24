#!mainFile "../../dev_main.opy"

playervar tank_armour

rule "[bastion/tank.opy]: Initialize tank mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.current_configuration == Configuration.RECON # Sentry mode can only be entered from recon mode
    @Condition eventPlayer.current_configuration != Configuration.SENTRY # prevents incorrectly identifying tank as sentry
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.current_configuration = Configuration.TANK

    eventPlayer.setMoveSpeed(percent(OW1_BASTION_TANK_CONFIG_MOVE_SPEED)) # move faster in tank mode
    setBaseDamage(eventPlayer, OW1_BASTION_TANK_CONFIG_DAMAGE/OW2_BASTION_TACTICAL_GRENADE_DAMAGE) # deal more damage in tank mode
    eventPlayer.setProjectileSpeed(percent(OW1_BASTION_TANK_CONFIG_PROJECTILE_SPEED/OW2_BASTION_TACTICAL_GRENADE_PROJECTILE_SPEED)) # increase grenade travel speed (to mimic tank shells)
    eventPlayer.setProjectileGravity(5)

    eventPlayer.disallowButton(Button.PRIMARY_FIRE) # Disallow firing machine gun
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setKnockbackReceived(100)

    waitUntil(not eventPlayer.isUsingAbility1(), OW1_BASTION_TANK_CONFIG_DURATION)

    if eventPlayer.isUsingAbility1():
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to recon mode
    eventPlayer.allowButton(Button.ABILITY_1)
    wait(TICK_DURATION)
    eventPlayer.stopFacing()
    eventPlayer.setPrimaryFireEnabled(true)

rule "[bastion/tank.opy]: Cancel out tank initial hit damage":
    @Event playerDealtDamage
    @Hero bastion
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim,null, OW1_BASTION_TANK_CONFIG_INITIAL_HIT_DAMAGE) # Deals an extra 30.75 damage, which added the math is 235.75

rule "[bastion/tank.opy]: Fire tank shells":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    do:     
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
        wait()
        waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0, Math.INFINITY)
    while RULE_CONDITION


rule "[bastion/tank.opy]: Reload tank shells":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_BASTION_TANK_CONFIG_SHELL_RELOAD_TIME_COMPENSATION) # modify cooldown for tank shell
    wait(OW1_BASTION_TANK_CONFIG_SHELL_RELOAD_TIME) # Wait tank shell reload time
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0) # Set tank shell as available