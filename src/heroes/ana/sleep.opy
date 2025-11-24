#!mainFile "../../dev_main.opy"


rule "[ana/sleep.opy]: Sleep longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1

    waitUntil(not victim.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    victim.setStatusEffect(attacker, Status.ASLEEP, (OW1_ANA_SLEEP_DART_SLEEP_DURATION/OW2_ANA_SLEEP_DART_TANK_SLEEP_DURATION) * OW1_ANA_SLEEP_DART_SLEEP_DURATION)
