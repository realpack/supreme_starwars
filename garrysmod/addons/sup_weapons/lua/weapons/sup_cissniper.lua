--[[
addons/swb_starwars/lua/weapons/sup_repsniper.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'CIS Sniper'

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

SWEP.TracerName = 'sup_laser_red'

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
SWEP.Primary.Cone			= 0.1

SWEP.FireDelay = 1.5
SWEP.FireSound = Sound 'blaster.fire_sniper'
SWEP.Recoil = 0.001
SWEP.HipSpread = 0.001
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 0
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 400
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

-- function SWEP:SecondaryAttack()
-- 	if self:GetNWBool("Ironsights") then
-- 		self.Weapon:SetNWBool("Ironsights", false)
-- 		self.Owner:GetViewModel():SetNoDraw(false)
-- 		self.Owner:SetFOV( 0, 0.25 )
-- 		self:AdjustMouseSensitivity()
-- 	elseif not self:GetNWBool("Ironsights") then
-- 		self.Weapon:SetNWBool("Ironsights", true)
-- 		self.Owner:GetViewModel():SetNoDraw(true)
-- 		self.Owner:SetFOV( 8, 0.25 )
-- 		self:AdjustMouseSensitivity()
-- 	end
-- end

-- function SWEP:AdjustMouseSensitivity()
-- 	if self:GetNWBool("Ironsights") then
-- 		return 0.15
-- 	else if not self:GetNWBool("Ironsights") then
-- 		return -1
-- 	end
-- end
-- end

-- function SWEP:DrawHUD()
-- 	if (CLIENT) then
-- 		if not self:GetNWBool("Ironsights") then
			
-- 			local x, y
-- 			if ( self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer() ) then

-- 				local tr = util.GetPlayerTrace( self.Owner )
-- //				tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
-- 				local trace = util.TraceLine( tr )
				
-- 				local coords = trace.HitPos:ToScreen()
-- 				x, y = coords.x, coords.y
				
-- 			else
-- 				x, y = ScrW() / 2.0, ScrH() / 2.0
-- 			end
	
-- 			local scale = 10 * self.Primary.Cone
	
-- 			local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
-- 			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
-- 			surface.SetDrawColor( 255, 0, 0, 255 )
			
-- 			local gap = 40 * scale
-- 			local length = gap + 20 * scale
-- 			surface.DrawLine( x - length, y, x - gap, y )
-- 			surface.DrawLine( x + length, y, x + gap, y )
-- 			surface.DrawLine( x, y - length, x, y - gap )
-- 			surface.DrawLine( x, y + length, x, y + gap )
-- 			return;
-- 		end
		
-- 		local Scale = ScrH()/480
-- 		local w, h = 320*Scale, 240*Scale
-- 		local cx, cy = ScrW()/2, ScrH()/2
-- 		local scope_sniper_lr = surface.GetTextureID("sprites/scopes/752/scope_synbf3_lr")
-- 		local scope_sniper_ll = surface.GetTextureID("sprites/scopes/752/scope_synbf3_ll")
-- 		local scope_sniper_ul = surface.GetTextureID("sprites/scopes/752/scope_synbf3_ul")
-- 		local scope_sniper_ur = surface.GetTextureID("sprites/scopes/752/scope_synbf3_ur")
-- 		local SNIPERSCOPE_MIN = -0.75
-- 		local SNIPERSCOPE_MAX = -2.782
-- 		local SNIPERSCOPE_SCALE = 0.4
-- 		local x = ScrW() / 2.0
-- 		local y = ScrH() / 2.0
		
-- 		surface.SetDrawColor( 0, 0, 0, 255 )
-- 		local gap = 0
-- 		local length = gap + 9999
		
-- 		surface.SetDrawColor( 0, 0, 0, 255 )
-- 		surface.DrawLine( x - length, y, x - gap, y )
-- 		surface.DrawLine( x + length, y, x + gap, y )
-- 		surface.DrawLine( x, y - length, x, y - gap )
-- 		surface.DrawLine( x, y + length, x, y + gap )
-- 		render.UpdateRefractTexture()
-- 		surface.SetDrawColor(255, 255, 255, 255)
-- 		surface.SetTexture(scope_sniper_lr)
-- 		surface.DrawTexturedRect(cx, cy, w, h)
-- 		surface.SetTexture(scope_sniper_ll)
-- 		surface.DrawTexturedRect(cx-w, cy, w, h)
-- 		surface.SetTexture(scope_sniper_ul)
-- 		surface.DrawTexturedRect(cx-w, cy-h, w, h)
-- 		surface.SetTexture(scope_sniper_ur)
-- 		surface.DrawTexturedRect(cx, cy-h, w, h)
-- 		surface.SetDrawColor(0, 0, 0, 255)
-- 		if cx-w > 0 then
-- 			surface.DrawRect(0, 0, cx-w, ScrH())
-- 			surface.DrawRect(cx+w, 0, cx-w, ScrH())
-- 		end
-- 	end
-- end
