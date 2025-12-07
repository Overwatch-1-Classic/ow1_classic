#!mainFile "../../dev_main.opy"

rule "[symmetra/beam.opy]: set secondary fire speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isReloading()

    eventPlayer.setProjectileSpeed(24.853) # artillary based on
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setProjectileSpeed(100)

rule "[symmetra/beam.opy]: Correct Photon Projector damage":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(
        victim, 
        attacker, 
        ((OW1_SYMMETRA_PROJECTOR_DAMAGE/OW2_SYMMETRA_PROJECTOR_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)