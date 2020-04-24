AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
 
	self:SetModel( "models/props_lab/tpplugholder_single.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
		if engine.ActiveGamemode() == "cwhl2rp" then
		self.HL2RP = true
	end
	
	timer.Simple(0.5, function()
	if self.HL2RP == true then
	local socket = ents.Create("prop_physics");
    socket:SetPos(self:GetPos());
    socket:SetAngles(self:GetAngles());
    socket:SetModel(self:GetModel())
    socket:Activate();
    socket:Spawn();
	self:Remove()
	end
	end)


 
end

