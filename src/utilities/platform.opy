#!mainFile "../dev_main.opy"

playervar platform_pvar
#!defineMember platform_detection platform_pvar[0]
#!defineMember controller_user platform_pvar[1]

subroutine detectPlatform

enum InputType:
    KEYBOARD = 1,
    CONTROLLER

def detectPlatform():
    @Name "[platform.opy]: Detect console or keyboard" # This code was made by HPJ#21547 & Lotto https://workshop.codes/7G6E9
    
    eventPlayer.platform_detection = ceil(eventPlayer.getHorizontalFacingAngle())
    # The only method i know how to detect player platform
    eventPlayer.startFacing(directionFromAngles(eventPlayer.platform_detection + 1, 0) if any([inputBindingString(i)[0] and 
        strContains("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&~\"#'{([-|`_\\^@)]=}^$%*,?.;/:>²ÉÈÇÀÙ+¤^ßÜÖÄÑ¡´¿ÒÌСЛП↓←→↑스아좌왼숫우오위空回退大下左暂右上；，向數", 
        inputBindingString(i).charAt(0)) for i in [Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.INTERACT, Button.JUMP, Button.MELEE, Button.PRIMARY_FIRE, Button.RELOAD, Button.SECONDARY_FIRE, Button.ULTIMATE]]) 
        else directionFromAngles(eventPlayer.platform_detection - 1, 0), 10000)
    wait(TICK_DURATION)
    waitUntil(round(eventPlayer.getHorizontalFacingAngle() * 100) / 100 in [eventPlayer.platform_detection + 1, eventPlayer.platform_detection - 1], 3)
    if round(eventPlayer.getHorizontalFacingAngle() * 100) / 100 == eventPlayer.platform_detection + 1:
        eventPlayer.controller_user = InputType.KEYBOARD
    else:
        eventPlayer.controller_user = InputType.CONTROLLER
    eventPlayer.stopFacing()