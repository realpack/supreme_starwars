AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DE-10 Side Arm'

	SWEP.CSMuzzleFlashes = false
	SWEP.AimPos = Vector(-3.315, -11, .99)
	SWEP.AimAng = Vector(0,0,0)
	SWEP.SprintPos = Vector(10, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = .5
	SWEP.IconLetter = 'b'

	SWEP.DelayedZoom = true
	SWEP.SimulateCenterMuzzle = false
	SWEP.ZoomAmount = 5

	SWEP.AdjustableZoom = false
	SWEP.MinZoom = 2
	SWEP.MaxZoom = 5
	SWEP.ZoomSteps = 5

	SWEP.ScopeOverrideMaterialIndex = 1
	SWEP.ScopeFOV = 20
	SWEP.ScopeFlipX = true
	SWEP.ScopeFlipY = true
	SWEP.ScopedBlur = false

	SWEP.ScopeTexture = Material( "ScopeScene" )
	SWEP.ScopeScene2 = GetRenderTarget( "ScopeScene", 400, 400, false)
	SWEP.ScopeMaterial = Material( "scopes/sw_ret_redux_yellow" )
end

sound.Add({
	name = 'blaster.de10_fire',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 100,
	pitch = { 95, 105 },
	sound = 'weapons/de10_fire.wav'
})

sound.Add({
	name = 'blaster.de10_reload',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 100,
	pitch = { 95, 105 },
	sound = 'weapons/de10_reload.wav'
})

SWEP.ReloadSound = 'blaster.de10_reload'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(22, 1, -.8)

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39

SWEP.HasScope = true
SWEP.FadeCrosshairOnAim = true
SWEP.PreventQuickScoping = true

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
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supde10.mdl'
SWEP.WorldModel = 'models/weapons/w_de10.mdl'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false

SWEP.FireDelay = .8
SWEP.FireSound = Sound 'blaster.de10_fire'
SWEP.Recoil = 3
SWEP.HipSpread = 0.01
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 2
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 45
SWEP.DeployTime = 1
SWEP.ShowHands = true

SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["rt"] = {
		type = "Model",
		model = "models/rtcircle.mdl",
		bone = "gunbase",
		rel = "",
		pos = Vector(3.97, -.8, 0),
		angle = Angle(0, -100, -90),
		size = Vector(.26, .26, .26),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "ScopeScene",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.WElements = {}

function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	return true
end

function SWEP:OnRemove()
	self:Holster()
end