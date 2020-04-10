hook.Add("Move","RopeKnifeMove", function(ply,mv,cmd)
	local ent = ply:GetNWEntity("ClimbingEnt")
	if IsValid( ent ) and ply:GetMoveType() == MOVETYPE_CUSTOM then
		
		local deltaTime = FrameTime()
		local pos = mv:GetOrigin()
		local targetpos = ply:GetNWEntity("ClimbingEnt"):GetPos()
		local maxspeed = ply:GetMaxSpeed()*0.6
		local forward = mv:GetForwardSpeed()/10000
		local vel = mv:GetVelocity()
		
		ply:SetNWInt("MoveSpeed", forward*maxspeed)
		
		local newVelocity = (Vector(0,0,1)*forward*maxspeed)
		local newOrigin = pos + newVelocity * deltaTime
		
		if pos.z >= targetpos.z + 50 and SERVER then
			ply:SetMoveType( MOVETYPE_WALK )
			ply:SetGroundEntity( NULL )
			ply:SetNWEntity("ClimbingEnt", NULL)
			ply:DrawViewModel(true)
			ply:DrawWorldModel(true)
		end
		if pos.z <= ent:GetNWVector("DownHit").z + 5 and ply:KeyDown(IN_BACK) and SERVER then
			newOrigin = newOrigin - ply:GetNWEntity("ClimbingEnt"):GetNWVector("HitNormal"):Angle():Forward()*18
			ply:SetMoveType( MOVETYPE_WALK )
			ply:SetGroundEntity( NULL )
			ply:SetNWEntity("ClimbingEnt", NULL)
			ply:DrawViewModel(true)
			ply:DrawWorldModel(true)
		end
		
		mv:SetVelocity( newVelocity )
		
		mv:SetOrigin( newOrigin )
		
		return true;
	end
end)

function RopeKnifeThink( ply )
	for k,ply in pairs(player.GetAll()) do
		if IsValid(ply:GetNWEntity("ClimbingEnt")) and ply:GetMoveType() == MOVETYPE_CUSTOM then
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) and GetConVar( "gk_enableshooting" ):GetBool() == false then
				wep:SetNextPrimaryFire(CurTime() + 0.5)
				ply:DrawViewModel(false)
				if SERVER then
					ply:DrawWorldModel(false)
				end
			end
		end
	end
end
hook.Add("Think", "RopeKnifeThink", RopeKnifeThink)

function PlayerDieClimb( victim, weapon, killer )
	victim:SetNWEntity("ClimbingEnt", NULL)
end
hook.Add( "PlayerDeath", "PlayerClimbDeath", PlayerDieClimb )

CreateConVar("gk_enableshooting", "0", {FCVAR_ARCHIVE})
CreateConVar("gk_forcefirstperson", "0", {FCVAR_ARCHIVE})
CreateConVar("gk_enabledamage", "1", {FCVAR_ARCHIVE})

if CLIENT then
	if GetConVar("gk_thirdperson") == nil then
		CreateClientConVar("gk_thirdperson", "1", true, true)
	end
	if GetConVar("gk_ropemat") == nil then
		CreateClientConVar("gk_ropemat", "", true, true)
	end
end


local function GKSettingsPanel(panel)
    panel:ClearControls()

	panel:AddControl("CheckBox", {
	    Label = "Thirdperson",
	    Command = "gk_thirdperson"
	})
    
end

local function GKAdminSettingsPanel(panel)
    panel:ClearControls()

	panel:AddControl("CheckBox", {
	    Label = "Shoot while climbing",
	    Command = "gk_enableshooting"
	})
	panel:AddControl("CheckBox", {
	    Label = "Enable grapple damage",
	    Command = "gk_enabledamage"
	})
	panel:AddControl("CheckBox", {
	    Label = "Force First-person",
	    Command = "gk_forcefirstperson"
	})
    
end

local function PopulateGKMenu()
    spawnmenu.AddToolMenuOption("Options", "Grappling Knife", "Grappling Knife", "Settings", "", "", GKSettingsPanel)
	spawnmenu.AddToolMenuOption("Options", "Grappling Knife", "Admin Grappling Knife", "Admin Settings", "", "", GKAdminSettingsPanel)
end
hook.Add("PopulateToolMenu", "GK Cvars", PopulateGKMenu)