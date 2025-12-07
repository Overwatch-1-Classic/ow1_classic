#!mainFile "../../dev_main.opy"


# rule "[zenyatta/transc.opy]: Allow self healing during Transcendence":
    # @Event eachPlayer
    # @Hero zenyatta
    # @Condition eventPlayer.isUsingUltimate()

    # pushSelfHealing(Button.ULTIMATE)
    # waitUntil(not eventPlayer.isUsingUltimate() , Math.INFINITY)
    # popSelfHealing(Button.ULTIMATE)

rule "[zenyatta/transc.opy]: No movement boost during Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW1_ZENYATTA_TRANSCENDENCE_MOVEMENT_BONUS))
    waitUntil((not eventPlayer.isUsingUltimate()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW1_ZENYATTA_TRANSCENDENCE_MOVEMENT_BONUS))