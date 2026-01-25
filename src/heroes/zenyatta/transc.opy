#!mainFile "../../dev_main.opy"


# rule "[zenyatta/transc.opy]: Allow self healing during Transcendence":
    # @Event eachPlayer
    # @Hero zenyatta
    # @Condition eventPlayer.isUsingUltimate()

    # pushSelfHealing(Button.ULTIMATE)
    # waitUntil(not eventPlayer.isUsingUltimate() , Math.INFINITY)
    # popSelfHealing(Button.ULTIMATE)

rule "[zenyatta/transc.opy]: No movement boost & Decrease healing during Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW2_ZENYATTA_TRANSCENDENCE_MOVEMENT_BONUS))
    eventPlayer.setAmmo(0, eventPlayer.transc_ammo)
    eventPlayer.setHealingDealt(percent(OW1_ZENYATTA_TRANSCENDENCE_HEALING/OW2_ZENYATTA_TRANSCENDENCE_HEALING))
    waitUntil((not eventPlayer.isUsingUltimate()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW2_ZENYATTA_TRANSCENDENCE_MOVEMENT_BONUS))
    eventPlayer.setHealingDealt(100)

rule "[zenyatta/transc.opy]: Get Zenyatta transc ammo":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.transc_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingUltimate()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.transc_ammo = eventPlayer.getAmmo(0)