#!mainFile "../../dev_main.opy"


# rule "[moira/biotic_orb.opy]: Allow self healing during Biotic Orb":
#     @Event eachPlayer
#     @Hero moira
#     @Condition eventPlayer.isUsingAbility2()
#     @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

#     pushSelfHealing(Button.ABILITY_2)
#     wait(7, Wait.IGNORE_CONDITION)
#     popSelfHealing(Button.ABILITY_2)

rule "[moira/biotic_orb.opy]: Always set to damage orb":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility2()

    do:
        eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        wait()
    while RULE_CONDITION