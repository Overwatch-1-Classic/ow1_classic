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

    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 1) # Temporary unkillable to prevent death during setup
    eventPlayer.setMaxHealth(100) # Keep this on for correct regenaration https://us.forums.blizzard.com/en/overwatch/t/shield-health-recharge/588713
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during rally
    eventPlayer.startHoT(null, Math.INFINITY, OW1_BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.rally_hot_id = getLastHoT()

def endRally():
    @Name "[brigitte/rally.opy]: endRally()"

    eventPlayer.stopScalingBarriers()

    eventPlayer.setMaxHealth(100) # Keep this on for correct regenaration https://us.forums.blizzard.com/en/overwatch/t/shield-health-recharge/588713
    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)