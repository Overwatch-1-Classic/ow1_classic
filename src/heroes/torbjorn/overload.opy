#!mainFile "../../dev_main.opy"

# Temporary comprimise for the time being

playervar overload_pvar
#!defineMember _overload_enabled overload_pvar [0]
#!defineMember _torbjorn_hp overload_pvar [1]
#!defineMember _torbjorn_overload_health overload_pvar [2]
#!defineMember _torbjorn_overload_armor overload_pvar [3]

subroutine startOverload
subroutine endOverload

rule "[torbjorn/overload.opy]: Set overload":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.isAlive() # Not use if dead

    startOverload()
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    endOverload()

def startOverload():
    @Name "[torbjorn/overload.opy]: startOverload()"

    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.disallowButton(Button.ABILITY_2)

    damage(eventPlayer, null, OW2_TORBJORN_OVERLOAD_EXTRA_HEALTH - 31) # 31 being inaccurate health, remove overload extra health

    #eventPlayer.setMaxHealth(percent(OW1_TORBJORN_TURRET_HEALTH_ULTIMATE/OW1_TORBJORN_TURRET_HEALTH))

    # wait() # Do not remove?? this wont reset the hp if you dont remove it for SOME reason
    # setCustomHp(OW1_TORBJORN_HEALTH, 0, 0)

    eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_ARMOR, false, false) # Apply Overload healthpool
    eventPlayer._torbjorn_overload_health = getLastCreatedHealthPool()
    eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_HEALTH, true, false) # Apply Overload healthpool
    eventPlayer._torbjorn_overload_armor = getLastCreatedHealthPool()

    eventPlayer._overload_enabled = true

def endOverload():
    @Name "[torbjorn/overload.opy]: endOverload()"

    # eventPlayer.setMaxHealth(100)
    # wait() # Do not remove?? this wont reset the hp if you dont remove it for SOME reason
    # eventPlayer._torbjorn_hp = eventPlayer.getHealthOfType(Health.NORMAL)
    # setCustomHp(OW1_TORBJORN_HEALTH, 0, 0)
    # eventPlayer.setHealth(min(OW1_TORBJORN_HEALTH, eventPlayer._torbjorn_hp))

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.setUltCharge(0)
    removeHealthPool(eventPlayer._torbjorn_overload_health)
    removeHealthPool(eventPlayer._torbjorn_overload_armor)

    eventPlayer._overload_enabled = false

# rule "[torbjorn/overload.opy]: Reset if Torbjorn died":
    # @Event playerDied
    # @Hero torbjorn
    # @Condition eventPlayer._overload_enabled

    # waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    # endOverload()