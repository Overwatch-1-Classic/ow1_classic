#!mainFile "../../dev_main.opy"

rule "[dva/remech.opy]: Set remech damage":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    
    waitUntil(eventPlayer.isUsingUltimate() or eventPlayer.isDead() or not eventPlayer.isInAlternateForm(), Math.INFINITY)
    if eventPlayer.isInAlternateForm():
        eventPlayer.setDamageDealt(percent(OW1_DVA_REMECH_DAMAGE/OW2_DVA_REMECH_DAMAGE))
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
        setBaseDamage(eventPlayer, OW1_DVA_FUSION_CANNONS_BASE_DAMAGE/OW2_DVA_FUSION_CANNONS_BASE_DAMAGE)

rule "[dva/booster.opy]: Correct light gun damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, 1.27) # Magic numbers for inaccurate number, temporarily solution for the time being