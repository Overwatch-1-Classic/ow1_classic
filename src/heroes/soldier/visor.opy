#!mainFile "../../dev_main.opy"

rule "[soldier/visor.opy]: Disable headshot even when aiming manually":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate()
    # @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventWasCriticalHit

    heal(victim, null, eventDamage*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE*2/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE*2)-eventDamage)
