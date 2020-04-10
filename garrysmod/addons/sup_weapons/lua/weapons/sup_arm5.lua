AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'Westar-M5 BR'
	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-4.9,-4, 1.05)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(10, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'

	SWEP.DelayedZoom = true
	SWEP.SimulateCenterMuzzle = false
	SWEP.ZoomAmount = 15
	SWEP.AdjustableZoom = true
	SWEP.MinZoom = 1
	SWEP.MaxZoom = 35
	SWEP.ZoomSteps = 5
	SWEP.ScopeOverrideMaterialIndex = 1
	SWEP.ScopeFOV = 10
	SWEP.ScopeFlipX = true
	SWEP.ScopeFlipY = false
	SWEP.ScopedBlur = false

	SWEP.ScopeTexture = Material( "ScopeScene" )
	SWEP.ScopeScene2 = GetRenderTarget( "ScopeScene", 400, 400, false)
	SWEP.ScopeMaterial = Material( "scopes/sw_ret_redux_green" )
end

list.Add('NPCUsableWeapons', {
	class = 'sup_arm5',
	title = 'Westar-M5 BR'
})

SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(25, -2, -2.5)

SWEP.CanPenetrate = true
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

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supwestarm5.mdl'
SWEP.WorldModel = 'models/weapons/w_alphablaster.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 101
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = true

SWEP.FireDelay = 0.1
SWEP.FireSound = Sound 'blaster.fire'
SWEP.Recoil = 0.001

SWEP.HipSpread = 0.005
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 0
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 70
SWEP.DeployTime = 1
SWEP.ShowHands = true

SWEP.BulletDiameter = 0
SWEP.CaseLength = 0

SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["rt"] = {
		type = "Model",
		model = "models/rtcircle.mdl",
		bone = "gunbase",
		rel = "",
		pos = Vector(-6, -.88, -2.2),
		angle = Angle(5, -190, 178),
		size = Vector(.32, .32, .32),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "ScopeScene",
		skin = 0,
		bodygroup = {}
	}
}
SWEP.WElements = {}