
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/t3m4/empprimed.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	
	-- Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetNetworkedString("Owner", "World")
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.timer = CurTime() + 3
end

local exp

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
	if self.timer < CurTime() then
	self:Explosion()
	self.Entity:Remove()
	end
end

/*---------------------------------------------------------
HitEffect
---------------------------------------------------------*/
function ENT:HitEffect()
	for k, v in pairs ( ents.FindInSphere( self.Entity:GetPos(), 600 ) ) do
		if v:IsValid() && v:IsPlayer() then
		end
	end
end
/*---------------------------------------------------------
Explosion
---------------------------------------------------------*/
function ENT:Explosion()

	local entpos = self.Entity:GetPos() 
	local entindex = self.Entity:EntIndex()

	timer.Create("tesla_zap" .. entindex,math.Rand(0.03,0.1),math.random(5,10),function()
	local lightning = ents.Create( "point_tesla" )
		lightning:SetPos(entpos)
		lightning:SetKeyValue("m_SoundName", "")
		lightning:SetKeyValue("texture", "sprites/bluelight1.spr")
		lightning:SetKeyValue("m_Color", "255 255 150")
		lightning:SetKeyValue("m_flRadius", "150")
		lightning:SetKeyValue("beamcount_max", "15")
		lightning:SetKeyValue("thick_min", "15")
		lightning:SetKeyValue("thick_max", "30")
		lightning:SetKeyValue("lifetime_min", "0.15")
		lightning:SetKeyValue("lifetime_max", "0.4")
		lightning:SetKeyValue("interval_min", "0.15")
		lightning:SetKeyValue("interval_max", "0.25")
		lightning:Spawn()
		lightning:Fire("DoSpark", "", 0)
		lightning:Fire("kill", "", 0.2)

	local light = ents.Create("light_dynamic")
		light:SetPos( entpos )
		light:Spawn()
		light:SetKeyValue("_light", "100 100 255")
		light:SetKeyValue("distance","550")
		light:Fire("Kill","",0.20)


	sound.Play( "k_lab.teleport_spark" , entpos,110)
	end)

	for k, v in pairs ( ents.FindInSphere( self.Entity:GetPos(), 150 ) ) do
		if v:IsValid() && v:IsPlayer() then
			v:SetArmor( 0 )
			v:TakeDamage(  math.random( 15, 30 ),  self.GrenadeOwner , self.Entity )
			v:SetMoveType(MOVETYPE_NONE)

       			v:ConCommand("pp_motionblur 1")
 
			timer.Simple(5, function()

				v:SetMoveType(MOVETYPE_WALK)

				v:ConCommand("pp_motionblur 0")
			end)
		elseif v:IsValid() && v:IsNPC() then
			local npc = v:GetClass()
			if npc == "npc_antlionguard" || npc == "npc_antlion" || npc == "npc_zombie"
			||  npc == "npc_citizen" || npc == "npc_rebel" || npc == "npc_zombie"
			|| npc == "npc_poisonzombie" || npc == "npc_fastzombie_torso" || npc == "npc_fastzombie"
			|| npc == "npc_headcrab" || npc == "npc_headcrab_black" then
				v:TakeDamage(  math.random( 1, 2 ),  self.GrenadeOwner , self.Entity )

			else
				v:TakeDamage(  math.random( 100, 200 ),  self.GrenadeOwner , self.Entity )
			end

		end
	end
end
/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
end


/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use( activator, caller, type, value )
end


/*---------------------------------------------------------
StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
end


/*---------------------------------------------------------
EndTouch
---------------------------------------------------------*/
function ENT:EndTouch( entity )
end


/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
end