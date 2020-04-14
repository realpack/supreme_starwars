AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'e5 client'

	SWEP.CSMuzzleFlashes = false
	SWEP.AimPos = Vector(-3.7, 0, 0)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(5, 0, 1)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
	SWEP.Tracer = 1
end

function SWEP:OnDrop()
	self:Remove()
end

SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.FadeCrosshairOnAim = false

SWEP.NormalHoldType = 'ar2'
SWEP.RunHoldType = 'passive'
SWEP.FireModes = {
	'auto'
}
SWEP.MuzzleEffect = 'swb_pistol_large'

SWEP.Base = 'cw_base'
SWEP.Category = 'SUP Starwars Weapons'

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/weapons/v_e5.mdl'
SWEP.WorldModel = 'models/weapons/w_e5.mdl'
SWEP.TracerName = 'sup_laser_red'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 80
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = true

SWEP.FireDelay = 0.200
SWEP.FireSound = Sound 'blaster.fire_smg'
SWEP.ReloadSound = Sound 'blaster.reload_smg'
SWEP.Recoil = 0.1

SWEP.HipSpread = .01
SWEP.AimSpread = .01
SWEP.VelocitySensitivity = 1.1
SWEP.MaxSpreadInc = 0.01
SWEP.SpreadPerShot = 0.1
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 40
SWEP.DeployTime = 0
SWEP.ShowHands = false
