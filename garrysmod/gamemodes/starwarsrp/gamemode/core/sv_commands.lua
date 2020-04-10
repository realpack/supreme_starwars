----require("query")
--query.EnableInfoDetour(true)

--print("Detour enabled")
--hook.Add("A2S_INFO", "reply", function(ip, port, info)
 --   if info.players >= 10 then
   --     info.players = math.Round(info.players+9)
     --   if info.players >= game.MaxPlayers() then
       --     info.players = game.MaxPlayers()
        --end
--    end

    --return info
--end)

--hook.Add("A2S_PLAYER", "reply", function(ip, port, info)
    -- print("A2S_PLAYER from", ip, port)
    -- PrintTable(info)
-- -   return info
--end)
