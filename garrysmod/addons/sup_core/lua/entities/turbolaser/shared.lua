ENT.Type 		= "anim"
ENT.Base 		= "base_anim"
ENT.PrintName		= "Vanilla_Turbolaser"
ENT.Author		= "VanillaNekoNYAN"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Force		= 1000
ENT.Damage		= 150
ENT.Magnitude		= 100

ENT.Phys		= nil
ENT.Once		= false

function ENT:SetupDataTables()

self:NetworkVar( "String", "3", "Colour" );

end
