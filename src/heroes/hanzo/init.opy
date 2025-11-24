#!mainFile "../../dev_main.opy"

#!include "scatter.opy"
#!include "dragon.opy"

playervar is_using_pin

def initHanzo():
    @Name "[hanzo/init.opy]: initHanzo()"
    
    setCustomHp(OW1_HANZO_HEALTH, 0, 0)
    setUltCost(OW1_HANZO_ULT_COST)
    removeSelfHealing()


# rule "[hanzo/init.opy]: Deal OW1 primary fire damage":
#     @Event playerDealtDamage
#     @Hero hanzo
#     @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1]

#     damage(victim, attacker, eventDamage*(OW1_HANZO_ARROW_DAMAGE/OW2_HANZO_ARROW_DAMAGE)-eventDamage)

rule "[hanzo/init.opy]: hanzo pin":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition not eventPlayer.is_using_pin
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isOnWall()
    
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    eventPlayer.disableEnvironmentCollision(true)
    waitUntil(not eventPlayer.isHoldingButton(Button.RELOAD), Math.INFINITY)
    eventPlayer.is_using_pin = true


rule "[hanzo/init.opy]: hanzo unpin":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.is_using_pin
    @Condition (eventPlayer.isDead() or eventPlayer.isHoldingButton(Button.RELOAD))
    
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.stopForcingPosition()
    waitUntil(not eventPlayer.isHoldingButton(Button.RELOAD ), Math.INFINITY)
    eventPlayer.is_using_pin = false