#!mainFile "../../dev_main.opy"

rule "[soldier/sprint.opy]: set cast time on sprint":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    wait(OW1_SOLDIER_SPRINT_CAST_TIME, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    startFiring()


rule "[soldier/sprint.opy]: Reload 1 ammo while sprinting":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0)

    do:
        wait(1/6)
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
    while RULE_CONDITION