#!mainFile "../../dev_main.opy"

playervar beat_pvar
#!defineMember _beat_enemies beat_pvar[0]
#!defineMember _beat_dropped beat_pvar[1]


rule "[lucio/sound_barrier.opy]: sound barrier reduce overhealth if on ground":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer._hp_health + OW1_LUCIO_SOUND_BARRIER_OVERHEALTH

    wait()
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    damage(getPlayersInRadius(eventPlayer.getPosition(), OW1_LUCIO_SOUND_BARRIER_AREA_OF_EFFECT, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS), null, OW2_LUCIO_SOUND_BARRIER_OVERHEALTH - OW1_LUCIO_SOUND_BARRIER_OVERHEALTH)

rule "[lucio/sound_barrier.opy]: Deal damage with Sound Barrier":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getAltitude() > 0
    @Condition not eventPlayer._beat_dropped

    waitUntil(eventPlayer.getAltitude() <= 0, Math.INFINITY)
    eventPlayer._beat_dropped = true

    eventPlayer._beat_enemies = getPlayersInRadius(eventPlayer, 3, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)
    eventPlayer._beat_enemies = [player for player in eventPlayer._beat_enemies if (angleBetweenVectors(Vector.DOWN, directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45)]
    damage(eventPlayer._beat_enemies, eventPlayer, Math.INFINITY)

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer._beat_dropped = false