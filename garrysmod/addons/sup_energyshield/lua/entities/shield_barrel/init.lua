AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OnRemove()
	self.shield:Remove()
end

function ENT:AcceptInput(inputName, pPlayer)
    if self.Owner and pPlayer == self.Owner then
        self:Remove()

		pPlayer:Give('weapon_baseshield')
    end
end

function ENT:OnTakeDamage( dmg )
    self:TakePhysicsDamage(dmg)

    local damage = (self:GetStability() or 100) - dmg:GetDamage()/10
    self:SetStability(damage)

    if damage <= 0 then
        self:Remove()
    end
end

-- -- Entity:GetCollisionBounds()
-- -- ent:GetRenderBounds()