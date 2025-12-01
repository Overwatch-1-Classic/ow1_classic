#!mainFile "../../dev_main.opy"

playervar beam_visibility

playervar beam_multiplier_dmg

playervar beam_effects
#!defineMember beam_effect beam_effects [0]
#!defineMember beam_effect1 beam_effects [1]
#!defineMember beam_effect2 beam_effects [2]
#!defineMember photon_projector_hud_effect beam_effects [3]

subroutine showPhotonProjecterBeam
subroutine hidePhotonProjector

subroutine showPhotonProjecterHUD

rule "[symmetra/beam.opy]: set sym primary fire":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isMeleeing()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not eventPlayer.isReloading()
    @Condition not isCCd(eventPlayer)
    
    do:
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) - 1)
        damage((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.hasSpawned() and isInLoS(eventPlayer.getEyePosition(), player.getEyePosition(), 
        BarrierLos.PASS_THROUGH_BARRIERS) and eventPlayer.isInViewAngle(player.getEyePosition(), 60) and distance(eventPlayer.getEyePosition(), player.getEyePosition()) < 5], 
        lambda i: distance(eventPlayer.getEyePosition(), 
        i.getEyePosition())))[0], 
        eventPlayer, 
        floor(eventPlayer.beam_multiplier_dmg) * OW1_SYMETTRA_BEAM_DAMAGE)
        wait(OW1_SYMETRA_BEAM_INCREASE_PS)
    while RULE_CONDITION

rule "[symmetra/beam.opy]: make beam visible":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isMeleeing()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not eventPlayer.isReloading()
    
    eventPlayer.beam_visibility = getAllPlayers()

rule "[symmetra/beam.opy]: make beam not visible":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isReloading() or eventPlayer.isFiringSecondaryFire() or not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isMeleeing()
    
    eventPlayer.beam_visibility = null

rule "[symmetra/beam.opy]: beam multiplier start":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility != Button.SECONDARY_FIRE
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.MELEE
    
    stopChasingVariable(eventPlayer.beam_multiplier_dmg)
    eventPlayer.beam_multiplier_dmg += OW1_SYMETRA_BEAM_INCREASE
    wait(OW1_SYMETRA_BEAM_INCREASE_PS, Wait.RESTART_WHEN_TRUE)
    chase(eventPlayer.beam_multiplier_dmg, 1, rate=OW1_SYMETTRA_BEAM_RATE, ChaseReeval.DESTINATION_AND_RATE)

rule "[symmetra/beam.opy]: symmetra multipier correction":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.beam_multiplier_dmg >= OW1_SYMETTRA_MAX_LEVEL
    
    eventPlayer.beam_multiplier_dmg = 3.9

rule "[symmetra/beam.opy]: set secondary fire speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isReloading()

    eventPlayer.setProjectileSpeed(24.853) # artillary based on
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setProjectileSpeed(100)

def showPhotonProjecterBeam():
    @Name "[symmetra/beam.opy]: showPhotonProjecterBeam()"

    createBeam(eventPlayer.beam_visibility, Beam.BAD, updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + worldVector(Vector.RIGHT,  
        eventPlayer, Transform.ROTATION) * 0.28 + normalize(crossProduct(eventPlayer.getFacingDirection(), 
        worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION))) * 0.19), 
        (((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasSpawned() and eventPlayer.isInViewAngle(player.getEyePosition(), 60)], lambda i: 
        distance(eventPlayer.getEyePosition(), 
        i.getEyePosition())))[0]).getEyePosition()) + vect(0, -0.3, 0) 
        if entityExists((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.hasSpawned() and isInLoS(eventPlayer.getEyePosition(), 
        player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) and eventPlayer.isInViewAngle(player.getEyePosition(), 60) and distance(eventPlayer.getEyePosition(),
        player.getEyePosition()) < 5], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]) else updateEveryTick(raycast(eventPlayer.getEyePosition(), 
        eventPlayer.getEyePosition() + 3 * eventPlayer.getFacingDirection(), null, null, false).getHitPosition()), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.beam_effect = getLastCreatedEntity()

    createEffect(eventPlayer.beam_visibility, Effect.ENERGY_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.beam_effect1 = getLastCreatedEntity()

    eventPlayer.beam_multiplier_dmg = 1

def hidePhotonProjector():
    @Name "[symmetra/beam.opy]: hidePhotonProjector()"

    destroyEffect(eventPlayer.beam_effect)
    eventPlayer.beam_effect = null

    destroyEffect(eventPlayer.beam_effect1)
    eventPlayer.beam_effect1 = null

    destroyEffect(eventPlayer.photon_projector_hud_effect)
    eventPlayer.photon_projector_hud_effect = null

rule "[symmetra/beam.opy]: Correct Photon Projector damage":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(
        victim, 
        attacker, 
        ((OW1_SYMMETRA_PROJECTOR_DAMAGE/OW2_SYMMETRA_PROJECTOR_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)

def showPhotonProjecterHUD():
    @Name "[symmetra/beam.opy]: showPhotonProjecterHUD()"

    createInWorldText([player for player in getPlayersOnHero(Hero.SYMMETRA, Team.ALL) if localPlayer.isAlive()], 
    "[{}]".format(floor(localPlayer.beam_multiplier_dmg)), updateEveryTick(localPlayer.getEyePosition() + (150 * (1.3 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + (-0.5 * 
    (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 
    2, 
    Clip.NONE, 
    WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
    Color.WHITE, 
    SpecVisibility.DEFAULT)

    eventPlayer.photon_projector_hud_effect = getLastCreatedEntity()