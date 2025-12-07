#!mainFile "../ggncd_main.opy"

#!define GAMEMODE_VERSION "v1.0.0"
#!define GAMEMODE_NAME "GGNCD - Overwatch 1 Classic Edition"
#!define GAMEMODE_CODE "FHPZ3"
#!define STAGING_CODE "None"
#!define DISCORD_SHORT_LINK "dsc.gg/ow1-classic"
#!define DISCORD_LONG_LINK "discord.gg/G64d9hZbHT"
#!define SOURCE_CODE_LINK "https://github.com/Overwatch-1-Classic/ow1_classic"
macro GAMEMODE_DESCRIPTION = (GAMEMODE_NAME" "GAMEMODE_VERSION"\n"\
                               "\n"\
                               "viper#18545's attempt to accurately recreate ""\n"\
                               "the first version of Overwatch 1 using workshop.""\n"\
                               "\n"\
                               "Gamemode forked from""\n"\
                               "Overwatch 1 Emulator (PBMYC)""\n"\
                               "\n"\
                               "Stable build: "GAMEMODE_CODE"\n"\
                               "Latest build: "STAGING_CODE"\n"\
                               "\n"\
                               "Codebase Contributors:""\n"\
                               "viper#18545""\n"\
                               "ecksdee#11729""\n"\
                               "wadetata#0315""\n"\
                               "\n"\
                               "workshop.codes/ow1-classic""\n"\
                               "\n"\
                               "Discord:""\n"\
                               DISCORD_SHORT_LINK"\n"\
                               DISCORD_LONG_LINK"\n"\
                               "\n"\
                               "Source code:""\n"\
                               SOURCE_CODE_LINK)


rule "Copyright (c) 2025 Overwatch 1 Classic. See https://github.com/arvrianmaybe/classic for license to use this code.":
    # This code has been forked by Overwatch 1 Emulator, Please also check theres https://github.com/Overwatch-1-Emulator/ow1-emulator
    disableScoring()
    disableInspector()

settings {
    "main": {
        "modeName": GAMEMODE_NAME,
        "description": GAMEMODE_DESCRIPTION,
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 0,
        "returnToLobby": "never"
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopIsland",
                "workshopIslandNight"
            ]
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableRandomHeroes": true,
            "respawnTime%": 0,
            "scoreToWin": 44,
            "enableSelfInitiatedRespawn": false
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ammoClipSize%": percent(OW1_ANA_CLIP_SIZE)/(OW2_ANA_CLIP_SIZE),
                "ultGen%": percent(OW2_ANA_ULT_COST/OW1_ANA_ULT_COST)
            },
            "ashe": {
                "ultGen%": percent(OW2_ASHE_ULT_COST/OW1_ASHE_ULT_COST)
            },
            "baptiste": {
                "ability2Cooldown%": percent(OW1_BAPTISTE_LAMP_COOLDOWN_TIME/OW2_BAPTISTE_LAMP_COOLDOWN_TIME),
                "ultGen%": percent(OW2_BAPTISTE_ULT_COST/OW1_BAPTISTE_ULT_COST)
            },
            "bastion": {
                "ability1Cooldown%": percent(OW1_BASTION_RECONFIGURE_COOLDOWN/OW2_BASTION_RECONFIGURE_COOLDOWN),
                "ammoClipSize%": percent(OW1_BASTION_CLIP_SIZE)/(OW2_BASTION_CLIP_SIZE), # Hard code it, workshop sucks.
                "ultGen%": percent(OW2_BASTION_ULT_COST/OW1_BASTION_ULT_COST)
            },
            "brigitte": {
                "shieldBashCooldown%": percent(OW1_BRIGITTE_SHIELD_BASH_COOLDOWN/OW2_BRIGITTE_SHIELD_BASH_COOLDOWN),
                "shieldBashKb%": percent(OW1_BRIGITTE_SHIELD_BASH_KNOCKBACK/OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK),
                "ultGen%": percent(OW2_BRIGITTE_ULT_COST/OW1_BRIGITTE_ULT_COST)
            },
            "cassidy": {
                "ability1Cooldown%": percent(OW1_MCCREE_COMBAT_ROLL_COOLDOWN/OW2_MCCREE_COMBAT_ROLL_COOLDOWN),
                "ability2Cooldown%": percent(OW1_MCCREE_FLASHBANG_COOLDOWN/OW2_MCCREE_FLASHBANG_COOLDOWN),
                "ultGen%": percent(OW2_MCCREE_ULT_COST/OW1_MCCREE_ULT_COST)
            },
            "doomfist": {
                "ammoRegenerationTime%": percent(OW1_DOOMFIST_AMMO_REGEN/OW2_DOOMFIST_AMMO_REGEN),
                "secondaryFireKb%": 0,
                "ultGen%": percent(OW2_DOOMFIST_ULT_COST/OW1_DOOMFIST_ULT_COST)
            },
            "dva": {
                "secondaryFireMaximumTime%": percent(OW1_DVA_MATRIX_DURATION/OW2_DVA_MATRIX_DURATION),
                "secondaryFireRechargeRate%": 500,
                "ultGen%": percent(OW2_DVA_ULT_COST/OW1_DVA_ULT_COST)
            },
            "echo": {
                "ultGen%": percent(OW2_ECHO_ULT_COST/OW1_ECHO_ULT_COST)
            },
            "freja": {
                "ultGen%": percent(OW2_FREJA_ULT_COST/OW1_FREJA_ULT_COST)
            },
            "genji": {
                "ability2Cooldown%": percent(OW1_GENJI_DEFLECT_COOLDOWN/OW2_GENJI_DEFLECT_COOLDOWN),
                "ultDuration%": percent(OW1_GENJI_BLADE_DURATION/OW2_GENJI_BLADE_DURATION),
                "ultGen%": percent(OW2_GENJI_ULT_COST/OW1_GENJI_ULT_COST)
            },
            "hanzo": {
                "ultGen%": percent(OW2_HANZO_ULT_COST/OW1_HANZO_ULT_COST)
            },
            "hazard": {
                "ultGen%": percent(OW2_HAZARD_ULT_COST/OW1_HAZARD_ULT_COST)
            },
            "illari": {
                "ultGen%": percent(OW2_ILLARI_ULT_COST/OW1_ILLARI_ULT_COST)
            },
            "junkerQueen": {
                "secondaryFireCooldown%": percent(OW1_JUNKERQUEEN_BLADE_COOLDOWN/OW2_JUNKERQUEEN_BLADE_COOLDOWN),
                "ultGen%": percent(OW2_JUNKERQUEEN_ULT_COST/OW1_JUNKERQUEEN_ULT_COST)
            },
            "junkrat": {
                "ultGen%": percent(OW2_JUNKRAT_ULT_COST/OW1_JUNKRAT_ULT_COST)
            },
            "juno": {
                "ultGen%": percent(OW2_JUNO_ULT_COST/OW1_JUNO_ULT_COST)
            },
            "kiriko": {
                "ability2Cooldown%": 20,
                "ultGen%": percent(OW2_KIRIKO_ULT_COST/OW1_KIRIKO_ULT_COST)
            },
            "lifeweaver": {
                "ammoClipSize%": percent(OW1_LIFEWEAVER_CLIP_SIZE1)/(OW2_LIFEWEAVER_CLIP_SIZE1),
                "health%": percent(OW1_LIFEWEAVER_PETAL_HP/OW2_LIFEWEAVER_PETAL_HP), # for petal
                "ultGen%": percent(OW2_LIFEWEAVER_ULT_COST/OW1_LIFEWEAVER_ULT_COST)
            },
            "lucio": {
                "ultGen%": percent(OW2_LUCIO_ULT_COST/OW1_LUCIO_ULT_COST)
            },
            "mauga": {
                "ultGen%": percent(OW2_MAUGA_ULT_COST/OW1_MAUGA_ULT_COST)
            },
            "mei": {
                "ability2Cooldown%": percent(OW1_MEI_ICEWALL_COOLDOWN/OW2_MEI_ICEWALL_COOLDOWN),
                "ammoClipSize%": percent(OW1_MEI_CLIP_SIZE/OW2_MEI_CLIP_SIZE),
                "ultGen%": percent(OW2_MEI_ULT_COST/OW1_MEI_ULT_COST)
            },
            "mercy": {
                "ultGen%": percent(OW2_MERCY_ULT_COST/OW1_MERCY_ULT_COST),
                "enablePassive": false
            },
            "moira": {
                "ultGen%": percent(OW2_MOIRA_ULT_COST/OW1_MOIRA_ULT_COST),
                "primaryFireMaximumTime%": percent((OW2_MOIRA_HEAL_GRASP_AMMO_USAGE/OW1_MOIRA_HEAL_GRASP_AMMO_USAGE)*(OW1_MOIRA_HEAL_GRASP_AMMO/OW2_MOIRA_HEAL_GRASP_AMMO)),
            },
            "orisa": {
                "enableInfiniteAmmo": true,
                "ammoClipSize%": percent(OW1_ORISA_CLIP_SIZE/OW2_ORISA_CLIP_SIZE),
                "ultGen%": percent(OW2_ORISA_ULT_COST/OW1_ORISA_ULT_COST)
            },
            "pharah": {
                # "passiveExtraFuel%": 0,
                "ultGen%": percent(OW1_PHARAH_ULT_COST/OW2_PHARAH_ULT_COST)
            },
            "ramattra": {
                "secondaryFireCooldown%": percent(OW1_RAMATTRA_VOID_BARRIER_COOLDOWN/OW2_RAMATTRA_VOID_BARRIER_COOLDOWN),
                "enableInfiniteUlt": true, # for old ult
                "ultGen%": percent(OW2_RAMATTRA_ULT_COST/OW1_RAMATTRA_ULT_COST)
            },
            "reaper": {
                "ultGen%": percent(OW2_REAPER_ULT_COST/OW1_REAPER_ULT_COST)
            },
            "reinhardt": {
                # "health%": percent(OW1_REINHARDT_BARRIER_HEALTH/OW2_REINHARDT_BARRIER_HEALTH), # for barrier
                "secondaryFireRechargeRate%": percent(OW1_REINHARDT_BARRIER_REGEN/OW2_REINHARDT_BARRIER_REGEN),
                "ultGen%": percent(OW2_REINHARDT_ULT_COST/OW1_REINHARDT_ULT_COST)
            },
            "roadhog": {
                "ammoClipSize%": percent(OW1_ROADHOG_CLIP_SIZE/OW2_ROADHOG_CLIP_SIZE),
                "secondaryFireMaximumTime%": percent((OW1_ROADHOG_BREATHER_CAST_TIME+OW1_ROADHOG_BREATHER_DURATION)/OW2_ROADHOG_BREATHER_DURATION),
                "secondaryFireRechargeRate%": 500,
                "ultGen%": percent(OW2_ROADHOG_ULT_COST/OW1_ROADHOG_ULT_COST)
            },
            "sigma": {
                # barrier recharge rate scales with health scalar for some reason
                "secondaryFireRechargeRate%": percent((OW1_SIGMA_BARRIER_REGEN/OW2_SIGMA_BARRIER_REGEN)/(OW1_SIGMA_SHIELDS/OW2_SIGMA_SHIELDS)),
                "ultGen%": percent(OW2_SIGMA_ULT_COST/OW1_SIGMA_ULT_COST),
            },
            "sojourn": {
                "ultGen%": percent(OW2_SOJOURN_ULT_COST/OW1_SOJOURN_ULT_COST)
            },
            "soldier": {
                "ultGen%": percent(OW2_SOLDIER_ULT_COST/OW1_SOLDIER_ULT_COST)
            },
            "sombra": {
                "secondaryFireCooldown%": percent(OW1_SOMBRA_HACK_COOLDOWN_TIME/OW2_SOMBRA_HACK_COOLDOWN_TIME),
                "ultGen%": percent(OW2_SOMBRA_ULT_COST/OW1_SOMBRA_ULT_COST)
            },
            "symmetra": {
                "health%": percent(OW1_SYMMETRA_TURRET_HEALTH/OW2_SYMMETRA_TURRET_HEALTH), # for turret hp
                "ultGen%": percent(OW2_SYMMETRA_ULT_COST/OW1_SYMMETRA_ULT_COST)
            },
            "torbjorn": {
                "ultGen%": percent(OW2_TORBJORN_ULT_COST/OW1_TORBJORN_ULT_COST)
            },
            "tracer": {
                "ultGen%": percent(OW2_TRACER_ULT_COST/OW1_TRACER_ULT_COST)
            },
            "venture": {
                "ultGen%": percent(OW2_VENTURE_ULT_COST/OW1_VENTURE_ULT_COST),
            },
            # "vendetta": {
                # "ultGen%": percent(OW2_VENDETTA_ULT_COST/OW1_VENDETTA_ULT_COST),
            # },
            "widowmaker": {
                "ammoClipSize%": percent(OW1_WIDOWMAKER_CLIP_SIZE/OW2_WIDOWMAKER_CLIP_SIZE),
                "ultGen%": percent(OW2_WIDOWMAKER_ULT_COST/OW1_WIDOWMAKER_ULT_COST)
            },
            "winston": {
                "ammoClipSize%": percent(OW1_WINSTON_CLIP_SIZE/OW2_WINSTON_CLIP_SIZE),
                "ultGen%": percent(OW2_WINSTON_ULT_COST/OW1_WINSTON_ULT_COST)
            },
            "hammond": {
                "ability1Kb%": percent(1/OW2_WRECKING_BALL_FIREBALL_KB),
                "ultGen%": percent(OW2_WRECKING_BALL_ULT_COST/OW1_WRECKING_BALL_ULT_COST),
            },
            "zarya": {
                "ultGen%": percent(OW2_ZARYA_ULT_COST/OW1_ZARYA_ULT_COST),
            },
            "zenyatta": {
                "ultGen%": percent(OW2_ZENYATTA_ULT_COST/OW1_ZENYATTA_ULT_COST)
            },
            "disabledHeroes": [

            ],
            "general": {
                "abilityCooldown%": 0,
                "enableInfiniteAmmo": true,
                "ultGen%": 500,
                "combatUltGen%": 500,
                "passiveUltGen%": 500
            }
        }
    }
}