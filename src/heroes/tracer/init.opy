#!mainFile "../../dev_main.opy"

#!include "pulse_pistol.opy"
#!include "pulse_bomb.opy"


def initTracer():
    @Name "[tracer/init.opy]: initTracer()"

    setCustomHp(OW1_TRACER_HEALTH, 0, 0)
    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()

rule "[tracer/init.opy]: Deal OW1 tracer Pulse Bomb damage":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.isUsingAbility2()

    waitUntil(not eventPlayer.isUsingAbility2())
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)