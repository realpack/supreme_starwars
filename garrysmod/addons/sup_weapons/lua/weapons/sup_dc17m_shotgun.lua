AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-17m Shotgun'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(0,-1,0)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(10, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'
end

list.Add('NPCUsableWeapons', {
	class = 'sup_dc17m_shotgun',
	title = 'DC-17m Shotgun'
})

SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 4
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(16, -1.5, -4)

SWEP.FadeCrosshairOnAim = false
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

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supdc17m.mdl'
SWEP.WorldModel = 'models/weapons/w_dc17m_at.mdl'
SWEP.Bodygroups = '020'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true

SWEP.FireDelay = .5
SWEP.FireSound = Sound 'blaster.fire_shotgun'
SWEP.ReloadSound = Sound 'blaster.reload_dc17m'

SWEP.Recoil = 2
SWEP.ShotgunReload = false
SWEP.ReloadStartWait = 0.6
SWEP.ReloadFinishWait = 1.1
SWEP.ReloadShellInsertWait = 0.6
SWEP.Chamberable = false

SWEP.HipSpread = 0
SWEP.AimSpread = 0
SWEP.ClumpSpread = .05

SWEP.VelocitySensitivity = 2.2
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.02
SWEP.SpreadCooldown = 1.03
SWEP.Shots = 8
SWEP.Damage = 35
SWEP.DeployTime = 1
SWEP.ShowHands = true
