#!mainFile "../../dev_main.opy"

#!include "overload.opy"
#!include "rivet.opy"
#!include "scrap.opy"
#!include "turret.opy"
#!include "armour_pack.opy"

/*
This 2016 Torbjorn workshop script was made by wadetata#0315
https://workshop.codes/AMSG8    code: AMSG8
*/

def initTorbjorn():
    @Name "[torbjorn/init.opy]: initTorbjorn()"

    setCustomHp(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
    setUltCost(OW1_TORBJORN_ULT_COST)
    removeSelfHealing()

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.ULTIMATE)

    createProgressBarInWorldText(eventPlayer, 0.5 * eventPlayer.scrap, 
        "Scrap: {}/200".format(eventPlayer.scrap), 
        updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.7 * worldVector(Vector.RIGHT, 
        eventPlayer, 
        Transform.ROTATION) + (-1.5 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
        verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
        1, 
        Clip.NONE, 
        Color.ORANGE, 
        Color.WHITE, 
        ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, 
        SpecVisibility.DEFAULT)
    eventPlayer.scrap_hud = getLastCreatedText()

    eventPlayer.turret_level = OW1_TORBJORN_TURRET_DEFAULT

    eventPlayer.use_armour_pack = []
    eventPlayer.scrap_position = vect(0, -500, 0)

    eventPlayer.armour_pack_position = vect(0, -500, 0)
    eventPlayer.turret_level = 1
    eventPlayer.scrap = 0

    ARMOUR_PACK_TEAM_1 = []
    ARMOUR_PACK_TEAM_2 = []

    eventPlayer.setProjectileSpeed(percent(OW1_TORBJORN_RIVET_GUN_PROJECTILE_SPEED/OW2_TORBJORN_RIVET_GUN_PROJECTILE_SPEED))
    setBaseDamage(eventPlayer, OW1_TORBJORN_TURRET_DAMAGE/OW2_TORBJORN_TURRET_DAMAGE)

rule "[torbjorn/init.opy]: Clean up Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TORBJORN

    waitUntil(eventPlayer.getCurrentHero() != Hero.TORBJORN, Math.INFINITY)
    removeHealthPool(eventPlayer._torbjorn_overload_health)
    removeHealthPool(eventPlayer._torbjorn_overload_armor)
    destroyProgressBarInWorldText(eventPlayer.scrap_hud)
    hideTurretProgressHUD()
    eventPlayer.turret_level = 1
    eventPlayer.scrap = 0
    eventPlayer.use_armour_pack = []
    eventPlayer.armour_pack_position = vect(0, -500, 0)
    eventPlayer.scrap_position = vect(0, -500, 0)

rule "[torbjorn/init.opy]: Correct Rivet Gun, Hammer, and ultimate damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
