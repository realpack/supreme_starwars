if CLIENT then
	surface.CreateFont("meta.admin.font", { font = "Play Bold", size = 12, extended = true })
	surface.CreateFont("meta.admin.Noclipfont", { font = "Play Bold", size = 30, extended = true })

	-- hook.Add('ShowTeam', any identifier, function func)

	local function IsDark(color)
		local val = ((color.r*299)+(color.g*587)+(color.b*114))/1000
		if val < 50 then
			return Color(color.r+90,color.g+90,color.b+90)
		else
			return color
		end
	end

	local function draw_lines(tbl, to_s)
		for k,v in pairs(tbl) do
			draw.ShadowSimpleText(v.text, "meta.admin.font", to_s.x, to_s.y+15*(k-1), v.color, 1, 1)
		end
	end

	show_adminmode = true
	hook.Add("HUDPaint", "meta.admin.HUDPaint", function()
		if not show_adminmode then return end
		local ply = LocalPlayer()

		if not ply:IsAdmin() then return end
		if ply:GetMoveType() ~= MOVETYPE_NOCLIP then return end

		-- draw.ShadowSimpleText("Админ Режим!", "meta.admin.Noclipfont", 10, ScrH()-40, Color(255,255,0), 0, 2)

		local p_pos = ply:GetPos()

		for k,v in pairs(player.GetAll()) do
			if v == ply then continue end

			local t_pos = v:GetPos()
			local distance = t_pos:Distance(p_pos)

			if distance > 2000000 then continue end
			local to_s = t_pos:ToScreen()
			local team_ = v:Team()
			local color = team.GetColor(team_)
			local job = team.GetName(team_)
			local health = v:Alive() and v:Health().."%" or "СМЭРТ"
			local armor = v:Armor() > 0 and v:Armor().."%" or ""
			local rankData = serverguard.ranks:GetRank(v:GetUserGroup())

			to_s.x, to_s.y = math.Round(to_s.x), math.Round(to_s.y)


            if rankData and rankData.color then
                draw_lines({
                    { text = rankData.name, color = rankData.color },
                    { text = v:Name().." - "..v:OldName(), color = color_white },
                    { text = job, color = IsDark(color) },
                    { text = health, color = Color(200,50,50) },
                    { text = armor, color = Color(50,50,200) },
                    },
                    to_s
                )
            end
		end
	end)
else -- IF SERVER
	local function MakeInvisible(ply, invisible)
		ply:SetNoDraw(invisible)
		ply:SetNotSolid(invisible)

		ply:DrawViewModel(not invisible)
		ply:DrawWorldModel(not invisible)

		if (invisible) then
			ply:GodEnable()
		else
			ply:GodDisable()
		end
	end

	hook.Add( "PlayerNoClip", "meta.admin.PlayerNoCLip", function( ply, desiredNoClipState )
		timer.Simple(0, function()
			local invisible = ply:GetMoveType() == MOVETYPE_NOCLIP
			MakeInvisible(ply, invisible)
		end)
	end )

	local function lazy_search(name)
		for k,v in pairs(player.GetAll()) do
			if string.find(string.lower(v:Name()), string.lower(name), 0, true) then
				return v
			end
		end

		return false
	end

end
