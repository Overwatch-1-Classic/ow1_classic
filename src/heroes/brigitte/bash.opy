#!mainFile "../../dev_main.opy"

# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

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

rule "[brigitte/bash.opy]: Reduce shield bash damage to OW1":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, eventDamage - eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE))

# rule "[brigitte/barrier.opy]: OW1 brigitte barrier health":
#     @Event eachPlayer
#     @Hero brigitte
#     @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
#     @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0
# 
#     eventPlayer.setMaxHealth(percent(OW1_BRIGITTE_BARRIER_HEALTH/OW2_BRIGITTE_BARRIER_HEALTH))
#     eventPlayer.allowButton(Button.SECONDARY_FIRE)
#     eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
#     waitUntil(eventPlayer.isFiringSecondaryFire(), 1)
#     eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
# 
#     waitUntil(not eventPlayer.isFiringSecondaryFire())
#     eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
#     eventPlayer.disallowButton(Button.SECONDARY_FIRE)