ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = "Shield Barrel"
ENT.Author = "pack"
ENT.Category = "SUP | Разработки"

-- ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Stability" )
	self:NetworkVar( "Int", 1, "CircleHealth" )
end

function ENT:Initialize()
	local scale = Vector(4,4,4)
	local shield

	if SERVER then
		self:SetModel('models/props/electricbarrel.mdl')

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		local phys = self.Entity:GetPhysicsObject()
		if TypeID( phys ) == TYPE_PHYSOBJ and phys:IsValid() then
			phys:EnableMotion( false )
			phys:Wake()
		end

		shield = ents.Create('shield_circle')
		shield:SetPos( self:GetPos() )
		shield:SetAngles( self:GetAngles() )
		shield:SetParent( self )

		self:SetUseType( SIMPLE_USE )

		self:SetNWEntity('Shield', shield)

		shield:SpawnShield(scale)

		shield:SetCustomCollisionCheck( true )
		shield:SetCollisionGroup(COLLISION_GROUP_WORLD)

		self.shield = shield
	else
		timer.Simple(.1, function()
			local shield = self:GetNWEntity('Shield')
			if shield.SpawnShield then
				shield:SpawnShield(scale)
			end

			shield:SetCustomCollisionCheck( true )
			shield:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end)
	end

	self:SetStability( 100 )
	self:SetCircleHealth( 2000 )
end
