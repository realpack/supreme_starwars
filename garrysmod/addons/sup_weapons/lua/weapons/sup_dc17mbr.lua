AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-17 MBR'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-4,0, 1.8)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(10, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

list.Add('NPCUsableWeapons', {
	class = 'sup_dc17mbr',
	title = 'DC-17 MBR'
})

SWEP.FadeCrosshairOnAim = false
SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(16, -1.5, -4)

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

SWEP.Base = 'cw_base'
SWEP.Category = 'SUP Starwars Weapons'

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supdc17m.mdl'
SWEP.WorldModel = 'models/weapons/w_dc17m_br.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = true

SWEP.FireDelay = 0.10
SWEP.FireSound = Sound 'blaster.dc17mbr_fire'
SWEP.ReloadSound = Sound 'blaster.reload_dc17m'

SWEP.Recoil = 0.0
SWEP.HipSpread = 0.025
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.001
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 60
SWEP.DeployTime = 1
SWEP.ShowHands = true

