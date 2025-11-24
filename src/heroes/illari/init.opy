#!mainFile "../../dev_main.opy"

#!include "sun.opy"
#!include "solar_rifle.opy"


def initIllari():
    @Name "[illari/init.opy]: initIllari()"
    
    setCustomHp(OW1_ILLARI_HEALTH, 0, 0)
    setUltCost(OW1_ILLARI_ULT_COST)

    removePassiveHealing()

    # setBaseDamage(eventPlayer, OW1_ILLARI_SUNSTRUCK_DAMAGE/OW2_ILLARI_SUNSTRUCK_DAMAGE)

rule "[illari/init.opy]: Correct Outburst damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)