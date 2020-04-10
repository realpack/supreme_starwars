AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'B2 Wrist Blaster'

	SWEP.CSMuzzleFlashes = true
	SWEP.RestPos = Vector(6, 10, -4)
	SWEP.RestAng = Vector(0,0,0)
	SWEP.AimPos = Vector(6, 10, -4)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos =  Vector(6, 10, -4)
	SWEP.SprintAng = Vector(0,0,0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

list.Add('NPCUsableWeapons', {
	class = 'sup_b2',
	title = 'B2 Wrist Blaster'
})

SWEP.Tracer = 1
SWEP.TracerName = 'sup_laser_red'

SWEP.Primary.Tracer = 1
SWEP.Primary.TracerName = 'sup_laser_red'

SWEP.DisplayAmmo = false
SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(24, -0.3, -4.5)
SWEP.ViewModelFlip = true

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.NormalHoldType = 'pistol'
SWEP.RunHoldType = 'normal'
SWEP.FireModes = {
	'auto',
	'semi'
}

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
SWEP.ViewModel = ''
SWEP.WorldModel = ''

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true

SWEP.FireDelay = 0.070
SWEP.FireSound = Sound 'blaster.fire'
SWEP.Recoil = 0.001

SWEP.HipSpread = 0
SWEP.AimSpread = 0
SWEP.VelocitySensitivity = 0
SWEP.MaxSpreadInc = 0.001
SWEP.SpreadPerShot = 0.001
SWEP.SpreadCooldown = 0.5
SWEP.Shots = 1
SWEP.Damage = 60
SWEP.DeployTime = 1
SWEP.ShowHands = true
