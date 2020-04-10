AddCSLuaFile()

if ( CLIENT ) then

	SWEP.PrintName			= "Bowcaster"			
	SWEP.Author				= "Syntax_Error752"
	SWEP.ViewModelFOV		= 40
	SWEP.Slot				= 1
	SWEP.SlotPos			= 3
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/killicons/BOWCASTER")
	
	killicon.Add( "weapon_bowcaster", "HUD/killicons/BOWCASTER", Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType				= "ar2"
SWEP.Base					= "swsft_base"

SWEP.Category				= "Star Wars"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/v_BOWCASTER.mdl"
SWEP.WorldModel				= "models/weapons/w_BOWCASTER.mdl"

local FireSound 			= Sound ("weapons/BOWCASTER_fire.wav");
local ReloadSound 			= Sound ("weapons/BOWCASTER_reload.wav");

local MaxTimer				= 64
local CurrentTimer			= 0
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0125
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Tracer 		= "sup_laser_green"

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IronSightsPos = Vector (-4.8, -10, 0.5)

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if not self:CanPrimaryAttack() then 
		return 
	end
	
	self.Weapon:EmitSound( FireSound )
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	self:TakePrimaryAmmo(1)

	if self.Owner:IsNPC() then 
		return 
	end
	
	self.Owner:ViewPunch( Angle( math.Rand(-1,1) * self.Primary.Recoil, math.Rand(-1,1) *self.Primary.Recoil, 0 ) )
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 1								// Show a tracer on every x bullets 
	bullet.TracerName 	= self.Primary.Tracer
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	
	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	// CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end
end

function SWEP:Reload()
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:EmitSound( ReloadSound )
		end
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		self:SetIronsights(false)
	end
end

function SWEP:SecondaryAttack()
end