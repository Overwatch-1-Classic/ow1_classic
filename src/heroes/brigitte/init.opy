#!mainFile "../../dev_main.opy"

#!include "bash.opy"
# !include "whipshot.opy"
#!include "rally.opy"
#!include "inspire.opy"
#!include "repair.opy"

/*
This 2018 Brigitte workshop script is heavily based on
https://workshop.codes/MR5QJ       code: MR5QJ
created by oreoslurpee 
*/

def initBrigitte():
    @Name "[brigitte/init.opy]: initBrigitte()"
    
    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)

    removeSelfHealing()


rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
