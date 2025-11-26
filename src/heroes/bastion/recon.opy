#!mainFile "../../dev_main.opy"

#!include "repair.opy"

# playervar bastion_charge

rule "[bastion/recon.opy]: Initialize recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form

    wait(TICK_DURATION, Wait.IGNORE_CONDITION) # small for sentry cast time to prevent conflicts
    eventPlayer.current_configuration = Configuration.RECON

    eventPlayer.stopFacing()
    eventPlayer.setMoveSpeed(100)
    setBaseDamage(eventPlayer, OW1_BASTION_RECON_GUN_DAMAGE/OW2_BASTION_RECON_GUN_DAMAGE)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    
    eventPlayer.setDamageReceived(100)

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setJumpEnabled(true)

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setKnockbackReceived(100)

# rule "[bastion/sentry.opy]: OW1 Bastion recon fire rate":
#     @Event eachPlayer
#     @Hero bastion
#     @Condition eventPlayer.isFiringPrimaryFire()

#     do:
#         eventPlayer.setProjectileSpeed(100)
#         wait(1/OW1_BASTION_RECON_GUN_FIRERATE)
#     while (RULE_CONDITION)


# rule "[bastion/recon.opy]: OW1 Bastion recon fire rate + recoil":
    # @Event eachPlayer
    # @Hero bastion
    # @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    # @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form
    # @Condition eventPlayer.getAmmo(0) > 0
    # @Condition not isCCd(eventPlayer)
    # @Condition (not eventPlayer.hasStatus(Status.ROOTED))
    # @Condition not isUsingSelfRepair(eventPlayer)
    # @Condition eventPlayer.isAlive()
    # @Condition not eventPlayer.isReloading()
    # @Condition not eventPlayer.isMeleeing()
    
    #stopChasingVariable(eventPlayer.bastion_charge)
    # eventPlayer.bastion_charge = min(eventPlayer.bastion_charge + 0.25, 3)
    # wait(OW1_BASTION_RECON_GUN_FIRERATE)
    # if not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    # and (not eventPlayer.isInAlternateForm())
    # and eventPlayer.getAmmo(0) > 0
    # and not isCCd(eventPlayer)
    # and not isUsingSelfRepair(eventPlayer)
    # and eventPlayer.isAlive()
    # and not eventPlayer.isReloading()
    # and not eventPlayer.isMeleeing()):
        # chase(eventPlayer.bastion_charge, 1, rate=6, ChaseReeval.NONE)
        # return
    # createProjectile(Projectile.ORB, 
        # eventPlayer, raycast(eventPlayer.getEyePosition(), 
        # eventPlayer.getEyePosition() + ((eventPlayer.getFacingDirection() * cosDeg(random.uniform(eventPlayer.bastion_charge * -1, eventPlayer.bastion_charge)) + (sinDeg(random.uniform(eventPlayer.bastion_charge * 
        # -1, eventPlayer.bastion_charge)) * (worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) * cosDeg(random.uniform(0, eventPlayer.bastion_charge * 100)) + crossProduct(eventPlayer.getFacingDirection(), worldVector(Vector.LEFT, 
        # eventPlayer, Transform.ROTATION)) * sinDeg(random.uniform(0, eventPlayer.bastion_charge * 100))))) * 100), getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition() - eventPlayer.getFacingDirection(), 
        # null, 
        # Relativity.TO_WORLD, 
        # ModifyHealth.DAMAGE, 
        # getOppositeTeam(eventPlayer.getTeam()), 
        # OW1_BASTION_RECON_GUN_DAMAGE+5, # +5 because when i use setBaseDamage() It makes the damage inaccurate 
        # 2, 
        # 0, 
        # DynamicEffect.BAD_EXPLOSION, 
        # DynamicEffect.EXPLOSION_SOUND, 
        # 0, 
        # Math.INFINITY, 
        # 5, 
        # 0, 
        # 0, 
        # 0)
    # eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) - 1))
    # wait(OW1_BASTION_RECON_GUN_FIRERATE)
    # if RULE_CONDITION:
        # goto RULE_START
    #chase(eventPlayer.bastion_charge, 1, rate=6, ChaseReeval.NONE)