#!mainFile "../../dev_main.opy"


rule "[soldier/pulse_rifle.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)

rule "[soldier/pulse_rifle.opy]: Lower fire & partially remove upwards recoil":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingUltimate()

    do:
        eventPlayer.setPrimaryFireEnabled(false)
        wait(TICK_DURATION * 8)
        eventPlayer.setPrimaryFireEnabled(true)
        async(startFiring, AsyncBehavior.RESTART)
    while RULE_CONDITION

# Disabled cause it crashes very often