#!mainFile "../../dev_main.opy"

# This code was made by: Spiderman31807 & Dark
# https://workshop.codes/C9WF3 & https://workshop.codes/PBMYC (Overwatch 1 Emulator)

playervar defense_pvar
#!defineMember defense_health defense_pvar[0]
#!defineMember defense_overhealth defense_pvar[1]
#!defineMember decay_timer defense_pvar[2]


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
    @Condition any([eventAbility == i for i in [Button.SECONDARY_FIRE, Button.ULTIMATE, Button.ABILITY_1]]) or eventPlayer.is_using_uppercut

    eventPlayer.decay_timer = OW1_DOOMFIST_BEST_DEFENSE_LINGER
    eventPlayer.defense_overhealth = eventPlayer.getHealthOfType(Health.SHIELDS)
    if eventAbility == Button.ULTIMATE: # Ultimate overhealth
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH - victim.getHealth(), 
            eventPlayer.defense_overhealth + OW1_DOOMFIST_BEST_DEFENSE_ULTIMATE), false, false)
    else:
        eventPlayer.setHealth(eventPlayer.defense_health) # Slam, Punch overhealth
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH - victim.getHealth(), 
            eventPlayer.defense_overhealth + OW1_DOOMFIST_BEST_DEFENSE), false, false)
        wait(0.4)

    if eventPlayer.getHealthOfType(Health.SHIELDS) > eventPlayer.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH: # Correct overheatlh if over max overhealth limit
        eventPlayer.setHealth(eventPlayer.defense_health)
        eventPlayer.addHealthPool(Health.SHIELDS, OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH, false, false)
        return

rule "[doomfist/defense.opy]: Decay Health":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS)

    do:
        if eventPlayer.decay_timer == 0:
            eventPlayer.setHealth(eventPlayer.getHealth() - OW1_DOOMFIST_BEST_DEFENSE_LINGER)
        else:
            eventPlayer.decay_timer -= 0.1
        wait(OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
    while RULE_CONDITION