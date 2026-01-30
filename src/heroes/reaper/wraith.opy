#!mainFile "../../dev_main.opy"

rule "[reaper/wraith.opy]: Set Wraith speed & ammo":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setMoveSpeed(percent(OW1_REAPER_WRAITH_MOVEMENT_INCREASE/OW2_REAPER_WRAITH_MOVEMENT_INCREASE))
    eventPlayer.setAmmo(0, eventPlayer.wrath_ammo)
    waitUntil((not eventPlayer.isUsingAbility1()), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)

rule "[reaper/wraith.opy]: Get Wraith or Death Blossom ammo":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.wrath_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingAbility1() or not eventPlayer.isUsingUltimate()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wrath_ammo = eventPlayer.getAmmo(0)