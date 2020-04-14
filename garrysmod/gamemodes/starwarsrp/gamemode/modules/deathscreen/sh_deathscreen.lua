local function respawntime(pl)
	return 25
end

if SERVER then
    meta.util.deathinfo = meta.util.deathinfo or {}

	-- util.AddNetworkString("RespawnTimer")
	hook.Add("PlayerDeath", "RespawnTimer", function(pPlayer, inflictor, attacker )
		pPlayer.deadtime = RealTime()

        meta.util.deathinfo = meta.util.deathinfo or {}

		-- net.Start("RespawnTimer")
		-- 	net.WriteBool(true)
        --     if meta.util.deathinfo[pPlayer] then
        --         net.WriteTable(meta.util.deathinfo[pPlayer])
        --     else
        --         net.WriteTable({})
        --     end
		-- net.Send(pPlayer)

		netstream.Start(pPlayer, 'RespawnTimer', true, meta.util.deathinfo[pPlayer] and meta.util.deathinfo[pPlayer] or {})

		pPlayer:AddDeaths(1)

		if IsValid(attacker) and attacker:IsPlayer() and attacker ~= pPlayer then
			attacker:AddFrags(1)
		end

        meta.util.deathinfo[pPlayer] = nil
	end)

	hook.Add('OnNPCKilled', 'FragCounter', function(npc, attacker, inflictor)
		if IsValid(attacker) and attacker:IsPlayer() then
			attacker:AddFrags(1)
		end
	end)

	hook.Add("PlayerDeathThink", "RespawnTimer", function(pPlayer)
		if pPlayer.deadtime and RealTime() - pPlayer.deadtime < respawntime(pPlayer) then
			return false
		end
	end)

	hook.Add("PlayerSpawn", "HideRespawnTimer", function(pPlayer)
		-- net.Start("RespawnTimer")
		-- 	net.WriteBool(false)
		-- net.Send(pPlayer)

		netstream.Start(pPlayer, 'RespawnTimer', false)
	end)

    hook.Add("EntityTakeDamage", "DeathScreen_EntityTakeDamage", function( target, dmginfo )
        if target:IsPlayer() then
            meta.util.deathinfo[target] = meta.util.deathinfo[target] or {}


			if #meta.util.deathinfo[target] >= 20 then
				table.remove(meta.util.deathinfo[target], 1)
			end

            local att = dmginfo:GetAttacker()

            -- local name = att:IsWorld() and 'worldspawn' or ( att.Name and att:Name() or ( att.Nick and att:Nick() or 'worldspawn' ) )
            local attacker = att:IsWorld() and 'worldspawn' or ( att.Name and att:Name() or ( att.Nick and att:Nick() or 'worldspawn' ) )
            -- local tm_c = not att:IsWorld() and team.GetColor(att:Team()) or color_white
            local tm_c = color_white
            if not att:IsWorld() and att.Team and att:Team() then
                tm_c = team.GetColor(att:Team())
            end
            local att_color = att:IsWorld() and '<colour=255, 165, 0, 255>' or string.format('<colour=%s, %s, %s, %s>', tm_c.r, tm_c.g, tm_c.b, 255)
            table.insert(meta.util.deathinfo[target], {
                attacker = attacker,
                att_color = '<colour=255, 165, 0, 255>',
                damage = dmginfo:GetDamage()
            })
            -- print(dmginfo:GetAttacker(), dmginfo:GetDamage())
            -- dmginfo:ScaleDamage( 0.5 ) // Damage is now half of what you would normally take.
        end
    end)
end



if CLIENT then

	-- local pp_params = {}
	-- pp_params["$pp_colour_addr"] = 0
	-- pp_params["$pp_colour_addg"] = 0
	-- pp_params["$pp_colour_addb"] = 0

	-- pp_params["$pp_colour_brightness"] = 1
	-- pp_params["$pp_colour_contrast"] = 0.3
	-- pp_params["$pp_colour_colour"] = 1

	-- pp_params["$pp_colour_mulr"] = 0
	-- pp_params["$pp_colour_mulg"] = 0
	-- pp_params["$pp_colour_mulb"] = 0


	-- hook.Add("RenderScreenspaceEffects", "RespawnTimer", function()
	-- 	-- if LocalPlayer():Alive() then
	-- 	-- 	pp_params["$pp_colour_colour"] = 1
	-- 	-- 	pp_params["$pp_colour_brightness"] = 1
	-- 	-- else
	-- 	-- 	DrawColorModify(pp_params)
	-- 	-- 	pp_params["$pp_colour_colour"] = Lerp(FrameTime(), pp_params["$pp_colour_colour"], 0.2)
	-- 	-- 	pp_params["$pp_colour_brightness"] = Lerp(FrameTime(), pp_params["$pp_colour_brightness"], 0)
	-- 	-- end
	-- end)

    local alpha_lerp, alpha = 0, 0
	-- net.Receive("RespawnTimer", function()
	netstream.Hook("RespawnTimer", function(bool, dmginfo)
		if bool then
			surface.PlaySound('sup_sound/death.mp3')


			local dead = RealTime()
            -- PrintTable(net.ReadTable() or {})
            -- local dmginfo = net.ReadTable() or {}

            alpha = 160
            local markup_string = ''

            if dmginfo then
                for i, case in pairs(dmginfo) do
                    markup_string = markup_string..'<font=font_roboto_24>'..case.att_color..tostring(case.attacker)..'</colour> нанёс вам <colour=214, 45, 32, 255>'..tostring( math.Round(case.damage) )..'</colour> урона </font>\n'
                end
            end

            local parsed = markup.Parse( markup_string )

			hook.Add("HUDPaint", "RespawnTimer", function()
				local time = math.Round(respawntime() - RealTime() + dead, 2)
                alpha_lerp = Lerp(FrameTime()*6,alpha_lerp or 0,alpha or 0) or 0

                local w, h = ScrW(), ScrH()
                -- draw.DrawBlur( 0, 0, w, h, alpha_lerp/100 )

                draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 180))

                parsed:Draw( 30, 60, 0, 0 )

                local h = parsed:GetHeight()
				draw.SimpleText('Вас убили без просто так??! Напишите @ и причину жалобы.', "font_roboto_21", 30, 70+h, color_white, 0, 0)

				if time > 0 then
					draw.SimpleText('До возрождения '..time..' секунд', "font_roboto_24", 20, 20, color_white, 0, 0)
				else
					draw.SimpleText('Нажмите любую кнопку для возрождения', "font_roboto_24", 20, 20, color_white, 0, 0)
				end
				 if not reviev_button then
                    gui.EnableScreenClicker( true )

                    reviev_button = vgui.Create('DButton')
                    reviev_button:SetSize(200,30)
                    reviev_button:SetPos(ScrW()*.5-reviev_button:GetWide()*.5,ScrH()- 100)
                    reviev_button:SetText('')
                    reviev_button.DoClick = function()
                        netstream.Start('CreateMedicHelpPoint')
                        reviev_button:SetDisabled( true )
                        -- reviev_button:Remove()
                        -- reviev_button = false
                    end
                    reviev_button.Paint = function( self, w, h )
                        draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
                        draw.SimpleText('Вызвать медика', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
                    end
                end
			end)



			hook.Add("Think", "RespawnTimerMusic", function()
				if (RealTime() - dead) < 1 then return end

				hook.Remove("Think", "RespawnTimerMusic")

				if LocalPlayer():Alive() then return end
				if not system.HasFocus() then return end
			end)
			system.FlashWindow()
		else
			hook.Remove("HUDPaint", "RespawnTimer")
            gui.EnableScreenClicker( false )
            if reviev_button and IsValid(reviev_button) then
                reviev_button:Remove()
                reviev_button = false
            end
		end
	end)

	hook.Add("CalcView", "FirstPersonDeath", function(pPlayer, pos, ang, fov, nearz, farz)
		if (pPlayer:Alive() or !IsValid(pPlayer.eRagdoll)) then return end

		local rag = pPlayer.eRagdoll
		local eyeattach = rag:LookupAttachment('eyes')

		if (!eyeattach) then return end
		local eyes = rag:GetAttachment(eyeattach)

		if (!eyes) then return end
		return {origin = eyes.Pos, angles = eyes.Ang, fov = fov}
	end)
end
