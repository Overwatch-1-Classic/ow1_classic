#!mainFile "../../dev_main.opy"

rule "[junkrat/init.opy]: Set tire ammo":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isUsingUltimate()

    wait(1, Wait.ABORT_WHEN_FALSE) # Need to have a delay
    eventPlayer.tire_ammo = eventPlayer.getAmmo(0)

rule "[junkrat/tire.opy]: Get tire ammo":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.tire_ammo != eventPlayer.getAmmo(0)
    @Condition eventPlayer.isUsingUltimate()
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.tire_ammo = eventPlayer.getAmmo(0)

rule "[junkrat/tire.opy]: Drop tire tech": # This isnt accurate because when upon using drop tire it sends the tire down instantly even when casting
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setGravity(Math.INFINITY)
    eventPlayer.applyImpulse(Vector.DOWN, Math.INFINITY, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(OW1_JUNKRAT_TIRE_CAST_TIME-0.25)
    eventPlayer.setGravity(100)

rule "[junkrat/tire.opy]: tire health": # Doesn't work
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMaxHealth(100)
    waitUntil(eventPlayer.isUsingUltimate(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))