#!mainFile "../../dev_main.opy"

playervar scatter_pvar
#!defineMember _scatter_time scatter_pvar [0]
#!defineMember _scatter_velocity scatter_pvar [1] 
#!defineMember _scatter_position scatter_pvar [2]
#!defineMember _scatter_arrow_fragment scatter_pvar [3]
#!defineMember _scatter_hit_position scatter_pvar [4]
#!defineMember _scatter_hit_normal scatter_pvar [5]
#!defineMember _scatter_hit_normal_position scatter_pvar [6]
#!defineMember platform_detection scatter_pvar [7]
#!defineMember controller_user scatter_pvar [8]

subroutine platformCheck
subroutine fireScatterArrow 


def fireScatterArrow():
    @Name "[hanzo/scatter.opy]: fireScatterArrow()"
    
    eventPlayer._scatter_time = getTotalTimeElapsed()
    eventPlayer._scatter_position = eventPlayer.getEyePosition()
    eventPlayer._scatter_velocity = 110 * eventPlayer.getFacingDirection()
    waitUntil(raycast(eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)), eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true).getHitPosition() != eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), 100)
    eventPlayer._scatter_hit_position = raycast(eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)), eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true).getHitPosition()
    eventPlayer._scatter_hit_normal = raycast(eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)), eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true).getNormal()
    eventPlayer._scatter_hit_normal_position = eventPlayer._scatter_velocity + (OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) - ((2 * (dotProduct(eventPlayer._scatter_velocity + (OW1_HANZO_SCATTER_ARROW_GRAVITY * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)), normalize(eventPlayer._scatter_hit_normal)))) * normalize(eventPlayer._scatter_hit_normal))
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.TEAM_1 if eventPlayer.getTeam() == Team.1 else Color.TEAM_2, eventPlayer._scatter_hit_position, 0.7)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer._scatter_hit_position, 70)
    eventPlayer._scatter_arrow_fragment = 0
    while eventPlayer._scatter_arrow_fragment < OW1_HANZO_SCATTER_ARROW_FRAGMENT - 1:
        createProjectile(Projectile.ORB, eventPlayer, eventPlayer._scatter_hit_position, 
        directionFromAngles(horizontalAngleOfDirection(eventPlayer._scatter_hit_normal_position) - (OW1_HANZO_SCATTER_ARROW_SPREAD * (cosDeg(90 + (eventPlayer._scatter_arrow_fragment * (360 / (OW1_HANZO_SCATTER_ARROW_FRAGMENT - 1)))))), 
        verticalAngleOfDirection(eventPlayer._scatter_hit_normal_position) - (OW1_HANZO_SCATTER_ARROW_SPREAD * (sinDeg(90 + (eventPlayer._scatter_arrow_fragment * (360 / (OW1_HANZO_SCATTER_ARROW_FRAGMENT - 1))))))), 
        Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), 
        OW1_HANZO_SCATTER_ARROW_DAMAGE, 
        OW1_HANZO_SCATTER_ARROW_CRIT, 0, 
        DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 
        0, 
        OW1_HANZO_SCATTER_ARROW_SPEED, 
        OW1_HANZO_SCATTER_ARROW_LIFETIME, 
        0, 
        OW1_HANZO_SCATTER_ARROW_RICOHET, 
        OW1_HANZO_SCATTER_ARROW_GRAVITY)
        eventPlayer._scatter_arrow_fragment++


rule "[hanzo/scatter.opy]: fire scatter arrow":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingAbility2()

    waitUntil(eventPlayer.isUsingAbility2(), 0.3)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        async(fireScatterArrow, AsyncBehavior.NOOP)
        eventPlayer.disallowButton(Button.PRIMARY_FIRE)
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        while eventPlayer.isUsingAbility2():
            eventPlayer.forceButtonPress(Button.ABILITY_1 if eventPlayer.controller_user else Button.ABILITY_2)
            wait()
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_HANZO_SCATTER_ARROW_COOLDOWN)
    else:
        waitUntil(eventPlayer.isFiringPrimaryFire() or not eventPlayer.isUsingAbility2(), 5)
        if eventPlayer.isFiringPrimaryFire():
            async(fireScatterArrow, AsyncBehavior.NOOP)
            eventPlayer.disallowButton(Button.PRIMARY_FIRE)
            eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
            while eventPlayer.isUsingAbility2():
                eventPlayer.forceButtonPress(Button.ABILITY_1 if eventPlayer.controller_user else Button.ABILITY_2)
                wait()
        else:
            eventPlayer.setAbilityCooldown(Button.ABILITY_1 if eventPlayer.controller_user else Button.ABILITY_2, 0.25)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)

def platformCheck():
    @Name "[hanzo/scatter.opy]: Platform detection for scatter" # This code was made by HPJ#21547 & Lotto https://workshop.codes/7G6E9
    
    eventPlayer.platform_detection = ceil(eventPlayer.getHorizontalFacingAngle())
    eventPlayer.startFacing(directionFromAngles(eventPlayer.platform_detection + 1, 0) if any([inputBindingString(i)[0] and strContains("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&~\"#'{([-|`_\\^@)]=}^$%*,?.;/:>²ÉÈÇÀÙ+¤^ßÜÖÄÑ¡´¿ÒÌСЛП↓←→↑스아좌왼숫우오위空回退大下左暂右上；，向數", inputBindingString(i).charAt(0)) for i in [Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.INTERACT, Button.JUMP, Button.MELEE, Button.PRIMARY_FIRE, Button.RELOAD, Button.SECONDARY_FIRE, Button.ULTIMATE]]) else directionFromAngles(eventPlayer.platform_detection - 1, 0), 10000)
    wait(0.25)
    waitUntil(round(eventPlayer.getHorizontalFacingAngle() * 100) / 100 in [eventPlayer.platform_detection + 1, eventPlayer.platform_detection - 1], 3)
    if round(eventPlayer.getHorizontalFacingAngle() * 100) / 100 == eventPlayer.platform_detection + 1:
        eventPlayer.controller_user = false
    else:
        eventPlayer.controller_user = true
    eventPlayer.stopFacing()