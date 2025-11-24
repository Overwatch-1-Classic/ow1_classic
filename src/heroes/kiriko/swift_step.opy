#!mainFile "../../dev_main.opy"

rule "[kiriko/swift_step.opy]: Buff kiriko if using swift step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setDamageDealt(110)
    eventPlayer.setMoveSpeed(150)
    eventPlayer.setHealingReceived(110)
    wait(1)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setHealingReceived(100)