#!mainFile "../../dev_main.opy"

rule "[bastion/sentry.opy]: Initialize sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.current_configuration = Configuration.SENTRY

    setBaseDamage(eventPlayer, OW1_BASTION_SENTRY_CONFIG_DAMAGE/OW2_BASTION_ASSAULT_CONFIG_DAMAGE)
    eventPlayer.setMoveSpeed(percent(OW1_BASTION_TANK_CONFIG_MOVE_SPEED)) # move faster in sentry mode

    # transform into ow1 sentry
    eventPlayer.setUltEnabled(false) # Prevent Bastion from getting ult charge during ultimate
    wait(OW1_BASTION_TANK_CONFIG_TRANSFORM_TIME-OW2_BASTION_ASSAULT_CONFIG_TRANSFORM_TIME)
    eventPlayer.cancelPrimaryAction() # interrupt ultimate animation right before it completes
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to turret mode
    eventPlayer.disallowButton(Button.ABILITY_1) # Disable reconfiguring out of turret mode
    eventPlayer.setDamageReceived(90) # take 30% less damage

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to recon mode
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setDamageReceived(100)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setUltEnabled(true)