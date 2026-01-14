#!mainFile "../../dev_main.opy"

globalvar LUCIO_CROSSFADE = createWorkshopSetting(bool, "Lucio", "30M Crossfade", true)

playervar crossfade_pvar 
#!defineMember crossfade_aura crossfade_pvar[0]
#!defineMember crossfade_enabled crossfade_pvar[1]
#!defineMember crossfade_default crossfade_pvar[2]

#!defineMember crossfade_targets crossfade_pvar[3]

#!defineMember crossfade_target_temporary crossfade_pvar[4]
#!defineMember crossfade_grace_temporary crossfade_pvar[5]

#!defineMember crossfade_grace crossfade_pvar[6]
#!defineMember crossfade_area_text crossfade_pvar[7]
#!defineMember crossfade_effects crossfade_pvar[8]
playervar cross_fade_index 

/*
# Code by Spiderman31807 https://workshop.codes/APTH1
# Recoded in overpy by viper & thanks for Spiderman31807 for coding this crossfade code!

Index 0 Mode  values of `Healing` or `Speed` [string]
Index 1 Enabled values of `true` or `false` [boolean]
Index 2 Preference values of `Toggle`, `Default Healing` & `Default Speed` [string]
Index 3 Targets collection of players [array]
Index 4 TargetsTEMP collection of players [array]
Index 5 GraceTEMP collection of numbers [array]
Index 6 Grace collection of numbers [array]

Mode if value is `Healing` then it heals the players inside `Targets` if the value is `Speed` then it increases the speed of players inside `Targets` (value is case sensitive)
Enabled used only by a hack status detection script that disables the whole system when its set to `false`
Preference If the value is `Toggle` then it swaps between the two `Mode` values when the input is pressed, if the value is `Default Healing` then it'll change `Mode` to `Speed` when the input is pressed and `Healing` when it is not pressed.. then `Default Speed` is obviously just the opposite of `Default Healing` (value is case sensitive)
Targets this is the list of players that'll obtain the `Mode` effects when the crossfade has `Enabled` as `true`
TargetsTEMP this is the temp array of targets that builds the `Targets` array without modifying the `Targets` array until its finished.
Grace: this is how long the player has (in seconds) before their effects from the crossfade will turn off once they leave the area of effect, in the basegame there is a grace of a single second which is mimicked over to this.. players inside the `Targets` array will not be removed until their linked `Grace` (linked on index of couse) has reached 0
GraceTEMP this is the temp of grace values it builds before updating the main one used elsewhere, it uses the `TargetsTEMP` to choose weather to set the value to 1 or decrease it by 0.1 (the interval of updates for the targeting)
*/

macro initCrossfade():
        eventPlayer.crossfade_pvar = ["Speed", true, "Toggle", [], [], []]
        lbl_0:
        createEffect([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer.crossfade_enabled], 
        Effect.RING, 
        Color.GREEN if eventPlayer.crossfade_aura == "Speed" else Color.YELLOW, 
        updateEveryTick(eventPlayer.getPosition()), 
        OW1_LUCIO_CROSSFADE_RADIUS, 
        EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        eventPlayer.crossfade_effects = getLastCreatedEntity()

        eventPlayer.crossfade_aura = "Healing"
        waitUntil(eventPlayer.isInAlternateForm(), Math.INFINITY)
        eventPlayer.crossfade_aura = "Speed"

macro showCrossfadeAreaText():
        createInWorldText(eventPlayer, "{}".format(len([i for i in localPlayer.crossfade_targets if i.isAlive()].exclude(localPlayer))), 
            updateEveryTick(localPlayer.getEyePosition() + (150 * (0 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + (-0.3 * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), 
            verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 
            2, 
            Clip.NONE, 
            WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
            Color.WHITE, 
            SpecVisibility.DEFAULT)
    eventPlayer.crossfade_area_text = getLastCreatedText()

macro hideCrossfadeAreaText():
    destroyInWorldText(eventPlayer.crossfade_area_text)
    eventPlayer.crossfade_area_text = null
    destroyEffect(eventPlayer.crossfade_effects)
    eventPlayer.crossfade_effects = null

rule "[lucio/aura.opy]: Detect crossfade target":
    @Event eachPlayer
    @Condition eventPlayer.crossfade_enabled
    
    do:
        eventPlayer.crossfade_target_temporary = getPlayersInRadius(eventPlayer, OW1_LUCIO_CROSSFADE_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
        eventPlayer.crossfade_targets.append([i for i in eventPlayer.crossfade_target_temporary if not i in eventPlayer.crossfade_targets])
        eventPlayer.crossfade_grace_temporary = []
        for eventPlayer.cross_fade_index in range(len(eventPlayer.crossfade_targets)):
            if eventPlayer.crossfade_targets[eventPlayer.cross_fade_index] in eventPlayer.crossfade_target_temporary:
                eventPlayer.crossfade_grace_temporary.append(1)
            else:
                eventPlayer.crossfade_grace_temporary.append(eventPlayer.crossfade_grace[eventPlayer.cross_fade_index] - 0.1)
        eventPlayer.crossfade_grace = eventPlayer.crossfade_grace_temporary
        eventPlayer.crossfade_targets.remove([_ for _, i in eventPlayer.crossfade_targets if eventPlayer.crossfade_grace[i] <= 0])
        eventPlayer.crossfade_grace.remove([i for i in eventPlayer.crossfade_grace if i <= 0])
        wait(0.1) # Update every 0.1 so it doesnt take too much load in the workshop
    while RULE_CONDITION


rule "[lucio/aura.opy]: Set crossfade speed":
    @Event eachPlayer
    @Condition (any([eventPlayer in player.crossfade_targets and player.crossfade_aura == "Speed" and player.crossfade_enabled for player in getPlayers(eventPlayer.getTeam())]))
    @Condition not isHeroBeingPlayed(Hero.LUCIO, eventPlayer.getTeam()) == eventPlayer.isUsingAbility2()
    
    eventPlayer.setMoveSpeed(percent(OW1_LUCIO_CROSSFADE_SPEED))
    waitUntil(all([not eventPlayer in player.crossfade_targets or player.crossfade_aura != "Speed" or player.crossfade_enabled == false for player in getPlayers(eventPlayer.getTeam())]), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)


rule "[lucio/aura.opy]: Set crossfade healing":
    @Event eachPlayer
    @Condition (any([eventPlayer in player.crossfade_targets and player.crossfade_aura == "Healing" and player.crossfade_enabled for player in getPlayers(eventPlayer.getTeam())]))
    
    while any([eventPlayer in player.crossfade_targets and player.crossfade_aura == "Healing" and player.crossfade_enabled for player in getPlayers(eventPlayer.getTeam())]):
        if (([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer in player.crossfade_targets and player.crossfade_aura == "Healing" and player.crossfade_enabled])[0]) == eventPlayer and ((len([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer in player.crossfade_targets and player.crossfade_aura == "Healing" and player.crossfade_enabled])) == 1):
            heal(eventPlayer, eventPlayer, 1)
        else:
            heal(eventPlayer, [player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer in player.crossfade_targets and player.crossfade_aura == "Healing" and player.crossfade_enabled], 1.6)
        wait(0.1) # Update every 0.1 so it doesnt take too much load in the workshop

rule "[lucio/aura.opy]: Disable crossfade if nearby lucio":
    @Event eachPlayer
    @Condition entityExists(getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam())[0])
    @Condition eventPlayer.isInAlternateForm()
    @Condition distance(eventPlayer, sorted(getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam()), lambda player: distance(eventPlayer.getEyePosition(), player.getEyePosition()))[0]) < OW2_LUCIO_CROSSFADE_RADIUS
    @Condition isInLoS(eventPlayer.getEyePosition(), sorted(getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam()), lambda player: distance(eventPlayer, player))[0].getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
    @Condition not isHeroBeingPlayed(Hero.LUCIO, eventPlayer.getTeam()) == eventPlayer.isUsingAbility2()
    
    do:
        eventPlayer.setMoveSpeed(percent(OW1_LUCIO_CROSSFADE_SPEED/OW2_LUCIO_CROSSFADE_SPEED))
        wait(0.1) # Update every 0.1 so it doesnt take too much load in the workshop
    while RULE_CONDITION


rule "[lucio/aura.opy]: set correct toggle":
    @Event eachPlayer
    @Hero lucio
    @Condition LUCIO_CROSSFADE
    @Condition not eventPlayer.isInAlternateForm()
    
    eventPlayer.crossfade_aura = "Healing"
    waitUntil(eventPlayer.isInAlternateForm(), Math.INFINITY)
    eventPlayer.crossfade_aura = "Speed"


rule "[lucio/aura.opy]: set correct amp speed":
    @Event eachPlayer
    @Hero lucio
    @Condition LUCIO_CROSSFADE
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isUsingAbility2()

    do:
        eventPlayer.setMoveSpeed(percent(OW1_LUCIO_AMP_SPEED/OW2_LUCIO_AMP_SPEED))
        wait(TICK_DURATION)
    while RULE_CONDITION