#!mainFile "../../dev_main.opy"

#!include "nemesis.opy"
# !include "vortex.opy"
#!include "annahilation.opy"

def initRamattra():
    @Name "[ramattra/init.opy]: initRamattra()"

    setCustomHp(OW1_RAMATTRA_HEALTH, OW1_RAMATTRA_ARMOR, OW1_RAMATTRA_SHIELDS)
    setUltCost(OW1_RAMATTRA_ULT_COST)

    # removeTankPassive()
    removeSelfHealing()

rule "[ramattra/init.opy]: Clean up Ramattra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.RAMATTRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.RAMATTRA, Math.INFINITY)
    stopAnnihilation()

rule "[ramattra/init.opy]: OW1 Ramattra barrier health":
    @Event eachPlayer
    @Hero ramattra
    @Condition not eventPlayer.isInAlternateForm()
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setMaxHealth(percent(OW1_RAMATTRA_BARRIER_HEALTH/OW2_RAMATTRA_BARRIER_HEALTH))
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))

# rule "[ramattra/init.opy]: Set armour during nemesis or annahilation":
    # @Event eachPlayer
    # @Hero ramattra
    # @Condition eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()

    # eventPlayer.addHealthPool(Health.ARMOR, OW1_RAMATTRA_NEMESIS_ARMOR, true, true)
    # eventPlayer.annahilation_armour = getLastCreatedHealthPool()
    # waitUntil(not eventPlayer.isUsingAbility1() or not eventPlayer.isUsingUltimate(), Math.INFINITY)
    # removeHealthPool(eventPlayer.annahilation_armour)