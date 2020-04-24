meta.ui.scoreboard = meta.ui.scoreboard or {}
meta.ui.scoreboard.players = {}

local scoreboard = meta.ui.scoreboard

local tblIconsGroups = {
	['founder'] = { col = Color(245,245,245,255), symbol = 'Основатель' },
	['serverstaff'] = { col = Color(230,230,230,255), symbol = 'Персонал Сервера' },
	['moderator'] = { col = Color(230,230,230,255), symbol = 'Модератор' },
	['apollo'] = { col = Color(230,230,230,255), symbol = 'Апполион'},
	['thaumiel'] = { col = Color(230,230,230,255), symbol = 'Таумиель'},
	['afina'] = { col = Color(230,230,230,255), symbol = 'Афина'},
	['sponsor'] = { col = Color(230,230,230,255), symbol = 'Афина'},
	['premium'] = { col = Color(230,230,230,255), symbol = 'Кетер'},
	['keter'] = { col = Color(230,230,230,255), symbol = 'Кетер'},
	['euclid'] = { col = Color(230,230,230,255), symbol = 'Евклид'},
	['commander'] = { col = Color(230,230,230,255), symbol = 'Коммандер'},
	['user'] = { col = Color(230,230,230,255), symbol = 'Игрок'},
	-- ['admin'] = { col = Color(190,190,190,255), symbol = '★', name = 'Администратор' },
	-- ['superadmin'] = { col = Color(190,190,190,255), symbol = '★', name = 'Главный Администратор' }
}

team.SetColor( 0, Color(131,138,142) )
team.SetColor( 1001, Color(131,138,142) )

local function timeToStr( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7
	local w = math.floor( tmp / 7 )

	return string.format( "%s%s%s%s%s",
        w > 0 and ' '..w..'мес' or '',
        d > 0 and ' '..d..'д' or '',
        h > 0 and ' '..h..'ч' or '',
        m > 0 and ' '..m..'м' or '',
        s > 0 and ' '..math.Round(s)..'с' or ''
    )
end

local function get_admins_count()
	local adminsonline = {}
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then table.insert(adminsonline,v) end
	end

	return adminsonline
end

local logo = Material('gamemodes/sandbox/logo.png', 'smooth noclamp')
local function OpenScoreboard()
	local line_front = markup.Parse(string.format('<font=font_base_22><colour=255, 255, 255, 255>Онлайн: <colour=175, 175, 175, 255>%s</colour> из <colour=175, 175, 175, 255>%s</colour> игроков / Администрация: <colour=175, 175, 175, 255>%s</colour> / Карта: <colour=175, 175, 175, 255>%s</colour></colour></colour></font>',
		#player.GetAll(),
		game.MaxPlayers(),
		#get_admins_count(),
		game.GetMap()
	))

	local main = vgui.Create('Panel')
	main:SetSize(ScrW(), ScrH())
	main:Center()
	main:SetAlpha( 0 )
	main:AlphaTo( 255, .1, 0 )

	meta.ui.scoreboard.panel = main

	local center = vgui.Create('Panel', main)
	center:SetSize(ScrW()*.8, ScrH()*.75)
	center:SetPos(main:GetWide()*.5-center:GetWide()*.5, main:GetTall()*.5-center:GetTall()*.5+46 )

	main.Paint = function( self, w, h )
		draw.DrawBlur(0, 0, w, h, 6)
		line_front:Draw( self:GetWide()*.5 - ScrW()*.8*.5, main:GetTall()*.5-center:GetTall()*.5+46+center:GetTall(), 0, 0 )

		draw.Icon( w*.5-(322/2), h*.5-128*.5 - ScrH()*.8*.5-10, 322, 128, logo )
	end

	local DCollapsible = vgui.Create( "DCategoryList", center )
	DCollapsible:Dock( FILL )
	DCollapsible.Paint = function( self, w, h )

	end

	DCollapsible.VBar:SetWide(0)

	local team_players = {}

	for g, pl in pairs(player.GetAll()) do
		local t = pl:Team()
		team_players[t] = team_players[t] or { players = {} }
		table.insert(team_players[t].players, pl)

		if not team_players[t].panel then
			local cat = DCollapsible:Add('')
			team_players[t].panel = cat
			cat.Header.Paint = function( self, w, h ) end
			cat.Header:SetFont( "font_base_small" )
			cat:SetTall(20)
			cat.Paint = function( self, w, h )
				draw.RoundedBox(3, 0, 0, w, 18, ColorAlpha(team.GetColor(t), 180))
				draw.SimpleText( 'Звание:', "font_base_small", w/2 - w/5, 18/2, Color( 255, 255, 255, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( 'Привилегия:', "font_base_small", w/2 + w/5, 18/2, Color( 255, 255, 255, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( 'У / С', "font_base_small", w/2 + w/3, 18/2, Color( 255, 255, 255, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( team.GetName(t), "font_base_small", 4, 18/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( team.NumPlayers(t), "font_base_small", w - 4, 18/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
		end
	end

	for i, tm in pairs(team_players) do
		local layout = vgui.Create("DListLayout", panel)
		layout:Dock(FILL)

		for i, pl in ipairs(tm.players) do
			if pl and IsValid(pl) then

				local btn = vgui.Create('DButton', layout)
				btn:SetText('')

				if scoreboard.players[pl] then
					btn:SetTall(88)
					btn.toggle = true
				else
					btn:SetTall(28)
				end

				btn:DockMargin(0, 1, 0, 0)

				btn.DoRightClick = function( self )
					if not IsValid(pl) then return end
					local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
					local commands = serverguard.command:GetTable()

					local bNoAccess = true
					local menu = DermaMenu(Main);
					menu:SetSkin("serverguard");
					menu:AddOption("Открыть профиль Steam", function()
						pl:ShowProfile()
					end):SetIcon("icon16/group_link.png");
					menu:AddOption(timeToStr( tonumber(pl:GetUTimeTotalTime()) ), function()
						pl:ShowProfile()
					end):SetIcon("icon16/clock.png");
					menu:AddSpacer()
					menu:AddOption("Скопировать SteamID", function()
						SetClipboardText(pl:SteamID());
					end):SetIcon("icon16/page_copy.png");
					menu:AddOption("Скопировать SteamID64", function()
						SetClipboardText(pl:SteamID64());
					end):SetIcon("icon16/page_copy.png");
					menu:AddOption("Скопировать ник", function()
						SetClipboardText(pl:Name());
					end):SetIcon("icon16/page_copy.png");

					menu:AddSpacer()
					local sub_commands = menu:AddSubMenu("Администрирование")
					for unique, data in pairs(commands) do
						if (data.ContextMenu and (!data.permissions or serverguard.player:HasPermission(LocalPlayer(), data.permissions))) then
							data:ContextMenu(pl, sub_commands, rankData); bNoAccess = false;
						end;
					end;
					menu:Open();
				end
				

				btn.DoClick = function( self )
					btn:SizeTo( btn:GetWide(), self.toggle and 28 or 88, .1, 0, 1)
					self.toggle = not self.toggle
					scoreboard.players[pl] = self.toggle
					surface.PlaySound('sup_sound/scroll.wav')
				end

				local t = pl:Team()
				local team_color = team.GetColor(t)
				local team_name = team.GetName(t)
				local name = pl:Name()
				local steam_name = pl:OldName()
				local col = ColorAlpha(team_color, 255)
				local money = pl:PS_GetPoints()
				local group = pl:GetUserGroup()
				local steamid = pl:SteamID()
				local time = timeToStr(tonumber(pl:GetUTimeTotalTime()))

				local rank = pl:GetNWString('meta_rank')
				local frags, deaths = pl:Frags(), pl:Deaths()

				local ping = pl:Ping() or 0

				btn.Paint = function( self, w, h )
					local toggle = self:GetTall() ~= 28

					ping = pl:Ping() or 0

					draw.RoundedBoxEx(3, 0, 0, w, 28, col or color_white, true, true, not toggle, not toggle)
					draw.ShadowText(name, "font_notify", 32, 4, Color( 247, 247, 247, 255 ), Color(0,0,0,40), 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					-- draw.ShadowText(team_name, "font_notify", w*.5, 4, Color( 247, 247, 247, 255 ), Color(0,0,0,40), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					-- if money then
					-- 	draw.ShadowText(money..' Рк', "font_notify", w*.75, 4, Color( 247, 247, 247, 255 ), Color(0,0,0,40), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					-- end

					if rank then
						draw.SimpleText(rank, "font_notify", w/2 - w/5 , 14, Color( 255, 255, 255, 255 ), 1, 1)
					end

					if tblIconsGroups[pl:GetUserGroup()] then
						local group_data = tblIconsGroups[pl:GetUserGroup()]
						-- PrintTable(group_data)
						surface.SetFont('font_notify')
						wgr, _ = surface.GetTextSize(group_data.symbol..' ')

						draw.SimpleText(group_data.symbol, "font_notify", w/2 + w/5, 14, group_data.col, 1, 1)
					end

					draw.SimpleText(frags..', '..deaths, "font_notify", w/2 + w/3, 14, Color( 255, 255, 255, 190 ), 1, 1)

					draw.ShadowText(ping, "font_notify", w-4-26, 4, Color( 247, 247, 247, 255 ), Color(0,0,0,40), 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
					local pgcol = ping < 100 and Color(119,184,0) or ping < 200 and Color(255,165,0) or Color(214,45,32)
					draw.RoundedBox(0, w-10, 4, 6, 20, pgcol)
					draw.RoundedBox(0, w-17, 9, 6, 15, pgcol)
					draw.RoundedBox(0, w-24, 14, 6, 10, pgcol)

					if toggle then
						draw.RoundedBoxEx(3, 0, 28, w, h-28, Color(col.r-10, col.g-10, col.b-10) or color_white, false, false, true, true)
					end
				end

				btn.Think = function()
					if not (pl and IsValid(pl)) then
						btn:Remove()
					end
				end
				

				local avatar = vgui.Create( "AvatarImage", btn )
				avatar:SetSize( 28, 28 )
				avatar:SetPos( 0, 0 )
				avatar:SetPlayer( pl, 64 )

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 6, 32 )
				line.Paint = function( self, w, h )
					draw.SimpleText( 'Имя: '..name, "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 6, 56 )
				line.Paint = function( self, w, h )
					draw.SimpleText( 'Группа: '..tblIconsGroups[group].symbol, "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 256, 32 )
				line.Paint = function( self, w, h )
					draw.SimpleText( 'Steam: '..steam_name, "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 256, 56 )
				line.Paint = function( self, w, h )
					draw.SimpleText( 'SteamID: ', "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local hover = vgui.Create( "DButton", line )
				hover:SetSize( 185, 24 )
				hover:SetPos( 65, 0 )
				hover:SetText('')
				hover.Paint = function( self, w, h )
					draw.SimpleText( steamid, "font_base_18", 0, h*.5, self:IsHovered() and Color( 51, 153, 255, 255 ) or Color( 91, 173, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				hover.DoClick = function()
					SetClipboardText(steamid)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 506, 32 )
				line.Paint = function( self, w, h )
					if pl:IsBot() or not rank then return end
					draw.SimpleText( 'Звание: '..rank, "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 506, 56 )
				line.Paint = function( self, w, h )
					draw.SimpleText( 'Легион: '..team_name, "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 756, 32 )
				line.Paint = function( self, w, h )
					if not ping then return end
					draw.SimpleText( 'Пинг: '..ping..'ms', "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 756, 56 )
				line.Paint = function( self, w, h )
					if not time then return end
					draw.SimpleText( 'Время: '..time, "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local line = vgui.Create( "DPanel", btn )
				line:SetSize( 250, 24 )
				line:SetPos( 756+250, 32 )
				line.Paint = function( self, w, h )
					if not money then return end
					draw.SimpleText( 'РК: '..string.Comma(money)..'', "font_base_18", 0, h*.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				-- layout:Add(panel)
				tm.panel:SetContents( layout )
			end
		end
	end
end


hook.Add('ScoreboardShow', 'meta_Scoreboard', function()
	gui.EnableScreenClicker( true )
	OpenScoreboard()
	surface.PlaySound('sup_sound/on.ogg')
end)

hook.Add('ScoreboardHide', 'meta_Scoreboard', function()
	local main = scoreboard.panel

	if main and IsValid(main) then
		gui.EnableScreenClicker( false )
		surface.PlaySound('sup_sound/off.ogg')

		main:AlphaTo( 0, .1, 0, function()
			main:Remove()
		end )
	end
end)

function GM:ScoreboardShow() end