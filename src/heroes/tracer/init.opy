#!mainFile "../../dev_main.opy"

#!include "pulse_pistol.opy"
#!include "pulse_bomb.opy"


def initTracer():
    @Name "[tracer/init.opy]: initTracer()"

    setCustomHp(OW1_TRACER_HEALTH, 0, 0)
    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()
