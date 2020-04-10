include('shared.lua')

include('shared.lua')

local icon_size = 200
local mat_wep = Material('sup_ui/vgui/gicons/armor-vest.png', 'smooth noclamp')

function ENT:Draw()
	if self.prop_effect then
		self.prop_scale_lerp = LerpVector( FrameTime()*2, self.prop_scale_lerp or Vector( 0, 0, 0 ), self.prop_scale * .7 or Vector( 0, 0, 0 ) )

		local m = Matrix()
		m:Scale( self.prop_scale_lerp )

		self.prop_effect:SetLOD( 0 )
		self.prop_effect:EnableMatrix( "RenderMultiply", m )
	end

	self:DrawModel()
end

function ENT:SpawnShield(scale)
	self.prop_effect = ClientsideModel( 'models/effects/hexshield.mdl', RENDERGROUP_OTHER )
	self.prop_effect:SetParent( self )
	self.prop_effect:SetPos( self:GetPos() )
	self.prop_effect:SetAngles( self:GetAngles() )

	self.prop_scale = scale
	self.prop_scale_lerp = Vector(0, 0, 0)

	self:SetModel( Model( "models/props_phx/construct/metal_dome360.mdl" ) )

	-- self:SetNoDraw( true )
	self:SetParent( self )
	self:SetPos( self:GetPos() )
	self:SetAngles( self:GetAngles() )

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

	local min, max = self:GetRenderBounds()
	self:SetRenderBounds( min * scale, max * scale )
	self:DestroyShadow()
	self:EnableCustomCollisions( true )
end

function ENT:OnRemove()
	self.prop_effect:Remove()
end