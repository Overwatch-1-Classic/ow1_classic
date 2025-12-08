#!mainFile "../../dev_main.opy"

rule "[primal/init.opy]: Primal Rage health":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()

    clearCustomHp() # No bugged healthpool
    setCustomHp(OW1_WINSTON_PRIMAL_HEALTH, OW1_WINSTON_PRIMAL_ARMOR, 0)
    heal(eventPlayer, null, OW1_WINSTON_PRIMAL_HEALTH + OW1_WINSTON_PRIMAL_ARMOR)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    clearCustomHp() # No bugged healthpool
    setCustomHp(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)

rule "[winston/primal.opy]: Primal damage":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(
        victim, 
        attacker, 
        ((OW1_WINSTON_PRIMAL_DAMAGE/OW2_WINSTON_PRIMAL_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)

# rule "[winston/primal.opy]: set primal ammo":
    # @Event eachPlayer
    # @Hero winston
    # @Condition eventPlayer.isUsingUltimate()
    
    # wait(1, Wait.ABORT_WHEN_FALSE)
    # eventPlayer.setAmmo(0, eventPlayer.primal_ammo)
    # waitUntil((not eventPlayer.isUsingUltimate()), Math.INFINITY)

# rule "[winston/primal.opy]: get primal ammo":
    # @Event eachPlayer
    # @Hero winston
    # @Condition eventPlayer.primal_ammo != eventPlayer.getAmmo(0)
    # @Condition not eventPlayer.isUsingUltimate()
    
    # wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    # eventPlayer.primal_ammo = eventPlayer.getAmmo(0)

# Bugged