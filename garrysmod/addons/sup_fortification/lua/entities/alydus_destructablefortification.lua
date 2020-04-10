AddCSLuaFile()

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
else
	CreateConVar("alydus_enablefortificationdestructionmessage", 1)
end
function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_fortifications/sandbags_line1.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end
function ENT:OnTakeDamage(dmg)
	if SERVER then
		local currentHardpointHealth = self:GetNWInt("fortificationHealth", 0)

		if currentHardpointHealth <= 0 then
			return false
		end

		if dmg:GetDamage() >= 1 then

			currentHardpointHealth = currentHardpointHealth - dmg:GetDamage()

			self:SetNWInt("fortificationHealth", currentHardpointHealth)
		end
	end
end

function ENT:Think()
	if SERVER then
		if self.previousHealth != self:GetNWInt("fortificationHealth", 0) then
			self.previousHealth = self:GetNWInt("fortificationHealth", 0)
		end
		if self.previousHealth == 0 or self:GetNWInt("fortificationHealth", 0) <= 0 then
			self:EmitSound("physics/concrete/concrete_break2.wav")

			if GetConVar("alydus_enablefortificationdestructionmessage"):GetInt() == 1 and IsValid(self.isPlayerPlacedFortification) and self.isPlayerPlacedFortification:IsPlayer() then
				self.isPlayerPlacedFortification:ChatPrint("Ваша фортификация была уничтожена!")
			end

			self:Remove()
		end
	end
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = true

ENT.PrintName = "Destructable Fortification"
ENT.Author = "Alydus"
ENT.Contact = "Alydus"
ENT.Purpose = "A destructable fortification, can only be spawned using the fortification builder tablet."
ENT.Instructions = "Spawn by using the fortification builder tablet weapon."