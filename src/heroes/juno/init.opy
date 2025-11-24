#!mainFile "../../dev_main.opy"


def initJuno():
    @Name "[juno/init.opy]: initJuno()"
    
    setCustomHp(OW1_JUNO_HEALTH, 0, OW1_JUNO_SHIELDS)
    setUltCost(OW1_JUNO_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, 200/225)

# Code made by Alomare https://youtu.be/bM6uR52GCZI?si=lfS8jqDPLe4Lv6wD&t=324

playervar juno_pvar
#!defineMember juno_abduction juno_pvar[0]
#!defineMember juno_abduction_damage juno_pvar[1]
playervar juno_abduction_position 
playervar juno_abduction_true 

rule "[juno/init.opy]: juno abduction":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingUltimate()
    
    wait(0.49, Wait.ABORT_WHEN_FALSE)
    eventPlayer.juno_abduction_position = [eventPlayer.getPosition() * vect(1, 0, 1) + eventPlayer.getFacingDirection() * vect(1, 0, 1) * 3.1, eventPlayer.getFacingDirection() * vect(1, 0, 1)]
    wait(0.4)
    eventPlayer.juno_abduction_true = eventPlayer.juno_abduction
    chaseAtRate(eventPlayer.juno_abduction_true, eventPlayer.juno_abduction + eventPlayer.juno_abduction_position * 100, 2.2, ChaseRateReeval.NONE)
    wait(0.35)
    while eventPlayer.isUsingUltimate():
        eventPlayer.juno_abduction_damage = [player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(player.getPosition() * vect(1, 0, 1), eventPlayer.juno_abduction_true) <= 8]
        damage(eventPlayer.juno_abduction_damage, eventPlayer, 25)
        eventPlayer.juno_abduction_damage.applyImpulse(Vector.UP, 4, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.1)
    stopChasingVariable(eventPlayer.juno_abduction_true)