#!mainFile "../../dev_main.opy"

#!include "blossom.opy"
#!include "soul_orb.opy"
# !include "wraith.opy"
#!include "step.opy"

def initReaper():
    @Name "[reaper/init.opy]: initReaper()"

    setCustomHp(OW1_REAPER_HEALTH, 0, 0)
    setUltCost(OW1_REAPER_ULT_COST)
    removePassiveHealing()
    eventPlayer.setHealingDealt(percent(OW1_REAPER_LIFESTEAL/OW2_REAPER_LIFESTEAL))


rule "[reaper/init.opy]: Deal OW1 Reaper primary fire damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (OW1_REAPER_HELLFIRE_SHOTGUNS_DAMAGE/OW2_REAPER_HELLFIRE_SHOTGUNS_DAMAGE) * eventDamage - eventDamage)
