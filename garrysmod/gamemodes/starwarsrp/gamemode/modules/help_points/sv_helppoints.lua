netstream.Hook('CreateHelpPoint', function(pPlayer, data)
    if pPlayer:IsAdmin() then
        for k, pl in pairs(player.GetAll()) do
            -- print(pPlayer, meta.jobs[pl:Team()].control, meta.jobs[pPlayer:Team()].control)

            if meta.jobs[pl:Team()] and meta.jobs[pl:Team()].control == meta.jobs[pPlayer:Team()].control then
                -- PrintTable(data)
                -- print(pl)
                local code = string.format([[
                    local i = table.insert(meta.help_points, { type = '%s', title = '%s', text = '%s', pos = Vector('%s') });
                    print("UniquePoint"..i)

                    timer.Simple(]]..data.time..[[, function()
                        table.remove(meta.help_points, i)
                    end)
                    surface.PlaySound('%s')
                    ]], data.type, data.title, data.text, tostring(pPlayer:GetEyeTrace().HitPos), HELPPOINTS_TYPES[data.type].sound)

                -- BroadcastLua( code )
                pl:SendLua( code )
            end
        end
    end
end)

netstream.Hook('CreateMedicHelpPoint', function(pPlayer, data)
    if not pPlayer:Alive() then
        for k, pl in pairs(player.GetAll()) do
            if pl:Team() == TEAM_74 then
                local code = string.format([[
                    local i = table.insert(meta.help_points, { type = 'Иконка Сердца', title = 'Вызов медика', text = '', pos = Vector('%s') });
                    print("UniquePoint"..i)
                    timer.Simple(25, function()
                        table.remove(meta.help_points, i)
                    end)
                    ]], tostring(pPlayer:GetPos()))

                -- BroadcastLua( code )
                pl:SendLua( code )
            end
        end
    end
end)
