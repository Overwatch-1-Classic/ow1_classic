#!mainFile "../../dev_main.opy"

playervar repair_pvar
#!defineMember self_repair_instance repair_pvar[3]
#!defineMember _self_repair_resource_gui repair_pvar[4]
#!defineMember _self_repair_sparkles_upper_gui repair_pvar[5]
#!defineMember _self_repair_sparkles_lower_gui repair_pvar[6]
#!defineMember _self_repair_ring_gui repair_pvar[7]
#!defineMember _self_repair_pvar repair_pvar[8]

macro isPressingSelfRepairButton(player):
    (player.isHoldingButton(Button.ABILITY_2)) or player.isHoldingButton(Button.SECONDARY_FIRE) # I know bastion's self-repair is ability 2, but its a nice qol to allow both buttons

macro isUsingSelfRepair(player):
    ((isPressingSelfRepairButton(player))
 and (not player.isFiringPrimaryFire())
 and (not player.isMeleeing())
 and (not isCCd(player))
 and (player.isAlive()))

# Remove repair resource vfx
macro hideSelfRepairResource():
    destroyProgressBarHud(eventPlayer._self_repair_resource_gui)
    eventPlayer._self_repair_resource_gui = null

# Remove repair sparks and ring vfx
macro hideSelfRepairRing():
    destroyEffect(eventPlayer._self_repair_sparkles_upper_gui)
    eventPlayer._self_repair_sparkles_upper_gui = null
    destroyEffect(eventPlayer._self_repair_sparkles_lower_gui)
    eventPlayer._self_repair_sparkles_lower_gui = null
    destroyEffect(eventPlayer._self_repair_ring_gui)
    eventPlayer._self_repair_ring_gui = null


rule "[bastion/repair.opy]: Activate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isUsingUltimate() # When casting, you can move right in tank
    @Condition isUsingSelfRepair(eventPlayer)
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isReloading()

    wait(0.15, Wait.ABORT_WHEN_FALSE) # Set this so you dont immediately use self repair  after untoggling it

    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    eventPlayer.setPrimaryFireEnabled(false)

    # repair sparks and ring vfx
    if eventPlayer._self_repair_sparkles_upper_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getEyePosition()), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_upper_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_sparkles_lower_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick((eventPlayer.getEyePosition()+eventPlayer.getPosition())/2), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_lower_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_ring_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.LIGHT_SHAFT, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getPosition()), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_ring_gui = getLastCreatedEntity()

    if eventPlayer.self_repair_instance == null:
        eventPlayer.startHoT(eventPlayer, Math.INFINITY, OW1_BASTION_SELF_REPAIR_HEALING_RATE)
        eventPlayer.self_repair_instance = getLastHoT()

rule "[bastion/repair.opy]: Deactivate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition isPressingSelfRepairButton(eventPlayer) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isUsingUltimate()

    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null

    hideSelfRepairRing()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        startFiring()

    if eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.setPrimaryFireEnabled(false)
        wait(OW1_BASTION_SENTRY_CONFIG_DELAY_TIME*2) # Firing delay
        eventPlayer.setPrimaryFireEnabled(true)
        startFiring()

rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer._missing_ult_points += eventHealing