#!mainFile "../../dev_main.opy"

#!include "focusing_beam.opy"
#!include "duplicate.opy"


def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH-1, 0, 1) # Partially fix shield healthpool
    setUltCost(OW1_ECHO_ULT_COST)
    removeSelfHealing()
