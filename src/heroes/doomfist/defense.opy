#!mainFile "../../dev_main.opy"

playervar defense_pvar
#!defineMember defense_health defense_pvar[0]
#!defineMember defense_overhealth defense_pvar[1]
#!defineMember decay_timer defense_pvar[2]

rule "[doomfist/defense.opy]: Track Doom Health for Best Defense":
    @Event eachPlayer
    @Hero doomfist
    
    eventPlayer.defense_health = eventPlayer.getHealthOfType(Health.NORMAL)
    wait(0.1) # Update every 0.1 seconds so it doesn't kill the workshop load as often
    loop()

rule "[doomfist/defense.opy]: Add Best defense health":
    @Event playerDealtDamage
    @Hero doomfist
    # @Condition victim != attacker
    @Condition any([eventAbility == i for i in [Button.SECONDARY_FIRE, Button.ULTIMATE, Button.ABILITY_1]])
    
    eventPlayer.decay_timer = OW1_DOOMFIST_BEST_DEFENSE_LINGER
    eventPlayer.defense_overhealth = eventPlayer.getHealthOfType(Health.SHIELDS)
    if eventAbility == Button.ULTIMATE:
        eventPlayer.setHealth(eventPlayer.defense_health)
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH - victim.getHealth(), 
            eventPlayer.defense_overhealth + OW1_DOOMFIST_BEST_DEFENSE_ULTIMATE), false, false)
    else:
        eventPlayer.setHealth(eventPlayer.defense_health)
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH - victim.getHealth(), 
            eventPlayer.defense_overhealth + OW1_DOOMFIST_BEST_DEFENSE), false, false)
        wait(0.4)
    if eventPlayer.getHealthOfType(Health.SHIELDS) > eventPlayer.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH:
        removeHealthPool(getLastCreatedHealthPool())
        eventPlayer.setHealth(eventPlayer.defense_health)
        eventPlayer.addHealthPool(Health.SHIELDS, OW1_DOOMFIST_BEST_DEFENSE_MAX_OVERHEALTH, false, false)
        return

rule "[doomfist/defense.opy]: Decay Health":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS)
    
    #try eventPlayer.getMaxHealth() to shields then that
    do:
        if eventPlayer.decay_timer == 0:
            eventPlayer.setHealth(eventPlayer.getHealth() - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
        else:
            eventPlayer.decay_timer -= 0.1
        wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
    while RULE_CONDITION


