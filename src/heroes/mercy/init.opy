#!mainFile "../../dev_main.opy"

#!include "guardian.opy"
#!include "resurrect.opy"
#!include "regeneration.opy"


def initMercy():
    @Name "[mercy/init.opy]: initMercy()"
    
    setCustomHp(OW1_MERCY_HEALTH, 0, 0)
    setUltCost(OW1_MERCY_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)

    setBaseHealing(eventPlayer, OW1_MERCY_STAFF_HEALING/OW2_MERCY_STAFF_HEALING)

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false

rule "[mercy/init.opy]: Clean up Mercy":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.MERCY

    waitUntil(eventPlayer.getCurrentHero() != Hero.MERCY, Math.INFINITY)
    hideMercyMassResurrectionHud()
    eventPlayer.stopAllHealingOverTime()