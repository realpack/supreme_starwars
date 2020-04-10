    netstream.Hook("WalkieTalkie.SpeakerToggle", function(ply, data)
    ply.walkie_talkie.speaker = not ply.walkie_talkie.speaker

    local str = not ply.walkie_talkie.speaker and "выключили" or "включили"
    meta.util.Notify('yellow', ply, "Вы "..str.." рацию.")
end)

netstream.Hook("WalkieTalkie.MicroToggle", function(ply, data)
    ply.walkie_talkie.micro = not ply.walkie_talkie.micro

    local str = not ply.walkie_talkie.micro and "выключили" or "включили"
    meta.util.Notify('yellow', ply, "Вы "..str.." микрофон рации.")
end)

netstream.Hook("WalkieTalkie.ChangeChannel", function(ply, data)
    local channel = data.channel

    if not channel or channel < 0 or channel > 100 then
        meta.util.Notify('red', ply, "Канал рации может быть не выше 100 и не ниже 0.")
        return
    end

    ply:SetNVar('meta_radio', data.channel, NETWORK_PROTOCOL_PUBLIC)
    meta.util.Notify('yellow', ply, "Вы изменили канал рации на "..data.channel..".")
end)

hook.Add("PlayerInitialSpawn", "WalkieTalkie_PlayerInitialSpawn", function(ply)
    ply.walkie_talkie = ply.walkie_talkie or {}
    ply.walkie_talkie.speaker = false
    ply.walkie_talkie.micro = false
end)

hook.Add("PlayerCanHearPlayersVoice", "WalkieTalkie_PlayerCanHearPlayersVoice", function(listener, talker)
    if not talker or not listener or talker.isScanner then return end
    if not talker.walkie_talkie or not listener.walkie_talkie then return end

    -- local job_l = meta.jobs[listener:Team()]
    -- local job_t = meta.jobs[talker:Team()]
    local channel_l = listener:GetNVar('meta_radio')
    local channel_t = talker:GetNVar('meta_radio')
    local listener_s, listener_m = listener.walkie_talkie.speaker, listener.walkie_talkie.micro
    local talker_s, talker_m = talker.walkie_talkie.speaker, talker.walkie_talkie.micro

    if talker_m and talker_s and listener_s then
        if channel_l and channel_t and channel_l == channel_t then
            return true
        end
        -- if job_l and job_l.radio and job_t and job_t.radio and job_l.radio == job_t.radio then
        --     return true
        -- end
    end
end)

local function find_players_in_radio(radio)
    local targets = {}

    for k, v in pairs(player.GetAll()) do
        local channel = v:GetNVar('meta_radio')

        if channel and channel == radio then
            table.insert(targets, v)
        end
        -- local job = meta.jobs[v:Team()]

        -- if job and job.radio and job.radio == radio then
        --     table.insert(targets, v)
        -- end
    end

    return targets
end

local function send_group_message(ply, radio, text)
    if not radio then
        meta.util.Notify("red", ply, "Вы не можете использовать групповой чат.")
        return
    end

    text = string.gsub(text, "/g", "", 1)

    ChatAddText(find_players_in_radio(radio), Color(135, 102, 245), "[Рация] ", ply, color_white, ': ', text)
end

hook.Add("PlayerSay", "WalkieTalkie_PlayerSay", function(ply, text, teamonly)
    local job = meta.jobs[ply:Team()]
    local args = string.Explode(" ", text)

    local radio = ply:GetNVar('meta_radio')

    if args[1] == "/g" then

        send_group_message(ply, radio, text)

        return ""
    end

 	if teamonly then
 		send_group_message(ply, radio, text)
 		return ""
 	end
end)
