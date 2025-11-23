#!mainFile "../../dev_main.opy"

playervar widowmaker_falloff_pvar
#!defineMember scoped_shot_distance widowmaker_falloff_pvar[0]
#!defineMember scoped_damage_base widowmaker_falloff_pvar[1]
#!defineMember ow2_scoped_damage_falloff_scalar widowmaker_falloff_pvar[2]
#!defineMember ow1_scoped_damage_falloff_scalar widowmaker_falloff_pvar[3]
#!defineMember expected_scoped_damage widowmaker_falloff_pvar[4]


# Damage falloff derived from Marblr's "How Damage Falloff is Calculated" video: https://youtu.be/VL2VnkNJPpE
#!define OW1WidowmakerN(d) ((d - OW1_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW1_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW2WidowmakerN(d) ((d - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW2_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1WidowmakerFalloff(d) ((OW1WidowmakerN(d)) * OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW1WidowmakerN(d)))
#!define OW2WidowmakerFalloff(d) ((OW2WidowmakerN(d)) * OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW2WidowmakerN(d)))

rule "[widowmaker/widow_kiss.opy]: Remove sniper damage falloff":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    eventPlayer.ow2_scoped_damage_falloff_scalar = OW2WidowmakerFalloff(eventPlayer.scoped_shot_distance)
    # Cap min/max scalar
    if eventPlayer.ow2_scoped_damage_falloff_scalar > 1: # Max damage scalar
        eventPlayer.ow2_scoped_damage_falloff_scalar = 1
    elif eventPlayer.ow2_scoped_damage_falloff_scalar < OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
        eventPlayer.ow2_scoped_damage_falloff_scalar = OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR

    eventPlayer.scoped_damage_base = eventDamage/eventPlayer.ow2_scoped_damage_falloff_scalar
    
    eventPlayer.ow1_scoped_damage_falloff_scalar = OW1WidowmakerFalloff(eventPlayer.scoped_shot_distance)
    # Cap min/max scalar
    if eventPlayer.ow1_scoped_damage_falloff_scalar > 1: # Max damage scalar
        eventPlayer.ow1_scoped_damage_falloff_scalar = 1
    elif eventPlayer.ow1_scoped_damage_falloff_scalar < OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
        eventPlayer.ow1_scoped_damage_falloff_scalar = OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR

    eventPlayer.expected_scoped_damage = eventPlayer.scoped_damage_base * eventPlayer.ow1_scoped_damage_falloff_scalar
    damage(victim, attacker, eventPlayer.expected_scoped_damage - eventDamage)


rule "[widowmaker/widow_kiss.opy]: Correct sniper bodyshot damage & Compensate for no faster charge rate":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventWasCriticalHit

    damage(
        victim, 
        attacker, 
        ((OW1_WIDOWMAKER_WIDOW_KISS_DAMAGE/OW2_WIDOWMAKER_WIDOW_KISS_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)

rule "[widowmaker/widow_kiss.opy]: fix reload":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.getAmmo() == 0
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(TICK_DURATION*7)
    eventPlayer.setAmmo(0, 0)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)


rule "[widowmaker/widow_kiss.opy]: delay on casting":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    
    wait(OW1_WIDOWMAKER_WIDOW_KISS_DELAY, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE): 
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE) 
        waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY) 
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)

rule "[widowmaker/widow_kiss.opy]: Fixed secondary fire ammo comsuption":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    
    waitUntil(not eventPlayer.isFiringPrimaryFire() and eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo() + 2))

# rule "[widowmaker/widow_kiss.opy]: Correct headshot damage":
    # @Event playerDealtDamage
    # @Hero widowmaker
    # @Condition eventPlayer.isFiringSecondaryFire()
    # @Condition eventAbility in [Button.PRIMARY_FIRE]
    # @Condition eventWasCriticalHit


    # heal(victim, null, ((eventDamage/eventPlayer._base_damage_scalar)*(OW1_WIDOWMAKER_WIDOW_KISS_HEADSHOT_MULTIPLIER/OW2_WIDOWMAKER_WIDOW_KISS_HEADSHOT_MULTIPLIER) - eventDamage)/eventPlayer._base_damage_scalar)
    
# rule "[widowmaker/widow_kiss.opy]: Correct headshot damage":
    # @Event playerDealtDamage
    # @Hero widowmaker
    # @Condition eventPlayer.isFiringSecondaryFire()
    # @Condition eventAbility in [Button.PRIMARY_FIRE]
    # @Condition eventWasCriticalHit


    # heal(victim, null, 75)