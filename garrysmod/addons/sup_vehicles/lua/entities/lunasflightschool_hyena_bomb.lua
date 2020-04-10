AddCSLuaFile()

ENT.Type            = "anim"

ENT.Model = "models/bomb/helfire.mdl"
ENT.Mass = 20
ENT.DMG = 200
ENT.DMGDist = 700
ENT.IdleSound = "lfs/hyenabomber/bombs/bomb_whistle.wav"
ENT.ExplodeSound = "lfs/hyenabomber/bombs/bomb_explosion" .. math.random(1,5) .. ".wav"

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Attacker" )
	self:NetworkVar( "Entity",1, "Inflictor" )
	self:NetworkVar( "Float",0, "StartVelocity" )
	self:NetworkVar( "Bool",1, "CleanMissile" )
	self:NetworkVar( "Bool",2, "DirtyMissile" )
	self:NetworkVar( "Bool",0, "Disabled" )
end

function ENT:BlindFire()
		if self:GetDisabled() then return end
		
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:SetVelocityInstantaneous( self:GetForward() * (self:GetStartVelocity() + 3000) )
	end
end



if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )



		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 20 )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:PhysWake()
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:EnableGravity( true ) 
			pObj:SetMass(self.Mass) 
		end
		
		self.SpawnTime = CurTime()
	end

	function ENT:Think()	
		local curtime = CurTime()
		self:NextThink(curtime)
		
		if self.Explode then
			local Inflictor = self:GetInflictor()
			local Attacker = self:GetAttacker()
			util.BlastDamage( IsValid( Inflictor ) and Inflictor or Entity(0), IsValid( Attacker ) and Attacker or Entity(0), self:GetPos(),self.DMGDist,self.DMG)
			
			self:Remove()
		end
		
		if (self.SpawnTime + 35) < curtime then
			self:Remove()
		end
		
		return true
	end

	function ENT:PhysicsCollide( data )
		self.Explode = true
	end

	function ENT:OnTakeDamage( dmginfo )	

	end
else

	function ENT:Initialize()	
		self.Emitter = ParticleEmitter( self:GetPos(), false )
		
		self.Materials = {
			"particle/smokesprites_0001",
			"particle/smokesprites_0002",
			"particle/smokesprites_0003",
			"particle/smokesprites_0004",
			"particle/smokesprites_0005",
			"particle/smokesprites_0006",
			"particle/smokesprites_0007",
			"particle/smokesprites_0008",
			"particle/smokesprites_0009",
			"particle/smokesprites_0010",
			"particle/smokesprites_0011",
			"particle/smokesprites_0012",
			"particle/smokesprites_0013",
			"particle/smokesprites_0014",
			"particle/smokesprites_0015",
			"particle/smokesprites_0016"
		}
		
		self.snd = CreateSound(self,self.IdleSound)
		self.snd:Play()
	end

local mat = Material( "sprites/light_glow02_add" )
	function ENT:Draw()
		self:DrawModel()
		
		if self.Disabled then return end
		
		local pos = self:GetPos()
				--particle:SetColor( 138,43,225 )

		local r = 255
		local g = 40
		local b = 100
		
		render.SetMaterial( mat )
		
		if self:GetCleanMissile() then
			r = 0
			g = 127
			b = 255
			
			for i =0,10 do
				local Size = (10 - i) * 25.6
				render.DrawSprite( pos - self:GetForward() * i * 5, Size, Size, Color( r, g, b, 255 ) )
			end
			

		end
		
		render.DrawSprite( pos, 256, 256, Color( r, g, b, 255 ) )
	end

function ENT:Think()
		local curtime = CurTime()
		
		self.NextFX = self.NextFX or 0
		
		if self.NextFX < curtime then
			self.NextFX = curtime + 0.02
			
			local pos = self:LocalToWorld( Vector(-8,0,0) )
			
			if self:GetDisabled() then 
				if not self.Disabled then
					self.Disabled = true
					
					if self.snd then
						self.snd:Stop()
					end
				end
				
				self:doFXbroken( pos )
				
				return
			end
			
			self:doFX( pos )
		end
		
		return true
	end

	function ENT:doFX( pos )
		local emitter = self.Emitter
		if not emitter then return end
	

			if not self:GetCleanMissile() then
				local particle = emitter:Add( self.Materials[math.random(1, table.Count(self.Materials) )], pos )
				
				if particle then
					particle:SetGravity( Vector(0,0,100) + VectorRand() * 50 ) 
					particle:SetVelocity( -self:GetForward() * 500  )
					particle:SetAirResistance( 600 ) 
					particle:SetDieTime( math.Rand(4,6) )
					particle:SetStartAlpha( 150 )
					particle:SetStartSize( math.Rand(6,12) )
					particle:SetEndSize( math.Rand(40,90) )
					particle:SetRoll( math.Rand( -1, 1 ) )
					particle:SetColor( 50,50,50 )
					particle:SetCollide( false )
				end
			end
			
			local particle = emitter:Add( "particles/flamelet"..math.random(1,5), pos )
			if particle then
				particle:SetVelocity( -self:GetForward() * 300 + self:GetVelocity())
				particle:SetDieTime( 0.1 )
				particle:SetAirResistance( 0 ) 
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( 4 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(-1,1) )
				particle:SetColor( 255,255,255 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )
		end
	end

	function ENT:OnRemove()
		
		local Pos = self:GetPos()
		
		self:Explosion( Pos + self:GetVelocity() / 20 )
		
		local random = math.random(1,2)
		self.snd:Stop()
		sound.Play(self.ExplodeSound, Pos, 95, 140, 1 )

		if self.Emitter then
			self.Emitter:Finish()
	end
end

	function ENT:Explosion( pos )
		local emitter = self.Emitter
		if not emitter then return end
		if self.SmallExplosion then
			for i = 0,60 do
				local particle = emitter:Add( self.Materials[math.random(1,table.Count( self.Materials ))], pos )
				
				if particle then
					particle:SetVelocity( VectorRand(-1,1) * 600 )
					particle:SetDieTime( math.Rand(4,6) )
					particle:SetAirResistance( math.Rand(200,600) ) 
					particle:SetStartAlpha( 255 )
					particle:SetStartSize( math.Rand(10,30) )
					particle:SetEndSize( math.Rand(80,120) )
					particle:SetRoll( math.Rand(-1,1) )
					particle:SetColor( 50,50,50 )
					particle:SetGravity( Vector( 0, 0, 100 ) )
					particle:SetCollide( false )
				end
			end
			
			for i = 0, 40 do
				local particle = emitter:Add( "sprites/flamelet"..math.random(1,5), pos )
				
				if particle then
					particle:SetVelocity( VectorRand(-1,1) * 500 )
					particle:SetDieTime( 0.14 )
					particle:SetStartAlpha( 255 )
					particle:SetStartSize( 10 )
					particle:SetEndSize( math.Rand(30,60) )
					particle:SetEndAlpha( 100 )
					particle:SetRoll( math.Rand( -1, 1 ) )
					particle:SetColor( 200,150,150 )
					particle:SetCollide( false )
				end
			end
			
			local dlight = DynamicLight( math.random(0,9999) )
			if dlight then
				dlight.pos = pos
				dlight.r = 255
				dlight.g = 180
				dlight.b = 100
				dlight.brightness = 8
				dlight.Decay = 2000
				dlight.Size = 200
				dlight.DieTime = CurTime() + 0.1
			end
		else
			for i = 0,90 do
				local particle = emitter:Add( self.Materials[math.random(1,table.Count( self.Materials ))], pos )
				
				if particle then
					particle:SetVelocity( VectorRand(-1,1) * 1300 )
					particle:SetDieTime( math.Rand(8,12) )
					particle:SetAirResistance( math.Rand(200,600) ) 
					particle:SetStartAlpha( 255 )
					particle:SetStartSize( math.Rand(70,90) )
					particle:SetEndSize( math.Rand(180,210) )
					particle:SetRoll( math.Rand(-1,1) )
					particle:SetColor( 50,50,50 )
					particle:SetGravity( Vector( 0, 0, 100 ) )
					particle:SetCollide( false )
				end
			end
			
			for i = 0, 90 do
				local particle = emitter:Add( "sprites/flamelet"..math.random(1,5), pos )
				
				if particle then
					particle:SetVelocity( VectorRand(-1,1) * 800 )
					particle:SetDieTime(0.2)
					particle:SetStartAlpha( 255 )
					particle:SetStartSize(90)
					particle:SetEndSize( math.Rand(150,210) )
					particle:SetEndAlpha( 100 )
					particle:SetRoll( math.Rand( -1, 1 ) )
					particle:SetColor( 200,150,150 )
					particle:SetCollide( false )
				end
			end
			
			local dlight = DynamicLight( math.random(0,9999) )
			if dlight then
				dlight.pos = pos
				dlight.r = 255
				dlight.g = 180
				dlight.b = 100
				dlight.brightness = 8
				dlight.Decay = 2000
				dlight.Size = 200
				dlight.DieTime = CurTime() + 0.1
			end
		end
	end
end

