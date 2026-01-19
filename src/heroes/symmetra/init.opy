#!mainFile "../../dev_main.opy"

/*
This Support Symettra workshop script is heavily based on
https://workshop.codes/AMSG8    code: AMSG8
created by wadetata#0315
*/

#!include "shield.opy"
#!include "beam.opy"
#!include "orb.opy"
#!include "teleporter.opy"


def initSymmetra():
    @Name "[symmetra/init.opy]: initSymmetra()"

    setCustomHp(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    # removeSelfHealing()

    showPhotonProjecterBeam()
    showPhotonProjecterHUD()

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

rule "[symmetra/init.opy]: Clean up Symmetra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SYMMETRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.SYMMETRA, Math.INFINITY)
    destroyTeleporter()
    hidePhotonProjector()