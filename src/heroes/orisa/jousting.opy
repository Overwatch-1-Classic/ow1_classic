#!mainFile "../../dev_main.opy"

# Orisa jousting LOL
# #umamusume </3

# Taken from: https://www.youtube.com/watch?v=SWFOA14vMQM or AWV3E

playervar occupied 
playervar closest_orisa 
playervar jousting_orisa 


rule "[orisa/jousting.opy]: Get closest orisa":
    @Event eachPlayer
    @Hero hanzo
    
    eventPlayer.closest_orisa = ([i for i in sorted(getPlayersOnHero(Hero.ORISA, eventPlayer.getTeam()), lambda player: distance(eventPlayer, player)) if i != eventPlayer])[0]
    wait()
    if ruleCondition:
        loop()


rule "[orisa/jousting.opy]: Get on":
    @Event eachPlayer
    @Hero hanzo
    @Condition distance(eventPlayer, eventPlayer.closest_orisa) <= 2
    @Condition not eventPlayer.closest_orisa.occupied
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    
    if createWorkshopSettingBool("Settings", "Orisas can ride orisas", false) == false:
        if eventPlayer.getHero() == Hero.ORISA:
            return
    
    eventPlayer.closest_orisa.occupied = true
    eventPlayer.jousting_orisa = true
    eventPlayer.attachTo(eventPlayer.closest_orisa, vect(0, 1, -0.5))


rule "[orisa/jousting.opy]: Get off (crouch)":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.jousting_orisa
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    
    eventPlayer.detach()
    eventPlayer.jousting_orisa = false
    eventPlayer.closest_orisa.occupied = false


rule "[orisa/jousting.opy]: Orisa speed":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.jousting_orisa

    eventPlayer.setMoveSpeed(150)
    waitUntil( not eventPlayer.jousting_orisa, Math.INFINITY)
    eventPlayer.setMoveSpeed(100)

rule "[orisa/jousting.opy]: Hanzo passive damage reduction":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.jousting_orisa

    eventPlayer.setDamageReceived(75)
    waitUntil(eventPlayer.jousting_orisa == false, Math.INFINITY)
    eventPlayer.setDamageReceived(100)