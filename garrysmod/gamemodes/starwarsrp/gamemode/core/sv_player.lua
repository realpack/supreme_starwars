function pMeta:SavePlayerData( name, value, is_money )
    local str = isnumber(value) and "%d" or "%s"
    value = isnumber(value) and value or MySQLite.SQLStr(value)
    if is_money and (value < 0 or value >= 1 / 0) then return end

    MySQLite.query( string.format( "UPDATE metahub_player_data SET %s = "..str.." WHERE steam_id = %s;",
        name,
        value,
        MySQLite.SQLStr( self:SteamID() )
    ))
end

function pMeta:ChangeRPID( new )
    if not self:GetNVar('is_load_char') then return end

    local t = self:Team()
    local char_id = self:GetNVar('meta_character')

    if not char_id then return end
    if t == TEAM_CONNECTING or t == TEAM_SPECTATOR or t == TEAM_UNASSIGNED then return end

    MySQLite.query(string.format( "UPDATE metahub_characters SET rpid = %s WHERE character_id = %s;",
        MySQLite.SQLStr( new ),
        MySQLite.SQLStr( char_id)
    ), function()
        self:SetNVar('meta_rpid', new, NETWORK_PROTOCOL_PUBLIC)
        self:SetNWString('meta_rpid', new)
    end)
end

function pMeta:CharacterByID(character_id)
    for i, char in pairs(self.Characters) do
        if char.character_id == character_id then
            return char
        end
    end

    return false
end

function pMeta:SetMoney(intCount)
    self:SavePlayerData('money', intCount, true)
    self:SetNVar('meta_money', intCount, NETWORK_PROTOCOL_PUBLIC)
end

function pMeta:AddMoney(intCount)
    self:SetMoney(self:GetMoney()+intCount)
end

function pMeta:RequestCharacters(func)
    MySQLite.query( string.format("SELECT * FROM metahub_player_data WHERE steam_id = %s;", MySQLite.SQLStr(self:SteamID())), function(player_data)
        if player_data and istable(player_data) then
            self:SetNVar('meta_playerid',player_data[1].id)
            MySQLite.query( string.format("SELECT * FROM metahub_characters WHERE player_id = %s;", MySQLite.SQLStr(player_data[1].id)), function(characters)
                local characters = characters or {}
                for i, char in pairs(characters) do
                    characters[i].team_index = meta.jobs_by_id[char.team_id].index
                end

                if func then func(characters, player_data[1]) end
                return characters, player_data[1]
            end, function(err)
                print(err)
                return err
            end)
        else
            return false
        end

    end, function(err)
        print(err)
        return err
    end)
end

function pMeta:LoadCharacter(func, character_id)
    local steamid = self:SteamID()

    local char = self:CharacterByID(character_id)

    if char then
        self:SetNVar('is_load_char', true, NETWORK_PROTOCOL_PRIVATE)
        self:SetNWString( "rpname", char.name )
        -- self:SetCurrentSkillHooks()

        self:SetTeam(char.team_index)
        self:Spawn()

        if func then func(char) end
    else
        self:ConCommand('retry')
    end

    -- self:RequestCharacters(function(characters, player_data)
    --     self.Characters = characters

    --     local char = self:CharacterByID(character_id)

    --     if char then
    --         self:SetNVar('is_load_char', true, NETWORK_PROTOCOL_PRIVATE)
    --         self:SetNWString( "rpname", char.name )

    --         self:SetTeam(char.team_index)
    --         self:Spawn()

    --         if func then func(char) end
    --     end
    -- end)
end

-- function GM:PlayerInitialSpawn(pPlayer)
--     pPlayer:RequestCharacters(function(characters, player_data)
--         pPlayer.Characters = characters

--         netstream.Start(pPlayer, "OpenCharacterMenu", characters)
--     end)
-- end

function GM:PlayerSelectSpawn(pPlayer)
    local tm = pPlayer:Team()

	if tm == 0 or tm == 1001 then
		pPlayer:SetPos(Vector('-13051.519531 13943.320313 -880.392822'))
		return
	end

    if pPlayer:GetNVar("Arrested") == true then
        pPlayer:SetPos(table.Random(JAIL_VECTORS))
        return
    end

    local spawn_categories, spawns = {}, {}
    for name, data in pairs(SPAWNPOINTS_CATEGORIES) do
        if data.teams[pPlayer:Team()] then
            spawn_categories[name] = data.priority
        end
    end



    for _, ent in pairs( ents.FindByClass('spawn_point') ) do
        local cat = ent.Category
        if cat == table.GetWinningKey( spawn_categories ) then
            table.insert(spawns, ent)
        end
    end

    if #spawns == 0 then
        for _, ent in pairs( ents.FindByClass('spawn_point') ) do
            local cat = ent.Category
            if cat == 'all' then
                table.insert(spawns, ent)
            end
        end
    end

    -- PrintTable(spawns)

    local spawn = #spawns > 0 and table.Random(spawns) or table.Random(ents.FindByClass('info_player_start'))

    local POS

    if spawn and spawn.GetPos then
        POS = spawn:GetPos()
    else
        POS = pPlayer:GetPos()
    end

    POS = meta.util.findEmptyPos(POS, {pPlayer}, 600, 30, Vector(16, 16, 64))

    return spawn, POS
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if talker.isScanner then return end

    return listener:GetPos():Distance(talker:GetPos()) <= DEFAULT_VOICE_DISTANCE, true
end

function GM:PlayerCanSeePlayersChat( text, bTeam, listener, talker )
    if not IsValid(listener) or not IsValid(talker) then return end
    if listener:GetPos():Distance( talker:GetPos() ) > 300 then return false end
    return true
end