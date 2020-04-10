AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )

function ENT:Initialize()
	self.Entity:SetModel( "models/weapons/w_knife_t.mdl" )
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.StartTime = CurTime()
end

function ENT:Use( activator, caller )
end

function ENT:Touch( ent )
end

function ENT:OnRemove()
end

function ENT:Think()
	if !self:GetNWBool("Stuck") and self.StartTime + 4 < CurTime() then
		local phys = self:GetPhysicsObject()
		phys:AddVelocity( Vector(0,0,-350) )
	elseif !self:GetNWBool("Stuck") and self.StartTime + 2 < CurTime() then
		local phys = self:GetPhysicsObject()
		phys:EnableGravity(true)
	end
	if !self:GetNWBool("Stuck") then return end
	if self:GetNWBool("Useless") then return end
	local pos = self:GetPos()
	
	local line = {}
	line.start = pos
	line.endpos = pos + Vector(0,0,-16000)
	line.filter = {self}
	
	local tr = util.TraceLine( line )
	
	if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:KeyDown(IN_USE) and ( !tr.Entity.NextUse or tr.Entity.NextUse < CurTime() ) then
		tr.Entity.NextUse = CurTime() + 0.5
		if tr.Entity:GetMoveType() == MOVETYPE_CUSTOM then
			tr.Entity:SetMoveType(MOVETYPE_WALK)
			tr.Entity:SetGroundEntity( NULL )
			tr.Entity:SetNWEntity("ClimbingEnt", NULL)
			local pos = tr.Entity:GetPos()
			pos.x = self:GetPos().x
			pos.y = self:GetPos().y
			tr.Entity:SetPos( pos - self:GetNWVector("HitNormal"):Angle():Forward()*18 )
			tr.Entity:DrawViewModel(true)
			tr.Entity:DrawWorldModel(true)
		else
			tr.Entity:SetMoveType( MOVETYPE_CUSTOM )
			tr.Entity:SetGroundEntity( NULL )
			tr.Entity:SetNWEntity("ClimbingEnt", self)
			if self:GetNWBool("MultiAngle") then
				local pos = tr.Entity:GetPos()
				pos.x = self:GetPos().x
				pos.y = self:GetPos().y
				local ang = tr.Entity:EyeAngles()
				ang.p = 0
				ang.r = 0
				tr.Entity:SetPos( pos - ang:Forward()*14 )
				tr.Entity:SetNWVector("ClimbNormal", ang:Forward())
			else
				local pos = tr.Entity:GetPos()
				pos.x = self:GetPos().x
				pos.y = self:GetPos().y
				tr.Entity:SetPos( pos - self:GetNWVector("HitNormal"):Angle():Forward()*14 )
			end
			if GetConVar( "gk_enableshooting" ):GetBool() == false then
				tr.Entity:DrawViewModel(false)
				tr.Entity:DrawWorldModel(false)
			end
		end
	end
end

function ENT:OnRemove()
	for k,ply in pairs(player.GetAll()) do
		if ply:GetNWEntity("ClimbingEnt") == self then
			ply:SetMoveType(MOVETYPE_WALK)
			ply:SetGroundEntity( NULL )
			ply:SetNWEntity("ClimbingEnt", NULL)
			ply:DrawViewModel(true)
			ply:DrawWorldModel(true)
		end
	end
end

hook.Add("PlayerNoClip", "NoclipRope", function( pl )
	local oldstate = pl:GetMoveType()
	if oldstate == MOVETYPE_CUSTOM and IsValid(pl:GetNWEntity("ClimbingEnt")) then
		pl:SetMoveType(MOVETYPE_WALK)
		pl:SetGroundEntity( NULL )
		local pos = pl:GetPos()
		pos.x = pl:GetNWEntity("ClimbingEnt"):GetPos().x
		pos.y = pl:GetNWEntity("ClimbingEnt"):GetPos().y
		pl:SetPos( pos - pl:GetNWEntity("ClimbingEnt"):GetNWVector("HitNormal"):Angle():Forward()*18 )
		pl:SetNWEntity("ClimbingEnt", NULL)
		pl:DrawViewModel(true)
		pl:DrawWorldModel(true)
	end
end)