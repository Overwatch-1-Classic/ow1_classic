#!mainFile "../../dev_main.opy"

#!include "kunai.opy"
#!include "suzu.opy"
#!include "swift_step.opy"

def initKiriko():
    @Name "[kiriko/init.opy]: initKiriko()"
    
    setCustomHp(OW1_KIRIKO_HEALTH, 0, 0)
    setUltCost(OW1_KIRIKO_ULT_COST)

    removePassiveHealing()

    eventPlayer.setHealingDealt(percent(OW1_KIRKIO_OFUDA_HEALING/OW2_KIRIKO_OFUDA_HEALING))

    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 12)
    setBaseDamage(eventPlayer, (OW1_KIRIKO_KUNAI_HEADSHOT_DAMAGE/OW2_KIRIKO_KUNAI_HEADSHOT_DAMAGE))


rule "[kiriko/init.opy]: Deal regular damage for any non custom damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition eventAbility in [Button.MELEE]
    
    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[kiriko/init.opy]: Heal when using Swift Step & Rush":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility2()

    eventPlayer.addHealthPool(Health.NORMAL, 100, false)