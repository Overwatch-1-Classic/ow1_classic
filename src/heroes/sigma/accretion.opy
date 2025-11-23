#!mainFile "../../dev_main.opy"

playervar accerition_pvar
#!defineMember _accertion_distance_traveled accerition_pvar [0]
#!define accretionDistanceTraveled accerition_pvar [1]
#!define accretionKnockedDownDuration accerition_pvar [2]

rule "[sigma/init.opy]: Change accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # Checks for direct hit vs splash damage

    damage(victim, attacker, eventDamage*(OW1_SIGMA_ACCRETION_DAMAGE/OW2_SIGMA_ACCRETION_DAMAGE)-eventDamage)

rule "[sigma/init.opy]: Accretion stun scale upon distance":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    
    victim._accertion_distance_traveled = distance(attacker, victim)
    victim.accretionKnockedDownDuration = OW1_ACCERETION_MAX_DOWNTIME * (victim._accertion_distance_traveled / OW1_ACCERETION_DISTANCE_FULL_STUN)
    if victim.accretionKnockedDownDuration > OW1_ACCERETION_MAX_DOWNTIME:
        victim.accretionKnockedDownDuration = OW1_ACCERETION_MAX_DOWNTIME
    elif victim.accretionKnockedDownDuration < OW1_ACCERITION_MIN_DOWNTIME:
        victim.accretionKnockedDownDuration = OW1_ACCERITION_MIN_DOWNTIME
    victim.clearStatusEffect(Status.KNOCKED_DOWN)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, victim.accretionKnockedDownDuration)

rule "[sigma/init.opy]: Set sigma barrier cooldown":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, TICK_DURATION)