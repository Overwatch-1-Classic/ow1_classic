#!mainFile "../../dev_main.opy"

#!include "transc.opy"
#!include "discord.opy"
#!include "orb.opy"

def initZenyatta():
    @Name "[zenyatta/init.opy]: initZenyatta()"
    
    setCustomHp(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    setUltCost(OW1_ZENYATTA_ULT_COST)
    removeSelfHealing()
    
    eventPlayer.setProjectileSpeed(percent(OW1_ZENYATTA_ORB_SECONDARY_PROJECTILE_SPEED/OW2_ZENYATTA_ORB_SECONDARY_PROJECTILE_SPEED))
    eventPlayer.setKnockbackDealt(0)
    setBaseDamage(eventPlayer, OW1_ZENYATTA_ORB_DAMAGE/OW2_ZENYATTA_ORB_DAMAGE)
    
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)


rule "[zenyatta/init.opy]: OW1 Zenyatta melee damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == Button.MELEE

    heal(victim, null, eventDamage - (OW1_MELEE_DAMAGE/OW2_ZENYATTA_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))

rule "[zenyatta/init.opy]: OW1 Zenyatta secondary fire damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim, null, eventDamage - (OW1_ZENYATTA_ORB_DAMAGE_SECONDARY/OW2_ZENYATTA_ORB_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))

rule "[zenyatta/init.opy]: Fly in secondary fire!":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setGravity(4)
    eventPlayer.forceButtonPress(Button.JUMP)
    waitUntil(not eventPlayer.isFiringSecondaryFire())
    eventPlayer.setGravity(100)