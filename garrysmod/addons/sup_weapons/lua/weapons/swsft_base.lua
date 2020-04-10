AddCSLuaFile()

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 82
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false
SWEP.BounceWeaponIcon = false

SWEP.Author			= "Syntax_Error752"
SWEP.Contact		= ""
SWEP.Purpose		= "To eradicate the disease that is our enemy"
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0125
SWEP.Primary.Delay			= 0.175

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Tracer 		= "effect_sw_laser_red"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetNetworkedBool( "Ironsights", false ) 

	local npc = self:GetOwner()
	if SERVER and IsValid(npc) and npc:IsNPC() then
		npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	end
end

function SWEP:Think()	
end

function SWEP:SetIronsights( b )
	self:SetNetworkedBool( "Ironsights", b )
end

SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()
	if not self.IronSightsPos then 
		return 
	end

	if self.NextSecondaryAttack > CurTime() then 
		return 
	end
	
	local bIronsights = not self:GetNetworkedBool("Ironsights", false)
	
	self:SetIronsights(bIronsights)
	self.NextSecondaryAttack = CurTime() + 0.3
end

function SWEP:DrawHUD()
	if self:GetNetworkedBool("Ironsights") then 
		return
	end

	local x, y
	if self:GetOwner() == LocalPlayer() && self:GetOwner():ShouldDrawLocalPlayer() then
		local tr = util.GetPlayerTrace(self:GetOwner())
		local trace = util.TraceLine( tr )
		local coords = trace.HitPos:ToScreen()
		x, y = coords.x, coords.y
	else
		x, y = ScrW() / 2.0, ScrH() / 2.0
	end
	
	local scale = 10 * self.Primary.Cone
	local LastShootTime = self:GetNetworkedFloat( "LastShootTime", 0 )

	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	surface.SetDrawColor( 255, 255, 255, 255 )

	local gap = 55 * scale
	local length = gap + 60 * scale

	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end

function SWEP:OnRestore()
	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
end

function SWEP:DoImpactEffect( tr, dmgtype )
	if tr.HitSky then 
		return true 
	end

	util.Decal('fadingscorch', tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

	local effect = EffectData()
	effect:SetOrigin( tr.HitPos )
	effect:SetNormal( tr.HitNormal )
	util.Effect('cwbase_impact', effect )

	return true
end

