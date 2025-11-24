#!mainFile "../../dev_main.opy"


rule "[reaper/blossom.opy]: OW1 Death Blossom damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, null, eventDamage - (OW1_REAPER_DEATH_BLOSSON_DAMAGE/OW2_REAPER_DEATH_BLOSSON_DAMAGE) * eventDamage)

rule "[reaper/wraith.opy]: set reaper blossom speed":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(350)
    waitUntil((not eventPlayer.isUsingUltimate()), 3)
    eventPlayer.setMoveSpeed(100)