#!mainFile "../../dev_main.opy"

# This code was made by: Spiderman31807 & Dark
# https://workshop.codes/C9WF3 & https://workshop.codes/PBMYC (Overwatch 1 Emulator)

playervar defense_pvar
#!defineMember defense_health defense_pvar[0]
#!defineMember defense_shields defense_pvar[1]
#!defineMember current_health defense_pvar[2]
#!defineMember decay_timer  defense_pvar[3]


macro  doomfistStoredShields():
    eventPlayer.current_health = eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.SHIELDS)

macro doomfistBestDefenseShields():
    attacker.setHealth(eventPlayer.defense_health) # Overwrite OW2 Best defense 
    attacker.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH - victim.getHealth(), 
        attacker.defense_shields + OW1_DOOMFIST_BEST_DEFENSE), false, false) # OW1 Best defense shields

rule "[doomfist/defense.opy]: Track Doom Health for Best Defense":
    @Event eachPlayer
    @Hero doomfist
    
    eventPlayer.defense_health = eventPlayer.getHealthOfType(Health.NORMAL)
    wait()
    loop()

rule "[doomfist/defense.opy]: Add Best defense health":
    @Event playerDealtDamage
    @Hero doomfist
    # @Condition victim != attacker
    @Condition any([eventAbility == i for i in [Button.SECONDARY_FIRE, Button.ULTIMATE, Button.ABILITY_1]])

    if eventPlayer.getHealthOfType(Health.SHIELDS) > eventPlayer.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH: # Correct overhealth if over max shields limit
        removeHealthPool(getLastCreatedHealthPool())
        eventPlayer.addHealthPool(Health.SHIELDS, OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH, false, false)
        return

rule "[doomfist/defense.opy]: Decay best defense shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS)

    do:
        if eventPlayer.decay_timer == 0:
            damage(eventPlayer, null, OW1_DOOMFIST_BEST_DEFENSE_DECAY_TIMER) # Make self damage so
            # eventPlayer.setHealth(eventPlayer.getHealth() - OW1_DOOMFIST_BEST_DEFENSE_DECAY_TIMER)
        else:
            eventPlayer.decay_timer -= 0.1
        wait(OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
    while RULE_CONDITION