#!mainFile "../../dev_main.opy"

#!include "flux.opy"
#!include "grasp.opy"
#!include "accretion.opy"

/*
This 2019 Sigma workshop script is heavily based on
https://workshop.codes/8DNEV       code: 8DNEV
created by oreoslurpee 
*/

def initSigma():
    @Name "[sigma/init.opy]: initSigma()"

    setCustomHp(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
    setUltCost(OW1_SIGMA_ULT_COST)
    # removeTankPassive()
    removeSelfHealing()

    eventPlayer.setGravity(0)
    eventPlayer.setSecondaryFireEnabled(false)

    setBaseDamage(eventPlayer, OW1_SIGMA_ACCRETION_TOTAL_DAMAGE/OW2_SIGMA_ACCRETION_TOTAL_DAMAGE)

rule "[sigma/init.opy]: Compensate Sigma global damage reduction":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility in [Button.PRIMARY_FIRE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

/*
rule "[sigma/barrier.opy]: OW1 Sigma barrier health":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0

    eventPlayer.setMaxHealth(percent(OW1_SIGMA_BARRIER_HEALTH/OW2_SIGMA_BARRIER_HEALTH))
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
*/


rule "[sigma/init.opy]: Move upwards on jump":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    do:
        eventPlayer.applyImpulse(Vector.UP, FLIGHT_IMPULSE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION


rule "[sigma/init.opy]: Move downwards on crouch":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    do:
        eventPlayer.applyImpulse(Vector.DOWN, FLIGHT_IMPULSE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION