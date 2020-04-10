AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.AddNetworkString("Colour")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/wood/wood_boardx4.mdl")
	self:EmitSound("vanilla/turbolaser/vanilla_tl_shot.wav", 511, math.random(95,125))
	self:SetName("Turbolaser")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Phys = self:GetPhysicsObject()
end

function ENT:KeyValue( key, value )
	if ( key == "Force" ) then
		self.Force = value
	end
	if ( key == "Damage" ) then
		self.Damage = value
	end
	if ( key == "Magnitude" ) then
		self.Magnitude = value
	end
	if ( key == "Colour" ) then
		self:SetColour(value)
	end
end

function ENT:PhysicsUpdate()
	if self.Once then
		self:Remove()
	else
		self.Phys:SetVelocity( self:GetForward() * self.Force )
	end
end

function ENT:Think()
end

function ENT:Boom()
	if not self.Once then
		local Pos = self:GetPos()
		local Scale = self.Magnitude * 500
		local effectdata = EffectData()
		effectdata:SetStart( Pos )
		effectdata:SetOrigin( Pos )
		effectdata:SetScale( Scale )
		util.Effect( "Explosion", effectdata )
		util.Effect( "HelicopterMegaBomb", effectdata)
		util.BlastDamage( self, self, self:GetPos(), self.Magnitude, self.Damage )
		self:EmitSound("weapons/explode" .. math.random(3,5) .. ".wav", 400, 100)
	end
	self.Once = true
end

function ENT:PhysicsCollide( data, phys )
	self:Boom()
end
