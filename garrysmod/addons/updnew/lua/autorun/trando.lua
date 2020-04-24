player_manager.AddValidModel( "pm_trando_bossk", "models/trando_bossk/pm_trando_bossk.mdl" )

local NPC = {
	Name = "Bossk (Friendly)",
	Class = "npc_citizen",
	Category = "CGI Bossk",
	Model = "models/trando_bossk/npc_trando_bossk_f.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_trando_bossk_f", NPC )


local NPC = {
	Name = "Bossk (Hostile)",
	Class = "npc_combine_s",
	Category = "CGI Bossk",
	Model = "models/trando_bossk/npc_trando_bossk_h.mdl"
}
list.Set( "NPC", "npc_trando_bossk_h", NPC )