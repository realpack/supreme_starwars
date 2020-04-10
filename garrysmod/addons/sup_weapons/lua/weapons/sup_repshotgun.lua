AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'Republic Shotgun'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-5.08,-12, 1.05)
	SWEP.AimAng = Vector(-1.5,0,0)
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
SWEP.AmmoOffset = Vector(20, -2, -3)

SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
SWEP.BulletDiameter = 5
SWEP.CaseLength = 10

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.NormalHoldType = 'ar2'
SWEP.RunHoldType = 'passive'
SWEP.FireModes = {
	'auto',
	'semi'
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
SWEP.ViewModel = 'models/galactic/weapons/vmodels/suprepublicshotgun.mdl'
SWEP.WorldModel = 'models/galactic/weapons/wmodels/suprepublicshotgunworld.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true

SWEP.FireDelay = 1
SWEP.FireSound = Sound 'blaster.fire'
SWEP.Recoil = 2
SWEP.ShotgunReload = false
SWEP.ReloadStartWait = 0.6
SWEP.ReloadFinishWait = 1.1
SWEP.ReloadShellInsertWait = 0.6
SWEP.Chamberable = false

SWEP.HipSpread = 0.001
SWEP.AimSpread = 0.001
SWEP.ClumpSpread = .1

SWEP.VelocitySensitivity = 2.2
SWEP.MaxSpreadInc = 1
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 1.03
SWEP.Shots = 8
SWEP.Damage = 50
SWEP.DeployTime = 1
SWEP.ShowHands = true
