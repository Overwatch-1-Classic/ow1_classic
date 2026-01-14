#!mainFile "../../dev_main.opy"

rule "[lucio/sound_barrier.opy]: sound barrier reduce overhealth if on ground":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer._hp_health + OW1_LUCIO_SOUND_BARRIER_OVERHEALTH

    wait()
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
        getPlayersInRadius(eventPlayer.getPosition(), 
            OW1_LUCIO_SOUND_BARRIER_AREA_OF_EFFECT, 
            eventPlayer.getTeam(), 
            LosCheck.SURFACES).setHealth(eventPlayer.getHealth() - OW2_LUCIO_SOUND_BARRIER_OVERHEALTH-OW1_LUCIO_SOUND_BARRIER_OVERHEALTH)
#     damage(getPlayersInRadius(eventPlayer.getPosition(), 
#         OW1_LUCIO_SOUND_BARRIER_AREA_OF_EFFECT, 
#         eventPlayer.getTeam(), 
#         LosCheck.SURFACES), 
#         null, 
#         OW2_LUCIO_SOUND_BARRIER_OVERHEALTH-OW1_LUCIO_SOUND_BARRIER_OVERHEALTH)