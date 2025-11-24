#!mainFile "../../dev_main.opy"

#!include "regen_burst.opy"
# !include "lamp.opy"


def initBaptiste():
    @Name "[baptiste/init.opy]: initBaptiste()"

    setCustomHp(OW1_BAPTISTE_HEALTH, 0, 0)
    setUltCost(OW1_BAPTISTE_ULT_COST)

    # setBaseDamage(eventPlayer, OW1_BAPTISTE_PRIMARY_DAMAGE/OW2_BAPTISTE_PRIMARY_DAMAGE)

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    removeSelfHealing()

    # eventPlayer.disallowButton(Button.ABILITY_2)

rule "[baptiste/init.opy]: Piledriver":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0

    eventPlayer.setGravity(200)
    eventPlayer.applyImpulse(Vector.DOWN, 98, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    damage(getPlayersInRadius(eventPlayer.getPosition(), 5, getOppositeTeam(eventPlayer.getTeam())), eventPlayer, OW1_BAPTISTE_PILEDRIVER_DAMAGE)
    eventPlayer.setGravity(100)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3)