#!mainFile "../../dev_main.opy"

rule "[pharah/barrage.opy]: get barrage ammo":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.barrage_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingUltimate()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.barrage_ammo = eventPlayer.getAmmo(0)
        
rule "[pharah/barrage.opy]: set barrage ammo":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isUsingUltimate()
    
    eventPlayer.setAmmo(0, eventPlayer.barrage_ammo)

rule "[pharah/barrage.opy]: 3s barrage duration":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isUsingUltimate()

    wait(OW1_PHARAH_BARRAGE_DURATION - OW2_PHARAH_BARRAGE_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)