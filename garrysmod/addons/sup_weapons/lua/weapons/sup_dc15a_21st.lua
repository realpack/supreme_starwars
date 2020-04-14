AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-15A 21st'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-5.08,-18, 1.05)
	SWEP.AimAng = Vector(-2.4,0,0)
	SWEP.SprintPos = Vector(10, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(24, -0.3, -4.5)

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.NormalHoldType = 'ar2'
SWEP.RunHoldType = 'passive'
SWEP.FireModes = {
	'auto',
	'semi'
}
SWEP.FadeCrosshairOnAim = false

SWEP.Base = 'cw_base'
SWEP.Category = 'SUP Starwars Weapons'

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.Tracer = 'sup_laser_blue'
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supdc15a.mdl'
SWEP.WorldModel = 'models/weapons/w_dc15a_neue.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = true

SWEP.FireDelay = .1
SWEP.FireSound = Sound 'blaster.fire'
SWEP.Recoil = 0.1

SWEP.HipSpread = 0.03
SWEP.AimSpread = 0.015
SWEP.VelocitySensitivity = 10
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 50
SWEP.DeployTime = 1
SWEP.ShowHands = true

