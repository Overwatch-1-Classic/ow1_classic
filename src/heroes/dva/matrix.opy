#!mainFile "../../dev_main.opy"

playervar defense_matrix_hud_text

macro isUsingDefenseMatrix(player):
    (player.isHoldingButton(Button.ABILITY_2)) \ 
 or player.isHoldingButton(Button.SECONDARY_FIRE) \
 and (not player.isMeleeing()) \
 and (not isCCd(player)) \
 and (player.isAlive())

macro showDefenseMatrixHUD():
    if eventPlayer.defense_matrix_hud_text == null:
    createInWorldText(eventPlayer,
                    "CANCEL {0} |                                                                                                  | {1} CANCEL".format(inputBindingString(Button.PRIMARY_FIRE), inputBindingString(Button.SECONDARY_FIRE)),
                    updateEveryTick(eventPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((0.15 - 0.3) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()),
                    verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))),
                    1.5,
                    Clip.NONE,
                    WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,\
                    Color.WHITE,
                    SpecVisibility.DEFAULT)
    eventPlayer.defense_matrix_hud_text = getLastCreatedText()

macro hideDestroyMatrixHUD():
    destroyInWorldText(eventPlayer.defense_matrix_hud_text)
    eventPlayer.defense_matrix_hud_text = null

rule "[dva/matrix.opy]: OW1 Classic Defense Matrix":
    @Event eachPlayer
    @Hero dva
    @Condition isUsingDefenseMatrix(eventPlayer)

    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)

    showDefenseMatrixHUD()

    waitUntil(isCCd(eventPlayer) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or not eventPlayer.isFiringSecondaryFire(), OW1_DVA_MATRIX_DURATION)
    
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    hideDestroyMatrixHUD()

rule "[dva/matrix.opy]: Set Defense Matrix cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_DVA_MATRIX_COOLDOWN)