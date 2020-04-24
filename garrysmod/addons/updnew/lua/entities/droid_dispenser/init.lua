
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	local skytrace = {}
		skytrace.start = tr.HitPos
		skytrace.endpos = tr.HitPos + Vector(0, 0, 65000)
		skycheck = util.TraceLine(skytrace)
	if !skycheck.HitSky then
		return
	end

	local Pos = tr.HitPos
	if Pos.x >= 0 then
		if math.fmod(Pos.x, 80) >= 40 then
			Pos.x = math.floor(Pos.x/80) * 80 + 80
		else
			Pos.x = math.floor(Pos.x/80) * 80
		end
	else
		if math.fmod(math.abs(Pos.x),80) >= 40 then
			Pos.x = -math.floor(math.abs(Pos.x)/80) * 80 - 80
		else
			Pos.x = -math.floor(math.abs(Pos.x)/80) * 80
		end
	end
	if Pos.y >= 0 then
		if math.fmod(Pos.y, 80) >= 40 then
			Pos.y = math.floor(Pos.y/80) * 80 + 80
		else
			Pos.y = math.floor(Pos.y/80) * 80
		end
	else
		if math.fmod(math.abs(Pos.y),80) >= 40 then
			Pos.y = -math.floor(math.abs(Pos.y)/80) * 80 - 80
		else
			Pos.y = -math.floor(math.abs(Pos.y)/80) * 80
		end
	end
	Pos.z = Pos.z

	local ent = ents.Create("droid_dispenser")

	ent:SetPos(Pos + Vector(0, 0, 3600))
	ent:SetAngles(Angle(0, 0, 0))
	ent:Spawn()
	ent:Activate()

	return ent
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	local model = ("models/props/starwars/vehicles/bd_dispenser.mdl")
	
	self.Entity:SetModel(model)
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(true)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end





	self.Collided = false
	
	timer.Simple(2.6, function() self:EmitSound("sanctum2/towers/tower_entry"..math.random(1,2)..".ogg", 150, math.Rand(80,120)) end)

end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
local poorbastards = {
	"npc_citizen",
	"npc_alyx",
	"npc_barney",
	"npc_kleiner",
	"npc_mossman",
	"npc_eli",
	"npc_gman",
	"npc_breen",
	"npc_monk",
	"npc_combine_s",
	"npc_metropolice",
	"npc_zombine",
	"npc_poisonzombine",
	}
function ENT:PhysicsCollide(data, phys)

	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end

	local angle = self.Entity:GetAngles()

	if !data.HitEntity:IsValid() then
		self:CollideEffect()
		self.Collided = true
		if (math.abs(angle.r) < 45) then
			phys:EnableMotion(false)
			phys:Sleep()
		end
	elseif data.HitEntity:IsValid() then
		if table.HasValue(poorbastards, string.lower(data.HitEntity:GetClass())) or data.HitEntity:IsPlayer() then
			if !self.Collided then
				local effectdata = EffectData()
				effectdata:SetScale(1.6)
				effectdata:SetOrigin(data.HitEntity:GetPos() + Vector(0, 0, -32))
				util.Effect("m9k_gdcw_s_blood_cloud", effectdata)
			end
		end
		
		if !data.HitEntity:IsPlayer() and (math.abs(angle.r) < 15) then
			if data.HitEntity:GetClass() != "prop_vehicle_jeep" then
				if !self.Collided then
					data.HitEntity:Remove()
				end
			end
		end
	end
	
end

function ENT:CollideEffect()

	if self.Collided then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() + Vector(0, 0, 0))
		effectdata:SetEntity(self.Entity)		// Who done it?
		effectdata:SetScale(0.8)
		effectdata:SetMagnitude(50)			// Length of explosion trails
	util.Effect("m9k_gdcw_s_boom", effectdata)
	util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 96, 200 )
	util.ScreenShake(self.Entity:GetPos(), 16, 250, 1, 512)
	self.Entity:EmitSound("sanctum2/towers/tower_impact"..math.random(1,3)..".ogg", 150, math.Rand(80,120))

end

