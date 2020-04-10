function GetInfoAllSpawns()
    local spawns = {}
    for i, ent in pairs(ents.FindByClass('info_player_start')) do
        spawns[i] = { pos = ent:GetPos(), ang = ent:GetAngles(), index = ent:GetCreationID(), category = ent.Category }
    end

    return spawns
end

local function SpawnInfoPlayers()
    MySQLite.query( string.format( "SELECT * FROM metahub_spawnpoints WHERE map = %s;", MySQLite.SQLStr(game.GetMap()) ), function(data)
        if data and istable(data) then
            for _, v in pairs(ents.FindByClass('spawn_point')) do
                v:Remove()
            end

            for k, e in pairs(data) do
                local ent = ents.Create('spawn_point')
                ent:Spawn()
                ent:Activate()
                ent:SetPos( Vector(e.vector) )
                ent.Category = e.category
                ent:SetNWString('Category', e.category)
                ent.SpawnPointID = e.id
                ent:SetNWString('SpawnPointID', e.id)
            end
        end
    end)
end


-- hook.Add("PlayerSay", "SpawnPoints_PlayerSay", function(ply, text, teamonly)
--     local args = string.Explode(" ", text)

--     if args[1] == "/rmspawn" and ply:IsUserGroup('founder') then
--         local id = tonumber(args[2])
--         if isnumber(id) then
--             local vector = false
--             for _, v in pairs(ents.FindByClass('spawn_point')) do
--                 if v:GetCreationID() == id then
--                     vector = tostring(v:GetPos())

--                     MySQLite.query( string.format( "DELETE FROM `metahub_spawnpoints` WHERE map = %s AND vector = %s;", MySQLite.SQLStr(game.GetMap()), MySQLite.SQLStr(vector) ), function(data)
--                         v:Remove()
--                     end)

--                     timer.Simple(1, function()
--                         netstream.Start(player.GetAll(), 'SpawnPoints_SendAllPlayerInfoStarts', GetInfoAllSpawns())
--                     end)
--                     break
--                 end
--             end
--         end
--         return ""
--     end
-- end)

hook.Add('PostCleanupMap', 'SpawnPoints_PostCleanupMap', function()
    SpawnInfoPlayers()
end)

hook.Add('InitPostEntity', 'SpawnPoints_InitPostEntity', function()
    SpawnInfoPlayers()
end)

hook.Add('DatabaseInitialized', 'SpawnPoints_DatabaseInitialized', function()
    timer.Simple(2, function()
        SpawnInfoPlayers()
    end)
end)

-- SpawnInfoPlayers()

function meta.util.isEmpty(vector, ignore)
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

    return a and b
end


function meta.util.findEmptyPos(pos, ignore, distance, step, area)
    if meta.util.isEmpty(pos, ignore) and meta.util.isEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do -- alternate in direction
            local k = j * i

            -- Look North/South
            if meta.util.isEmpty(pos + Vector(k, 0, 0), ignore) and meta.util.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            -- Look East/West
            if meta.util.isEmpty(pos + Vector(0, k, 0), ignore) and meta.util.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            -- Look Up/Down
            if meta.util.isEmpty(pos + Vector(0, 0, k), ignore) and meta.util.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end

netstream.Hook('SpawnPoint_Create', function(pPlayer, data)
    if pPlayer:GetUserGroup() == 'founder' or pPlayer:GetUserGroup() == 'serverstaff' or pPlayer:GetUserGroup() == 'moderator' then
        local vector = data.vector
        local category = data.category

        MySQLite.query(string.format("INSERT INTO `metahub_spawnpoints`(map, vector, category) VALUES(%s, %s, %s);",
            MySQLite.SQLStr( game.GetMap() ), MySQLite.SQLStr( tostring(vector) ), MySQLite.SQLStr( category )
        ), function(a,id)
            local ent = ents.Create('spawn_point')
            ent:Spawn()
            ent:Activate()
            ent:SetPos(vector)
            ent.Category = data.category
            ent:SetNWString('Category', data.category)
            ent.SpawnPointID = id
            ent:SetNWString('SpawnPointID', id)
        end)
    end
end)

netstream.Hook('SpawnPoint_Reload', function(pPlayer, data)
    if pPlayer:GetUserGroup() == 'founder' or pPlayer:GetUserGroup() == 'serverstaff' then
        local vector = data.vector
        local category = data.category
        local target = data.target

        local id = target.SpawnPointID

        -- print(string.format( "UPDATE `metahub_spawnpoints` SET vector = %s, category = %s WHERE map = %s AND id = %s;", MySQLite.SQLStr(tostring(target:GetPos())), MySQLite.SQLStr(category), MySQLite.SQLStr(game.GetMap()), MySQLite.SQLStr(target.SpawnPointID) ))
        MySQLite.query( string.format( "UPDATE `metahub_spawnpoints` SET vector = %s, category = %s WHERE map = %s AND id = %s;",
            MySQLite.SQLStr(tostring(target:GetPos())), MySQLite.SQLStr(category), MySQLite.SQLStr(game.GetMap()), MySQLite.SQLStr(id) ), function()
                target.Category = category
                target:SetNWString('Category', category)
                target.SpawnPointID = id
                target:SetNWString('SpawnPointID', id)
            end
        )
    end
end)

-- hook.Add('PlayerSelectSpawn', 'SpawnPoints_PlayerSelectSpawn', function( ply )
--     -- local spawn = GAMEMODE.Sandbox.PlayerSelectSpawn(GAMEMODE, ply)

--     -- local POS
--     -- if spawn and spawn.GetPos then
--     --     POS = spawn:GetPos()
--     -- else
--     --     POS = ply:GetPos()
--     -- end

--     -- POS = meta.util.findEmptyPos(Vector(-1270.486450, 1062.328979, -431.968750), {ply}, 600, 30, Vector(16, 16, 64))

--     -- return spawn, POS
-- end)
