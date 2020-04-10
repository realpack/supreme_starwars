netstream.Hook('ProfileWhitelist_ChangeToTime', function(pPlayer, data)
	local rank = data.rank
	local target = data.target
	local team_index = data.team_index

	local job = meta.jobs[team_index]
	local old_job = meta.jobs[target:Team()]
	local team_id = job.jobID
	-- local features = data.features

	if not pPlayer:CanUseWhitelist() then return end
	if not pPlayer:CanGiveTeam(team_index) then return end
	if not ALIVE_RANKS[job.Type] then return end


	-- local player_id = target:GetNVar('meta_playerid')
	local character_id = target:GetNVar('meta_character')

	local worldmodel = istable(job.WorldModel) and table.Random(job.WorldModel) or job.WorldModel
	local model = (job.FeatureRanks and job.FeatureRanks[rank].model) and job.FeatureRanks[rank].model or worldmodel

	target:StripWeapons()
	target:SetNVar('meta_model', model, NETWORK_PROTOCOL_PUBLIC)

	target:SetMaxHealth(job.maxHealth or 100);
	target:SetHealth(job.maxHealth or 100);
	target:SetArmor(job.maxArmor or 255);
	target:SetNVar('maxArmor', job.maxArmor or 255, NETWORK_PROTOCOL_PUBLIC)
	target:SetNVar('maxHealth', job.maxHealth or 100, NETWORK_PROTOCOL_PUBLIC)

	if data.no_spawn then
		target:SetTeam(team_index)
		target:Spawn()
	else
		local pos, ang = target:GetPos(), target:EyeAngles()
		target:SetTeam(team_index)
		target:Spawn()
		target:SetPos(pos)
		target:SetEyeAngles(ang)
	end

	target:SetNVar('meta_rank', rank, NETWORK_PROTOCOL_PUBLIC)
	target:SetNWString('meta_rank', rank)
	-- target:SetNVar('meta_features', features, NETWORK_PROTOCOL_PUBLIC)
end)

netstream.Hook('ProfileWhitelist_Change', function(pPlayer, data)
    local rank = data.rank
    local target = data.target
    local team_index = data.team_index

    if ((pPlayer.nextChangeWhitelist or 0) >= CurTime()) then return end
    pPlayer.nextChangeWhitelist = CurTime() + .1

    local job = meta.jobs[team_index]
    local old_job = meta.jobs[pPlayer:Team()]
    local team_id = job.jobID
    local features = data.features
    local modify_model = data.model

    local old_rank = pPlayer:GetNVar('meta_rank')
    local old_features = pPlayer:GetNVar('meta_features')

    if not pPlayer:CanUseWhitelist() then return end
    if not pPlayer:CanGiveTeam(team_index) then return end
    if not ALIVE_RANKS[job.Type] then return end

    local player_id = target:GetNVar('meta_playerid')
    local character_id = target:GetNVar('meta_character')

    for index, char in pairs(pPlayer.Characters) do
        if char.character_id == character_id then
            char.features = features
            char.rank = rank
            char.team_id = team_id
            char.team_index = team_index
            break
        end
    end

    local model = false
    if modify_model then
        model = modify_model
        target:SetNVar('meta_model', model, NETWORK_PROTOCOL_PUBLIC)
    else
        local worldmodel = istable(job.WorldModel) and table.Random(job.WorldModel) or job.WorldModel
        local model = (job.FeatureRanks and job.FeatureRanks[rank].model) and job.FeatureRanks[rank].model or worldmodel

        target:SetNVar('meta_model', model, NETWORK_PROTOCOL_PUBLIC)

        local one_ft = false
        for ft, bool in pairs(features) do
            if one_ft then
                features[ft] = false
            else
                if bool == true then
                    one_ft = true

                    local norm_ft = FEATURES_TO_NORMAL[ft]
                    if norm_ft then
                        if norm_ft.models and norm_ft.models[team_index] then
                            target:SetNVar('meta_model', norm_ft.models[team_index], NETWORK_PROTOCOL_PUBLIC)
                            model = norm_ft.models[team_index]
                        end
                    end
                end
            end
        end
    end

    target:StripWeapons()

    target:SetMaxHealth(job.maxHealth or 100);
	target:SetHealth(job.maxHealth or 100);
	target:SetArmor(job.maxArmor or 255);
    target:SetNVar('maxArmor', job.maxArmor or 255, NETWORK_PROTOCOL_PUBLIC)
    target:SetNVar('maxHealth', job.maxHealth or 100, NETWORK_PROTOCOL_PUBLIC)

    if data.no_spawn then
        target:SetTeam(team_index)
        target:Spawn()
    else
        local pos, ang = target:GetPos(), target:EyeAngles()
        target:SetTeam(team_index)
        target:Spawn()
        target:SetPos(pos)
        target:SetEyeAngles(ang)
    end

    target:SetNVar('meta_rank', rank, NETWORK_PROTOCOL_PUBLIC)
    target:SetNWString('meta_rank', rank)
    target:SetNVar('meta_features', features, NETWORK_PROTOCOL_PUBLIC)

    MySQLite.query( string.format("UPDATE metahub_characters SET rank = %s, team_id = %s, features = %s, model = %s WHERE player_id = %s AND character_id = %s;",
        MySQLite.SQLStr(rank),
        MySQLite.SQLStr(team_id),
        MySQLite.SQLStr( util.TableToJSON(features) ),
        MySQLite.SQLStr(model),
        MySQLite.SQLStr(player_id),
        MySQLite.SQLStr(character_id)
    ))
end)