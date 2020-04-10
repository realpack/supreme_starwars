--[[
addons/swb_starwars/lua/weapons/sup_repsniper.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'Republic Sniper'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-4.804,-3, 1.265)
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
	SWEP.ScopeFlipY = true
	SWEP.ScopedBlur = false

	SWEP.ScopeTexture = Material( "ScopeScene" )
	SWEP.ScopeScene2 = GetRenderTarget( "ScopeScene", 400, 400, false)
	SWEP.ScopeMaterial = Material( "scopes/sw_ret_redux_blue" )
end

list.Add('NPCUsableWeapons', {
	class = 'sup_repsniper',
	title = 'Republic Sniper'
})

SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(20, -1, -3)

SWEP.PlayBackRate = 5
SWEP.PlayBackRateSV = 5
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39

SWEP.CanPenetrate = true
SWEP.HasScope = true
SWEP.FadeCrosshairOnAim = true
SWEP.PreventQuickScoping = true

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.NormalHoldType = 'ar2'
SWEP.RunHoldType = 'passive'
SWEP.FireModes = {
	'bolt'
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

SWEP.ViewModel = 'models/galactic/weapons/vmodels/suprepublicsniper.mdl'
SWEP.WorldModel = 'models/galactic/weapons/wmodels/suprepublicsniperworld.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false

SWEP.FireDelay = 1.5
SWEP.FireSound = Sound 'blaster.fire_sniper'
SWEP.Recoil = 0.001
SWEP.HipSpread = 0.001
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 0
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 350
SWEP.DeployTime = 1
SWEP.ShowHands = true

SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["rt"] = {
		type = "Model",
		model = "models/rtcircle.mdl",
		bone = "gunbase",
		rel = "",
		pos = Vector(3.72, 2.85, -.01),
		angle = Angle(0, -100, -90),
		size = Vector(.32, .32, .32),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "ScopeScene",
		skin = 0,
		bodygroup = {}
	}
}
SWEP.WElements = {}