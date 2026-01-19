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
    # removeSelfHealing()

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.turret_level = OW1_TORBJORN_TURRET_DEFAULT

    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    initScrap()
    initArmourPack()
    showScrapHUD()

    eventPlayer.setProjectileSpeed(percent(OW1_TORBJORN_RIVET_GUN_PROJECTILE_SPEED/OW2_TORBJORN_RIVET_GUN_PROJECTILE_SPEED))
    setBaseDamage(eventPlayer, OW1_TORBJORN_TURRET_DAMAGE/OW2_TORBJORN_TURRET_DAMAGE)

rule "[torbjorn/init.opy]: Clean up Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TORBJORN

    waitUntil(eventPlayer.getCurrentHero() != Hero.TORBJORN, Math.INFINITY)
    
    removeHealthPool(eventPlayer._torbjorn_overload_health)
    removeHealthPool(eventPlayer._torbjorn_overload_armor)
    
    hideScrapHUD()
    hideTurretProgressHUD()
    initScrap()
    initArmourPack()

rule "[torbjorn/init.opy]: Correct Rivet Gun, Hammer, and ultimate damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
