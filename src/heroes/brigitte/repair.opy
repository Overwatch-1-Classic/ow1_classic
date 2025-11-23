#!mainFile "../../dev_main.opy"

playervar repair_pack_armor 

rule "[brigitte/repair.opy]: Only one repair":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2()

    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)
    wait(OW1_BRIGITTE_REPAIR_PACK_COOLDOWN)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 3)

rule "[brigitte/repair.opy]: disable repair if 20m":
    @Event eachPlayer
    @Hero brigitte
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) >= OW1_BRIGITTE_REPAIR_PACK_RANGE
    
    eventPlayer.disallowButton(Button.ABILITY_2)


rule "[brigitte/repair.opy]: enable repair if under 20m":
    @Event eachPlayer
    @Hero brigitte
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= OW1_BRIGITTE_REPAIR_PACK_RANGE
    
    eventPlayer.allowButton(Button.ABILITY_2)

rule "[brigitte/repair.opy]: repair instant heal":
    @Event playerReceivedHealing
    @Condition healer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    heal(eventPlayer, healer, OW1_BRIGITTE_REPAIR_PACK_INSTANT_HEAL)


rule "[brigitte/repair.opy]: repair bonus armor":
    @Event playerReceivedHealing
    @Condition healer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventPlayer.getNormalizedHealth() == 1
    
    eventPlayer.addHealthPool(Health.NORMAL, OW1_BRIGITTE_REPAIR_PACK_ARMOR, false, false)
    eventPlayer.repair_pack_armor = getLastCreatedHealthPool()
    wait(OW1_BRIGITTE_INSPIRE_DURATION)
    removeHealthPool(getLastCreatedHealthPool())