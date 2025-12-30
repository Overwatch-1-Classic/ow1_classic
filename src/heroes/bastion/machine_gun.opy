#!mainFile "../../dev_main.opy"

playervar machine_gun_pvar
#!defineMember machine_gun_ammo_id machine_gun_pvar[0]
#!defineMember machine_gun_ammo machine_gun_pvar[2]

macro hideMachineGunAmmo():
    destroyInWorldText(eventPlayer.machine_gun_ammo_id)
    eventPlayer.machine_gun_ammo_id = null

macro updateMachineGunAmmo():
    # eventPlayer.setAmmo(1, eventPlayer.getAmmo(1) - 1)
    eventPlayer.setAmmo(1, eventPlayer.machine_gun_ammo - 1)

macro resetMachineGun():
    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    updateMachineGunAmmo()

rule "[bastion/machine_gun.opy]: Activate & De-activate machine gun in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    # show machine gun ammo
    if eventPlayer.machine_gun_ammo_id == null:
        createInWorldText(
            eventPlayer,
            "{0}|{1}".format(ceil(eventPlayer.machine_gun_ammo), OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE),
            updateEveryTick(eventPlayer.getEyePosition() + \
            (100 * (3.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + \
            ((-1.3 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
            verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
            2, 
            Clip.NONE, 
            WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
            Color.WHITE, 
            SpecVisibility.DEFAULT)
        eventPlayer.machine_gun_ammo_id = getLastCreatedText()
    
    waitUntil(eventPlayer.current_configuration != Configuration.SENTRY, Math.INFINITY)

    hideMachineGunAmmo()

rule "[bastion/machine_gun.opy]: Update machine gun ammo when shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isReloading()

    updateMachineGunAmmo()

rule "[bastion/machine_gun.opy]: Consume machine gun ammo when shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isReloading()
    @Condition not eventPlayer.isMeleeing()
    
    do:
        eventPlayer.machine_gun_ammo -= 1
        wait(1/OW1_BASTION_SENTRY_CONFIG_FIRE_RATE)
    while RULE_CONDITION

rule "[bastion/machine_gun.opy]: Reload machine gun when out of ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.machine_gun_ammo <= 0 or eventPlayer.getAmmo(1) == 0
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.setAmmo(1, 0) # Not go negative ammo & When restarting sentry force reload
    wait(OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME, Wait.ABORT_WHEN_FALSE)
    resetMachineGun()

rule "[bastion/machine_gun.opy]: Reload machine gun on reload key":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isReloading()

    wait(OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME, Wait.ABORT_WHEN_FALSE) # Cant use eventPlayer.isReloading() due to it instantly reloading after restarting sentry and i find this approach better because no time is wasted
    resetMachineGun()

rule "[bastion/machine_gun.opy]: Reload machine gun when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    wait(OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME, Wait.ABORT_WHEN_FALSE)
    resetMachineGun()