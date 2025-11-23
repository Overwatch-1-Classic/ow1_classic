#!mainFile "../../dev_main.opy"

rule "[genji/dragonblade.opy]: Deal OW1 dragonblade damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE

    damage(victim, attacker, eventDamage*(OW1_GENJI_DRAGON_BLADE_DAMAGE/OW2_GENJI_DRAGON_BLADE_DAMAGE)-eventDamage)

rule "[genji/dragonblade.opy]: Slower firerate dragonblade":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_GENJI_DRAGON_BLADE_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    startFiring()

rule "[genji/blade.opy]: Set blade ammo":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate()
    
    wait(1, Wait.ABORT_WHEN_FALSE) # Need to have a delay
    eventPlayer.setAmmo(0, eventPlayer.dragonblade_ammo)

rule "[genji/blade.opy]: Get genji blade ammo":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.dragonblade_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingUltimate()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.dragonblade_ammo = eventPlayer.getAmmo(0)