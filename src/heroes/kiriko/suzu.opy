#!mainFile "../../dev_main.opy"


# This rule doesn't work due to workshop bug
# rule "[kiriko.opy]: Allow self healing during Suzu":
#     @Disabled
#     @Event eachPlayer
#     @Hero kiriko
#     @Condition eventPlayer.isUsingAbility2()

#     pushSelfHealing(Button.ABILITY_2)
#     waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
#     popSelfHealing(Button.ABILITY_2)

rule "[kiriko.opy]: Buff kiriko if using suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setDamageDealt(110)
    eventPlayer.setMoveSpeed(150)
    eventPlayer.setHealingReceived(110)
    waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setHealingReceived(100)