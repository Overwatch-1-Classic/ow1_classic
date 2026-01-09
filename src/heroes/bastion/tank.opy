#!mainFile "../../dev_main.opy"

playervar tank_pvar
#!defineMember tank_armour tank_pvar[0]

rule "[bastion/tank.opy]: Initialize tank mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.current_configuration = Configuration.TANK

    eventPlayer.startCamera(updateEveryTick(eventPlayer.getEyePosition()), updateEveryTick(eventPlayer.getEyePosition() + vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)), 0) # Bruteforce camera

    cancelSelfRepair()
    eventPlayer.setMoveSpeed(percent(OW1_BASTION_TANK_CONFIG_MOVE_SPEED)) # move faster in tank mode
    setBaseDamage(eventPlayer, OW1_BASTION_TANK_CONFIG_DAMAGE/OW2_BASTION_TACTICAL_GRENADE_DAMAGE) # deal more damage in tank mode
    eventPlayer.setProjectileSpeed(percent(OW1_BASTION_TANK_CONFIG_PROJECTILE_SPEED/OW2_BASTION_TACTICAL_GRENADE_PROJECTILE_SPEED)) # increase grenade travel speed (to mimic tank shells)
    eventPlayer.setProjectileGravity(5)

    eventPlayer.disallowButton(Button.PRIMARY_FIRE) # Disallow firing machine gun
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setKnockbackReceived(100)

    # transform into ow1 tank
    eventPlayer.setUltEnabled(false) # Prevent Bastion from getting ult charge during ultimate
    wait(OW1_BASTION_TANK_CONFIG_TRANSFORM_TIME-OW2_BASTION_ASSAULT_CONFIG_TRANSFORM_TIME)
    eventPlayer.setStatusEffect(null, Status.ROOTED, OW1_BASTION_TANK_CONFIG_TRANSFORM_TIME) # More cast time, due cancelPrimaryAction() not working if i wait for 1 second 0.5 + 1 is 1.5
    eventPlayer.cancelPrimaryAction() # interrupt ultimate animation right before it completes
    eventPlayer.stopCamera() # Stop bruteforcing camera
    eventPlayer.setFacing(vect(updateEveryTick(eventPlayer.getFacingDirection()).x, 0, updateEveryTick(updateEveryTick(eventPlayer.getFacingDirection()).z)), Relativity.TO_WORLD) # Bruteforce camera facing
    eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to turret mode
    eventPlayer.disallowButton(Button.ABILITY_1) # Disable reconfiguring out of turret mode
    eventPlayer.setDamageReceived(percent(OW1_BASTION_ICONCLAD_DAMAGE_REDUCTION/(OW1_BASTION_ICONCLAD_DAMAGE_REDUCTION-OW2_BASTION_ICONCLAD_DAMAGE_REDUCTION))) # Remove Ironclad

    eventPlayer.addHealthPool(Health.ARMOR, OW1_BASTION_TANK_ARMOR-OW1_BASTION_ARMOR, true, false) # Apply Tank healthpool
    eventPlayer.tank_armour = getLastCreatedHealthPool()

    wait(OW1_BASTION_TANK_CONFIG_DURATION-OW2_BASTION_ASSAULT_CONFIG_LENGTH) # Keep these 2 no matter what otherwise it would break
    waitUntil(not eventPlayer.isUsingAbility1(), OW1_BASTION_TANK_CONFIG_DURATION-OW2_BASTION_ASSAULT_CONFIG_LENGTH) # Keep these 2 no matter what otherwise it would break

    # Restart tank config
    eventPlayer.allowButton(Button.ABILITY_1)
    
    eventPlayer.forceButtonPress(Button.ABILITY_1) # Leave assault mode
    eventPlayer.cancelPrimaryAction()

    eventPlayer.forceButtonPress(Button.ABILITY_1) # Re-enter assault and restart tank mode
    eventPlayer.cancelPrimaryAction()

    eventPlayer.disallowButton(Button.ABILITY_1) # Re-disable reconfiguring out of turret mode

    waitUntil(not eventPlayer.isInAlternateForm(), OW2_BASTION_ASSAULT_CONFIG_LENGTH)

    if eventPlayer.isUsingAbility1():
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to recon mode
    eventPlayer.stopFacing()
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setUltEnabled(true)
    removeHealthPool(eventPlayer.tank_armour)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)

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

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_BASTION_TANK_CONFIG_SHELL_RELOAD_TIME) # modify cooldown for tank shell
    wait(OW1_BASTION_TANK_CONFIG_SHELL_RELOAD_TIME) # Wait tank shell reload time
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0) # Set tank shell as available