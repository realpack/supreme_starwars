AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-15 Side Arm'

	SWEP.CSMuzzleFlashes = false
	SWEP.AimPos = Vector(-3.25, 0, 1.8)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(4, -2, 2)
	SWEP.SprintAng = Vector(-20, 10, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

list.Add('NPCUsableWeapons', {
	class = 'sup_dc15sa',
	title = 'DC-15 Side Arm'
})

sound.Add({
	name = 'blaster.dc15sa_fire',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 100,
	pitch = { 95, 105 },
	sound = 'weapons/dc15sa_fire.wav'
})

SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true

SWEP.AmmoOffset = Vector(15, -2.3, -2.5)

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
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supdc15sa.mdl'
SWEP.WorldModel = 'models/weapons/w_dc15sa.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false

SWEP.FireDelay = .35
SWEP.FireSound = Sound 'blaster.dc15sa_fire'
SWEP.ReloadSound = Sound 'blaster.reload_pistol'
SWEP.Recoil = 2

SWEP.HipSpread = 0.02
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 20
SWEP.DeployTime = 1
SWEP.ShowHands = true
