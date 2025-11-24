#!mainFile "../../dev_main.opy"

#!include "hp.opy"
#!include "gun.opy"
#!include "booster.opy"
# !include "micro_missiles.opy"
#!include "bomb.opy"
#!include "matrix.opy"
#!include "remech.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"
    
    setUltCost(OW1_DVA_ULT_COST)
    # removeTankPassive()
    removeSelfHealing()

    eventPlayer.startScalingSize(0.5, true)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbility2Enabled(false)

    eventPlayer.setProjectileSpeed(200) # Compensation due to overwatch being bad and cant increase firerate
    eventPlayer.setDamageDealt(200) # Compensation due to overwatch being bad and cant increase firerate

    # waitUntil(not eventPlayer.isInAlternateForm(), Math.INFINITY)
    # setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)

    # setBaseDamage(eventPlayer, OW1_DVA_MICRO_MISSILES_DAMAGE/OW2_DVA_MICRO_MISSILES_DAMAGE)

rule "[dva/init.opy]: Even smaller dva in pilot":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    eventPlayer.startScalingSize(0.5, true)
    eventPlayer.setProjectileSpeed(200) # Compensation due to overwatch being bad and cant increase firerate

rule "[dva/init.opy]: DVa pistol damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, 14 - 10.5)


# rule "[dva/init.opy]: Compensate D.Va global damage reduction":
#     @Event playerDealtDamage
#     @Hero dva
#     @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]

#     damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)