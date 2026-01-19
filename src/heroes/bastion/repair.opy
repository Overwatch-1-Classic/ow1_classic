#!mainFile "../../dev_main.opy"

playervar repair_pvar
#!defineMember self_repair_instance repair_pvar[1]
#!defineMember _self_repair_resource_gui repair_pvar[2]
#!defineMember _self_repair_sparkles_upper_gui repair_pvar[3]
#!defineMember _self_repair_sparkles_lower_gui repair_pvar[4]
#!defineMember _self_repair_ring_gui repair_pvar[5]
#!defineMember _is_using_self_repair repair_pvar[6]
#!defineMember _self_repair_cooldown repair_pvar[7]

macro isPressingSelfRepairButton(player):
    (player.isHoldingButton(Button.ABILITY_2)) \
 or player.isHoldingButton(Button.SECONDARY_FIRE) \

macro isUsingSelfRepair(player):
    ((isPressingSelfRepairButton(player))
 and (not player.isFiringPrimaryFire())
 and (not player.isFiringSecondaryFire())
 and (not player.isMeleeing())
 and (not isCCd(player))
 and (player.isAlive()))

# Remove repair detection
macro hideSelfRepair():
    eventPlayer._is_using_self_repair = false
    eventPlayer._self_repair_cooldown = 0

# Remove repair sparks and ring vfx
macro hideSelfRepairRing():
    destroyEffect(eventPlayer._self_repair_sparkles_upper_gui)
    eventPlayer._self_repair_sparkles_upper_gui = null
    destroyEffect(eventPlayer._self_repair_sparkles_lower_gui)
    eventPlayer._self_repair_sparkles_lower_gui = null
    destroyEffect(eventPlayer._self_repair_ring_gui)
    eventPlayer._self_repair_ring_gui = null

macro cancelSelfRepair():
    eventPlayer._is_using_self_repair = false
    hideSelfRepairRing()

rule "[bastion/repair.opy]: Activate self-repair + Deactive self repair":
    @Event eachPlayer
    @Hero bastion
    @Condition isUsingSelfRepair(eventPlayer)
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isUsingUltimate()
    @Condition eventPlayer._self_repair_cooldown == 0 # Custom ability timer.

    eventPlayer._is_using_self_repair = true

    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setReloadEnabled(false)

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

    if eventPlayer.isReloading():
        eventPlayer.cancelPrimaryAction()
    
    waitUntil(isCCd(eventPlayer) or not isPressingSelfRepairButton(eventPlayer) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), OW1_BASTION_MAX_SELF_REPAIR_DURATION) # Holding isPressingSelfRepairButton()
    waitUntil(isCCd(eventPlayer) or isPressingSelfRepairButton(eventPlayer) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), OW1_BASTION_MAX_SELF_REPAIR_DURATION) # Not holding isPressingSelfRepairButton()

    wait(0.1) # Doesn't instantly restart self-repair

    eventPlayer._is_using_self_repair = false

    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null

    hideSelfRepairRing()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        startFiring()

rule "[bastion/repair.opy]: Deactivate self-repair if player took damage":
    @Event playerTookDamage
    @Hero bastion
    @Condition eventPlayer._is_using_self_repair == true
    
    eventPlayer._is_using_self_repair = false

    eventPlayer.clearStatusEffect(Status.ROOTED)

    hideSelfRepairRing()
    eventPlayer._self_repair_cooldown = OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME # Custom timer
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME) # Visual self-repair cooldown

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)

    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null

    wait(OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME)
    eventPlayer._self_repair_cooldown = 0

rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer._missing_ult_points += eventHealing