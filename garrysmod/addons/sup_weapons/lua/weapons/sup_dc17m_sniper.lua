AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = 'DC-17m Sniper'

	SWEP.CSMuzzleFlashes = true
	SWEP.AimPos = Vector(-4.7,-18, -.33)
	SWEP.AimAng = Vector(-.5,0,0)
	SWEP.SprintPos = Vector(10, -10, 2)
	SWEP.SprintAng = Vector(-15, 50, 0)
	SWEP.ViewModelMovementScale = 1
	SWEP.IconLetter = 'b'
	SWEP.DelayedZoom = true
end

SWEP.MuzzleEffect = 'swb_pistol_large'
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ViewbobIntensity = 2
SWEP.ViewbobEnabled = true
SWEP.AmmoOffset = Vector(0, 0, -4)


SWEP.CanPenetrate = true
SWEP.PlayBackRate = 5
SWEP.PlayBackRateSV = 5
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 39

SWEP.HasScope = false
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

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Author = 'Scott'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''
SWEP.Primary.Cone			= 0.1
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dc17m_sn.mdl"
SWEP.WorldModel = "models/weapons/w_dc17m_sn.mdl"
SWEP.Bodygroups = '010'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false

SWEP.FireDelay = 2
SWEP.FireSound = Sound 'blaster.fire_sniper'
SWEP.ReloadSound = Sound 'blaster.reload_dc17m'

SWEP.Recoil = 0.1
SWEP.Primary.IronAccuracy = .005
SWEP.CrouchAccuracyMultiplier = 0.5
SWEP.HipSpread = 0.001
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 0.1
SWEP.MaxSpreadInc = 0.1
SWEP.SpreadPerShot = 0.1
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 250
SWEP.DeployTime = 1
SWEP.UseHands = false

function SWEP:SecondaryAttack()
	if self:GetNWBool("Ironsights") then
		self.Weapon:SetNWBool("Ironsights", false)
		self.Owner:GetViewModel():SetNoDraw(false)
		self.Owner:SetFOV( 0, 0.25 )
		self:AdjustMouseSensitivity()
	elseif not self:GetNWBool("Ironsights") then
		self.Weapon:SetNWBool("Ironsights", true)
		self.Owner:GetViewModel():SetNoDraw(true)
		self.Owner:SetFOV( 8, 0.25 )
		self:AdjustMouseSensitivity()
	end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetNWBool("Ironsights") then
		return 0.15
	else if not self:GetNWBool("Ironsights") then
		return -1
	end
end
end

function SWEP:DrawHUD()
	if (CLIENT) then
		if not self:GetNWBool("Ironsights") then
			
			local x, y
			if ( self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer() ) then

				local tr = util.GetPlayerTrace( self.Owner )
//				tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
				local trace = util.TraceLine( tr )
				
				local coords = trace.HitPos:ToScreen()
				x, y = coords.x, coords.y
				
			else
				x, y = ScrW() / 2.0, ScrH() / 2.0
			end
	
			local scale = 10 * self.Primary.Cone
	
			local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
			surface.SetDrawColor( 255, 0, 0, 255 )
			
			local gap = 40 * scale
			local length = gap + 20 * scale
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )
			return;
		end
		
		local Scale = ScrH()/480
		local w, h = 320*Scale, 240*Scale
		local cx, cy = ScrW()/2, ScrH()/2
		local scope_sniper_lr = surface.GetTextureID("sprites/scopes/752/scope_synbf3_lr")
		local scope_sniper_ll = surface.GetTextureID("sprites/scopes/752/scope_synbf3_ll")
		local scope_sniper_ul = surface.GetTextureID("sprites/scopes/752/scope_synbf3_ul")
		local scope_sniper_ur = surface.GetTextureID("sprites/scopes/752/scope_synbf3_ur")
		local SNIPERSCOPE_MIN = -0.75
		local SNIPERSCOPE_MAX = -2.782
		local SNIPERSCOPE_SCALE = 0.4
		local x = ScrW() / 2.0
		local y = ScrH() / 2.0
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		local gap = 0
		local length = gap + 9999
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
		render.UpdateRefractTexture()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(scope_sniper_lr)
		surface.DrawTexturedRect(cx, cy, w, h)
		surface.SetTexture(scope_sniper_ll)
		surface.DrawTexturedRect(cx-w, cy, w, h)
		surface.SetTexture(scope_sniper_ul)
		surface.DrawTexturedRect(cx-w, cy-h, w, h)
		surface.SetTexture(scope_sniper_ur)
		surface.DrawTexturedRect(cx, cy-h, w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		if cx-w > 0 then
			surface.DrawRect(0, 0, cx-w, ScrH())
			surface.DrawRect(cx+w, 0, cx-w, ScrH())
		end
	end
end
