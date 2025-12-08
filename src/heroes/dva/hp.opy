#!mainFile "../../dev_main.opy"

rule "[dva/hp.opy]: Correct DVa mech health":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()

    # wait(1, Wait.ABORT_WHEN_FALSE)
    clearCustomHp()
    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
    heal(eventPlayer, null, OW1_DVA_HEALTH + OW1_DVA_ARMOR)

rule "[dva/hp.opy]: Correct DVa pilot health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.getMaxHealthOfType(Health.NORMAL) != OW1_DVA_PILOT_HEALTH

    clearCustomHp()
    setCustomHp(OW1_DVA_PILOT_HEALTH, 0, 0)
    heal(eventPlayer, null , OW1_DVA_PILOT_HEALTH)