#!mainFile "../../dev_main.opy"

# !include "railgun.opy"


def initSojourn():
    @Name "[sojourn/init.opy]: initSojourn()"

    setCustomHp(OW1_SOJOURN_HEALTH, 0, 0)
    setUltCost(OW1_SOJOURN_ULT_COST)

    eventPlayer.setAmmo(0, 60)
    eventPlayer.setMaxAmmo(0, 60)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setDamageDealt(120)
    eventPlayer.setProjectileSpeed(Math.INFINITY)
    removeSelfHealing()
