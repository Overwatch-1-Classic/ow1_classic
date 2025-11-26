#!mainFile "../../dev_main.opy"

#!include "aura.opy" 
#!include  "soundwave.opy"
#!include "sound_barrier.opy"
#!include "wallride.opy"

def initLucio():
    @Name "[lucio/init.opy]: initLucio()"
    
    setCustomHp(OW1_LUCIO_HEALTH, 0, 0)
    setUltCost(OW1_LUCIO_ULT_COST)
    removePassiveHealing()

    # if LUCIO_CROSSFADE == true:
        # eventPlayer.cross_fade_stats = ["Speed", true, "Toggle", [], [], []]
        # lbl_0:
        # createEffect([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer.cross_fade_stats[1] == true], 
        # Effect.RING, 
        # Color.GREEN if eventPlayer.cross_fade_stats[0] == "Speed" else Color.YELLOW, 
        # updateEveryTick(eventPlayer.getPosition()), 
        # OW1_LUCIO_AURA_RADIUS, 
        # EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        # eventPlayer.cross_fade_stats[7] = getLastCreatedEntity()

        # createInWorldText(getPlayersOnHero(Hero.LUCIO, Team.ALL), "{}".format(len([i for i in localPlayer.cross_fade_stats[4] if i.isAlive()].exclude(localPlayer))), 
            # updateEveryTick(localPlayer.getEyePosition() + (150 * (0 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + (-0.3 * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), 
            # verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 
            # 2, 
            # Clip.NONE, 
            # WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
            # Color.WHITE, 
        # SpecVisibility.DEFAULT)

    setBaseDamage(eventPlayer, OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE)
    eventPlayer.setKnockbackDealt(percent(OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))

# rule "[lucio/init.opy]: Clean up Lucio":
    # @Event eachPlayer
    # @Condition eventPlayer.getCurrentHero() == Hero.LUCIO
    
    # waitUntil(eventPlayer.getCurrentHero() != Hero.LUCIO, Math.INFINITY)
    # destroyEffect(eventPlayer.cross_fade_stats[7])
    # eventPlayer.cross_fade_stats[7] = null


rule "[lucio/init.opy]: OW1 Lucio gun damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


# rule "[lucio/init.opy]: Compensate Lucio global damage reduction":
#     @Event playerDealtDamage
#     @Hero lucio
#     @Condition eventAbility in []

#     damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
