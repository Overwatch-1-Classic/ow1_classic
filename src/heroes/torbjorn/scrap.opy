#!mainFile "../../dev_main.opy"

playervar scrap_pvar
#!defineMember scrap scrap_pvar[0]
#!defineMember scrap_effect scrap_pvar[1]
#!defineMember scrap_collected scrap_pvar[2]
#!defineMember scrap_hud scrap_pvar[3]

playervar scrap_position

macro showScrapHUD():
    createProgressBarInWorldText(eventPlayer, 0.5 * eventPlayer.scrap, 
        "Scrap: {}/200".format(eventPlayer.scrap), 
        updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.7 * worldVector(Vector.RIGHT, 
        eventPlayer, 
        Transform.ROTATION) + (-1.5 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
        verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
        1, 
        Clip.NONE, 
        Color.ORANGE, 
        Color.WHITE, 
        ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, 
        SpecVisibility.DEFAULT)
    eventPlayer.scrap_hud = getLastCreatedText()

macro hideScrapHUD():
    destroyProgressBarInWorldText(eventPlayer.scrap_hud)
    eventPlayer.scrap_hud = null

macro initScrap():
    eventPlayer.scrap_position = vect(0, -500, 0)
    eventPlayer.scrap = 0

rule "[torbjorn/scrap.opy]: Collect scrap":
    @Event eachPlayer
    @Hero torbjorn
    # @Condition not eventPlayer.isDead()
    @Condition distance(eventPlayer.getPosition() + vect(0, 1, 0), ((sorted(getDeadPlayers(Team.ALL).exclude(eventPlayer), lambda i: distance(eventPlayer.getPosition() + vect(0, 1, 0), i.scrap_position)))[0]).scrap_position) < 1.5
    @Condition ((sorted(getDeadPlayers(Team.ALL).exclude(eventPlayer), lambda i: distance(eventPlayer.getPosition() + vect(0, 1, 0), i.scrap_position)))[0]).scrap_collected != true
    @Condition any([player.scrap_collected != true for player in getAllPlayers()])
    @Condition eventPlayer.scrap < OW1_TORBJORN_SCRAP_MAX
    @Condition len(getDeadPlayers(Team.ALL).exclude(eventPlayer)) > 0
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    ((sorted(getDeadPlayers(Team.ALL).exclude(eventPlayer), lambda i: distance(eventPlayer.getPosition() + vect(0, 1, 0), i.scrap_position)))[0]).scrap_collected = true
    eventPlayer.scrap += OW1_TORBJORN_SCRAP_PIECE


rule "[torbjorn/scrap.opy]: Collected scrap":
    @Event eachPlayer
    @Condition eventPlayer.scrap_collected
    
    destroyEffect(eventPlayer.scrap_effect)

rule "[torbjorn/scrap.opy]: Never negative scrap":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.scrap < 0
    
    eventPlayer.scrap = 0

rule "[torbjorn/scrap.opy]: Never overflow past scrap limit":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.scrap > OW1_TORBJORN_SCRAP_MAX
    
    do:
        eventPlayer.scrap = OW1_TORBJORN_SCRAP_MAX
        wait(0.1)
    while RULE_CONDITION

rule "[torbjorn/scrap.opy]: Accelerate scrap to torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.isDead()
    @Condition not eventPlayer.scrap_collected
    @Condition getPlayersOnHero(Hero.TORBJORN, Team.ALL) > 0
    @Condition (any([player.isAlive() and player.scrap < OW1_TORBJORN_SCRAP_MAX and player != eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < OW1_TORBJORN_SCRAP_RADIUS for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL)]))
    
    chase(eventPlayer.scrap_position, ((sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player.isAlive() and player.scrap < OW1_TORBJORN_SCRAP_MAX and player != eventPlayer], 
        lambda i: distance(eventPlayer.getPosition(), i.getPosition())))[0]).getPosition(), 
        rate=10, # 10 is acceleration speed 
        ChaseReeval.DESTINATION_AND_RATE)


rule "[torbjorn/scrap.opy]: De-accelerate scrap to torbjorn":
    @Event eachPlayer
    @Condition (not eventPlayer.scrap_collected or eventPlayer.isAlive())
    @Condition (any([player.isAlive() and player.scrap < OW1_TORBJORN_SCRAP_MAX and player != eventPlayer and distance(eventPlayer.getPosition(), 
        player.getPosition()) > OW1_TORBJORN_SCRAP_RADIUS for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL)]) or eventPlayer.isAlive())
    
    stopChasingVariable(eventPlayer.scrap_position)

rule "[torbjorn/scrap.opy]: Create soul orb if player dies":
    @Event eachPlayer
    @Condition isHeroBeingPlayed(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))
    @Condition eventPlayer.isDead()
    
    eventPlayer.scrap_position = eventPlayer.getPosition() + vect(0, 1, 0)
    createEffect(getPlayersOnHero(Hero.TORBJORN, Team.ALL), Effect.ORB, Color.ORANGE, eventPlayer.scrap_position, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scrap_effect = getLastCreatedEntity()
    eventPlayer.scrap_collected = false
    waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer.scrap_collected = true