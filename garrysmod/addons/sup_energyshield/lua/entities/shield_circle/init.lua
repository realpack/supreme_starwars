AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString('SpawnShield')

function ENT:SpawnShield(scale)
	-- local prop = ents.Create( "prop_physics_multiplayer" )
	self:SetModel( Model( "models/props_phx/construct/metal_dome360.mdl" ) )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local min, max = self:GetCollisionBounds()
	self:SetCollisionBounds(min * scale, max * scale)

	local phys = self:GetPhysicsObject()
	if TypeID( phys ) == TYPE_PHYSOBJ and phys:IsValid() then
		local physmesh = phys:GetMeshConvexes()
		if istable( physmesh ) or #physmesh < 1 then
			for convexkey, convex in pairs( physmesh ) do
				for poskey, postab in pairs( convex ) do
					convex[ poskey ] = postab.pos * scale
				end
			end
		end

		self:PhysicsInitMultiConvex( physmesh )

		-- print(phys)
		local phys = self:GetPhysicsObject()
		phys:SetPos( self:GetPos() )
		phys:SetAngles( self:GetAngles() )
		phys:EnableMotion( false )

		phys:SetDamping( 0, 0 )
		phys:Wake()
	end

	self:SetMaterial( "models/effects/vol_light001" )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )

	self:EnableCustomCollisions( true )
	self:CollisionRulesChanged()

	-- prop:SetNoDraw( true )

	-- timer.Simple(.2, function()
	-- 	prop:SetNoDraw( false )
	-- end)
end

-- -- Entity:GetCollisionBounds()
-- -- ent:GetRenderBounds()