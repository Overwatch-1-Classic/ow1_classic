#!mainFile "../../dev_main.opy"

#!include "widow_kiss.opy"

def initWidowmaker():
    @Name "[widowmaker/init.opy]: initWidowmaker()"

    setCustomHp(OW1_WIDOWMAKER_HEALTH, 0, 0)
    setUltCost(OW1_WIDOWMAKER_ULT_COST)
    removeSelfHealing()

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)