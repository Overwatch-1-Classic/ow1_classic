#!mainFile "../../dev_main.opy"


# rule "[moira/biotic_grasp.opy]: Allow self healing during Biotic Grasp":
#     @Event playerDealtDamage
#     @Hero moira
#     @Condition eventAbility == Button.SECONDARY_FIRE

#     pushSelfHealing(Button.SECONDARY_FIRE)
#     wait(1)
#     popSelfHealing(Button.SECONDARY_FIRE)