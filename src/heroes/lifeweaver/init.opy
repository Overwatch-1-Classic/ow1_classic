#!mainFile "../../dev_main.opy"

# Depcrecated code, lifeweaver is not included anymore

#!include "parting_gift.opy"
#!include "platform.opy"
#!include "tree.opy"

def initLifeweaver():
    @Name "[lifeweaver/init.opy]: initLifeweaver()"
    
    setCustomHp(OW1_LIFEWEAVER_HEALTH, 0, 0)
    setUltCost(OW1_LIFEWEAVER_ULT_COST)
    removePassiveHealing()

    eventPlayer.setProjectileSpeed(percent(OW1_LIFEWEAVER_THORN_VALLEY_PROJECTILE_SPEED/OW2_LIFEWEAVER_THORN_VALLEY_PROJECTILE_SPEED))
    setBaseDamage(eventPlayer, OW1_LIFEWEAVER_THORN_VALLEY_DAMAGE/OW2_LIFEWEAVER_THORN_VALLEY_DAMAGE)

    eventPlayer.setAmmo(0, OW1_LIFEWEAVER_CLIP_SIZE2)
    # eventPlayer.setMaxAmmo(0, OW1_LIFEWEAVER_CLIP_SIZE2)

rule "[lifeweaver/init.opy]: Healing blossom move penalty":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isFiringPrimaryFire()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW1_LIFEWEAVER_HEALING_BLOSSOM_MOVE_PENALTY))
    waitUntil((not eventPlayer.isFiringPrimaryFire()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW1_LIFEWEAVER_HEALING_BLOSSOM_MOVE_PENALTY))

# rule "[lifeweaver/init.opy]: Partially fix reload": # I personally dont like this approach cause its weird, buggy. And sadly due to Workshop Bugs, setMaxAmmo() is bugged on heroes like Lifeweaver 
    # @Event eachPlayer
    # @Hero lifeweaver
    # @Condition eventPlayer.getAmmo() <=  OW1_LIFEWEAVER_CLIP_SIZE2-1
    # @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    
    # eventPlayer.setAmmo(0, 0)
    # eventPlayer.forceButtonPress(Button.RELOAD)
    # waitUntil(not eventPlayer.isReloading())
    # eventPlayer.setAmmo(0, OW1_LIFEWEAVER_CLIP_SIZE2)