netstream.Hook("NewPlayerCharacter", function(pPlayer, data)
    if not (IsValid(pPlayer)) then return end

    local character_name = string.sub( data.name, 1, 30 )
    local rpid = math.random(1,9)..math.random(1,9)..math.random(1,9)..math.random(1,9)

    local whitelist_teams = WHITELIST_GROUP_TEAMS[pPlayer:GetUserGroup()]
    local start_team = (whitelist_teams and data.start_team and whitelist_teams[data.start_team]) and data.start_team or TEAM_CADET

    MySQLite.query(string.format("SELECT * FROM `metahub_player_data` WHERE steam_id = %s;", MySQLite.SQLStr(pPlayer:SteamID())), function(player_data)
        if player_data and istable(player_data) then
            local characters = pPlayer.Characters or {}
            local job = meta.jobs[start_team]
            -- local default_rank = table.GetKeys(ALIVE_RANKS[TYPE_CLONE])[1]
            local default_rank = DEFAULT_RANKS[TYPE_CLONE]
            local worldmodel = istable(job.WorldModel) and table.Random(job.WorldModel) or job.WorldModel
            local model = (job.FeatureRanks and job.FeatureRanks[default_rank] and job.FeatureRanks[default_rank].model) and job.FeatureRanks[default_rank].model or worldmodel

            local char = {
                player_id = player_data[1].id,
                rpid = rpid,
                team_id = job.jobID,
                character_name = character_name,
                data = {},
            }
            pPlayer:SetNVar('meta_money', tonumber(player_data[1].money), NETWORK_PROTOCOL_PUBLIC)
            pPlayer:SetNVar('meta_vehicles', util.JSONToTable(player_data[1].vehicles), NETWORK_PROTOCOL_PUBLIC)
            pPlayer:SetNVar('meta_model', model, NETWORK_PROTOCOL_PUBLIC)
            pPlayer:SetNVar('meta_data', util.JSONToTable(char.data), NETWORK_PROTOCOL_PUBLIC)

            local max_characters = GROUPS_RELATION[pPlayer:GetUserGroup()] or 1
            if #characters <= max_characters then
                MySQLite.query(string.format("INSERT INTO `metahub_characters`(player_id, rpid, rank, features, team_id, character_name, model, data) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s);",
                    char.player_id,
                    MySQLite.SQLStr( char.rpid ),
                    MySQLite.SQLStr( default_rank ),
                    MySQLite.SQLStr( util.TableToJSON(DEFAULT_FEATURES) ),
                    MySQLite.SQLStr( char.team_id ),
                    MySQLite.SQLStr( char.character_name ),
                    MySQLite.SQLStr( model ),
                    MySQLite.SQLStr( util.TableToJSON(char.data) )
                ), function(e, char_id)
                    pPlayer.Characters = characters or {}
                    char.character_id = char_id
                    char.rpid = rpid
                    char.rank = default_rank
                    char.features = DEFAULT_FEATURES
                    char.team_index = start_team
                    char.model = model
                    char.data = {}
                    table.insert(pPlayer.Characters, char)

                    GmLogger.PostMessageInDiscord(string.format("Игрок **%s**(``%s``) создал нового персонажа(%s), .", pPlayer:OldName(), pPlayer:SteamID(), char_id, team.GetName(start_team)), '0x4f545c')

                    pPlayer:RequestCharacters(function(characters, player_data)
                        netstream.Start(pPlayer, "OpenCharacterMenu", { characters = characters })
                        pPlayer.Characters = characters
                    end)
                end, function(e) print(e) end)
            end
        else
            MySQLite.query(string.format("INSERT INTO `metahub_player_data`(steam_id, community_id, player, money, vehicles) VALUES(%s, %s, %s, %s, %s);",
                MySQLite.SQLStr( pPlayer:SteamID() ),
                MySQLite.SQLStr( pPlayer:SteamID64() ),
                MySQLite.SQLStr( pPlayer:OldName() ),
                MySQLite.SQLStr( DEFAULT_MONEY ),
                MySQLite.SQLStr( '{}' )
            ), nil, nil)

            pPlayer:SetNVar('meta_money', DEFAULT_MONEY, NETWORK_PROTOCOL_PUBLIC)
            pPlayer:SetNVar('meta_vehicles', util.JSONToTable('{}'), NETWORK_PROTOCOL_PUBLIC)
        end
    end)
end)

netstream.Hook("RemovePlayerCharacter", function(pPlayer, data)
    if not (IsValid(pPlayer)) then return end
    local can_remove = true

    if pPlayer:GetNVar('meta_character') == data.character_id then
        pPlayer:RequestCharacters(function(characters, player_data)
            netstream.Start(pPlayer, "OpenCharacterMenu", { characters = characters, err = 'Вы не можете удалить этого персонажа играя за него.' })
        end)
        return
    end

    local character_id = data.character_id
    for k, char in pairs(pPlayer.Characters) do
        if char.character_id == 1 then
            if char.team_id == 'cadet_dolbaeb' then
                netstream.Start(pPlayer, "OpenCharacterMenu", { characters = pPlayer.Characters, err = 'Вы не можете удалить этого персонажа.' })
                can_remove = false
            end
            break
        end
    end
    if can_remove ~= false then
        MySQLite.query(string.format("DELETE FROM `metahub_characters` WHERE character_id = %s;", MySQLite.SQLStr(character_id)), function()
            pPlayer:RequestCharacters(function(characters, player_data)
                netstream.Start(pPlayer, "OpenCharacterMenu", { characters = characters })
                pPlayer.Characters = characters
            end)
        end)
    end
end)

netstream.Hook("SpawnPlayerCharacter", function(pPlayer, data)
    if not pPlayer:Alive() then return end

    if not IsValid(pPlayer) then return end
    local character_id = data.character_id

    if not (character_id) then return end
    if not (pPlayer:CharacterByID(character_id)) then return end

    if pPlayer:GetNVar("Arrested") then
        return
    end

    pPlayer:LoadCharacter(function(char)
        hook.Run('PlayerLoadout', pPlayer)

        pPlayer:SetNVar('meta_character', character_id, NETWORK_PROTOCOL_PUBLIC)
        pPlayer:SetNWString('meta_rank', char.rank)

        local features = istable(char.features) and char.features or util.JSONToTable(char.features)
        local data = istable(char.data) and char.data or util.JSONToTable(char.data)
        pPlayer:SetNVar('meta_features', features, NETWORK_PROTOCOL_PUBLIC)
        pPlayer:SetNVar('meta_rpid', char.rpid, NETWORK_PROTOCOL_PUBLIC)
        pPlayer:SetNWString( 'meta_rpid', char.rpid )
        pPlayer:SetNWString( "rpname", char.character_name )
        pPlayer:SetNVar('meta_model', char.model, NETWORK_PROTOCOL_PUBLIC)
        pPlayer:SetNVar('meta_data', data, NETWORK_PROTOCOL_PUBLIC)

        pPlayer:Spawn()

        -- GmLogger.PostMessageInDiscord(string.format("Игрок **%s**(``%s``) выбрал персонажа(``%s``,``%s``).", pPlayer:OldName(), pPlayer:SteamID(), char.character_name, character_id), '0x4f545c')
    end, character_id)

    MySQLite.query(string.format("SELECT * FROM `metahub_player_levelsystem` WHERE steam_id = %s;", MySQLite.SQLStr(pPlayer:SteamID())), function(data)
        local level, experience

		if (data and istable(data)) then
            level, experience = data[1].level, data[1].experience
		else
            level, experience = 0, 0

			MySQLite.query( string.format("INSERT INTO `metahub_player_levelsystem`(steam_id, level, experience) VALUES(%s, %s, %s);",
                MySQLite.SQLStr( pPlayer:SteamID() ),
                MySQLite.SQLStr( level ),
                MySQLite.SQLStr( experience )
            ))
		end

        pPlayer:SetNVar('meta_level', level, NETWORK_PROTOCOL_PUBLIC)
        pPlayer:SetNVar('meta_experience', experience, NETWORK_PROTOCOL_PUBLIC)
	end )
end)

hook.Add('PlayerInitialSpawn', 'Characters_PlayerInitialSpawn', function(pPlayer)
    pPlayer:SetNVar("Arrested", false)

    MySQLite.query(string.format("SELECT * FROM `metahub_player_data` WHERE steam_id = %s;", MySQLite.SQLStr(pPlayer:SteamID())), function(player_data)
        if player_data and istable(player_data) then

            pPlayer:SetNVar('meta_money', tonumber(player_data[1].money), NETWORK_PROTOCOL_PUBLIC)
            pPlayer:SetNVar('meta_vehicles', util.JSONToTable(player_data[1].vehicles), NETWORK_PROTOCOL_PUBLIC)

            pPlayer:RequestCharacters(function(characters, player_data)
                netstream.Start(pPlayer, "OpenInitCharacterMenu", { characters = characters })
                pPlayer.Characters = characters
            end)
        else
            MySQLite.query(string.format("INSERT INTO `metahub_player_data`(steam_id, community_id, player, money, vehicles) VALUES(%s, %s, %s, %s, %s);",
                MySQLite.SQLStr( pPlayer:SteamID() ),
                MySQLite.SQLStr( pPlayer:SteamID64() ),
                MySQLite.SQLStr( pPlayer:OldName() ),
                MySQLite.SQLStr( DEFAULT_MONEY ),
                MySQLite.SQLStr( '{}' )
            ), function(e, id)
                pPlayer:SetNVar('meta_money', DEFAULT_MONEY, NETWORK_PROTOCOL_PUBLIC)
                pPlayer:SetNVar('meta_vehicles', util.JSONToTable('{}'), NETWORK_PROTOCOL_PUBLIC)

                pPlayer:RequestCharacters(function(characters, player_data)
                    netstream.Start(pPlayer, "OpenInitCharacterMenu", { characters = characters })
                    pPlayer.Characters = characters
                end)
            end, nil)
        end
    end)
end)