AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
    local tr = self.Owner:GetEyeTrace()
    if tr.HitPos:DistToSqr(self.Owner:GetPos()) > 128 ^ 2 then return false end

    local ent = ents.Create('shield_barrel')
    ent:SetPos(tr.HitPos)
    ent:Spawn()

    ent.Owner = self.Owner

	self.Owner:StripWeapon('weapon_baseshield')

	return false
end

function SWEP:SecondaryAttack()
	return false
end