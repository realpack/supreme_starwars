AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
 
function ENT:Initialize()
 
    -- Set up the entity
    self.Entity:SetModel( "models/riddickstuff/bactagrenade/bactanade.mdl" )
 
	self.Entity:PhysicsInit( SOLID_BSP )
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_BSP )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
    self.Entity:SetColor( Color( 255, 255, 255, 255 ) )
        
    self.Index = self.Entity:EntIndex()
        
    local phys = self.Entity:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end
 
function ENT:PhysicsCollide( data, physobj )
	local entowner = self.Entity:GetOwner()
	//util.BlastDamage( self, entowner, self.Entity:GetPos(), 165, 4 )
	local tobeblasted = ents.FindInSphere( self.Entity:GetPos(), 500 )
	for k, v in pairs( tobeblasted ) do
		 
		if v:IsPlayer() then
			
			//if v == entowner then return end
			if ( SERVER ) then
				v:SetHealth( math.min( v:GetMaxHealth(), v:Health() + (v:GetMaxHealth() * .5) ) )
				//v:Kill()
			end				
		end
		
	end
	self.Entity:EmitSound("bacta/bactapop.wav", 75, 50)
	local effectdata = EffectData() 
	effectdata:SetOrigin( self.Entity:GetPos() )
	//effectdata:SetScale( 1 )
	util.Effect("effect_bactanade",effectdata)
	//util.Effect( "HelicopterMegaBomb", effectdata )
	self.Entity:Remove()
end
