#!mainFile "../../dev_main.opy"

# This code was taken & recoded from https://workshop.codes/PK7BH       code: PK7BH
# Created by Mathemann69

globalvar ULT_DURATION_WORKSHOP_SETTINGS = createWorkshopSetting(int[1:10], "Ramattra", "Annihilation duration", OW1_RAMATTRA_ANNIHILATION_DURATION, 0)
globalvar ULT_DURATION_MAX = ULT_DURATION_WORKSHOP_SETTINGS 

playervar ult_duration 
playervar annahilation_pvar
#!defineMember annahilation_progress_bar annahilation_pvar[0]
#!defineMember annahilation_hud_text_id annahilation_pvar[1]
#!defineMember annahilation_armour annahilation_pvar[2]

macro startAnnihilation():
    eventPlayer.ult_duration = ULT_DURATION_WORKSHOP_SETTINGS 
    # progressBarHud(eventPlayer, eventPlayer.ult_duration * (100 / ULT_DURATION_MAX), "{}s".format(round(eventPlayer.ult_duration)), 
    # HudPosition.TOP, 
    # 1000, 
    # Color.WHITE, 
    # Color.WHITE, 
    # ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
    # SpecVisibility.NEVER) 
    # eventPlayer.annahilation_progress_bar = getLastCreatedText() 

    # Draw annahilation timer
    createInWorldText(eventPlayer,
                    "{}".format(ceil(eventPlayer.ult_duration)),
                    updateEveryTick(eventPlayer.getEyePosition() + (100 * (0.18 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((0.25 - 0.3) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()),
                    verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))),
                    2.5,
                    Clip.NONE,
                    WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,\
                    Color.WHITE,
                    SpecVisibility.DEFAULT)
    eventPlayer.annahilation_progress_bar = getLastCreatedText()
    chase(eventPlayer.ult_duration, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
 
macro stopAnnihilation():
    stopChasingVariable(eventPlayer.ult_duration)

    # destroyProgressBarHud(eventPlayer.annahilation_progress_bar)
    destroyInWorldText(eventPlayer.annahilation_progress_bar)
    eventPlayer.annahilation_progress_bar = null

    eventPlayer.ult_duration = ULT_DURATION_WORKSHOP_SETTINGS

rule "[ramattra/annihilation.opy]: start ult and chase variables":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate()
    
    startAnnihilation()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    stopAnnihilation()


rule "[ramattra/annihilation.opy]: dealt dmg stop chase variables":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventAbility == Button.ULTIMATE
    
    stopChasingVariable(eventPlayer.ult_duration)
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    chase(eventPlayer.ult_duration, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "[ramattra/annihilation.opy]: stop ult if varb hits 0":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.ult_duration <= 0
    @Condition eventPlayer.isUsingUltimate()
    
    do:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait()
    while RULE_CONDITION