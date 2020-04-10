AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-17 Side Arm'

	SWEP.CSMuzzleFlashes = false
	SWEP.AimPos = Vector(-3.25, 0, 1.4)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(5, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

list.Add('NPCUsableWeapons', {
	class = 'sup_dc17',
	title = 'DC-17 Side Arm'
})

SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(12, -2.3, -2)

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
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supdc17.mdl'
SWEP.WorldModel = 'models/weapons/w_dc17.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false

SWEP.FireDelay = .4
SWEP.FireSound = Sound 'blaster.fire_pistol'
SWEP.ReloadSound = Sound 'blaster.reload_pistol'

SWEP.Recoil = 1
SWEP.HipSpread = 0.02
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 5
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 15
SWEP.DeployTime = 1
SWEP.ShowHands = true
