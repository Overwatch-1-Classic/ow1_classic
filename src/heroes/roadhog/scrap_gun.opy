#!mainFile "../../dev_main.opy"

rule "[roadhog/scrap_gun.opy]: OW1 roadhog fire rate m1":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringPrimaryFire()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_ROADHOG_SCRAP_GUN_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    startFiring()

rule "[roadhog/scrap_gun.opy]: OW1 roadhog fire rate m1":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    wait(OW1_ROADHOG_SCRAP_GUN_RECOVERY_TIME)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE): 
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE) 
        waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY) 
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)