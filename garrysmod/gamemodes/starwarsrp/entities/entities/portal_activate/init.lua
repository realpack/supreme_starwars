AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel('models/fyu/cedi/coruscant/v4/coru_stuff_3.mdl')

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE )
    self.ProtalVector = false

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end
end

function ENT:StartTouch( ent )
    if ent and IsValid(ent) and ent:Alive() and self.ProtalVector then

        local job = meta.jobs[ent:Team()]
        if job and job.Type == TYPE_JEDI then
            ent:SetPos(self.ProtalVector)
        end
    end
end

function ENT:AcceptInput(inputName, pPlayer)
    if SPAWNPORTALS_COMMANDERS[pPlayer:Team()] or pPlayer:IsUserGroup('founder') then
        netstream.Start(pPlayer,'NPCPortal_OpenMenu',{ ent_index = self:EntIndex() })
    end
end

netstream.Hook("NPCPortal_MakeProtals", function(pPlayer, data)
    local name = data.name
    local ent_index = data.ent_index

    if SPAWNPORTALS_COMMANDERS[pPlayer:Team()] or pPlayer:IsUserGroup('founder') then
        if SPAWNPORTALS_VECTORS[name] then
            Entity( ent_index ).ProtalVector = SPAWNPORTALS_VECTORS[name]
            -- for _, ent in pairs(ents.FindByClass('portal_activate')) do
            --     ent.ProtalVector = SPAWNPORTALS_VECTORS[name]
            -- end
        end
    end
end)
