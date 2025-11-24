#!mainFile "../../dev_main.opy"

#!include "focusing_beam.opy"
#!include "duplicate.opy"


def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH, 0, 0)
    setUltCost(OW1_ECHO_ULT_COST)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setGravity(0)
    removeSelfHealing()

rule "[echo/init.opy]: Move upwards on jump":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    do:
        eventPlayer.applyImpulse(Vector.UP, FLIGHT_IMPULSE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION


rule "[echo/init.opy]: Move downwards on crouch":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    do:
        eventPlayer.applyImpulse(Vector.DOWN, FLIGHT_IMPULSE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION

rule "[echo/init.opy]: Short dash flight":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0

    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 5)