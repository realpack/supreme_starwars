--[[
addons/swb_starwars/lua/weapons/cw_base.lua
--]]
AddCSLuaFile()

local bar = 5
local white = Color(200, 200, 200)

if CLIENT then
	SWEP.PrintName = 'SWB Base'
	SWEP.DrawCrosshair = false

	SWEP.IconLetter = 'b'
	SWEP.CSMuzzleFlashes = true
	SWEP.MuzzleEffect = 'tfa_muzzlesmoke'
	SWEP.MuzzlePosMod = {x = 6.5, y =	30, z = -2}

	SWEP.AimPos = Vector(-7.6,-16,2.1)
	SWEP.AimAng = Vector(0,-1.2,0)
	SWEP.SprintPos = Vector(1.786, 1.442, 2)
	SWEP.SprintAng = Vector(-10.778, 27.573, 0)
	SWEP.ViewModelMovementScale = 1

	SWEP.ScopeMaterialManual = CreateMaterial('cw_base_scoope0', 'UnlitGeneric', {
		['$basetexture'] = 'dev/dev_scanline',
		['$model'] = 1,
		['$translucent'] = .05,
		['$alpha'] = .2,
		['$vertexcolor'] = 1,
		['Proxies']={
			['TextureScroll']={
				['texturescrollvar']='$basetexturetransform',
				['texturescrollrate']=1,
				['texturescrollangle']=-90
			}

		}
	})

	SWEP.ScopeMaterialManual:Recompute()
end

SWEP.Tracer = 1
SWEP.TracerName = 'sup_laser_blue' -- 'cwbase_laser'

SWEP.Primary.Tracer = 1
SWEP.Primary.TracerName = 'sup_laser_blue' -- 'cwbase_laser'

SWEP.FadeCrosshairOnAim = true
SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.CanRicochet = false

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.NormalHoldType = 'ar2'
SWEP.RunHoldType = 'passive'
SWEP.FireModes = {
	'auto',
	'semi'
}

SWEP.Base = 'swb_base'
SWEP.Category = 'SUP Starwars Weapons'

SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.ViewModel = 'models/weapons/cstrike/c_rif_ak47.mdl'
SWEP.WorldModel = 'models/weapons/w_irifle.mdl'

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = 'ar2'

SWEP.FireDelay = 0.3
SWEP.FireSound = Sound 'blaster.fire'
SWEP.Recoil = .8

SWEP.HipSpread = 0.02
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 30
SWEP.DeployTime = 1
SWEP.ShowHands = true

-- SWEP.ImpactEffect = 'cwbase_impact'
-- SWEP.ImpactDecal = 'FadingScorch'

sound.Add({
	name = 'blaster.fire_smg',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 95, 100 },
	sound = 'weapons/dc15s_fire.wav'
}) 

sound.Add({
	name = 'blaster.fire',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 100, 105 },
	sound = 'weapons/dc15a_fire.wav'
})

sound.Add({
	name = 'blaster.fire_shotgun',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 80, 85 },
	sound = 'weapons/dc15a_fire.wav'
}) 

sound.Add({
	name = 'blaster.fire_pistol',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 100, 105 },
	sound = 'weapons/dc15sa_fire.wav'
}) 

sound.Add({
	name = 'blaster.fire_sniper',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 80, 90 },
	sound = 'weapons/dc17m_sn_fire.wav'
})

sound.Add({
	name = 'blaster.reload_dc17m',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 95, 100 },
	sound = 'weapons/dc17m_br_reload.wav'
})

sound.Add({
	name = 'blaster.dc17mbr_fire',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 95, 100 },
	sound = 'weapons/dc17m_br_fire.wav'
})

sound.Add({
	name = 'blaster.reload_smg',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 95, 100 },
	sound = 'weapons/westar34_reload.wav'
})

sound.Add({
	name = 'blaster.reload_pistol',
	channel = CHAN_WEAPON,
	volume = 1,
	level = 90,
	pitch = { 95, 100 },
	sound = 'weapons/dc17_reload.wav'
})

function SWEP:DoImpactEffect(tr, dmgtype)
	if not IsValid(self) or tr.HitSky then 
		return true 
	end

	self:BlastMarks(tr.HitPos, tr.HitNormal, tr.MatType)

	if self.ImpactDecal then
		util.Decal(self.ImpactDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		return true
	end
end

function SWEP:BlastMarks(pos, normal, mattype)
	local fx = EffectData()

	fx:SetOrigin(pos)
	fx:SetNormal(normal)
	fx:SetEntity(self:GetOwner())
	fx:SetMagnitude(mattype or 0)
	fx:SetScale(math.sqrt(self.CaseLength / 30))

	util.Effect('ffswbase_impact', fx)

	if self.ImpactEffect then
		util.Effect(self.ImpactEffect, fx)
	end

	return true
end

function SWEP:OnReload()
	if self.ReloadSound then
		self:EmitSound(self.ReloadSound)
	end

	if IsFirstTimePredicted() and self.ReloadSteam then
		-- Do Reload Effects.
	end
end

function SWEP:DrawScope(sw, sh)
	surface.SetDrawColor(20, 100, 100, 250)
	surface.SetMaterial(self.ScopeMaterialManual)
	surface.DrawTexturedRect(0, 0, sw, sh)
	
	draw.Box(sw/2-50, sh/2, 100, 8, white)
	draw.Box(sw/2-4, sh/2, 8, 50, white)
end

MuzzlePosition = Vector()
MuzzlePosition2 = Vector()
hook.Add('HUDPaint', function() 
	local vm = LocalPlayer():GetViewModel()
	if IsValid(vm) then
		local attachment = vm:GetAttachment(1)
		MuzzlePosition = attachment and attachment.Pos or EMPTY
		local attachment = vm:GetAttachment(2)
		MuzzlePosition2 = attachment and attachment.Pos or nil
	end
end) 

