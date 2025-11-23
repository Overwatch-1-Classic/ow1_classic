#!mainFile "../../dev_main.opy"
# rule "[lifeweaver/tree.opy]: Allow self healing during Tree of Life":
    # @Event eachPlayer
    # @Hero lifeweaver
    # @Condition eventPlayer.isUsingUltimate()

    # pushSelfHealing(Button.ULTIMATE)
    # waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    # popSelfHealing(Button.ULTIMATE)

rule "[lifeweaver/tree.opy]: Launch OW2 Lifeweaver tree health":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMaxHealth(percent(OW1_LIFEWEAVER_TREE_OF_LIFE_HEALTH/OW2_LIFEWEAVER_TREE_OF_LIFE_HEALTH))
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))