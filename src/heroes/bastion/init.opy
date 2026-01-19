#!mainFile "../../dev_main.opy"

#!include "configuration.opy"
#!include "repair.opy"
#!include "machine_gun.opy"


def initBastion():
    @Name "[bastion/init.opy]: initBastion()"
    
    setCustomHp(OW1_BASTION_HEALTH, OW1_BASTION_ARMOR, 0)
    setUltCost(OW1_BASTION_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BASTION_RECON_GUN_DAMAGE/OW2_BASTION_RECON_GUN_DAMAGE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.setAmmo(0, OW1_BASTION_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BASTION_CLIP_SIZE)

    reloadMachineGun()
    eventPlayer._is_using_self_repair = false

    # removeSelfHealing()

rule "[bastion/init.opy]: Clean up Bastion":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BASTION
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.BASTION, Math.INFINITY)
    hideMachineGunAmmo()
    hideSelfRepair()
    hideSelfRepairRing()