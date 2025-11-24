#!mainFile "../../dev_main.opy"

rule "[reaper/wraith.opy]: set reaper wraith":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.disallowButton(Button.ABILITY_1)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW1_REAPER_WRAITH_MOVEMENT_INCREASE))
    eventPlayer.setAmmo(0, eventPlayer.wrath_ammo)
    waitUntil((not eventPlayer.isUsingAbility1()), 3)
    eventPlayer.allowButton(Button.ABILITY_1)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW1_REAPER_WRAITH_MOVEMENT_INCREASE))

rule "[reaper/wraith.opy]: get wrath ammo":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.wrath_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingAbility1()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wrath_ammo = eventPlayer.getAmmo(0)