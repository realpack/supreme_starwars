--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 70 )
	ent:Spawn()
	ent:Activate()

	return ent

end

local lBomb = Vector(-12.05,45,-33.53)
local rBomb = Vector(-69.32,43.63,-35.06)

function ENT:RunOnSpawn()
end

function ENT:OnTick()
if self:GetEngineActive() then
	self.AstroAng = self.AstroAng or 0
	self.nextAstro = self.nextAstro or 0
	if self.nextAstro < CurTime() then
		self.nextAstro = CurTime() + math.Rand(0.5,2)
		self.AstroAng = math.Rand(-180,180)
		
		if math.random(0,16) == 4 then
			self:EmitSound( "lfs/hyenabomber/communication/"..math.random(1,73)..".mp3" )
		end
	end
end
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound( "HYENA_FIRE" )
	
	self:SetNextPrimary( 0.16 )
	
	local fP = { Vector(51.26,2.44,-5.74), Vector(53.51,17.14,-5.74), Vector(51.26,2.44,4.43), Vector(53.51,17.14,3.24) }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 4 then self.NumPrim = 1 end
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( fP[self.NumPrim] )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 40
	bullet.Damage	= 40
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	if self:GetAI() then return end
	
	self:TakeSecondaryAmmo()

	self:EmitSound( "HYENA_FIRE2" )
	
	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = self
} )
	
	local rocketpos = {
		self:GetPos()+self:GetForward()*25+self:GetUp()*-26+self:GetRight()*26.9,
	}	
		
	local ent = ents.Create( "lunasflightschool_hyena_missile" )
	local mPos
	if (self:GetAmmoSecondary()+1)%5 == 0 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.30 )

	elseif (self:GetAmmoSecondary()+1)%5 == 4 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.30 )

	elseif (self:GetAmmoSecondary()+1)%5 == 3 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.30 )

	elseif (self:GetAmmoSecondary()+1)%5 == 2 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.30 )

	else
		mPos = rocketpos[1]
		self:SetNextSecondary( 7 )
	end

	local Ang = self:WorldToLocal( mPos ).y > 0 and -1 or 1
	ent:SetPos( mPos )
	ent:SetAngles( self:LocalToWorldAngles( Angle(0,Ang,0) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	ent:SetDirtyMissile( true )
	
	if self:GetAI() then
		local enemy = self:AIGetTarget()
		if IsValid(enemy) then
			if math.random(1,8) != 1 then
				if string.find(enemy:GetClass(),"lunasflightschool") then
					if enemy:GetClass() == "lunasflightschool_hyena_missile" then return end
					ent:SetLockOn(enemy)
					ent:SetStartVelocity(0)
				end
			end
		end
	else
		if tr.Hit then
			local Target = tr.Entity
			if IsValid(Target) then
				if Target:GetClass():lower() ~= "lunasflightschool_hyena_missile" then
					ent:SetLockOn(Target)
					ent:SetStartVelocity(0)
				end
			end
		end
	end
	constraint.NoCollide(ent,self,0,0) 
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end

ENT.TotalBombsFire = 0
function ENT:AltPrimaryAttack( Driver, Pod )

	if not self:CanAltPrimaryAttack() then return end
	
	if self.TotalBombsFire >= 5 then
		return
	end
	self:SetNextAltPrimary( 0.25 )
	self.TotalBombsFire = self.TotalBombsFire +1
	if self.TotalBombsFire >= 5 then
		timer.Simple(14,function()
			if IsValid(self) then
				self.TotalBombsFire = 0
			end
		end)
	end

	
	self.MirrorPrimary = not self.MirrorPrimary	
	local Mirror = self.MirrorPrimary and -1 or 1
	
	local ent = ents.Create("lunasflightschool_hyena_bomb")
	local Pos
	if Mirror == 1 then
		Pos = self:LocalToWorld(lBomb)
	else
		Pos = self:LocalToWorld(rBomb)
	end
	ent:SetPos(Pos)
	ent:SetAngles(Angle(90,0,0))
	ent.SmallExplosion = true
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker(self:GetDriver())
	ent:SetInflictor(self)
	ent:SetStartVelocity(0)
	constraint.NoCollide(ent,self,0,0)
end

function ENT:OnKeyThrottle( bPressed )
	if bPressed then
		if self:CanSound() then
			self:EmitSound( "HYENA_BOOST" )
			self:DelayNextSound( 4 )
		end
	end
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/hyenabomber/communication/engine/on"..math.random(1,7)..".mp3" )
end

function ENT:OnEngineStopped()

end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
	
		FireTurret = Driver:KeyDown( IN_WALK )
	
		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
	end
	

	if Fire1 then
		if FireTurret and not HasGunner then
			self:AltPrimaryAttack()
		else
			self:PrimaryAttack()
		end
end

	if Fire2 then
		self:SecondaryAttack()
	end
end

function ENT:HandleLandingGear()
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		local KeyJump = Driver:KeyDown( IN_JUMP )
		
		if self.OldKeyJump ~= KeyJump then
			self.OldKeyJump = KeyJump
			if KeyJump then
				self:ToggleLandingGear()
				self:PhysWake()
			end
		end
	end
	
	local TVal = self.LandingGearUp and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self:SetLGear( self:GetLGear() + math.Clamp(TVal - self:GetLGear(),-Speed,Speed) )
	
	if istable( self.LandingGearPlates ) then
		for _, v in pairs( self.LandingGearPlates ) do
			if IsValid( v ) then
				local pObj = v:GetPhysicsObject()
				if IsValid( pObj ) then
					pObj:SetMass( 1 + 2000 * self:GetLGear() ^ 10 )
				end
			end
		end
	end
end
