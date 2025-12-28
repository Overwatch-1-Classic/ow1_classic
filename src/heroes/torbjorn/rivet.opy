#!mainFile "../../dev_main.opy"

rule "[torbjorn/rivet.opy]: Correct rivet ammo consumption":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) - 1))

rule "[torbjorn/rivet.opy]: OW1 Torbjorn reload speed":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isReloading()

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    waitUntil(not eventPlayer.isReloading(), OW2_TORBJORN_RIVET_GUN_RELOAD_SPEED)
    wait(OW1_TORBJORN_RIVET_GUN_RELOAD_SPEED-OW2_TORBJORN_RIVET_GUN_RELOAD_SPEED)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    startFiring()

rule "[torbjorn/rivet.opy]: OW1 Torbjorn hammer damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.MELEE]

    damage(victim, attacker, OW1_TORBJORN_HAMMER_DAMAGE-OW2_TORBJORN_HAMMER_DAMAGE)

rule "[torbjorn/rivet.opy]: OW1 Torbjorn fire rate":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_TORBJORN_HAMMER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)

rule "[torbjorn/rivet.opy]: OW1 Torbjorn fire rate melee":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isHoldingButton(Button.MELEE) # For some reason it wont let me do isMeleeing()
    @Condition not eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.MELEE)
    wait(OW1_TORBJORN_HAMMER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.MELEE)
    if eventPlayer.isHoldingButton(Button.MELEE):
        eventPlayer.forceButtonPress(Button.MELEE)