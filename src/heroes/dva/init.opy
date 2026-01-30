#!mainFile "../../dev_main.opy"

#!include "hp.opy"
#!include "matrix.opy"
#!include "gun.opy"
#!include "booster.opy"
# !include "micro_missiles.opy"
#!include "bomb.opy"
#!include "remech.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"
    
    setUltCost(OW1_DVA_ULT_COST)
    # removeTankPassive()
    # removeSelfHealing()

    # Defense Matrix init
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbility2Enabled(false)

    setBaseDamage(eventPlayer, OW1_DVA_FUSION_CANNONS_BASE_DAMAGE/OW2_DVA_FUSION_CANNONS_BASE_DAMAGE)

rule "[dva/init.opy]: Clean up DVa":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DVA

    waitUntil(eventPlayer.getCurrentHero() != Hero.DVA, Math.INFINITY)
    hideDestroyMatrixHUD()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)