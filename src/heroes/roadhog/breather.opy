#!mainFile "../../dev_main.opy"

# subroutine startBreather

# def startBreather():
    # @Name "[roadhog/breather.opy]: startBreather()"

    # eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    # eventPlayer.disallowButton(Button.ABILITY_2)

rule "[roadhog/breather.opy]: OW1 Classic Take a Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) # For some reason isUsingAbility2() doesn't work here
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isMeleeing()
    @Condition not isCCd(eventPlayer)

    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    eventPlayer.setDamageReceived(percent((1-OW1_ROADHOG_BREATHER_DAMAGE_REDUCTION)/(1-OW2_ROADHOG_BREATHER_DAMAGE_REDUCTION)))
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(OW1_ROADHOG_BREATHER_CAST_TIME*2+OW1_ROADHOG_BREATHER_DURATION)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.setDamageReceived(100)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN)

/*
rule "[roadhog/breather.opy]: Allow self healing during Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) # For some reason isUsingAbility2() doesn't work here
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(not eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0, Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)
*/