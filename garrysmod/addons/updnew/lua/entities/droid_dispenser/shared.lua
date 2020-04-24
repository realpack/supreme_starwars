
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName	= "Droid Dispenser"
ENT.Category		= "Droid Dispenser"

ENT.Spawnable			= true
ENT.AdminSpawnable	= true
ENT.AdminOnly = false
ENT.DoNotDuplicate = true
ENT.MineAmmo = 5

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "MineAmmoNum")
end