#!mainFile "../../dev_main.opy"

#!include "guardian.opy"
#!include "resurrect.opy"


def initMercy():
    @Name "[mercy/init.opy]: initMercy()"
    
    setCustomHp(OW1_MERCY_HEALTH, 0, 0)
    setUltCost(OW1_MERCY_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer.setProjectileSpeed(200)
    setBaseDamage(eventPlayer, OW1_MERCY_BLASTER_DAMAGE/OW2_MERCY_BLASTER_DAMAGE)
    setBaseHealing(eventPlayer, OW1_MERCY_STAFF_HEALING/OW2_MERCY_STAFF_HEALING)

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false

rule "[mercy/init.opy]: Fast reload":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isReloading()

    wait(1.05, Wait.ABORT_WHEN_FALSE) # 1.05 is the reload speed but 25% faster, base is 1.4 seconds
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)