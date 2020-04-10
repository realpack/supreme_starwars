AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel('models/galactic/supclone/loreclone/simequipmentlocker.mdl')

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE )
    self:SetModelScale(0.7)
    self.ProtalVector = false

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end
end

function ENT:AcceptInput(inputName, pPlayer)
    if ((pPlayer.nextUse or 0) >= CurTime()) then
		return
	end

    pPlayer.nextUse = CurTime() + 1
    if meta.jobs[pPlayer:Team()].Type == TYPE_CLONE then
        netstream.Start(pPlayer,'Cupboard_OpenMenu',{ ent_index = self:EntIndex() })
    end

    -- for _, wep in pairs(meta.jobs[pPlayer:Team()].weapons) do
    --     pPlayer:Give(wep)
    -- end

    -- local team = meta.jobs[pPlayer:Team()]

    -- local rank = pPlayer:GetNWString('meta_rank')
    -- local feature_weapons = {}
    -- if rank then
    --     feature_weapons = (team.FeatureRanks and team.FeatureRanks[rank].weapons) and team.FeatureRanks[rank].weapons or {}
    -- end

    -- -- print(feature_weapons)
    -- -- PrintTable(feature_weapons)

	-- for _, wep in pairs(feature_weapons) do
	-- 	pPlayer:Give(wep)
	-- end
end

netstream.Hook("Cupboard_TakeModel", function(pPlayer, data)
    local name = data.name
    local feat = FEATURE_ARMORMODELS[name] or false

    if feat and feat.check(pPlayer) == true then
        local model = feat.model

        if model and pPlayer and IsValid(pPlayer) then
            pPlayer:SetModel(model)
            pPlayer:GetNVar('meta_character')
            MySQLite.query( string.format( "UPDATE metahub_characters SET model = %s WHERE character_id = %s;",
                MySQLite.SQLStr( model ),
                MySQLite.SQLStr( tostring(pPlayer:GetNVar('meta_character')) )
            ))
        end
    end
end)

netstream.Hook("Cupboard_TakeOffModel", function(pPlayer, data)
    for key, feat in pairs(FEATURE_ARMORMODELS) do
        if feat.model == pPlayer:GetModel() then
            local job = meta.jobs[pPlayer:Team()]
            local rank = pPlayer:GetNWString('meta_rank') or DEFAULT_RANKS[TYPE_CLONE]
            local worldmodel = istable(job.WorldModel) and table.Random(job.WorldModel) or job.WorldModel
            local model = (job.FeatureRanks and job.FeatureRanks[rank].model) and job.FeatureRanks[rank].model or worldmodel

            if model and pPlayer and IsValid(pPlayer) then
                pPlayer:SetModel(model)
                pPlayer:GetNVar('meta_character')
                MySQLite.query( string.format( "UPDATE metahub_characters SET model = %s WHERE character_id = %s;",
                    MySQLite.SQLStr( model ),
                    MySQLite.SQLStr( tostring(pPlayer:GetNVar('meta_character')) )
                ))
            end

            break
        end
    end
end)
