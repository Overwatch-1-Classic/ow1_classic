#!mainFile "../../dev_main.opy"

rule "[reinhardt/earthshatter.opy]: Correct Earthstatter crit damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventWasCriticalHit


    heal(victim, null, OW2_REINHARDT_EARTHSHATTER_BONUS_DAMAGE - OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE)
    # heal(victim, null, eventDamage)
    # damage(
        # victim, 
        # attacker, 
        # ((OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE/OW2_REINHARDT_EARTHSHATTER_BASE_DAMAGE) \
        # * (eventDamage/eventPlayer._base_damage_scalar) \
        # - eventDamage)/eventPlayer._base_damage_scalar)

rule "[reinhardt/earthshatter.opy]: Correct Earthstatter damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE

    damage(
        victim, 
        attacker, 
        ((OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE/OW2_REINHARDT_EARTHSHATTER_BASE_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)

rule "[reinhardt/shatter.opy]: OW1 earthshatter knock down duration":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition victim.hasStatusEffect(Status.KNOCKED_DOWN)

    wait(OW1_REINHARDT_EARTHSHATTER_KNOCK_DOWN_DURATION)
    victim.clearStatusEffect(Status.KNOCKED_DOWN)

rule "[reinhardt/earthshatter.opy]: Piledriver":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.setGravity(200)
    eventPlayer.applyImpulse(Vector.DOWN, 98, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setGravity(100)