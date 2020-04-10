AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'Z6'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-5.08,-8, .02)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(-2, -10, 2)
	SWEP.SprintAng = Vector(50, 0, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
	SWEP.Tracer = 1
	SWEP.TracerName = 'sup_laser_blue'
end

SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(18, -4, -4)

SWEP.SpeedDec = 75
SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.NormalHoldType = 'crossbow'
SWEP.RunHoldType = 'passive'
SWEP.FireModes = {
	'auto'
}

SWEP.Base = 'cw_base'
SWEP.Category = 'SUP Starwars Weapons'

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supz6.mdl'
SWEP.WorldModel = 'models/galactic/weapons/wmodels/supz6world.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 250
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true

SWEP.FireDelay = 0.03
SWEP.FireSound = Sound 'blaster.fire'
SWEP.ReloadSound = Sound 'blaster.reload_pistol'
SWEP.Recoil = 0.2

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 25
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.002
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 10
SWEP.DeployTime = 1
SWEP.ShowHands = true
