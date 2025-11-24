#!mainFile "../../dev_main.opy"


rule "[pharah/concussive.opy]: Rocket no self damage & better kb":
    @Event playerDealtDamage
    @Hero pharah
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker == victim

    heal(victim, null, eventDamage)
