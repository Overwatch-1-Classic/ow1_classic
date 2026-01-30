#!mainFile "../../dev_main.opy"


rule "[reaper/blossom.opy]: OW1 Death Blossom damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, null, eventDamage - (OW1_REAPER_DEATH_BLOSSON_DAMAGE/OW2_REAPER_DEATH_BLOSSON_DAMAGE) * eventDamage)

rule "[reaper/blossom.opy]: Set Death Blossom ammo":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate()

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setAmmo(0, eventPlayer.wrath_ammo)