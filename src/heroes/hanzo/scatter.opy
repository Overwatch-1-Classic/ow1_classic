#!mainFile "../../dev_main.opy"


# Scatter Arrow Code by blaking707#1221 https://workshop.codes/NRPQZX

playervar scatter_pvar
#!defineMember _scatter_time scatter_pvar [0]
#!defineMember _scatter_velocity scatter_pvar [1] 
#!defineMember _scatter_position scatter_pvar [2]
#!defineMember _scatter_arrow_active scatter_pvar [3]
#!defineMember _scatter_arrow_angle scatter_pvar [4]
#!defineMember _scatter_arrow_normalized scatter_pvar [5]
#!defineMember _controller_user scatter_pvar [6]

rule "[hanzo/scatter.opy]: check if on console if not, pc":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition not eventPlayer.isUsingAbility2()

    wait(0.10)
    if eventPlayer.isUsingAbility2():
        return
    wait(0.15)
    if eventPlayer.isUsingAbility2():
        eventPlayer._controller_user = true


rule "[hanzo/scatter.opy]: check if on pc if not, console":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition not eventPlayer.isUsingAbility2()

    wait(0.1)
    if eventPlayer.isUsingAbility2():
        return
    wait(0.15)
    if eventPlayer.isUsingAbility2():
        eventPlayer._controller_user = false

rule "[hanzo/scatter.opy]: Scatter arrow firing state":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingAbility2()

    # setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW1_HANZO_SCATTER_ARROW_MOVE_PENALTY)) # Removed move penalty cause scatter didnt have that, and it feels wanky if you're not even gonna shoot.
    waitUntil((eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)) or not eventPlayer.isUsingAbility2(), Math.INFINITY)
    # setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW1_HANZO_SCATTER_ARROW_MOVE_PENALTY)) # Removed move penalty cause scatter didnt have that, and it feels wanky if you're not even gonna shoot.
    if eventPlayer.isUsingAbility2():
        eventPlayer._scatter_velocity = eventPlayer.getFacingDirection() * OW1_HANZO_SCATTER_ARROW_SPEED 
        eventPlayer._scatter_position = eventPlayer.getFacingDirection() * 1 + eventPlayer.getEyePosition() + Vector.UP * -0.25
        eventPlayer._scatter_arrow_active = true
        eventPlayer.disallowButton(Button.PRIMARY_FIRE)
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        while eventPlayer.isUsingAbility2():
            eventPlayer.forceButtonPress(Button.ABILITY_1 if eventPlayer._controller_user else Button.ABILITY_2)
            wait()
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1 if eventPlayer._controller_user else Button.ABILITY_2, 0.2)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)


rule "[hanzo/scatter.opy]: Scatter Arrow Projectile Creation":
    @Event eachPlayer
    @Hero hanzo
    @Condition distance(raycast(eventPlayer._scatter_position, eventPlayer._scatter_position + eventPlayer._scatter_velocity * 0.016, getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition(), eventPlayer._scatter_position + eventPlayer._scatter_velocity * 0.016) > OW1_HANZO_SCATTER_ARROW_SPEED * 0
    @Condition eventPlayer._scatter_arrow_active 
    
    eventPlayer._scatter_arrow_angle = raycast(eventPlayer._scatter_position, eventPlayer._scatter_position + eventPlayer._scatter_velocity, getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getNormal()
    eventPlayer._scatter_arrow_normalized = normalize(eventPlayer._scatter_velocity) + 2 * eventPlayer._scatter_arrow_angle * (dotProduct(-1 * normalize(eventPlayer._scatter_velocity), eventPlayer._scatter_arrow_angle))
    createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_position, eventPlayer._scatter_arrow_normalized * OW1_HANZO_SCATTER_ARROW_SPEED, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_HANZO_SCATTER_ARROW_DAMAGE, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_HANZO_SCATTER_ARROW_SPEED, OW1_HANZO_SCATTER_ARROW_LIFETIME, 0, OW1_HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT, OW1_HANZO_SCATTER_ARROW_GRAVITY)
    createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_position, (normalize(crossProduct(eventPlayer._scatter_arrow_angle, eventPlayer._scatter_arrow_normalized) * 0.0625 + eventPlayer._scatter_arrow_normalized)) * OW1_HANZO_SCATTER_ARROW_SPEED, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_HANZO_SCATTER_ARROW_DAMAGE, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_HANZO_SCATTER_ARROW_SPEED, OW1_HANZO_SCATTER_ARROW_LIFETIME, 0, OW1_HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT, OW1_HANZO_SCATTER_ARROW_GRAVITY)
    createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_position, (normalize(crossProduct(eventPlayer._scatter_arrow_angle, eventPlayer._scatter_arrow_normalized) * 0.125 + eventPlayer._scatter_arrow_normalized)) * OW1_HANZO_SCATTER_ARROW_SPEED, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_HANZO_SCATTER_ARROW_DAMAGE, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_HANZO_SCATTER_ARROW_SPEED, OW1_HANZO_SCATTER_ARROW_LIFETIME, 0, OW1_HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT, OW1_HANZO_SCATTER_ARROW_GRAVITY)
    createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_position, (normalize(crossProduct(eventPlayer._scatter_arrow_angle, eventPlayer._scatter_arrow_normalized) * -0.0625 + eventPlayer._scatter_arrow_normalized)) * OW1_HANZO_SCATTER_ARROW_SPEED, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_HANZO_SCATTER_ARROW_DAMAGE, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_HANZO_SCATTER_ARROW_SPEED, OW1_HANZO_SCATTER_ARROW_LIFETIME, 0, OW1_HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT, OW1_HANZO_SCATTER_ARROW_GRAVITY)
    createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_position, (normalize(crossProduct(eventPlayer._scatter_arrow_angle, eventPlayer._scatter_arrow_normalized) * -0.125 + eventPlayer._scatter_arrow_normalized)) * OW1_HANZO_SCATTER_ARROW_SPEED, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_HANZO_SCATTER_ARROW_DAMAGE, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_HANZO_SCATTER_ARROW_SPEED, OW1_HANZO_SCATTER_ARROW_LIFETIME, 0, OW1_HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT, OW1_HANZO_SCATTER_ARROW_GRAVITY)
    createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_position, (normalize(crossProduct(eventPlayer._scatter_arrow_angle, eventPlayer._scatter_arrow_normalized) * -0.0625 + eventPlayer._scatter_arrow_normalized)) * OW1_HANZO_SCATTER_ARROW_SPEED, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_HANZO_SCATTER_ARROW_DAMAGE, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_HANZO_SCATTER_ARROW_SPEED, OW1_HANZO_SCATTER_ARROW_LIFETIME, 0, OW1_HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT, OW1_HANZO_SCATTER_ARROW_GRAVITY)
    eventPlayer._scatter_arrow_active = false

rule "[hanzo/scatter.opy]: Disable scatter":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer._scatter_arrow_active 
    
    wait(OW1_HANZO_SCATTER_ARROW_COOLDOWN, Wait.ABORT_WHEN_FALSE)
    eventPlayer._scatter_arrow_active = false


rule "[hanzo/scatter.opy]: Move scatter":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer._scatter_arrow_active 
    
    do:
        eventPlayer._scatter_position = eventPlayer._scatter_position + eventPlayer._scatter_velocity * 0.016
        eventPlayer._scatter_velocity = eventPlayer._scatter_velocity + vect(0, -9.18, 0) * 0.016
    while RULE_CONDITION

rule "[hanzo/scatter.opy]: remove scatter arrow critical hit":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventWasCriticalHit
    @Condition eventPlayer.isUsingAbility2()

    heal(victim, null, eventDamage)
    damage(victim, eventPlayer, OW1_HANZO_SCATTER_ARROW_DAMAGE)