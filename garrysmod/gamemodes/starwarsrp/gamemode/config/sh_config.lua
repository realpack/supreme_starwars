--
print('include sh_conifg.lua')

DEFAULT_VOICE_DISTANCE = 400

LOADING_CAM_POS = {
    ['rp_hanamura'] = {
        pos = Vector('-15589.789063 15601.954102 -15487.968750'),
        ang = Angle('-4.514422 137.451080 0.000000')
    },
}

CONTROLPOINT_ICONS = {
    ['Shield'] = Material('sup_ui/backpack.png', 'smooth noclamp'),
    ['Robot'] = Material('meta_ui/genders/robot.png', 'smooth noclamp'),
    ['Falcon'] = Material('sup_ui/metaui/falcon.png', 'smooth noclamp'),
    ['Shield2'] = Material('sup_ui/metaui/metascoreboard/staff.png', 'smooth noclamp'),
    ['User'] = Material('sup_ui/metaui/metascoreboard/user.png', 'smooth noclamp'),
    ['Vip'] = Material('sup_ui/metaui/metascoreboard/vip.png', 'smooth noclamp')
}


HELPPOINTS_TYPES = {
    ['Иконка ВАР'] = {
        color = Color(51,153,255,0),
        icon = Material( 'sup_ui/metaui/republic.png' ),
        sound = 'sup_sound/sound1.mp3'
    },
    ['Иконка Сердца'] = {
        color = Color(214,45,32),
        icon = Material( 'sup_ui/vgui/gicons/health-increase.png' ),
        sound = ''
    }
}

CONTROL_REPUBLIC = 1
CONTROL_CIS = 2
CONTROL_CITIZEN = 3

CONTROLPOINT_TEAMS = {
    [0] = { color = Color(191,191,191,255), name = 'Нейтралитет'},
    [CONTROL_REPUBLIC] = { color = Color(84,144,181,255), name = 'ВАР'},
    [CONTROL_CIS] = { color = Color(255,37,37,255), name = 'КНС'},
    [CONTROL_CITIZEN] = { color = Color(255,165,0,255), name = 'Жители'}
}

SUP_ANIMATIONS = { -- Некоторые закоментил, ибо они ходят при анимации или хуево работают
    ['tlc_animation_chest'] = { name = 'Стойка', time = 10 },
    ['tlc_animation_otjim'] = { name = 'Отжимание', time = 20 },
    ['tlc_animation_prised'] = { name = 'Приседание', time = 0 },
    ['tlc_animation_sdatsya'] = { name = 'Сдаться', time = 0 }, -- Если time = 0, то анимация будет работать когда игрок не сдвитется.
    -- ['tlc_animation_hotbizarabotalo'] = { name = '', time = 2 },
    ['tlc_animation_stoika'] = { name = 'Стойка', time = 10 },
    -- ['tlc_handandhok'] = { name = '', time = 2 },
    -- ['tlc_handofbackhead'] = { name = '', time = 2 },
    -- ['tlc_long'] = { name = '', time = 2 },
    ['tlc_weak'] = { name = 'Слабость', time = 2 },
    ['tlc_cleenerarms'] = { name = 'Отряхнуть Руки', time = 2 },
    ['tlc_die'] = { name = 'Перерезать горло', time = 2 },
    -- ['tlc_lightly_wounded'] = { name = '', time = 2 },
    ['tlc_pafos'] = { name = 'Пафос', time = 0 },
    ['tlc_stop_it_left'] = { name = 'Остановить', time = 0 },
    -- ['pose_ducking01'] = { name = 'Присесть 01', time = 5 },
    -- ['pose_ducking02'] = { name = 'Присесть 02', time = 5 },
    -- ['pose_standing01'] = { name = 'Стойка 01', time = 5 },
    -- ['pose_standing02'] = { name = 'Стойка 02', time = 5 },
    -- ['pose_standing03'] = { name = 'Стойка 03', time = 5 },
    -- ['pose_standing04'] = { name = 'Стойка 04', time = 5 },
    ['wos_genji_dance'] = { name = 'Танец Гендзи', time = 10 },
}

HANDCUFFED_DURATION = 0.5
UN_HANDCUFFED_DURATION = 1

/*
    Notifications
*/

NOTIFY_TYPES = {
    ['yellow'] = Color(221, 174, 100),
    ['red']    = Color(183, 81, 52),
    ['blue']   = Color(123, 168, 196),
    ['green']  = Color(140, 160, 93),
    ['purple'] = Color(176, 100, 149),
    ['cyan']   = Color(136, 219, 216),
}

NOTIFY_DATE_FORMAT = "%H:%M"


timer.Simple(0, function()
    DEFAULT_PLAYER_STATS = {
        ['RunSpeed'] = 225,
        ['WalkSpeed'] = 80,
        ['JumpPower'] = 180
    }
end)

TYPE_CLONE = 1
TYPE_DROID = 3
TYPE_MERCENARY = 4
TYPE_ROOKIE = 5
TYPE_CITIZEN = 6
TYPE_RPDROID = 7
TYPE_ADMIN = 8

DEFAULT_RANKS = {
    [TYPE_CLONE] = 'Кадет',
    [TYPE_RPDROID] = 'Ряд.Модуль-1',
    [TYPE_DROID] = 'Армия Дроидов',
    [TYPE_MERCENARY] = 'Местный',
    [TYPE_ROOKIE] = 'Переобучение',
    [TYPE_CITIZEN] = '',
    [TYPE_ADMIN] = 'Админ-Работяга',
}

ALIVE_RANKS = {
    [TYPE_CLONE] = {
        [1] = 'Кадет',
        [2] = 'Рядовой',
        [3] = 'Рядовой Первого Класса',
        [4] = 'Капрал',
        [5] = 'Мл. Сержант',
        [6] = 'Сержант',
        [7] = 'Ст. Сержант',
        [8] = 'Штаб-Сержант',
        [9] = 'Мл. Лейтенант',
        [10] = 'Лейтенант',
        [11] = 'Ст. Лейтенант',
        [12] = 'Капитан',
        [13] = 'Майор',
        [14] = 'Полковник',
        [15] = 'Коммандер',
        [16] = 'Маршал Коммандер',
        [17] = 'Генерал-Губернатор',
    },
    [TYPE_RPDROID] = {
        [1] = 'Республиканский Дроид',
    },
    [TYPE_DROID] = {
        [1] = 'Армия Дроидов',
    },
    [TYPE_ADMIN] = {
        [1] = 'Админ-Работяга',
    },
    [TYPE_MERCENARY] = {
        [1] = 'Местный',
        [2] = 'Бывалый',
        [3] = 'Умник',
        [4] = 'Продвинутый',
        [5] = 'Уважаемый',
        [6] = 'Профи',
        [7] = 'Главарь',
        [8] = 'Авторитет',
        [9] = 'Хан',
    },
    [TYPE_ROOKIE] = {
        [1] = 'Переобучение',
    },
    [TYPE_CITIZEN] = {
        [1] = '',
    },
}

HIDE_NICKS_RANKS = {
	['Кадет'] = true,
    ['Переобучение'] = true,
	['Рядовой'] = true,
	['Рядовой Первого Класса'] = true,
}

timer.Simple(1, function()
    LEGION_CMDS = {
        [TEAM_OVERWATCH] = {
            ['cadet2'] = true,
        },
    }

    WHITELIST_GROUP_TEAMS = { -- Профессии которыем может выбрать игрок при создании нового персонажа. Кадет обязателен!
        ['founder'] = {
            [TEAM_ASTROMECH] = true,
            [TEAM_MERCENARY] = true,
            [TEAM_SENATOR] = true,
            [TEAM_ARC] = true,
            [TEAM_COMMANDO] = true,
            [TEAM_OVERWATCH] = true,
            [TEAM_CADET] = true,
        },
        ['user'] = {
            [TEAM_CADET] = true,
        },
        ['serverstaff'] = {
            [TEAM_CADET] = true,
            [TEAM_ASTROMECH] = true,
            [TEAM_MERCENARY] = true,
            [TEAM_SENATOR] = true,
            [TEAM_ARC] = true,
            [TEAM_COMMANDO] = true,
            [TEAM_OVERWATCH] = true,
        },
        ['moderator'] = {
            [TEAM_CADET] = true,
            [TEAM_ASTROMECH] = true,
            [TEAM_MERCENARY] = true,
            [TEAM_SENATOR] = true,
            [TEAM_ARC] = true,
            [TEAM_COMMANDO] = true,
            [TEAM_OVERWATCH] = true,
        },
        ['apollo'] = {
            [TEAM_CADET] = true,
            [TEAM_ASTROMECH] = true,
            [TEAM_MERCENARY] = true,
            [TEAM_SENATOR] = true,
            [TEAM_ARC] = true,
            [TEAM_COMMANDO] = true,
        },
        ['thaumiel'] = {
            [TEAM_CADET] = true,
            [TEAM_ASTROMECH] = true,
            [TEAM_MERCENARY] = true,
            [TEAM_SENATOR] = true,
            [TEAM_ARC] = true,
        },
        ['afina'] = {
            [TEAM_CADET] = true,
            [TEAM_ASTROMECH] = true,
            [TEAM_MERCENARY] = true,
            [TEAM_SENATOR] = true,
        },
        ['keter'] = {
            [TEAM_CADET] = true,
            [TEAM_ASTROMECH] = true,
            [TEAM_SENATOR] = true,
        },
        -- ['euclid'] = {
        --     [TEAM_UN] = true,
        --     [TEAM_ASTROMECH] = true,
        --     [TEAM_MERCENARY] = true,
        -- },
    }

    SPAWNPOINTS_CATEGORIES = {
        ['all1'] = { priority = 80, teams = {
                [TEAM_UN] = true,
                [TEAM_CADET] = true,
                [TEAM_OVERWATCH] = true,
                [TEAM_COMMANDO] = true,
                [TEAM_ASTROMECH] = true,
                [TEAM_SENATOR] = true,
                [TEAM_MERCENARY] = true,
                [TEAM_ARC] = true,
                [TEAM_ARF] = true,
                [TEAM_DOOM] = true,
                [TEAM_104] = true,
                [TEAM_501] = true,
                [TEAM_GUARD] = true,
                [TEAM_74] = true,
                [TEAM_7] = true,
                [TEAM_212] = true,
                [TEAM_DON] = true,
                [TEAM_DON4] = true,
                [TEAM_99] = true,
                [TEAM_SQUAD1] = true,
                [TEAM_SQUAD2] = true,
                [TEAM_DON3] = true,
                [TEAM_DON2] = true,
                [TEAM_DON5] = true,
                [TEAM_DON6] = true,
                [TEAM_DON7] = true,
                [TEAM_DON8] = true,
                [TEAM_DON9] = true,
                [TEAM_DON10] = true,
                [TEAM_DON11] = true,
                [TEAM_DON12] = true,
                [TEAM_DON13] = true,
                [TEAM_DON14] = true,
            }
        },
        ['cis'] = { priority = 99, teams = {
                [TEAM_B1] = true,
                [TEAM_B2] = true,
                [TEAM_B1s] = true,
                [TEAM_B1h] = true,
                [TEAM_BX] = true,
                [TEAM_DROIDEKA] = true,
            }
        },
        ['police'] = { priority = 99, teams = {
                [TEAM_POLICE] = true,
            }
        },
        ['citizen'] = { priority = 99, teams = {
                [TEAM_CITIZEN] = true,
            }
        },
        ['212'] = { priority = 99, teams = {
                [TEAM_212] = true,
            }
        },
        ['74'] = { priority = 99, teams = {
                [TEAM_74] = true,
            }
        },
        ['91'] = { priority = 99, teams = {
                [TEAM_91] = true,
            }
        },
        ['187'] = { priority = 99, teams = {
                [TEAM_187] = true,
            }
        },
        ['386'] = { priority = 99, teams = {
                [TEAM_386] = true,
            }
        },
        ['21'] = { priority = 99, teams = {
                [TEAM_21] = true,
            }
        },
        ['41'] = { priority = 99, teams = {
                [TEAM_41] = true,
            }
        },
        ['394'] = { priority = 99, teams = {
                [TEAM_394] = true,
            }
        },
        ['104'] = { priority = 99, teams = {
                [TEAM_104] = true,
            }
        },
        ['612'] = { priority = 99, teams = {
                [TEAM_612] = true,
            }
        },
        ['arf'] = { priority = 99, teams = {
                [TEAM_ARF] = true,
            }
        },
        ['501'] = {
            priority = 99,
            teams = {
                [TEAM_501] = true,
            }
        },
        ['doom'] = { priority = 99, teams = {
                [TEAM_DOOM] = true,
            }
        },
        ['7'] = { priority = 99, teams = {
                [TEAM_7] = true,
            }
        },
        ['un1'] = { priority = 99, teams = {
                [TEAM_UN] = true,
            }
        },
        ['mercenary'] = { priority = 99, teams = {
                [TEAM_MERCENARY] = true,
            }
        },
        ['guard'] = { priority = 99, teams = {
                [TEAM_GUARD] = true,
            }
        },
        ['arc'] = { priority = 99, teams = {
                [TEAM_ARC] = true,
            }
        },
        ['commandos'] = { priority = 99, teams = {
                [TEAM_COMMANDO] = true,
            }
        },
    }

    TEAMS_CANUSE_DEFCONS = {
        [TEAM_OVERWATCH] = true,
        [TEAM_GUARD] = true,
    }

    SPAWNPORTALS_COMMANDERS = { -- Командиры которые могут выставлять кординаты порталов.
        [TEAM_OVERWATCH] = true,
    }
end)

VEHICLES_SPAWNPOINT = {
    [1] = Vector('-6884.345703 2199.484375 197.571655'),
    [2] = Vector('-6448.699707 59.766594 187.051666'),
    [3] = Vector('-8694.668945 72.473869 196.141556'),
}

WHITELIST_ADMINS = { -- Админы которым доступен все профессии.
    ['founder'] = true,
    ['serverstaff'] = true,
    ['commander'] = true,
    ['moderator'] = true
}

GROUPS_RELATION = { -- Максимальное количество пресонажей которое может создать игрок.
    ['user'] = 2,
    ['commander'] = 2,
    ['euclid'] = 2,
    ['keter'] = 2,
    ['afina'] = 3,
    ['thaumiel'] = 4,
    ['apollo'] = 4,
    ['serverstaff'] = 4,
    ['moderator'] = 4,
    ['founder'] = 6,
}


VEHICLES_FEATURES = {
    ['air'] = {
        ['lunasflightschool_v19torrent'] = { -- Если price = 0, то техника доступна в любом случае.
            model = 'models/diggerthings/v19/4.mdl',
            price = 0,
            name = 'Истребитель V-19',
            icon = Material('sup_ui/metaui/falcon.png')
        },
        ['lunasflightschool_laatigunship'] = { -- Если price = 0, то техника доступна в любом случае.
            model = 'models/blu/laat.mdl',
            price = 40000,
            name = 'Транспортник СНДК',
            icon = Material('sup_ui/metaui/falcon.png')
        },
        ['lfs_nbt630'] = { -- Если price = 0, то техника доступна в любом случае.
            model = 'models/sweaw/ships/rep_ntb630_servius.mdl',
            price = 90000,
            name = 'Бомбардировщик NBT630',
            icon = Material('sup_ui/metaui/falcon.png')
        },
    },
    ['land'] = {
        ['tkaro_lfs_tx225'] = {
            model = 'models/tkaro/starwars/vehicle/empire/tx225.mdl',
            price = 0,
            name = 'Легкий Танк TX-130',
            icon = Material('sup_ui/metaui/sandcrawler.png')
        },
        ['tkaro_lfs_tx130'] = {
            model = 'models/tkaro/starwars/vehicle/republic/tx130.mdl',
            price = 60000,
            name = 'Репульсорный TX-130',
            icon = Material('sup_ui/metaui/sandcrawler.png')
        },
    },
}

-- VEHICLES_CISFEATURES = {
--     ['air'] = {
--         ['lunasflightschool_vulturedroid_cis'] = { -- Если price = 0, то техника доступна в любом случае.
--             model = 'models/salza/vulture_droid.mdl',
--             price = 0,
--             name = 'Истребитель Стервятник',
--             icon = Material('sup_ui/metaui/falcon.png')
--         },
--         ['lunasflightschool_droidgunship'] = {
--             model = 'models/syphadias/starwars/gunship.mdl',
--             price = 0,
--             name = 'Транспортник Дроидов HMP',
--             icon = Material('sup_ui/metaui/falcon.png')
--         },
--         ['lunasflightschool_tridroid'] = {
--             model = 'models/salza/droidtrifighter.mdl',
--             price = 25000,
--             name = 'Истребитель Три-Дроид',
--             icon = Material('sup_ui/metaui/falcon.png')
--         },
--     },
--     ['land'] = {
--         ['heracles421_lfs_aat'] = {
--             model = 'models/heracles421/galactica_vehicles/aat.mdl',
--             price = 25000,
--             name = 'AAT Танк',
--             icon = Material('sup_ui/metaui/sandcrawler.png')
--         },
--     },
-- }

SPAWNPORTALS_VECTORS = {
    ['Лусанкия'] = Vector('-5554.279785 -8061.700195 5695.418457'),
    ['Равнины Силы'] = Vector('-7701.724609 -10130.999023 -1467.141479'),
}

DEFAULT_MONEY = 5000

VEHICLES_TYPES = {
    ['air'] = {
        ['arc170v2'] = true,
    },
    ['land'] = {
        ['pommes_atrt'] = true,
    },
}

DEFCON_TYPES = {
    ['Defcon 0']  = { text = 'D0 - Активна фаза сбора у взлётно-посадочных платформ для отправки на боевую / спасательную / гуманитарную миссию.', sound = 'sup_sound/defcon0.wav' },
    ['Defcon 1']  = { text = 'D1 - Объявлена немедленная эвакуация бойцов! Всем немедленно вернуться на точки высадки', sound = 'sup_sound/defcon1.wav' },
    ['Defcon 2']  = { text = 'D2 - Приоритетные места обороны при нападении: Реакторная, Медицинский Блок и Штаб Командования', sound = 'sup_sound/defcon2.wav' },
    ['Defcon 3']  = { text = 'D3 - Ожидание атаки, назначение бойцов на боевые посты. Все клоны должны занять посты и ждать приказов', sound = 'sup_sound/defcon3.wav' },
    ['Defcon 4']  = { text = 'D4 - Всем немедленно приступить к патрулированию по 3 бойца', sound = 'sup_sound/defcon4.wav' },
    ['Defcon 5']  = { text = 'D5 - Военное положение! Максимальная Боевая тревога! Всем бойцам быть готовыми к экстренным ситуациям на поле боя', sound = 'sup_sound/defcon5.wav' },
    ['Defcon 6']  = { text = 'D6 - Стационарный Режим Работы', sound = 'sup_sound/defcon6.wav' },
    ['DefconFIX'] = { text = 'DFIX - Батальону Технической Инженерии приступить к починке жизненно важных систем', sound = 'sup_sound/defconfix.wav' },
    ['DefconMED'] = { text = 'DMED - Всем бойцам немедленно явится на Медицинский Осмотр', sound = 'sup_sound/defconmed.wav' },
    ['Defcon T'] = { text = 'DT - Опасность Вирусного Заражения! Объявлен Карантин! Основные зоны Карантина - Штаб Командования / Карцер / Медицинский Блок' },
}

function formatMoney(int)
    return string.Comma(int)..'РК'
end

JAIL_VECTORS = {
    Vector('-8498.359375 14708.305664 1073.930664'),
}

DEFAULT_FEATURES = {
    ['air'] = false,
    ['buld'] = false,
    ['comm'] = false,
    ['desu'] = false,
    ['gren'] = false,
    ['shield1'] = false,
    ['off'] = false,
    ['hvy'] = false,
    ['snip'] = false,
    ['land'] = false,
    ['specialist'] = false,
    ['med'] = false,
}

timer.Simple(.1,function()
    FEATURES_TO_NORMAL = {
        -- ['air'] = { name = 'Воздушная Техника', weapons = {'repair_tool'} },
        -- ['ground'] = { name = 'Наземная Техника', weapons = {'repair_tool'} },
        ['comm'] = {
            name = 'Связист',
            weapons = {'sup_dc15s', 'm9k_ww2artillery','m9k_orbital_strike'},
        },
        ['med'] = {
            name = 'Медик',
            weapons = {'heal_bacta', 'weapon_defibrillator'},
        },
        ['buld'] = {
            name = 'Строитель',
            weapons = {'sup_repshotgun', 'weapon_baseshield', 'alydus_fortificationbuildertablet'},
        },
        ['snip'] = {
            name = 'Снайпер',
            weapons = {'weapon_rope_knife', 'hook', 'sup_dc15s','sup_repsniper'},
        },
        ['desu'] = {
            name = 'Десантник',
            weapons = {'sup_dc15s', 'weapon_hexshield', 'hook', 'zeus_thermaldet'},
        },
        ['air'] = {
            name = 'Пилот',
            weapons = {'repair_tool', 'alydus_fusioncutter', 'sup_dc15sa'},
        },
        ['land'] = {
            name = 'Водитель',
            weapons = {'repair_tool', 'alydus_fusioncutter', 'sup_dc15sa'},
        },
        ['gren'] = {
            name = 'Гренадёр',
            weapons = {'sup_dc15a', 'sup_repat','sup_repat','m9k_milkormgl'},
        },
        ['shield1'] = {
            name = 'Щитовик',
            weapons = {'zeus_flashbang', 'weapon_smallriotshield','sup_dc15s'},
        },
        ['off'] = {
            name = 'Сапер',
            weapons = {'sup_repat','zeus_flashbang','zeus_smokegranade','zeus_thermaldet','m9k_suicide_bomb','weapon_slam'},
        },
        ['hvy'] = {
            name = 'Тяжёлый',
            weapons = {'sup_dc15a','weapon_hexshield','sup_z6'},
        },
        -- ['arf'] = {
        --     name = 'Разведка',
        --     weapons = {'hook','weapon_hexshield','sup_repsniper','weapon_rope_knife','weapon_rpw_binoculars_nvg'},
        -- },
        ['specialist'] = {
            name = 'Специалист',
            weapons = {'sup_repsniper','weapon_rpw_binoculars_nvg','sup_repat'},
        },
    }
FEATURE_ARMORMODELS = {
        ['snow'] = {
            model = 'models/player/trooper21/21_trp.mdl',
            name = 'Снежная Форма',
            check = function(pPlayer)
    return table.HasValue({TEAM_UN, TEAM_ARF, TEAM_DOOM, TEAM_501, TEAM_212, TEAM_7, TEAM_74, TEAM_104, TEAM_GUARD}, pPlayer:Team())
end
        },
        ['eng'] = {
            model = 'models/player/clone engineer/ccgi engineer.mdl',
            name = 'Форма Инженера',
            check = function(pPlayer)
    return table.HasValue({TEAM_104}, pPlayer:Team())
end
        },
        ['meddd'] = {
            model = 'models/player/bridgestaff/cgibridgestaff.mdl',
            name = 'Форма Медика',
            check = function(pPlayer)
    return table.HasValue({TEAM_74}, pPlayer:Team())
end
        },
        ['meddd2'] = {
            model = 'models/player/med21/21_medic.mdl',
            name = 'Форма Медика (Снежная)',
            check = function(pPlayer)
    return table.HasValue({TEAM_74}, pPlayer:Team())
end
        },
    }
end)
