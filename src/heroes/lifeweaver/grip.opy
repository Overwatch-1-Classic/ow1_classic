#!mainFile "../../dev_main.opy"

# Taken from: https://youtu.be/SWFOA14vMQM?si=WjCUs5oJNWAMFlzu&t=215 Btw, extremely buggy even if you arent aiming close to someone it still pulls anyway lol

playervar lifeweaver_grip
#!defineMember lifeweaver_pull lifeweaver_grip [0]
#!defineMember lifeweaver_effect lifeweaver_grip [1]


rule "[lifeweaver/grip.opy]: lifeweaver pull enemys":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isAlive()
    
    eventPlayer.lifeweaver_pull = eventPlayer.getPlayerClosestToReticle(Team.ALL)
    if not isInLoS(eventPlayer.lifeweaver_pull, eventPlayer):
        return
    createEffect(getAllPlayers(), Effect.SPHERE, Color.ROSE, eventPlayer.lifeweaver_pull, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.lifeweaver_effect = getLastCreatedEntity()
    eventPlayer.lifeweaver_pull.setGravity(0)
    eventPlayer.setMoveSpeed(50)
    while distance(eventPlayer, eventPlayer.lifeweaver_pull) >= 3:
        wait(0.1)
        eventPlayer.lifeweaver_pull.applyImpulse(directionTowards(eventPlayer.lifeweaver_pull, eventPlayer), 20, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        if not isInLoS(eventPlayer.lifeweaver_pull, eventPlayer):
            break
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_LIFEWEAVER_LIFEGRIP_COOLDOWN)
    destroyEffect(eventPlayer.lifeweaver_effect)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.lifeweaver_pull.setGravity(100)