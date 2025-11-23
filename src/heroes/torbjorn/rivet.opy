#!mainFile "../../dev_main.opy"

rule "[torbjorn/rivet.opy]: 3 rivet ammo consumption.":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) - 1))