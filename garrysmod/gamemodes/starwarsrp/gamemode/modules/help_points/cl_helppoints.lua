meta.help_points = meta.help_points or {}

hook.Add( "HUDPaint", "example", function()
    for k, data in pairs(meta.help_points) do
        local scr = data.pos:ToScreen()
        local dist_alpha = dist_alpha-90 > 0 and dist_alpha-90 or 0

        draw.SimpleText(data.title, 'font_base_18', scr.x+1, scr.y+1, Color(0,0,0,100), 1, 1)
        draw.SimpleText(data.title, 'font_base_18', scr.x, scr.y, Color(255,255,255,255), 1, 1)
        draw.SimpleText(data.text, 'font_base_24', scr.x+1, scr.y-20+1, Color(0,0,0,100), 1, 1)
        draw.SimpleText(data.text, 'font_base_24', scr.x, scr.y-20, Color(255,255,255,255), 1, 1)

        draw.Arc( {y = scr.y-10-35, x = scr.x}, 0, 360, 14, 32, 14, ColorAlpha( HELPPOINTS_TYPES[data.type].color, dist_alpha)  )
        draw.Arc( {y = scr.y-10-35, x = scr.x}, 0, 360, 16, 32, 2, Color(255,255,255,dist_alpha) )

        surface.SetDrawColor( Color(255,255,255,dist_alpha) )
        surface.SetMaterial( HELPPOINTS_TYPES[data.type].icon )
        surface.DrawTexturedRect( scr.x-10, scr.y-55, 20, 20 )
    end
end)

hook.Add( "PostDrawOpaqueRenderables", "example", function()
    if meta.help_points then
        for k, data in pairs(meta.help_points) do
            local trace = LocalPlayer():GetEyeTrace()
            local angle = trace.HitNormal:Angle()
            local player_angles = LocalPlayer():GetAngles()

            dist_alpha = LocalPlayer():GetPos():Distance(data.pos)

            cam.Start3D2D( data.pos, angle + Angle(90,0,0), 1 )
                draw.Arc( {y = 0, x = 0}, 0, 360, 14, 32, 14, ColorAlpha( HELPPOINTS_TYPES[data.type].color, 255-dist_alpha) )
                draw.Arc( {y = 0, x = 0}, 0, 360, 16, 32, 2, Color(255,255,255,255-dist_alpha) )

                surface.SetMaterial( HELPPOINTS_TYPES[data.type].icon )
                surface.DrawTexturedRectRotated( 0, 0, 20, 20, CurTime()*(2^2) )
            cam.End3D2D()

            -- cam.Start3D2D( trace.HitPos, Angle(0,player_angles.y-90,90), .1 )
                -- surface.SetDrawColor( 255, 255, 255, 150 )
                -- surface.DrawRect( -5, -500, 10, 500 )

                -- draw.SimpleText('Лови Аптечку', 'font_base_rotate', 0, -520, Color(255,255,255,200), 1, 1)
                -- draw.SimpleText('Аптечка', 'font_base_84', 0, -570, Color(255,255,255,200), 1, 1)
            -- cam.End3D2D()
        end
    end
end )
