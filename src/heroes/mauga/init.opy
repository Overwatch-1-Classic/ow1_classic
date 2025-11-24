#!mainFile "../../dev_main.opy"

# Depcrecated code, mauga is not included anymore


def initMauga():
    @Name "[mauga/init.opy]: initMauga()"
    
    setCustomHp(OW1_MAUGA_HEALTH, OW1_MAUGA_ARMOR, 0)
    setUltCost(OW1_MAUGA_ULT_COST)

    # removeTankPassive()
    removeSelfHealing()
