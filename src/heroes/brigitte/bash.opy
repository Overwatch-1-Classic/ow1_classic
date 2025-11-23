#!mainFile "../../dev_main.opy"

# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

globalvar BRIGITTE_SUPERGLIDE = createWorkshopSetting(bool, "Brigitte", "Superglide Bug/Tech", false) # I added this because im unsure if we should include this in the code or not.

rule "[brigitte/bash.opy]: Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition attacker.isFiringSecondaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE
    # @Condition not attacker.shield_bash_through_barrier
    
    victim.setStatusEffect(attacker, Status.STUNNED, OW1_BRIGITTE_SHIELD_BASH_STUN_DURATION)


rule "[brigitte/bash.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingUltimate()
    
    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > 0, Math.INFINITY)
    if eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))
    else:
        eventPlayer.setMoveSpeed(100)

rule "[brigitte/bash.opy]: Brigitte superglide 'tech' ": # https://youtu.be/qY4s7zJ01eU?si=X330hdHMUBxcOiY3&t=430 , Video by KarQ this is disabled by default
    @Event eachPlayer
    @Hero brigitte
    @Condition BRIGITTE_SUPERGLIDE == true
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()

    waitUntil(not eventPlayer.isFiringPrimaryFire(), Math.INFINITY)
    # waitUntil(not eventPlayer.isFiringPrimaryFire(), 0.1)
    if eventPlayer.isHoldingButton(Button.ABILITY_1) and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0:
        eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        # eventPlayer.applyImpulse(eventPlayer.getVelocity(), 2000, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        eventPlayer.applyImpulse(eventPlayer.getVelocity(), 30, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        eventPlayer.setMoveSpeed(100) # Hot fix cause sometimes speed get conflicted due to reduce shield bash distance rule

    waitUntil(not eventPlayer.isFiringPrimaryFire() and not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    if eventPlayer.isUsingAbility2() and eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
        eventPlayer.applyImpulse(eventPlayer.getVelocity(), 30, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        eventPlayer.setMoveSpeed(100) # Hot fix cause sometimes speed get conflicted due to reduce shield bash distance rule
        eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)

rule "[brigitte/bash.opy]: Reduce shield bash damage to OW1":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, eventDamage - eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE))

rule "[brigitte/barrier.opy]: OW1 brigitte barrier health":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0

    eventPlayer.setMaxHealth(percent(OW1_BRIGITTE_BARRIER_HEALTH/OW2_BRIGITTE_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(eventPlayer.isFiringSecondaryFire(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))

    waitUntil(not eventPlayer.isFiringSecondaryFire())
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

# I think i made this too easy LULZ