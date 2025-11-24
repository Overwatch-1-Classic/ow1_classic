#!mainFile "../../dev_main.opy"


rule "[ramattra/nemesis.opy]: Disable Block during nemesis":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setSecondaryFireEnabled(false)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setSecondaryFireEnabled(true)

rule "[ramattra/nemesis.opy]: OW1 pummel damage":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, OW1_RAMATTRA_PUMMEL_DAMAGE/OW2_RAMATTRA_PUMMEL_DAMAGE*eventDamage - eventDamage)

rule "[ramattra/nemesis.opy]: Nemesis pull forward if firing primary":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isFiringPrimaryFire()

    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 30, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)