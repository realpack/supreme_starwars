local HeightLine = 26


local mat_wrench = Material('icons/wrench.png', 'noclamp smooth')
local mat_star = Material('icons/star.png', 'noclamp smooth')
local mat_key = Material('icons/key.png', 'noclamp smooth')
local mat_case = Material('icons/case.png', 'noclamp smooth')
local mat_hammer = Material('icons/hammer.png', 'noclamp smooth')
local mat_lines = Material('icons/lines.png', 'noclamp smooth')

local tblIconsGroups = {
	['founder'] = { col = Color(220,220,220,255), symbol = 'Основатель' },
    ['serverstaff'] = { col = Color(190,190,190,255), symbol = 'Персонал Сервера' },
    ['moderator'] = { col = Color(190,190,190,255), symbol = 'Модератор' },
	['apollo'] = { col = Color(190,190,190,255), symbol = 'Апполион'},
    ['thaumiel'] = { col = Color(190,190,190,255), symbol = 'Таумиель'},
    ['afina'] = { col = Color(190,190,190,255), symbol = 'Афина'},
    ['sponsor'] = { col = Color(190,190,190,255), symbol = 'Афина'},
    ['premium'] = { col = Color(190,190,190,255), symbol = 'Кетер'},
    ['keter'] = { col = Color(190,190,190,255), symbol = 'Кетер'},
    ['euclid'] = { col = Color(190,190,190,255), symbol = 'Евклид'},
    ['commander'] = { col = Color(190,190,190,255), symbol = 'Коммандер'},
    ['user'] = { col = Color(190,190,190,255), symbol = 'Игрок'},
	-- ['admin'] = { col = Color(190,190,190,255), symbol = '★', name = 'Администратор' },
	-- ['superadmin'] = { col = Color(190,190,190,255), symbol = '★', name = 'Главный Администратор' }
}

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

team.SetColor( 0, Color(131,138,142) )
team.SetColor( 1001, Color(131,138,142) )

local MainPanel, Main
local alpha, alpha_lerp = 0, 0
function ScoreboardOpen()
	if not IsValid(Main) then
        alpha = 160

		LocalPlayer().Scoreboard = true
		Main = vgui.Create("DFrame")
		Main:SetSize(ScrW(),ScrH())
		Main:SetPos((ScrW()-Main:GetWide())/2,(ScrH()-Main:GetTall())/2)
		Main:SetTitle('')

        local line_front = markup.Parse(string.format('<font=font_base_22><colour=255, 255, 255, 255>Онлайн: <colour=175, 175, 175, 255>%s</colour> из <colour=175, 175, 175, 255>%s</colour> игроков / Администрация: <colour=175, 175, 175, 255>%s</colour> / Карта: <colour=175, 175, 175, 255>%s</colour></colour></colour></font>',
            #player.GetAll(),
            game.MaxPlayers(),
            #get_admins_count(),
            game.GetMap()
        ))
		-- Main:Center()
		Main:SetDraggable(false)
		Main:ShowCloseButton(false)
		Main.Paint = function( self, w, h )
			alpha_lerp = Lerp(FrameTime()*6,alpha_lerp or 0,alpha or 0) or 0

            local x, y = self:GetPos()
            -- print(alpha_lerp)
            -- if alpha_lerp/100 > 1 then
            --     draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), alpha_lerp/100 )
            -- end

            draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 180))

            line_front:Draw( Main:GetWide()*.5 - (Main:GetWide()/1.4)*.5, Main:GetTall()*.5 - (Main:GetTall()/1.2)*.5, 0, 0 )
		end

        MainPanel = vgui.Create('DScrollPanel', Main)
        MainPanel:SetSize(Main:GetWide()/1.4,Main:GetTall()/1.2)
        MainPanel:SetPos(Main:GetWide()*.5 - MainPanel:GetWide()*.5, Main:GetTall()*.5 - MainPanel:GetTall()*.5)

        MainPanel.Paint = function( self, w, h )
            -- line_front:Draw( 0, 0, 0, 0 )
            -- draw.SimpleText('Сейчас играет '..#player.GetAll()..' из '..game.MaxPlayers()..' игроков. Текущая карта '..game.GetMap(), "font_base_22", 0, 0, color_white, 0, 0)
        end

        MainPanel.VBar:SetWide(0)

        local DCollapsible = vgui.Create( "DCategoryList", MainPanel )
        DCollapsible:SetSize( MainPanel:GetWide(), MainPanel:GetTall() )
        DCollapsible:SetPos( 0, 30 )
        DCollapsible.Paint = function( self, w, h )

        end

        -- local layout = vgui.Create( "DListLayout" )
        -- layout:SetSize( DCollapsible:GetWide(), DCollapsible:GetTall() )
        -- layout:SetPos( 0, 0 )
        -- DCollapsible:SetContents( layout )

        local players = player.GetAll()
        -- table.sort(players, function(a, b)
		-- 	return a:Team() < b:Team()
		-- end)

        local team_players = {}

        for g, pl in pairs(players) do
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
                    draw.RoundedBox(0, 0, 0, w, 18, ColorAlpha(team.GetColor(t), 255))
                    draw.SimpleText( 'Ранг:', "font_base_small", w/2 - w/5, 18/2, Color( 255, 255, 255, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    draw.SimpleText( 'Группа:', "font_base_small", w/2 + w/5, 18/2, Color( 255, 255, 255, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    draw.SimpleText( 'У / С', "font_base_small", w/2 + w/3, 18/2, Color( 255, 255, 255, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    draw.SimpleText( team.GetName(t), "font_base_small", 4, 18/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                    draw.SimpleText( team.NumPlayers(t), "font_base_small", w - 4, 18/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                end
            end
        end

        for i, tm in pairs(team_players) do
            local layout = vgui.Create( "DListLayout" )
            layout:SetSize( DCollapsible:GetWide(), DCollapsible:GetTall() )
            layout:SetPos( 0, 0 )

            for i, pl in pairs(tm.players) do
                local PlayerPanel = vgui.Create('DButton')
                PlayerPanel:SetTall(30)
                PlayerPanel:SetWide(MainPanel:GetWide())
                PlayerPanel:SetText('')
                PlayerPanel.Paint = function( self, w, h )
                    if not pl or not IsValid(pl) then
                        return
                    end

                    local pcol = team.GetColor(pl:Team())
                    h = 28
                    if pl and pcol then
                        draw.RoundedBox(0,0,0,w,h,Color(pcol.r, pcol.g, pcol.b, 255))

                        local rpid = pl:GetRPID()
                        -- rpid = (rpid and rpid ~= '') and ' '..rpid..'' or '   ----  '
                        if rpid and rpid ~= '' then
                            local id = rpid
                            for i = 1, (4-#tostring(id)) do id = '0'..id end

                            rpid = ' '..id..''
                        else
                            rpid = '   ----  '
                        end


                        local tm = pl:Team()
                        local rank = pl:GetNWString('meta_rank')

                        surface.SetFont('font_base_22')
                        -- print(pl, pl:Name())
                        local name = pl:Name() or pl:GetNWString( "rpname" )
                        local wrt, _ = surface.GetTextSize(' '..name)

                        draw.RoundedBox(0, 28, 0, wrt+8, h, Color(pcol.r-12,pcol.g-12,pcol.b-12,255))

                        surface.SetFont('font_base_22')
                        local wgr = 0

                        -- if not HIDE_NICKS_RANKS[rank] or LocalPlayer():IsAdmin() then
                        --     local name = pl:GetNWString( "rpname" )
                        --     draw.SimpleText(name, "font_base_22", wrt+34+wgr+1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
                        --     draw.SimpleText(name, "font_base_22", wrt+34+wgr, h/2, Color( 255, 255, 255, 250 ), 0, 1)
                        -- end

                        draw.SimpleText(name, "font_base_22", 34 +1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
                        draw.SimpleText(name, "font_base_22", 34 , h/2, Color( 255, 255, 255, 240 ), 0, 1)

                        -- if LocalPlayer():IsAdmin() then
                            draw.SimpleText(pl:OldName(), "font_notify", w/2 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                            draw.SimpleText(pl:OldName(), "font_notify", w/2 , h/2, Color( 230, 230, 230, 240 ), 1, 1)
                        -- end

                        if rank then
                            draw.SimpleText(rank, "font_notify", w/2 - w/5 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                            draw.SimpleText(rank, "font_notify", w/2 - w/5 , h/2, Color( 255, 255, 255, 255 ), 1, 1)
                        end

            
                        draw.SimpleText(pl:Frags()..', '..pl:Deaths(), "font_notify", w/2 + w/3 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                        draw.SimpleText(pl:Frags()..', '..pl:Deaths(), "font_notify", w/2 + w/3 , h/2, Color( 255, 255, 255, 190 ), 1, 1)
                

                        if tblIconsGroups[pl:GetUserGroup()] then
                            local group_data = tblIconsGroups[pl:GetUserGroup()]
                            -- PrintTable(group_data)
                            surface.SetFont('font_notify')
                            wgr, _ = surface.GetTextSize(group_data.symbol..' ')

                            draw.SimpleText(group_data.symbol, "font_notify", w/2 + w/5 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                            draw.SimpleText(group_data.symbol, "font_notify", w/2 + w/5, h/2, group_data.col, 1, 1)
                        end

                        if self:IsHovered() then
                            draw.RoundedBox(0,0,0,w,h,Color(230, 230, 230, 4))
                        end
                    end

                    draw.RoundedBox(0, w-10+1, 4+1, 6, 20, Color(0,0,0,60))
                    draw.RoundedBox(0, w-17+1, 9+1, 6, 15, Color(0,0,0,60))
                    draw.RoundedBox(0, w-24+1, 14+1, 6, 10, Color(0,0,0,60))

                    local pg = pl:Ping()
                    local pgcol = pl:Ping() < 100 and Color(119,184,0) or pg < 200 and Color(255,165,0) or Color(214,45,32)
                    draw.RoundedBox(0, w-10, 4, 6, 20, pgcol)
                    draw.RoundedBox(0, w-17, 9, 6, 15, pgcol)
                    draw.RoundedBox(0, w-24, 14, 6, 10, pgcol)

                    -- draw.SimpleText(pg, "font_base_22", w - 30 +1, h/2+1, Color( 0, 0, 0, 60 ), 2, 1)
                    -- draw.SimpleText(pg, "font_base_22", w - 30 , h/2, Color( 255, 255, 255, 255 ), 2, 1)
                end

                PlayerPanel.DoClick = function( self )
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

                local Avatar = vgui.Create( "AvatarImage", PlayerPanel )
                Avatar:SetSize( 28, 28 )
                Avatar:SetPos( 0, 0 )
                Avatar:SetPlayer( pl, 64 )

                layout:Add( PlayerPanel )
            end

            tm.panel:SetContents( layout )
        end
	end
end

function ScoreboardClose()
	if IsValid(Main) then
		Main:Close()
		LocalPlayer().Scoreboard = false
        gui.EnableScreenClicker(false)
	end
end

function GM:ScoreboardShow()
	ScoreboardOpen()

	if IsValid(Main) then
		Main:Show()
		-- Main:MakePopup()
        gui.EnableScreenClicker(true)
		Main:SetKeyboardInputEnabled(true)
	end
end

function GM:ScoreboardHide()
    if MainPanel and IsValid(MainPanel) then
        MainPanel:Remove()
    end
	if IsValid(Main) then
        Main:SetKeyboardInputEnabled(false)
        LocalPlayer().Scoreboard = false

        alpha = 0
        -- timer.Simple(FrameTime()*6*8, function()
		    ScoreboardClose()
        -- end)
        gui.EnableScreenClicker(false)
	end
end

hook.Add('OnReloaded','CloseScoreboard_OnReloaded',function()
    if MainPanel and IsValid(MainPanel) then
        MainPanel:Remove()
    end
    if Main and IsValid(Main) then
        Main:Remove()
    end
    ScoreboardClose()
end)