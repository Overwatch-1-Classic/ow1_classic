#!mainFile "../../dev_main.opy"

rule "[tracer/pulse_bomb.opy]: Deal OW1 tracer Pulse Bomb damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.ULTIMATE

    damage(victim, attacker, eventDamage*(OW1_TRACER_PULSE_BOMB_DAMAGE/OW2_TRACER_PULSE_BOMB_DAMAGE)-eventDamage)