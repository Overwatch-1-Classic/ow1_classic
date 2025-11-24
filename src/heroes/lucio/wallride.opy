#!mainFile "../../dev_main.opy"

rule "[lucio/wallride.opy]: Launch wallride":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isOnWall()

    eventPlayer.setMoveSpeed(150)
    setBaseDamage(eventPlayer, OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE*2)
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) + OW1_LUCIO_SOUNDWAVE_AMMO_CONSUMPTION))
    eventPlayer.setProjectileSpeed(300)
    waitUntil(not eventPlayer.isOnWall(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setProjectileSpeed(100)
    setBaseDamage(eventPlayer, OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE)