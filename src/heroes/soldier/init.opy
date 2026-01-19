#!mainFile "../../dev_main.opy"

#!include "pulse_rifle.opy"
# !include "biotic_field.opy"
#!include "sprint.opy"
#!include "visor.opy"


def initSoldier():
    @Name "[soldier/init.opy]: initSoldier()"

    eventPlayer.setAmmo(0, OW1_SOLDIER_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SOLDIER_CLIP_SIZE)

    setCustomHp(OW1_SOLDIER_HEALTH, 0, 0)
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    # removeSelfHealing()
