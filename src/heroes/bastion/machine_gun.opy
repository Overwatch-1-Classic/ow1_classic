#!mainFile "../../dev_main.opy"

playervar machine_gun_ammo_id
playervar machine_gun_ammo # machine_gun_pvar[2]

macro hideMachineGunAmmo():
    destroyInWorldText(eventPlayer.machine_gun_ammo_id)
    eventPlayer.machine_gun_ammo_id = null

macro reloadMachineGun():
    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.setAmmo(1, OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE)

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

rule "[bastion/machine_gun.opy]: Consume machine gun ammo when shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == true

    chase(eventPlayer.machine_gun_ammo, 0, rate=OW1_BASTION_SENTRY_CONFIG_FIRE_RATE, ChaseReeval.DESTINATION_AND_RATE)


rule "[bastion/machine_gun.opy]: Stop machine gun ammo consumption when not shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition not (eventPlayer.current_configuration == Configuration.SENTRY and eventPlayer.isFiringPrimaryFire())

    stopChasingVariable(eventPlayer.machine_gun_ammo)

rule "[bastion/machine_gun.opy]: Reload machine gun on reload key or when out of ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.machine_gun_ammo <= 0
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition not eventPlayer.isReloading()
    @Condition eventPlayer.machine_gun_ammo < OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE # don't reload if ammo already full

    eventPlayer.setAmmo(1, 0) # play turret reload animation
    wait(OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME, Wait.ABORT_WHEN_FALSE)
    reloadMachineGun()

rule "[bastion/machine_gun.opy]: Reload machine gun when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    wait(OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME, Wait.ABORT_WHEN_FALSE)
    reloadMachineGun()

rule "[bastion/machine_gun.opy]: finish reloading machine gun":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.machine_gun_ammo < OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE # don't reload if ammo already full
    @Condition eventPlayer.isReloading()

    wait(OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME, Wait.ABORT_WHEN_FALSE)
    reloadMachineGun()