#!mainFile "../../dev_main.opy"

#!include "hover_jets.opy"
#!include "rocket_launcher.opy"
#!include "concussive.opy"
#!include "barrage.opy"

def initPharah():
    @Name "[pharah/init.opy]: initPharah()"

    setCustomHp(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)
    removeSelfHealing()
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setKnockbackDealt(175)
    initHoverJets()


# rule "[pharah/init.opy]: Clean up Pharah":
    # @Event eachPlayer
    # @Condition eventPlayer.getCurrentHero() == Hero.PHARAH
    
    # waitUntil(eventPlayer.getCurrentHero() != Hero.PHARAH, Math.INFINITY)
    # hideFuelGui()

/*
rule "[pharah/init.opy]: Pharah reduce elevation":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition not eventPlayer.isJumping()
    
    eventPlayer.setGravity(150)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    eventPlayer.setGravity(100)
*/