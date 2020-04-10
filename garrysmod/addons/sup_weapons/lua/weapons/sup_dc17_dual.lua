AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-17 Dual Side Arms'

	SWEP.CSMuzzleFlashes = false
	SWEP.AimPos = Vector(0, -5, 0)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(0, -12, -10)
	SWEP.SprintAng = Vector(50, 0, 5)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.Akimbo = true
SWEP.AmmoOffset = Vector(20, -3, -2)
SWEP.AmmoOffsetAng = Angle(-20, -90, 90)

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.SprintingEnabled = false

SWEP.NormalHoldType = 'duel'
SWEP.RunHoldType = 'normal'
SWEP.FireModes = {
	'semi'
}

SWEP.Base = 'cw_base'
SWEP.Category = 'SUP Starwars Weapons'

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.ViewModelFOV = 100
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supdc17dual.mdl'
SWEP.WorldModel = 'models/galactic/weapons/wmodels/supdc17sdualworld.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false

SWEP.FireDelay = .1
SWEP.FireSound = Sound 'blaster.fire_pistol'
SWEP.Recoil = 1

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 5
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 60
SWEP.DeployTime = 1
SWEP.ShowHands = true
