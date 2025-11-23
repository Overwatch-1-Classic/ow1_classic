#!mainFile "../../dev_main.opy"

# playervar primal_pvar
# !defineMember _primal_exit_health primal_pvar[0]
# !defineMember _primal_exit_armor primal_pvar[1]
# !defineMember _primal_hp_id primal_pvar[2]


# rule "[primal/init.opy]: Remove bonus Primal Rage health":
#     @Event eachPlayer
#     @Hero winston
#     @Condition eventPlayer.isUsingUltimate()

#     removeHealthPool(eventPlayer._primal_hp_id)
#     wait(OW2_WINSTON_PRIMAL_DURATION - 10 * TICK_DURATION)
#     eventPlayer._primal_exit_health = eventPlayer.getHealthOfType(Health.NORMAL)
#     eventPlayer._primal_exit_armor = eventPlayer.getHealthOfType(Health.ARMOR)
#     waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
#     eventPlayer.addHealthPool(Health.NORMAL, (OW2_WINSTON_PRIMAL_HEALTH_BONUS * (OW1_WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH) - OW1_WINSTON_PRIMAL_HEALTH_BONUS), true, true)
#     eventPlayer._primal_hp_id = getLastCreatedHealthPool()
#     eventPlayer.setHealth(min(OW1_WINSTON_HEALTH, eventPlayer._primal_exit_health) + eventPlayer._primal_exit_armor)

rule "[winston/primal.opy]: Primal damage":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(
        victim, 
        attacker, 
        ((OW1_WINSTON_PRIMAL_DAMAGE/OW2_WINSTON_PRIMAL_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)

rule "[winston/primal.opy]: set primal ammo":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, eventPlayer.primal_ammo)
    waitUntil((not eventPlayer.isUsingUltimate()), Math.INFINITY)

rule "[winston/primal.opy]: get primal ammo":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.primal_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingUltimate()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.primal_ammo = eventPlayer.getAmmo(0)

# Bugged