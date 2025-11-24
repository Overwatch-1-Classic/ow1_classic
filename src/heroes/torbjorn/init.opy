#!mainFile "../../dev_main.opy"

#!include "overload.opy"
#!include "rivet.opy"
#!include "scrap.opy"
#!include "turret.opy"


def initTorbjorn():
    @Name "[torbjorn/init.opy]: initTorbjorn()"

    setCustomHp(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
    setUltCost(OW1_TORBJORN_ULT_COST)
    removeSelfHealing()

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.ULTIMATE)

    progressBarHud(eventPlayer, eventPlayer._scrap_allowance / OW1_TORBJORN_SCRAP_MAX * 100, "Scrap {0}".
        format(eventPlayer._scrap_allowance), 
        HudPosition.TOP, 
        1, 
        Color.YELLOW, 
        Color.WHITE, 
        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
        SpecVisibility.DEFAULT)
    eventPlayer._scrap_hud = getLastCreatedText()

    eventPlayer.turret_level = OW1_TORBJORN_TURRET_DEFAULT

    setBaseDamage(eventPlayer, OW1_TORBJORN_TURRET_DAMAGE/OW2_TORBJORN_TURRET_DAMAGE)

    eventPlayer.startScalingSize(1.5, false)

rule "[torbjorn/init.opy]: Clean up Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TORBJORN

    waitUntil(eventPlayer.getCurrentHero() != Hero.TORBJORN, Math.INFINITY)
    removeHealthPool(eventPlayer._torbjorn_overload_health)
    removeHealthPool(eventPlayer._torbjorn_overload_armor)
    destroyProgressBarHud(eventPlayer._scrap_hud)
    eventPlayer.turret_level = 1
    eventPlayer._scrap = 1

rule "[torbjorn/init.opy]: OW1 Torbjorn fire rate":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_TORBJORN_HAMMER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)

rule "[torbjorn/init.opy]: OW1 Torbjorn fire rate melee":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isHoldingButton(Button.MELEE) # For some reason it wont let me do isMeleeing()
    @Condition not eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.MELEE)
    wait(OW1_TORBJORN_HAMMER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.MELEE)
    if eventPlayer.isHoldingButton(Button.MELEE):
        eventPlayer.forceButtonPress(Button.MELEE)

rule "[torbjorn/init.opy]: Correct Rivet Gun, Hammer, and ultimate damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
