local Category = "SUP NPCs / Сепаратисты"
local Category = "SUP NPCs / Разное"
local Category = "SUP NPCs / Разное"

list.Add( "NPCUsableWeapons", { class = "tfa_swch_e5",	title = "E5" }  )
list.Add( "NPCUsableWeapons", { class = "tfa_swch_ee3",	title = "EE3" }  )

local NPC = { Name = "Умбаранец 1 (Мир)", 
Class = "npc_citizen", 
Model = "models/player/trooper/f_npc_cctrooper.mdl", 
Health = "100", 
KeyValues = { citizentype = 4 }, 
Category = "SUP NPCs / Сепаратисты" } 
list.Set( "NPC", "npc_gumbarangeneral", NPC )

local NPC = { Name = "Умбаранец 1 (Враг)", 
Class = "npc_combine_s", 
Model = "models/npc_eng_gen/npc_coruscant_eng_gen_f.mdl", 
Squadname = "umbaranunit", 
Numgrenades = "5", 
Category = "SUP NPCs / Сепаратисты" } 
list.Set( "NPC", "npc_bnpcumbarangeneral", NPC )

local NPC = { Name = "Умбаранец 2 (Мир)", 
Class = "npc_citizen", 
Model = "models/player/icefusenetworks/gnpcifnumbaran.mdl", 
Health = "100", 
KeyValues = { citizentype = 4 }, 
Category = "SUP NPCs / Сепаратисты" } 
list.Set( "NPC", "npc_gumbaran", NPC )

local NPC = { Name = "Умбаранец 2 (Враг)", 
Class = "npc_citizen", 
Model = "models/npc_b1/npc_droid_cis_b1_f.mdl", 
Squadname = "umbaranunit", 
Numgrenades = "5", 
Category = "SUP NPCs / Сепаратисты" } 
list.Set( "NPC", "npc_bumbaran", NPC )

local NPC = {
	Name = "B1 Дроид",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Сепаратисты",
	Model = "models/tfa/comm/gg/npc_comb_sw_droid_b1.mdl"
}
list.Set( "NPC", "npc_sw_droid_commando_h", NPC )

local NPC = {
	Name = "B1 Дроид OOM",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Сепаратисты",
	Model = "models/npc_b1_co/npc_droid_cis_b1_co_h.mdl"
}
list.Set( "NPC", "npc_sw_droid_commander_h", NPC )

local NPC = {
	Name = "BX Дроид",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Сепаратисты",
	Model = "models/tfa/comm/gg/npc_comb_sw_droid_commando.mdl"
}
list.Set( "NPC", "npc_sw_droid_b2_h", NPC )


local NPC = {
	Name = "B2 Дроид",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Сепаратисты",
	Model = "models/tfa/comm/gg/npc_comb_sw_droid_b2.mdl"
}
list.Set( "NPC", "npc_sw_droid_b2_h_gv", NPC )

-- list.Add( "NPCUsableWeapons", { class = "b2_gun",	title = "B2 Ручной Бластер" }  )
-- list.Add( "NPCUsableWeapons", { class = "b2_cannon",	title = "B2 Ракетница" }  )

local NPC =
{
	Name = "Аква-Дроид (Мир)",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/player/valley/npc/aquadroidnpc.mdl",
	Health = "1000",
	Category = "SUP NPCs / Дроиды"
}
list.Set( "NPC", "npc_valley_aquadf", NPC )

local NPC =
{
	Name = "Аква-Дроид (Враг)",
	Class = "npc_combine_s",
	Model = "models/player/valley/npc/aquadroidnpc.mdl",
	Health = "1000",
	Category = "SUP NPCs / Дроиды"
}
list.Set( "NPC", "npc_valley_aquade", NPC )

-- local NPC = {
-- 	Name = "B1 Тренировочный Дроид",
-- 	Class = "npc_citizen",
-- 	Category = "SUP NPCs / Дроиды",
-- 	Model = "models/npc_b1_training/npc_droid_cis_b1_training_f.mdl",
-- 	KeyValues = { citizentype = CT_UNIQUE }
-- }
-- list.Set( "NPC", "npc_sw_t_droid_b1_f", NPC )

-- local NPC = {
-- 	Name = "B1 Тренировочный Дроид",
-- 	Class = "npc_combine_s",
-- 	Category = "SUP NPCs / Дроиды",
-- 	Model = "models/npc_b1_training/npc_droid_cis_b1_training_h.mdl"
-- }
-- list.Set( "NPC", "npc_sw_t_droid_b1_h", NPC )

-- local NPC = {
-- 	Name = "B1 Тяжёлый Дроид",
-- 	Class = "npc_combine_s",
-- 	Category = "SUP NPCs / Дроиды",
-- 	Model = "models/npc_b1_security/npc_droid_cis_b1_security_h.mdl"
-- }
-- list.Set( "NPC", "npc_sw_g_droid_b1_h", NPC )

-- local NPC = {
-- 	Name = "B1 Боевой Дроид",
-- 	Class = "npc_combine_s",
-- 	Category = "SUP NPCs / Дроиды",
-- 	Model = "models/npc_b1/npc_droid_cis_b1_h.mdl"
-- }
-- list.Set( "NPC", "npc_sw_droid_b1_h", NPC )

local NPC =
{
	Name = "Ночная Сестра (Мир)",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/player/valley/gotal/f_npc_gotal.mdl",
	Health = "1000",
	Category = "SUP NPCs / Разное"
}
list.Set( "NPC", "npc_valley_nightsf", NPC )

local NPC =
{
	Name = "Ночная Сестра (Враг)",
	Class = "npc_combine_s",
	Model = "models/player/valley/npc/night_sisternpc.mdl",
	Health = "1000",
	Category = "SUP NPCs / Разное"
}
list.Set( "NPC", "npc_valley_nightse", NPC )


local NPC = {
	Name = "Трандошанин 1",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Трандошане",
	Model = "models/tfa/comm/gg/npc_comb_sw_droid_commando.mdl"
}
list.Set( "NPC", "npc_sw_tbh_v1s1h", NPC )

local NPC = {
	Name = "Трандошанин 2",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Трандошане",
	Model = "models/tfa/comm/gg/npc_cit_sw_droid_b2.mdl"
}
list.Set( "NPC", "npc_sw_tbh_v1s2h", NPC )

local NPC = {
	Name = "Трандошанин 3",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Трандошане",
	Model = "models/tfa/comm/gg/npc_cit_sw_droid_b1.mdl"
}
list.Set( "NPC", "npc_sw_tbh_v2s1h", NPC )

local NPC = {
	Name = "Трандошанин 4",
	Class = "npc_combine_s",
	Category = "SUP NPCs / Трандошане",
	Model = "models/tfa/comm/gg/npc_comb_sw_droid_tactical.mdl"
}
list.Set( "NPC", "npc_sw_tbh_v2s2h", NPC )