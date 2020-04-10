ENT.Type 		= "anim"
ENT.Base 		= "base_anim"
ENT.PrintName		= "Vanilla_Hyperspace"
ENT.Author		= "VanillaNekoNYAN"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

function ENT:SetupDataTables()
    self:NetworkVar("String","1","PlaySound")
end
