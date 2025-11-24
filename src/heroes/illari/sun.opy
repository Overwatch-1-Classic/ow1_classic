#!mainFile "../../dev_main.opy"


rule "[illari/sun.opy]: Correct Captive Sun direct and splash hit damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility in [Button.ULTIMATE]
    @Condition eventDamage/eventPlayer._base_damage_scalar < (OW2_ILLARI_SUNSTRUCK_DAMAGE/2)

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[illari/sun.opy]: Solar powers funtional after ultimate":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingUltimate()

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(120)
    eventPlayer.setMoveSpeed(120)
    eventPlayer.setHealingDealt(120)

rule "[illari/sun.opy]: No more solar powers if dead":
    @Event playerDied
    @Hero illari

    eventPlayer.setDamageDealt(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setHealingDealt(100)