

function pMeta:Arrest(time, pPlayer)
    if not self:GetNVar("Arrested") then
        time = time or 300

        self:StripWeapons()
        self:StripAmmo()

        self:SetPos(table.Random(JAIL_VECTORS))
        self:SetNVar("Arrested", true, NETWORK_PROTOCOL_PUBLIC)
        self:SetNVar('ArrestedTime', CurTime() + time, NETWORK_PROTOCOL_PUBLIC)

        timer.Create("Arrested_"..self:SteamID64(), time, 1, function()
        if IsValid(self) then
                self:UnArrest()
        end
        end)
    end
end

function pMeta:UnArrest(pPlayer)
    self:SetNVar("Arrested", false, NETWORK_PROTOCOL_PUBLIC)
    self:Spawn()
    hook.Call('PlayerLoadout', GAMEMODE, self)
    timer.Remove("Arrested_"..self:SteamID64())
end

-- GetGlobalString('meta_defcon')
if not GetGlobalString('meta_defcon') then
    SetGlobalString('meta_defcon', '')
end

plogs.Register('Defcons', false)
meta.defcon_cooldown = meta.defcon_cooldown or true
netstream.Hook('SendCommandDefcon', function(pPlayer, data)
    local name = data.name

    timer.Remove('DefconTimer')


    if TEAMS_CANUSE_DEFCONS[pPlayer:Team()] and DEFCON_TYPES[name] and meta.defcon_cooldown then

        plogs.PlayerLog(pPlayer, 'Defcons', pPlayer:NameID() .. ' активировал defcon "' .. name .. '"', {
            ['Name']    = pPlayer:Name(),
            ['SteamID'] = pPlayer:SteamID(),
        })

        SetGlobalString('meta_defcon', name)
        if DEFCON_TYPES[name].sound then
            BroadcastLua( "surface.PlaySound('"..DEFCON_TYPES[name].sound.."') surface.PlaySound('sup_sound/jw-loop.wav')" )
        end

        meta.defcon_cooldown = false
        timer.Create('DefconCooldown', 30, 1, function()
            meta.defcon_cooldown = true
        end)

        if name == 'Defcon 6' then
            timer.Create('DefconTimer', 20, 1, function()
                SetGlobalString('meta_defcon', '')
            end)
        end
    end
end)
