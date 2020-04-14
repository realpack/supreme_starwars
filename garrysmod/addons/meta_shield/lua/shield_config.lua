btShield = btShield or {}

-- Lambda Wars Riot Shield
-- http://steamcommunity.com/sharedfiles/filedetails/?l=czech&id=543527096
-- models/pg_props/pg_weapons/pg_cp_shield_w.mdl

-- GLASS RIOT SHIELD MODEL
-- http://steamcommunity.com/sharedfiles/filedetails/?id=149837821
-- models/arleitiss/riotshield/shield.mdl

-- KOREAN POLICE SHIELD MODEL
-- http://steamcommunity.com/sharedfiles/filedetails/?id=223731572
-- models/thswjdals95/policeshield/shield.mdl


-- COMBINE SHIELD MODEL
-- http://steamcommunity.com/sharedfiles/filedetails/?id=117454900
-- models/cloud/ballisticshield_mod.mdl

-- Nogitsu's Police Shield
-- http://steamcommunity.com/sharedfiles/filedetails/?id=667029302
-- models/riotshield/riotshield.mdl

-- Custom HQ Model Support
-- http://steamcommunity.com/sharedfiles/filedetails/?id=897313173
-- models/custom/ballisticshield.mdl

-- PAYDAY2 FBI Shield
-- http://steamcommunity.com/sharedfiles/filedetails/?id=800483635
-- models/payday2/shield_fbi.mdl

btShield.blockSound = {
	"physics/metal/metal_solid_impact_bullet1.wav",
	"physics/metal/metal_solid_impact_bullet2.wav",
	"physics/metal/metal_solid_impact_bullet3.wav",
	"physics/metal/metal_solid_impact_bullet4.wav",
}

/*
	I SUGGEST YOU TO ADD PISTOL/MELEE HOLDTYPE IN THIS LIST
*/
btShield.shieldList = {
	weapon_riotshield = "genericShield",
	weapon_smallcombineshield = "smallCombineShield",
	weapon_combineshield = "combineShield",
	weapon_hqshield = "hqBalistic",
	weapon_smallriotshield = "smallRiot",
}

btShield.dualWield = {
	"sup_cissniper",
	"sup_dc15sa",
	"sup_dc15a",
	"sup_dc15a_21st",
	"sup_dc15s",
	"sup_dc17_dual",
	"sup_dc17mbr",
	"sup_dc17",
	"sup_dc17m_shotgun",
	"sup_dc17m_sniper",
    "sup_dc17antiarmor",
    "sup_de10",
    "sup_e5",
    "sup_e5_bx",
    "sup_e60rv",
    "sup_repat",
    "sup_repshotgun",
    "sup_repsniper",
    "sup_z6",
    "sup_z6_cis",
    "sup_arm5",
    "weapon_defibrillator",
    "weapon_hands",
	"bf2017_dc15aa",
	"bf2017_dc15lee",
	"bf2017_dc15ss",
	"bf2017_dc177",
    "bf2_dlt19",
    "bf2_dlt19x",
    "weapon_hands"
}

// You can change health or something in "game"
// If you touch other things, I can't sure what's going to happen to your server.
// I suggest you not to touch things below except health, regenHealth, regenDelay, brokenRegenDelay.

/*
	health = Health of Shield
	regenHealth = Regeneration Health Amount
	regenDelay = Delay between Regen and Latest Damage on the shield.
	brokenRegenDelay = Amount of time required to recover the shield.
*/
btShield.shieldInfo = {

	hqBalistic = {
		model = "models/swshields/sw_energy_shield.mdl",
		bone = "ValveBiped.Bip01_L_Forearm",
		render = {
			pos = Vector(3, 12, -45),
			ang = Angle(80, 1, 80),
			fpos = Vector(-65, 16, -2),
			fang = Angle(0, 0, 0),
		} ,
		block = {
			pos = Vector(8, 6, -5),
			ang = Angle(0, -10, -10),
			sizex = 35,
			sizey = 70,
		},
		game = {
			health = 13000,
			regenHealth = 9,
			regenDelay = 4,
			brokenRegenDelay = 8,
		},
	},

	smallRiot = {
		model = "models/swshields/sw_trooper_shield.mdl",
		bone = "ValveBiped.Bip01_L_Forearm",
		render = {
			pos = Vector(3, 12, -45),
			ang = Angle(80, 1, 80),
			fpos = Vector(-65, 16, -2),
			fang = Angle(0, 0, 0),
		} ,
		block = {
			pos = Vector(8, 6, -5),
			ang = Angle(0, -10, -10),
			sizex = 35,
			sizey = 70,
		},
		game = {
			health = 13000,
			regenHealth = 9,
			regenDelay = 4,
			brokenRegenDelay = 8,
		},
	},

	-- smallCombineShield = {
	-- 	model = "models/pg_props/pg_weapons/pg_cp_shield_w.mdl",
	-- 	bone = "ValveBiped.Bip01_L_Forearm",
	-- 	render = {
	-- 		pos = Vector(3, 12, -35),
	-- 		ang = Angle(100, 1, -100),
	-- 		fpos = Vector(-53, 16, -4),
	-- 		fang = Angle(0, 180, 0),
	-- 	} ,
	-- 	block = {
	-- 		pos = Vector(6, 10, -5),
	-- 		ang = Angle(0, -10, -10),
	-- 		sizex = 35,
	-- 		sizey = 65,
	-- 	},
	-- 	game = {
	-- 		health = 13000,
	-- 		regenHealth = 9,
	-- 		regenDelay = 4,
	-- 		brokenRegenDelay = 8,
	-- 	},
	-- },

	combineShield = {
		model = "models/swshields/sw_gungan_shield.mdl",
		bone = "ValveBiped.Bip01_L_Forearm",
		render = {
			pos = Vector(3, 16, -40),
			ang = Angle(80, 1, 80),
			fpos = Vector(-52, 16, -2),
			fang = Angle(0, 0, 0),
		} ,
		block = {
			pos = Vector(8, 6, -5),
			ang = Angle(0, -10, -10),
			sizex = 35,
			sizey = 70,
		},
		game = {
			health = 15000,
			regenHealth = 7,
			regenDelay = 4,
			brokenRegenDelay = 8,
		},
	},

	-- genericShield = {
	-- 	model = "models/arleitiss/riotshield/shield.mdl",
	-- 	bone = "ValveBiped.Bip01_L_Forearm",
	-- 	render = {
	-- 		pos = Vector(3, 12, -35),
	-- 		ang = Angle(80, 1, 80),
	-- 		fpos = Vector(-52, 16, -2),
	-- 		fang = Angle(0, 0, 0),
	-- 	} ,
	-- 	block = {
	-- 		pos = Vector(8, 6, -5),
	-- 		ang = Angle(0, -10, -10),
	-- 		sizex = 35,
	-- 		sizey = 70,
	-- 	},
	-- 	game = {
	-- 		health = 15000,
	-- 		regenHealth = 7,
	-- 		regenDelay = 4,
	-- 		brokenRegenDelay = 8,
	-- 	},
	-- },
}



hook.Add("PostGamemodeLoaded", "darkRP_GOGOGO!", function()
	if (DarkRP) then
		DarkRP.createShipment("riotShield", {
			model = "models/arleitiss/riotshield/shield.mdl",
			entity = "weapon_riotshield",
			price = 500,
			amount = 10,
			separate = false,
			pricesep = 200,
			noship = false,
			allowed = {TEAM_GUN}
		})
	end
end)
