#!mainFile "../../dev_main.opy"

rule "[ana/boost.opy]: Damage players to detect nano boost":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingUltimate()

    damage((([player for player in getPlayers(eventPlayer.getTeam()) if player.getNormalizedHealth() > 0.5]).exclude(eventPlayer)), null, MIN_RECOGNIZE_DAMAGE)


rule "[ana/boost.opy]: Set nano boosted player speed + remove nano instant healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    
    damage(healee, null, eventHealing-MIN_RECOGNIZE_DAMAGE)
    healee.setMoveSpeed(percent(OW1_ANA_NANO_BOOST_SPEED_MULTIPLIER*eventPlayer._base_movement_scalar))
    wait(OW1_ANA_NANO_BOOST_DURATION)
    healee.setMoveSpeed(100)