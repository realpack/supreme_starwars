AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 20
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = -20
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

    self:EmitSound( "lfs/speederbike/speeder_shoot.wav")
	
	self:SetNextPrimary( 0.4 )

	
	for i = 0,1 do
     
		self.MirrorPrimary = not self.MirrorPrimary
		
		local Mirror = self.MirrorPrimary and -0.05 or 0.05
		
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= self:LocalToWorld(Vector(90, 0, 18*Mirror) + Vector(0, 0, 18) )
		bullet.Dir 	= self:LocalToWorldAngles(Angle(0,0,0)):Forward()
		bullet.Spread 	= Vector( 0.0001,  0.0001, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_red"
		bullet.Force	= 101
		bullet.HullSize 	= 40
		bullet.Damage	= 45
		bullet.Attacker 	= self:GetDriver()
		bullet.AmmoType = "Pistol"
		bullet.Callback = function(att, tr, dmginfo)
		
		dmginfo:SetDamageType(DMG_BLAST)
		
		local effectdata = EffectData()
		
		effectdata:SetOrigin( tr.HitPos )
		
		util.Effect( "bullet", effectdata )
		end
		self:FireBullets( bullet )
		
		self:TakePrimaryAmmo()
	end
end