#!mainFile "../../dev_main.opy"

playervar overload_pvar
#!defineMember _torbjorn_overload_health overload_pvar [1]
#!defineMember _torbjorn_overload_armor overload_pvar [2]
#!defineMember _torbjorn_health_before_overload overload_pvar[3]
#!defineMember _torbjorn_armour_before_overload overload_pvar[4]

subroutine startOverload
subroutine endOverload

rule "[torbjorn/overload.opy]: Set overload":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.isAlive() # Not use if dead
    @Condition not isCCd(eventPlayer)

    eventPlayer._torbjorn_health_before_overload = eventPlayer.getHealthOfType(Health.NORMAL) and eventPlayer.getHealthOfType(Health.ARMOR)
    eventPlayer._torbjorn_armour_before_overload = eventPlayer.getHealthOfType(Health.ARMOR)
    startOverload()
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    endOverload()

def startOverload():
    @Name "[torbjorn/overload.opy]: startOverload()"

    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setHealth(eventPlayer._torbjorn_health_before_overload + eventPlayer._torbjorn_armour_before_overload)
    # damage(eventPlayer, null, eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR) > 0) 

    eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_ARMOR, false, false) # Apply Overload healthpool
    eventPlayer._torbjorn_overload_health = getLastCreatedHealthPool()
    eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_HEALTH, true, false) # Apply Overload healthpool
    eventPlayer._torbjorn_overload_armor = getLastCreatedHealthPool()

def endOverload():
    @Name "[torbjorn/overload.opy]: endOverload()"

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.setUltCharge(0)
    removeHealthPool(eventPlayer._torbjorn_overload_health)
    removeHealthPool(eventPlayer._torbjorn_overload_armor)