#!mainFile "../dev_main.opy"

globalvar THIRD_PERSON = createWorkshopSetting(bool, "Dev Tools", "third person perspective", true)

/*
This third person perspective was made by Mitsiee & jtbfs (for smooth camera)
https://workshop.codes/third-person & https://workshop.codes/SQGC8  code: SQGC8 or 2S23V
*/

# Middle Camera, No right or left shoulder

playervar third_person_pvar
#!defineMember zoom_pov third_person_pvar[0]
#!defineMember camera_shoulder third_person_pvar[1]
#!defineMember inaccurate_crosshair_lineup third_person_pvar[2]
#!defineMember middle_camera third_person_pvar[3]
#!defineMember visualize_crosshair_position third_person_pvar[4]

#!define LOWEST_CAMERA_POV -1
#!define HIGHEST_CAMERA_POV -5

enum CameraShoulder: # Camera Shoulder, similar to stadium
    MIDDLE_SHOULDER = 0,
    LEFT_SHOULDER = 1,
    RIGHT_SHOULDER = -1

rule "[utilities/third_person.opy]: Initialise":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    
    eventPlayer.camera_shoulder = CameraShoulder.LEFT_SHOULDER
    eventPlayer.zoom_pov = -2.5 # Default zoom level

    # By Dwaliyo, https://workshop.codes/W0V6E
    createBeam(eventPlayer, Beam.BAD, updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 0.1), 
        updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), 
        eventPlayer, 
        true).getHitPosition()), 
        Color.GREEN, 
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.visualize_crosshair_position = getLastCreatedEntity()


rule "[utilities/third_person.opy]: Set up third person perspective":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition not ((eventPlayer.getHero() == Hero.WIDOWMAKER or eventPlayer.getHero() == Hero.ASHE or eventPlayer.getHero() == Hero.REINHARDT or eventPlayer.getHero() == Hero.BRIGITTE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))

    if not eventPlayer.inaccurate_crosshair_lineup:
        #Accurate Crosshair Camera (Default)
        eventPlayer.startCamera(updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
            (eventPlayer.getEyePosition() + (worldVector(vect(eventPlayer.camera_shoulder * (min(eventPlayer.zoom_pov / 2.5, -0.75)) if eventPlayer.middle_camera == 0 else 0, 
            eventPlayer.middle_camera, 0), eventPlayer, Transform.ROTATION))) + eventPlayer.getFacingDirection() * eventPlayer.zoom_pov, getAllPlayers(), eventPlayer, false).getHitPosition()), 
            updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
            eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 200, 
            getAllPlayers(), 
            eventPlayer, 
            false).getHitPosition()))
    else:
        #Inaccurate Crosshair Camera
        eventPlayer.startCamera(updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
            (eventPlayer.getEyePosition() + (worldVector(vect(eventPlayer.camera_shoulder * (min(eventPlayer.zoom_pov / 2.5, -0.75)) if eventPlayer.middle_camera == 0 else 0, eventPlayer.middle_camera, 0), 
            eventPlayer, Transform.ROTATION))) + eventPlayer.getFacingDirection() * eventPlayer.zoom_pov, getAllPlayers(), eventPlayer, false).getHitPosition()), 
            updateEveryFrame(eventPlayer.getEyePosition()) + updateEveryFrame(eventPlayer.getFacingDirection()) * 200)


rule "[utilities/third_person.opy]: Disable Third Person for specific conditions":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition ((eventPlayer.getHero() == Hero.WIDOWMAKER or eventPlayer.getHero() == Hero.ASHE or eventPlayer.getHero() == Hero.REINHARDT or eventPlayer.getHero() == Hero.BRIGITTE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))
    
    eventPlayer.stopCamera()    
    
# Controls

rule "[utilities/third_person.opy]: Change shoulders when pressing interact":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    
    if eventPlayer.camera_shoulder == CameraShoulder.LEFT_SHOULDER:
        eventPlayer.camera_shoulder = CameraShoulder.RIGHT_SHOULDER
    else:
        eventPlayer.camera_shoulder = CameraShoulder.LEFT_SHOULDER


rule "[utilities/third_person.opy]: Increase POV":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    
    do:
        if eventPlayer.zoom_pov >= LOWEST_CAMERA_POV:
            goto lbl_0
        eventPlayer.zoom_pov += 0.1
        lbl_0:
        wait(TICK_DURATION)
    while RULE_CONDITION


rule "[utilities/third_person.opy]: Decrease POV":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    do:
        if eventPlayer.zoom_pov <= HIGHEST_CAMERA_POV:
            goto lbl_0
        eventPlayer.zoom_pov -= 0.1
        lbl_0:
        wait(TICK_DURATION)
    while RULE_CONDITION


rule "[utilities/third_person.opy]: Accurate Crosshair Mode":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition (eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.CROUCH))
    
    if not eventPlayer.inaccurate_crosshair_lineup:
        eventPlayer.inaccurate_crosshair_lineup = true
        # Inaccurate Crosshair Camera
        eventPlayer.startCamera(updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
            (eventPlayer.getEyePosition() + (worldVector(vect(eventPlayer.camera_shoulder * (min(eventPlayer.zoom_pov / 2.5, -0.75)) if eventPlayer.middle_camera == 0 else 0, eventPlayer.middle_camera, 0), 
            eventPlayer,
            Transform.ROTATION))) + eventPlayer.getFacingDirection() * eventPlayer.zoom_pov, 
            getAllPlayers(), 
            eventPlayer, 
            false).getHitPosition()), 
            updateEveryFrame(eventPlayer.getEyePosition()) + updateEveryFrame(eventPlayer.getFacingDirection()) * 200)
    else:
        eventPlayer.inaccurate_crosshair_lineup = false
        # Accurate Crosshair Camera
        eventPlayer.startCamera(updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
            (eventPlayer.getEyePosition() + (worldVector(vect(eventPlayer.camera_shoulder * (min(eventPlayer.zoom_pov / 2.5, -0.75)) if eventPlayer.middle_camera == 0 else 0, 
            eventPlayer.middle_camera, 0), 
            eventPlayer, 
            Transform.ROTATION))) + eventPlayer.getFacingDirection() * eventPlayer.zoom_pov, getAllPlayers(), 
            eventPlayer, false).getHitPosition()), 
            updateEveryFrame(raycast(eventPlayer.getEyePosition(), 
            eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 200, 
            getAllPlayers(), 
            eventPlayer, 
            false).getHitPosition()))


rule "[utilities/third_person.opy]: Middle Camera Mode":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.RELOAD))
    
    if eventPlayer.middle_camera == CameraShoulder.MIDDLE_SHOULDER:
        eventPlayer.middle_camera = 0.75 if not eventPlayer.getHero() in getTankHeroes() else CameraShoulder.LEFT_SHOULDER
    else:
        eventPlayer.middle_camera = CameraShoulder.MIDDLE_SHOULDER
    
# GUI

rule "[utilities/third_person.opy]: Third person controls (Top Middle)":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition THIRD_PERSON

    hudHeader(eventPlayer, "Third Person", HudPosition.TOP, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Current zoom level:", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, eventPlayer.zoom_pov, HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, "Zoom out with [CROUCH] + [Secondary Fire]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, "Zoom in with [CROUCH] + [Primary Fire]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, "Swap the camera shoulder side with [Interact]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, "Accurate Crosshair Mode [Crouch] + [Melee]: {}".format("Off" if eventPlayer.inaccurate_crosshair_lineup else "On"), HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, "Middle Camera Mode [Crouch] + [Reload]: {}".format("Off" if eventPlayer.middle_camera == 0 else "On"), HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)