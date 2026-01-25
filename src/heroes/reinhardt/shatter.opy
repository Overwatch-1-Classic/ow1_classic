#!mainFile "../../dev_main.opy"

rule "[reinhardt/earthshatter.opy]: Correct Earthstatter damage":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.getUltCharge() == 0
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition not isCCd(eventPlayer)

    eventPlayer.setDamageDealt(percent(OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE/OW2_REINHARDT_EARTHSHATTER_BONUS_DAMAGE))
    waitUntil(eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(100)