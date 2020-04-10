AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel('models/props/supweaponlocker.mdl')

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

function ENT:AcceptInput(inputName, pPlayer)
    if ((self.nextUse or 0) >= CurTime()) then
		return
	end

    self.nextUse = CurTime() + 1

    for _, wep in pairs(meta.jobs[pPlayer:Team()].weapons) do
        pPlayer:Give(wep)
    end

    local team = meta.jobs[pPlayer:Team()]

    local rank = pPlayer:GetNWString('meta_rank')
    local rank_weapons = {}
    if rank then
        rank_weapons = (team.FeatureRanks and team.FeatureRanks[rank].weapons) and team.FeatureRanks[rank].weapons or {}
    end

    local features = pPlayer:GetNVar('meta_features')
    if features and istable(features) then
        for feat, bool in pairs(features) do
            if bool then
                for _, wep in pairs(FEATURES_TO_NORMAL[feat].weapons) do
                    pPlayer:Give(wep)
                end
            end
        end
    end

    -- print(rank_weapons)
    -- PrintTable(rank_weapons)

	for _, wep in pairs(rank_weapons) do
		pPlayer:Give(wep)
	end
end
