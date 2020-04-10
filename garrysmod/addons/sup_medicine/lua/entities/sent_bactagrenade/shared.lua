ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Impulse Grenade"
ENT.Author = "randomscripter"
ENT.Contact = "..."
ENT.Purpose = "..."
ENT.Instructions = "you shouldnt be reading this" 

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupModel()

	self.Entity:SetModel( "models/items/grenadeAmmo.mdl" )

end