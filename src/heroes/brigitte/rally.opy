#!mainFile "../../dev_main.opy"

# Temporary comprimise for the time being

playervar rally_pvar
#!defineMember _brig_detect_rally rally_pvar [0]
#!defineMember _brig_hp rally_pvar [1]
#!defineMember _brig_armor rally_pvar [2]
#!defineMember _brig_barrier_hp rally_pvar [3]
#!defineMember _brig_rally_armour rally_pvar [4]
#!defineMember rally_hot_id rally_pvar [5]

subroutine startRally
subroutine endRally

rule "[brigitte/rally.opy]: rally start":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    startRally()
    waitUntil(not eventPlayer.isUsingUltimate(), OW1_BRIGITTE_RALLY_DURATION)
    endRally()

def startRally():
    @Name "[brigitte/rally.opy]: startRally()"

    # eventPlayer._brig_detect_rally = true

    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 1) # Temporary unkillable to prevent death during setup

    # eventPlayer._brig_barrier_hp = 0.1
    # eventPlayer.setMaxHealth(eventPlayer._brig_barrier_hp) # 604 is the least amount i could do, sorry i tried.

    eventPlayer.setMaxHealth(500) # Set barrier to 700
    eventPlayer.setMaxHealth(100) # Keep this on for correct regenaration https://us.forums.blizzard.com/en/overwatch/t/shield-health-recharge/588713

    eventPlayer.startScalingBarriers(0.75, false) # Set brig barrier scale

    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during rally

    eventPlayer.addHealthPool(Health.ARMOR, OW1_BRIGITTE_ARMOR, true, true)
    eventPlayer._brig_rally_armour = getLastCreatedHealthPool()

    # setCustomHp(OW1_BRIGITTE_RALLY_HEALTH, OW1_BRIGITTE_RALLY_ARMOR, 0)

    # damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR) # Remove Rally instant armor

    eventPlayer.startHoT(null, Math.INFINITY, OW1_BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.rally_hot_id = getLastHoT()

def endRally():
    @Name "[brigitte/rally.opy]: endRally()"

    eventPlayer.stopScalingBarriers()

    # eventPlayer._brig_hp = eventPlayer.getHealthOfType(Health.NORMAL)
    # eventPlayer._brig_armor = eventPlayer.getHealthOfType(Health.ARMOR)
    eventPlayer.setMaxHealth(100) # Keep this on for correct regenaration https://us.forums.blizzard.com/en/overwatch/t/shield-health-recharge/588713
    # setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    # eventPlayer.setHealth(min(OW1_BRIGITTE_HEALTH, eventPlayer._brig_hp) + eventPlayer._brig_armor)

    removeHealthPool(eventPlayer._brig_rally_armour)

    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)

    eventPlayer._brig_detect_rally = false

# rule "[brigitte/rally.opy]: Reset rally if player died":
    # @Event playerDied
    # @Condition eventPlayer._brig_detect_rally

    # waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    # endRally()