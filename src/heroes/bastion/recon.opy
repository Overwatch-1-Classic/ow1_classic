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
    # setBaseDamage(eventPlayer, OW1_BASTION_RECON_GUN_DAMAGE/OW2_BASTION_RECON_GUN_DAMAGE)
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