#!mainFile "../../dev_main.opy"

playervar turret_pvar
#!defineMember turret_position turret_pvar [0]
#!defineMember turret_level turret_pvar [1]
#!defineMember turret_progress turret_pvar [2]
#!defineMember turret_progress_hud turret_pvar [3]

subroutine setTurretHealth
subroutine clearTurretHealth

macro missleEffects():
    createProjectile(Projectile.ORB, 
        eventPlayer, 
        eventPlayer.turret_position + vect(0, 1, 0), 
        directionTowards(eventPlayer.turret_position + vect(0, 1.1, 0), (
        (sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.hasSpawned() and isInLoS(eventPlayer.turret_position + vect(0, 1, 0), 
        player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)], lambda i: distance(eventPlayer.turret_position, i.getEyePosition())))[0]).getEyePosition()), 
        Relativity.TO_WORLD, ModifyHealth.DAMAGE, 
        getOppositeTeam(eventPlayer.getTeam()), 
        OW1_TORBJORN_TURRET_LEVEL_ULTIMATE_DAMAGE, 
        OW1_TORBJORN_TURRET_LEVEL_ULTIMATE_EXPLOSION_RADIUS, 
        0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 
        OW1_TORBJORN_TURRET_LEVEL_ULTIMATE_SPEED, 
        OW1_TORBJORN_TURRET_LEVEL_ULTIMATE_LIFETIME, 
        OW1_TORBJORN_TURRET_LEVEL_ULTIMATE_EXPLOSION_RADIUS, 0, 0)

macro showTurretProgressHUD():
    createInWorldText(eventPlayer, "{}/100 {}".format(eventPlayer.turret_progress, 
        eventPlayer.turret_level), 
        updateEveryFrame(eventPlayer.getEyePosition() + (150 * (-1.35 * worldVector(Vector.RIGHT, 
        eventPlayer, 
        Transform.ROTATION) + (-1.6 * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
        verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 2.9 * eventPlayer.getFacingDirection()))), 
        2)
    eventPlayer.turret_progress_hud = getLastCreatedText()

macro hideTurretProgressHUD():
    destroyInWorldText(eventPlayer.turret_progress_hud)
    eventPlayer.turret_progress_hud = null

macro restartTurret():
    hideTurretProgressHUD()
    eventPlayer.allowButton(Button.INTERACT) 
    eventPlayer.forceButtonPress(Button.INTERACT) 
    eventPlayer.disallowButton(Button.INTERACT) 
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0) 
    eventPlayer.forceButtonPress(Button.ABILITY_1)

macro restartTurretProgress():
    # eventPlayer.turret_progress -= 100
    eventPlayer.turret_position = vect(0, -500, 0)
    eventPlayer.turret_level = 1
    eventPlayer.turret_progress = 0

rule "[torbjorn/turret.opy]: Set turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    
    showTurretProgressHUD()
    eventPlayer.turret_level = 1
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setProjectileGravity(Math.INFINITY)
    eventPlayer.setProjectileSpeed(0)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.1) # Small grace period
    eventPlayer.turret_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 10 * Vector.DOWN, null, null, true).getHitPosition() + vect(0, 0.1, 0)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.disallowButton(Button.ABILITY_1)    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_TORBJORN_TURRET_COOLDOWN)

rule "[torbjorn/turret.opy]: Set turret if using it":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0

    restartTurretProgress()
    restartTurret()

rule "[torbjorn/turret.opy]: Reset turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition not eventPlayer.isUsingAbility1()

    restartTurretProgress()


rule "[torbjorn/turret.opy]: Build turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isFiringPrimaryFire() or eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.turret_level < OW1_TORBJORN_TURRET_LEVEL_ULTIMATE
    @Condition (eventPlayer.turret_level < OW1_TOBRJORN_TURRET_LEVEL or eventPlayer.isUsingAbility2())
    
    wait(0.05 if eventPlayer.isUsingAbility2() else 0.1, Wait.ABORT_WHEN_FALSE)
    waitUntil(distance(eventPlayer.getPosition(), eventPlayer.turret_position) < OW1_TOBRJORN_TURRET_LEVEL and eventPlayer.isInViewAngle(eventPlayer.turret_position, 40), 0.192)
    if distance(eventPlayer.getPosition(), eventPlayer.turret_position) < OW1_TOBRJORN_TURRET_LEVEL and eventPlayer.isInViewAngle(eventPlayer.turret_position, 40):
        eventPlayer.turret_progress += OW1_TORBJORN_TURRET_UPGRADE_HIT


rule "[torbjorn/turret.opy]: Upgrade turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.turret_progress >= OW1_TORBJORN_TURRET_UPGRADE
    
    if eventPlayer.isUsingAbility2():
        eventPlayer.turret_level = OW1_TORBJORN_TURRET_LEVEL_ULTIMATE
        smallMessage(eventPlayer, "Turret Supercharged")
    else:
        eventPlayer.turret_level += 1
        smallMessage(eventPlayer, "Turret Upgraded to level {}".format(eventPlayer.turret_level))
        # setTurretHealth()

# rule "[torbjorn/turret.opy]: remove upgrade to level 2 if turret finished":
    # @Event eachPlayer
    # @Hero torbjorn
    # @Condition eventPlayer.turret_level >= OW1_TORBJORN_TURRET_LEVEL_ULTIMATE
    # @Condition not eventPlayer.isUsingAbility2()
    
    # eventPlayer.turret_level = OW1_TOBRJORN_TURRET_LEVEL
    # setTurretHealth()
    
rule "[torbjorn/turret.opy]: Instantly upgrade to level 3 if using overload":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()
    @Condition eventPlayer.turret_level == OW1_TOBRJORN_TURRET_LEVEL
    
    eventPlayer.turret_level = OW1_TORBJORN_TURRET_LEVEL_ULTIMATE
    smallMessage(eventPlayer, "Turret Supercharged")

rule "[torbjorn/turret.opy]: Turret damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ULTIMATE
    @Condition eventAbility != Button.SECONDARY_FIRE
    @Condition eventAbility != Button.ULTIMATE
    @Condition eventAbility != Button.MELEE
    
    if eventPlayer.turret_level > OW1_TOBRJORN_TURRET_LEVEL:
        damage(victim, attacker, eventDamage * 0.5)
    elif eventPlayer.turret_level < OW1_TOBRJORN_TURRET_LEVEL:
        heal(victim, null, eventDamage / 2)

rule "[torbjorn/turret.opy]: Set turret back to level 2 after ultimate":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.turret_level >= OW1_TORBJORN_TURRET_LEVEL_ULTIMATE
    @Condition not eventPlayer.isUsingAbility2()
    
    eventPlayer.turret_level = OW1_TOBRJORN_TURRET_LEVEL


rule "[torbjorn/turret.opy]: Missle effects if using overload":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.turret_level >= OW1_TORBJORN_TURRET_LEVEL_ULTIMATE
    @Condition (any([player.isAlive() and isInLoS(eventPlayer.turret_position + vect(0, 1, 0), 
        player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) and player.hasSpawned() and distance(eventPlayer.turret_position + vect(0, 1, 0), 
        player.getEyePosition()) < 40 for player in getPlayers(getOppositeTeam(eventPlayer.getTeam()))]))
    @Condition getNumberOfPlayers(getOppositeTeam(eventPlayer.getTeam())) > 0
    
    do:
        missleEffects()
        wait(OW1_TORBJORN_TURRET_LEVEL_ULTIMATE_FIRERATE, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION