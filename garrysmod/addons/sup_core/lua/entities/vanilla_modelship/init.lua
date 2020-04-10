AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self:SetName("Hyperspace")
	self:PhysicsInit( SOLID_VPHYSICS  )
	self:SetMoveType( MOVETYPE_VPHYSICS  )
	self:SetSolid(SOLID_VPHYSICS  )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:KeyValue( key, value )
	if ( key == "Model" ) then
		self:SetModel(value)
	end
end

function ENT:Think()
end

function ENT:OnRemove()
end
