if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then
	if (file.Exists("materials/hud/rope_knife.vmt","GAME")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("hud/rope_knife")
	end
	
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.BobScale = 1.5
	SWEP.SwayScale = 1.5
	
	SWEP.PrintName = "Grappling Knife"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.BounceWeaponIcon     = false
	SWEP.DrawWeaponInfoBox = true
	
end

SWEP.HoldType = "melee"

SWEP.Author = "Krede"
SWEP.Contact = "Through Steam"
SWEP.Instructions = "Use it to easily climb up buildings and high places"
SWEP.Category = "Krede's SWEPs"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true



function SWEP:GetViewModelPosition( pos, ang )

	return pos, ang
	
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
	if CLIENT then return end
	timer.Simple(0.2, function()
		self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		if self == NULL or !IsValid(self) then return false end
		local ent = ents.Create("sent_rope_knife")
		ent:SetNWEntity("Owner", self.Owner)
		ent:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector() * 32))
		ent:SetAngles(self.Owner:EyeAngles() + Angle(90,0,0))
		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter(self.Owner:GetAimVector()*1500)
		phys:AddAngleVelocity(Vector(0,10000,0))
		phys:EnableGravity(false)
		undo.Create( "Grappling Knife" )
			undo.AddEntity( ent )
			undo.SetPlayer( self.Owner )
		undo.Finish()
	end)
	
end

function SWEP:OnRemove()
end

function SWEP:Reload()
	return false
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:Initialize()
	self.Weapon:SetWeaponHoldType( self.HoldType )
end

function SWEP:DrawHUD()
	local pos = self.Owner:GetEyeTrace().HitPos
	local ent = self.Owner:GetEyeTrace().Entity
	local movement = LocalPlayer():GetVelocity():Length()/10
	local breath = math.sin(CurTime()*1.4)*3
	movement = math.Clamp(movement+breath,4,50)
	
	if IsValid(self.Owner:GetNWEntity("ClimbingEnt")) and self.Owner:GetMoveType() == MOVETYPE_CUSTOM and GetConVar( "gk_enableshooting" ):GetBool() == false then
		pos = self.Owner:GetNWEntity("ClimbingEnt"):GetPos()
	end
	
	local screenpos = pos:ToScreen()
	
	local col = Color(255,255,255,255)
	if self.Owner:GetPos():Distance( pos ) > 5000 then
		col = Color(255,0,0,255)
	elseif self.Owner:GetPos():Distance( pos ) > 3000 then
		col = Color(255,255,0,255)
	end
	
	if GetConVar( "gk_enabledamage" ):GetBool() == true and IsValid(ent) and !IsValid(self.Owner:GetNWEntity("ClimbingEnt")) and self.Owner:GetMoveType() != MOVETYPE_CUSTOM then
		if ent:IsPlayer() then
			text = ent:Nick()
		else
			local class = ent:GetClass()
			class = string.gsub(class, "npc_", "")
			class = string.gsub(class, "sent_rope_", "")
			class = string.gsub(class, "sent_", "")
			class = string.gsub(class, "ent_", "")
			local first = string.sub(class, 1, 1)
			first = string.upper(first)
			local rest = string.sub(class, 2, string.len(class))
			rest = string.lower(rest)
			text = first..rest
		end
		draw.SimpleText(text, "TargetID", screenpos.x, screenpos.y + movement + 25, col, TEXT_ALIGN_CENTER)
	end
	
	if self.Owner:GetPos():Distance( pos ) < 5000 then
		draw.SimpleText(math.Round(self.Owner:GetPos():Distance( pos )/60, 1).."M", "TargetID", screenpos.x, screenpos.y + movement + 5, col, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("OUT OF RANGE", "TargetID", screenpos.x, screenpos.y + movement + 5, col, TEXT_ALIGN_CENTER)
	end
	
	if LocalPlayer():Crouching() then
		surface.DrawCircle( screenpos.x, screenpos.y, math.Clamp(movement,4,50), col )
	else
		surface.DrawCircle( screenpos.x, screenpos.y, math.Clamp(movement,6,50), col )
	end
end