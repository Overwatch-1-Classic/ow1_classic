#!mainFile "../../dev_main.opy"

playervar discord_orb_damage

rule "[zenyatta/discord.opy]: Set discord orb":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).discord_orb_damage = true

rule "[zenyatta/discord.opy]: damage victim.":
    @Event eachPlayer
    @Condition eventPlayer.discord_orb_damage

    eventPlayer.setDamageReceived(percent(OW1_ZENYATTA_DISCORD_ORB_TAKEN*eventPlayer._base_damage_scalar))
    # eventPlayer.setDamageReceived(OW1_ZENYATTA_DISCORD_ORB_TAKEN*OW2_ZENYATTA_DISCORD_ORB_TAKEN) # I have no idea where do you get that number but it is correct?
    waitUntil(not getPlayersOnHero(Hero.ZENYATTA, getOppositeTeam(eventPlayer.getTeam())).isUsingAbility2(), Math.INFINITY)
    eventPlayer.setDamageReceived(100)
    eventPlayer.discord_orb_damage = false

rule "[zenyatta/discord.opy]: remove damaged received if pvar false":
    @Event eachPlayer
    @Condition not eventPlayer.discord_orb_damage

    eventPlayer.setDamageReceived(100)