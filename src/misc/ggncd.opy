#!mainFile "../ggncd_main.opy"

# Gun Game No CD by Vassy, inspiration by: https://youtu.be/2YbGwKprEQw?si=UTABfITk9Z4nksiG 

#!define AFK_START 30

globalvar available_heroes_array 
globalvar next_match_description 
globalvar next_match_timer 
globalvar hard_reset_match 
globalvar winner 

playervar randomized_heroes_array 
playervar next_hero 
playervar hero_skips 
playervar kills 
playervar used_hero_skip 
playervar is_afk  

playervar hud_pvar
#!defineMember afk_first_hud_id hud_pvar[0]
#!defineMember afk_second_hud_id hud_pvar[1]
#!defineMember afk_third_hud_id hud_pvar[2]
#!defineMember skip_potg_hud_id hud_pvar[3]
#!defineMember hero_skips_hud_text hud_pvar[4]
playervar afk_timer 


macro afkDetection(player):
    not player.isHoldingButton(Button.JUMP)\
    not player.isHoldingButton(Button.CROUCH)\
    not player.isHoldingButton(Button.PRIMARY_FIRE)\
    not player.isHoldingButton(Button.SECONDARY_FIRE)\
    not player.isHoldingButton(Button.ABILITY_1)\
    not player.isHoldingButton(Button.ABILITY_2)\
    not player.isHoldingButton(Button.ULTIMATE)\
    not player.isHoldingButton(Button.INTERACT)\
    not player.isHoldingButton(Button.MELEE)\
    not player.isHoldingButton(Button.RELOAD)\
    not player.isCommunicatingAnything()\

rule "One hour match time":
    @Condition isGameInProgress()

    setMatchTime(Math.INFINITY)


rule "Build available heroes list":
    available_heroes_array = Hero.ANA
    available_heroes_array.append(Hero.ASHE)
    available_heroes_array.append(Hero.BAPTISTE)
    available_heroes_array.append(Hero.BASTION)
    available_heroes_array.append(Hero.BRIGITTE)
    available_heroes_array.append(Hero.CASSIDY)
    available_heroes_array.append(Hero.DVA)
    available_heroes_array.append(Hero.DOOMFIST)
    available_heroes_array.append(Hero.ECHO)
    available_heroes_array.append(Hero.GENJI)
    available_heroes_array.append(Hero.HANZO)
    available_heroes_array.append(Hero.ILLARI)
    available_heroes_array.append(Hero.JUNKER_QUEEN)
    available_heroes_array.append(Hero.JUNKRAT)
    available_heroes_array.append(Hero.KIRIKO)
    available_heroes_array.append(Hero.LIFEWEAVER)
    available_heroes_array.append(Hero.LUCIO)
    available_heroes_array.append(Hero.MEI)
    available_heroes_array.append(Hero.MERCY)
    available_heroes_array.append(Hero.MOIRA)
    available_heroes_array.append(Hero.ORISA)
    available_heroes_array.append(Hero.PHARAH)
    available_heroes_array.append(Hero.RAMATTRA)
    available_heroes_array.append(Hero.REAPER)
    available_heroes_array.append(Hero.REINHARDT)
    available_heroes_array.append(Hero.ROADHOG)
    available_heroes_array.append(Hero.SIGMA)
    available_heroes_array.append(Hero.SOJOURN)
    available_heroes_array.append(Hero.SOLDIER)
    available_heroes_array.append(Hero.SOMBRA)
    available_heroes_array.append(Hero.SYMMETRA)
    available_heroes_array.append(Hero.TORBJORN)
    available_heroes_array.append(Hero.TRACER)
    available_heroes_array.append(Hero.WIDOWMAKER)
    available_heroes_array.append(Hero.WINSTON)
    available_heroes_array.append(Hero.WRECKING_BALL)
    available_heroes_array.append(Hero.ZARYA)
    available_heroes_array.append(Hero.ZENYATTA)
    available_heroes_array.append(Hero.MAUGA)
    available_heroes_array.append(Hero.VENTURE)
    available_heroes_array.append(Hero.JUNO)
    available_heroes_array.append(Hero.HAZARD)
    available_heroes_array.append(Hero.FREJA)


rule "Build hero list for each player and initialize hero_skips":
    @Event eachPlayer
    
    eventPlayer.randomized_heroes_array = random.shuffle(available_heroes_array)
    eventPlayer.hero_skips = 1


rule "Initialize HUD for each player":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition not winner
    
    hudSubtext(eventPlayer, " ", HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(eventPlayer, null, "    Gain a hero skip every 15 kills", "   Crouch + interact to use a Hero Skip", HudPosition.LEFT, 1, Color.WHITE, Color.GREEN, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    # hudText(eventPlayer, null, "Discord", "https://bit.ly/ggnocd-d", HudPosition.LEFT, 2, Color.WHITE, Color.GREEN, Color.YELLOW, HudReeval.NONE)
    # hudSubtext(eventPlayer, "Crouch + interact to use a hero skip", HudPosition.LEFT, 0, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    # hudSubtext(eventPlayer, "Gain a hero skip every 15 kills", HudPosition.LEFT, 0, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.hero_skips_hud_text = l"{0}: {1}".format("Hero skips", eventPlayer.hero_skips)
    hudSubtext(eventPlayer, l"{0} {1} {2}".format(l"{0}: {1}".format("Heroes left", len(eventPlayer.randomized_heroes_array) - eventPlayer.getScore() - 1), "                            ", eventPlayer.hero_skips_hud_text), HudPosition.TOP, 1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)


rule "Gain score and advance desired hero when earning a kill":
    @Event playerDealtFinalBlow
    @Condition isGameInProgress()
    
    wait(0.25)
    attacker.addToScore(1)
    attacker.next_hero++
    attacker.kills++
    wait(0.25)


rule "If a player's actual hero differs from the player's desired hero, force the hero":
    @Event eachPlayer
    @Condition eventPlayer.getHero() != eventPlayer.randomized_heroes_array[eventPlayer.next_hero]
    @Condition len(eventPlayer.randomized_heroes_array) - eventPlayer.getScore() > 0
    @Condition not winner
    
    eventPlayer.startForcingHero(eventPlayer.randomized_heroes_array[eventPlayer.next_hero])
    wait(0.25+TICK_DURATION)
    eventPlayer.preloadHero(eventPlayer.randomized_heroes_array.slice(eventPlayer.next_hero + 1, 12))
    if ruleCondition:
        loop()


rule "Skip hero - Gain charge":
    @Event eachPlayer
    @Condition isGameInProgress() 
    @Condition eventPlayer.kills != 0
    @Condition not strContains(eventPlayer.kills / 15, ".")
    
    wait(0.25)
    eventPlayer.hero_skips++
    eventPlayer.hero_skips_hud_text = l"{0}: {1}".format("Hero skips", eventPlayer.hero_skips)


rule "Skip hero - Skip":
    @Event eachPlayer
    @Condition isGameInProgress() 
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) 
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) 
    @Condition eventPlayer.hero_skips > 0
    @Condition len(eventPlayer.randomized_heroes_array) - eventPlayer.getScore() > eventPlayer.hero_skips
    @Condition not winner
    
    eventPlayer.addToScore(1)
    eventPlayer.next_hero++
    eventPlayer.hero_skips--
    eventPlayer.used_hero_skip = true
    eventPlayer.hero_skips_hud_text = l"{0}: {1}".format("Hero skips", eventPlayer.hero_skips)
    wait(0.1)


rule "Skip hero - Destroy Hero Skips HUD when no longer available":
    @Event eachPlayer
    @Condition isGameInProgress() 
    @Condition len(eventPlayer.randomized_heroes_array) - eventPlayer.getScore() <= eventPlayer.hero_skips
    
    eventPlayer.hero_skips_hud_text = "                               "

rule "Declare winner, clear his pets, set camera, make everyone invisible, set next match timer and description, remove afk status":
    @Event eachPlayer
    @Condition isGameInProgress() 
    @Condition len(eventPlayer.randomized_heroes_array) - eventPlayer.getScore() == 0
    @Condition not winner
    
    disableGamemodeCompletion()
    getAllPlayers().disableScoreboard()
    getAllPlayers().disableTextChat()
    winner = eventPlayer
    next_match_description = "Play of the game in"
    next_match_timer = 7
    getAllPlayers().setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)
    eventPlayer.startForcingHero(eventPlayer.randomized_heroes_array[eventPlayer.getScore() - 2])
    eventPlayer.startForcingHero(eventPlayer.randomized_heroes_array[eventPlayer.getScore() - 1])
    getAllPlayers().exclude(eventPlayer).startForcingThrottle(0, 0, 0, 0, 0, 0)
    getAllPlayers().disallowButton(Button.PRIMARY_FIRE)
    getAllPlayers().disallowButton(Button.SECONDARY_FIRE)
    getAllPlayers().disallowButton(Button.ABILITY_1)
    getAllPlayers().disallowButton(Button.ABILITY_2)
    getAllPlayers().disallowButton(Button.ULTIMATE)
    getAllPlayers().disallowButton(Button.JUMP)
    getAllPlayers().disallowButton(Button.CROUCH)
    getAllPlayers().disallowButton(Button.MELEE)
    getAllPlayers().disallowButton(Button.RELOAD)
    getAllPlayers().startCamera(vect(0, 30, 50), vect(0, 20, 0))
    getAllPlayers().teleport(nearestWalkablePosition(vect(0, 0, 0)))
    getAllPlayers().exclude(eventPlayer).setInvisibility(Invis.ALL)
    getAllPlayers().is_afk = false


rule "Waiting for next match state - Player joined":
    @Event playerJoined
    @Condition isGameInProgress() 
    @Condition winner 
    
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHud()
    eventPlayer.disableKillFeed()
    eventPlayer.startCamera(vect(0, 30, 50), vect(0, 20, 0))
    wait(0.1)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.teleport(vect(0, 0, 0))
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)


rule "Waiting for next match state - Skip play of the game":
    @Event eachPlayer
    @Condition winner
    @Condition winner == eventPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition not hard_reset_match
    
    next_match_description = "Next match in"
    destroyHudText(eventPlayer.skip_potg_hud_id)
    hard_reset_match = true


rule "Waiting for next match state - HUD":
    @Condition winner
    
    destroyAllHudTexts()
    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableHeroHud()
    getAllPlayers().disableKillFeed()
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 12, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 13, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 14, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 15, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 16, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 17, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 18, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 19, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 20, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 21, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 22, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 23, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 24, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 25, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 26, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 27, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 28, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 29, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 30, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 31, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 32, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 33, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " ", HudPosition.TOP, 34, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(getAllPlayers(), l"{0}: {1}".format(next_match_description, next_match_timer), HudPosition.TOP, 35, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(winner, l"{0}: {1}".format("Skip play of the game", l"{0} {1} {2}".format(inputBindingString(Button.ULTIMATE), " + ", inputBindingString(Button.INTERACT))), HudPosition.TOP, 36, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    winner.skip_potg_hud_id = getLastCreatedText()
    if not winner.used_hero_skip:
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 12, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 13, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 14, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 15, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 16, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 17, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 18, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 19, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 20, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 21, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 22, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 23, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 24, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 25, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 26, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 27, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 28, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 29, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 30, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudSubtext(getAllPlayers(), " ", HudPosition.LEFT, 31, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudHeader(winner, l"{0}: {1}".format("Emote up", inputBindingString(Button.PRIMARY_FIRE)), HudPosition.LEFT, 33, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudHeader(winner, l"{0}: {1}".format("Emote down", inputBindingString(Button.SECONDARY_FIRE)), HudPosition.LEFT, 34, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudHeader(winner, l"{0}: {1}".format("Emote left", inputBindingString(Button.ABILITY_1)), HudPosition.LEFT, 35, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        hudHeader(winner, l"{0}: {1}".format("Emote right", inputBindingString(Button.ABILITY_2)), HudPosition.LEFT, 36, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "Waiting for next match state - Clear all players pets, enable scoreboard and text chat at the end of next match state":
    @Event eachPlayer
    @Condition winner 
    @Condition eventPlayer != winner
    
    wait(0.1)
    eventPlayer.randomized_heroes_array = eventPlayer.randomized_heroes_array.exclude(winner.getHero())
    eventPlayer.H = eventPlayer.getHero()
    if eventPlayer.getScore() == 0:
        wait()
        eventPlayer.startForcingHero(eventPlayer.randomized_heroes_array[eventPlayer.getScore() + 1])
    else:
        wait()
        eventPlayer.startForcingHero(eventPlayer.randomized_heroes_array[eventPlayer.getScore() - 1])
    eventPlayer.startForcingHero(winner.getHero())
    wait(next_match_timer)
    wait()
    eventPlayer.startForcingHero(eventPlayer.H)
    getAllPlayers().enableScoreboard()
    getAllPlayers().enableTextChat()


rule "Waiting for next match state - Victory stage if no hero skips are used":
    @Condition winner
    @Condition not winner.used_hero_skip
    
    if getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT:
        winner.startScalingSize(20)
        winner.startThrottleInDirection(vect(0, 0, -1), 1, Relativity.TO_WORLD)
        wait(0.25)
        winner.startThrottleInDirection(vect(0, 0, 1), 1, Relativity.TO_WORLD)
        wait(0.25)
        winner.stopThrottleInDirection()
        winner.startForcingThrottle(0, 0, 0, 0, 0, 0)
    createInWorldText(getAllPlayers(), winner, vect(0, 36.4, 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE)
    createInWorldText(getAllPlayers(), "WON WITHOUT USING ANY HERO SKIPS", vect(0, 35.3, 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    createBeam(getAllPlayers(), Beam.BAD, vect(-5.1, 33.8, 40), vect(5.1, 33.8, 40), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers(), Beam.BAD, vect(5.05, 33.845, 40), vect(5.05, 32.4, 40.25), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers(), Beam.BAD, vect(5.1, 32.36, 40.26), vect(-5.1, 32.36, 40.26), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers(), Beam.BAD, vect(-5.05, 32.4, 40.25), vect(-5.05, 33.845, 40), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Waiting for next match state - Hero dance (only on workshop island)":
    @Condition winner
    @Condition not winner.used_hero_skip
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT)
    
    winner.startFacing(vect(0, -1, 0), 1000)
    winner.startForcingButton(Button.CROUCH)
    wait(0.2)
    winner.startFacing(vect(0, 1, 0), 1000)
    winner.stopForcingButton(Button.CROUCH)
    wait(0.2)
    loop()


rule "Waiting for next match state - Victory stage if hero skips are used":
    @Condition winner 
    @Condition winner.used_hero_skip 
    
    winner.setInvisibility(Invis.ALL)
    createInWorldText(winner, "YOU WON!", vect(0, 36.4, 30), 
    3,  
    Clip.NONE, 
    WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
    Color.ORANGE)
    
    createInWorldText(getAllPlayers().exclude(winner), l"{0} {1}".format(winner, "WON!"), vect(0, 36.4, 30), 
    3, 
    Clip.NONE, 
    WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
    Color.ORANGE)


rule "Waiting for next match state - Next match timer":
    @Condition winner 
    @Condition next_match_timer != 0
    
    next_match_timer = next_match_timer - 1
    wait(1, Wait.ABORT_WHEN_FALSE)
    loop()


rule "Waiting for next match state - Emote up":
    @Event eachPlayer
    @Condition winner 
    @Condition winner == eventPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) 
    @Condition next_match_timer <= 5
    
    eventPlayer.communicate(Comms.EMOTE_UP)


rule "Waiting for next match state - Emote down":
    @Event eachPlayer
    @Condition winner 
    @Condition winner == eventPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) 
    @Condition next_match_timer <= 5
    
    eventPlayer.communicate(Comms.EMOTE_DOWN)


rule "Waiting for next match state - Emote left":
    @Event eachPlayer
    @Condition winner 
    @Condition winner == eventPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) 
    @Condition next_match_timer <= 5
    
    eventPlayer.communicate(Comms.EMOTE_LEFT)


rule "Waiting for next match state - Emote right":
    @Event eachPlayer
    @Condition winner 
    @Condition winner == eventPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition next_match_timer <= 5
    
    eventPlayer.communicate(Comms.EMOTE_RIGHT)


rule "Match ender":
    @Condition winner 
    @Condition next_match_timer <= 0
    
    if hard_reset_match:
        restartMatch()
    else:
        declarePlayerVictory(winner)


rule "AFK Enter":
    @Event eachPlayer
    @Condition isGameInProgress() 
    @Condition not eventPlayer.is_afk
    @Condition not eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition afkDetection(eventPlayer)
    @Condition len(getAllPlayers()) > 1
    @Condition not winner
    
    wait(10, Wait.ABORT_WHEN_FALSE)
    eventPlayer.is_afk = true
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)
    eventPlayer.startForcingThrottle(0, 0.008, 0, 0.008, 0, 0.008)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    hudHeader(eventPlayer, 
        "YOU ARE MARKED AS AFK", 
        HudPosition.TOP, 
        2, 
        Color.RED, 
        HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.afk_first_hud_id = getLastCreatedText()

    hudHeader(eventPlayer, l"{0} {1}".format("YOU WILL BE KICKED IN", l"{0} sec".format(eventPlayer.afk_timer)), 
        HudPosition.TOP, 
        2, 
        Color.RED, 
        HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.afk_second_hud_id = getLastCreatedText()

    eventPlayer.afk_timer = AFK_START


rule "AFK Exit":
    @Event eachPlayer
    @Condition eventPlayer.is_afk 
    @Condition (eventPlayer.getThrottle() != vect(0, 0, 0) or eventPlayer.isCommunicatingAnything()) 
    
    eventPlayer.is_afk = false
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.stopForcingThrottle()
    wait(0.112)
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    destroyHudText(eventPlayer.afk_first_hud_id)
    destroyHudText(eventPlayer.afk_second_hud_id)
    destroyHudText(eventPlayer.afk_third_hud_id)


rule "AFK Timer":
    @Event eachPlayer
    @Condition eventPlayer.is_afk 
    
    eventPlayer.afk_timer = eventPlayer.afk_timer - 1
    wait(1, Wait.ABORT_WHEN_FALSE)
    loop()


rule "AFK Kick":
    @Event eachPlayer
    @Condition eventPlayer.is_afk 
    
    wait(AFK_START, Wait.ABORT_WHEN_FALSE)
    eventPlayer.removeFromGame()