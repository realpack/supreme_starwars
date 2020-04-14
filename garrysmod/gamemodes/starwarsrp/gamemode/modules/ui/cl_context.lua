local context_left, context_right
local DTasks, DTLayout, RadioScroll

local right_side_width = 400
local tasks = tasks or {}
local defcons_buttons = {}

local function OpenNewTask(pl, i )
    -- local pl_i = table.insert(tasks, pl)

    if pl:Team() == 0 or pl:Team() == 1001 then
        return
    end

    local DPanel = vgui.Create("DPanel")
    DPanel:SetSize(DTasks:GetWide(),230+32)
    DPanel:SetZPos(32767)
    DPanel.Paint = function( self, w, h )
        local pcol = Color(64, 105, 153)
        h = h -2
        if pl and pcol then
            draw.RoundedBox(0,0,0,w,h,Color(pcol.r, pcol.g, pcol.b, 250))

            local rpid = pl:GetNVar('meta_rpid')
            rpid = rpid and ' '..rpid..'' or ''

            local tm = pl:Team()
            local rank = pl:GetNWString('meta_rank') or ''

            local name = pl:Name()
            draw.SimpleText(name, "font_base_22", 32+1, 4, Color( 0, 0, 0, 60 ), 0, 0)
            draw.SimpleText(name, "font_base_22", 32, 4, Color( 255, 255, 255, 250 ), 0, 0)

            -- draw.SimpleText(rpid, "font_base_22", 32 + wt + 4 +1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
            -- draw.SimpleText(rpid, "font_base_22", 32 + wt + 4 , h/2, Color( 195, 195, 195, 255 ), 0, 1)

            -- local tname = tm == 0 and '(Не выбрал персонажа)' or team.GetName(tm)
            -- draw.SimpleText(tname, "font_base_22", w/2 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
            -- draw.SimpleText(tname, "font_base_22", w/2 , h/2, Color( 255, 255, 255, 255 ), 1, 1)

            -- if rank then
            --     draw.SimpleText(rank, "font_base_22", w/3 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
            --     draw.SimpleText(rank, "font_base_22", w/3 , h/2, Color( 255, 255, 255, 255 ), 1, 1)
            -- end

            local oldname = pl:OldName()
            surface.SetFont('font_base_22')
            local wt, _ = surface.GetTextSize(' '..rpid)

            draw.RoundedBox(0, w-wt-30, 0, wt, 30, Color(pcol.r-12,pcol.g-12,pcol.b-12,255))

            draw.SimpleText(rank..' '..rpid, "font_base_22", w-30 - 4 +1, 4+1, Color( 0, 0, 0, 60 ), 2, 0)
            draw.SimpleText(rank..' '..rpid, "font_base_22", w-30 - 4 , 4, Color( 255, 255, 255, 255 ), 2, 0)
        end
    end

    local features_panel = vgui.Create('DScrollPanel', DPanel)
    features_panel:SetPos(10, 70)
    features_panel:SetSize(200,120)


    features_panel.VBar = features_panel:GetVBar()
    features_panel.VBar:SetWide(6)

    function features_panel.VBar:PerformLayout()
        local Wide = self:GetWide()
        local Scroll = self:GetScroll() / self.CanvasSize
        local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( Wide * 2 ) ), 10 )
        local Track = self:GetTall() - BarSize
        Track = Track + 1

        Scroll = Scroll * Track

        self.btnGrip:SetPos( 0, Scroll )
        self.btnGrip:SetSize( Wide, BarSize )

        self.btnUp:SetPos( 0, 0, 0, 0 )
        self.btnUp:SetSize( 0, 0 )

        self.btnDown:SetPos( 0, self:GetTall() - 0, 0, 0 )
        self.btnDown:SetSize( 0, 0 )
    end
    features_panel.VBar.Paint = function( self, w, h ) end
    features_panel.VBar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 190)) end

    local Rank = vgui.Create( "DComboBox", DPanel )
    Rank:SetAutoStretchVertical(false)
    Rank:SetSortItems( false )
    Rank:SetSize( 200, 26 )
    Rank:SetPos( 10, 32 )

    Rank:SetTextColor(Color(255, 255, 255, 255))

    local DListTeams = vgui.Create( "DListView", DPanel )
    DListTeams:SetSize( 400, 130 )
    DListTeams:SetPos( DPanel:GetWide()-DListTeams:GetWide()-18-2, 58+20 )

    local modify_model = vgui.Create('DComboBox', DPanel)
    modify_model:SetSize( 390, 24 )
    modify_model:SetPos( DPanel:GetWide()-modify_model:GetWide()-28-2, 32 )
    modify_model:SetAutoStretchVertical(false)
    modify_model:SetSortItems( false )

    modify_model:SetTextColor(Color(255, 255, 255, 255))
    modify_model.OnSelect = function( panel, index, value ) end

    local features_buttons = {}
    local function refact_model( team_index, rank )
        print(rank)
        modify_model:Clear()

        local player_job = meta.jobs[team_index]

        local features = {}
        for k, v in pairs(features_buttons) do
            features[k] = v:GetChecked()
        end

        local feat_model = false
        if table.HasValue(features, true) then
            local ft = table.KeyFromValue( features, true )
            local norm_ft = FEATURES_TO_NORMAL[ft]
            if norm_ft then
                if norm_ft.models and norm_ft.models[team_index] then
                    feat_model = norm_ft.models[team_index]
                    modify_model:SetValue( feat_model )
                end
            end
        end

        if not feat_model then
            if player_job.FeatureRanks and player_job.FeatureRanks[rank] and player_job.FeatureRanks[rank].model then
                modify_model:AddChoice( player_job.FeatureRanks[rank].model )

                modify_model:SetValue( player_job.FeatureRanks[rank].model )
            else
                if player_job.WorldModel then
                    if istable(player_job.WorldModel) then
                        for _, mdl in pairs(player_job.WorldModel) do
                            modify_model:AddChoice( mdl )
                        end
                    elseif isstring(player_job.WorldModel) then
                        modify_model:AddChoice( player_job.WorldModel )
                    end
                end

                modify_model:SetValue( modify_model:GetOptionText( 1 ) )
            end

        end
    end

    local i = 1
    for k, v in pairs(FEATURES_TO_NORMAL) do
        local features = pl:GetNVar('meta_features') and pl:GetNVar('meta_features') or DEFAULT_FEATURES
        features = features == {} and DEFAULT_FEATURES or features

        features_buttons[k] = vgui.Create( "DCheckBoxLabel", features_panel )
        features_buttons[k]:SetSize( 200, 26 )
        features_buttons[k]:SetPos( 0, (20*(i-1)) )

        features_buttons[k]:SetValue( features[k] and 1 or 0 )
        features_buttons[k]:SizeToContents()

        -- print(k)
        -- PrintTable(v)
        features_buttons[k]:SetText( v.name )

        features_buttons[k].OnChange = function( self )
            -- print(self:GetChecked())
            if self:GetChecked() then
                for _, p in pairs(features_buttons) do
                    if p ~= self then
                        p:SetValue( 0 )
                    end
                end
            end

            refact_model(tonumber(DListTeams:GetSelected()[1]:GetColumnText( 1 )), Rank:GetValue())
        end

        i = i + 1
    end


    Rank.OnSelect = function( panel, index, value )
        -- print( value .." was selected!" )
        refact_model(tonumber(DListTeams:GetSelected()[1]:GetColumnText( 1 )), Rank:GetValue())
    end

    Rank.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 5))
        self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
    end
    Rank.DoClick = function( self )
        if ( self:IsMenuOpen() ) then
            return self:CloseMenu()
        end

        self:OpenMenu()

        self.Menu.Paint = function( panel, w, h ) end

        -- for k, v in pairs(self.Menu:GetChildrens()) do
        for i = 1, self.Menu:ChildCount() do
            local pnl = self.Menu:GetChild(i)
            pnl.Paint = function( self, w, h )
                draw.RoundedBox(0, 0, 0, w, h,Color(73, 111, 158, 255))
            end
            -- pnl:SetFont('font_base_22')
            pnl:SetTextColor(color_white)
        end

        -- print(tonumber(DListTeams:GetSelected()[1]:GetColumnText( 1 )))
        -- print(DListTeams:GetSelected():GetColumnText( 1 ))

    end
    Rank.DropButton:SetText('')
    Rank.DropButton.Paint = function( panel, w, h ) end
    table.insert(no_close_onedit, Rank)

    local Avatar = vgui.Create( "AvatarImage", DPanel )
    Avatar:SetSize( 28, 28 )
    Avatar:SetPos( 0, 0 )
    Avatar:SetPlayer( pl, 64 )

    local Close = vgui.Create( "DButton", DPanel )
    Close:SetSize( 30, 30 )
    Close:SetText('')
    Close:SetPos( DPanel:GetWide()-Close:GetWide()-18, 0 )
    Close.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
        draw.SimpleText('X', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    Close.DoClick = function( self )
        DPanel:Remove()
        table.remove(tasks, i)
    end

    DListTeams:SetMultiSelect( false )
    DListTeams:AddColumn( "ID" )
    DListTeams:AddColumn( "" )
    -- DListTeams:AddColumn( "Size" )

    for k, v in pairs(meta.jobs) do
        DListTeams:AddLine( k, v.Name )
    end

    DListTeams.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 5))
        self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
    end

    modify_model:AddChoice( pl:GetModel() )
    modify_model:SetValue( pl:GetModel() )

    modify_model.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 5))
        self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
    end
    modify_model.DoClick = function( self )
        if ( self:IsMenuOpen() ) then
            return self:CloseMenu()
        end

        self:OpenMenu()

        if self.Menu then
            self.Menu.Paint = function( panel, w, h ) end

            -- for k, v in pairs(self.Menu:GetChildrens()) do
            for i = 1, self.Menu:ChildCount() do
                local pnl = self.Menu:GetChild(i)
                pnl.Paint = function( self, w, h )
                    draw.RoundedBox(0, 0, 0, w, h,Color(73, 111, 158, 255))
                end
                -- pnl:SetFont('font_base_22')
                pnl:SetTextColor(color_white)

                local mdl = vgui.Create('ModelImage', pnl)
                mdl:SetSize(pnl:GetTall(), pnl:GetTall())
                mdl:SetPos(0,0)
                mdl:SetModel( pnl:GetValue() )
            end
        end
    end
    modify_model.DropButton:SetText('')
    modify_model.DropButton.Paint = function( panel, w, h ) end
    table.insert(no_close_onedit, modify_model)

    DListTeams.OnRowSelected = function( panel, rowIndex, row )
        local team_index = pl:Team()
        Rank:Clear()
        local job = meta.jobs[row:GetValue( 1 )]
        local ranks = ALIVE_RANKS[job.Type or 1]
        for _, r in pairs(ranks) do
            Rank:AddChoice( r )
        end

        local player_job = meta.jobs[team_index]

        if player_job.Type == job.Type then
            Rank:SetValue( pl:GetNWString('meta_rank') )
            refact_model(row:GetValue( 1 ), pl:GetNWString('meta_rank'))
        else
            Rank:SetValue( ranks[1] )
            refact_model(row:GetValue( 1 ), ranks[1])
        end

    end

    local teams_search = vgui.Create('DTextEntry', DPanel)
    teams_search:SetSize( 390, 20 )
    teams_search:SetPos( DPanel:GetWide()-teams_search:GetWide()-28-2, 58 )
    teams_search.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 35))
        self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
    end

    for k, line in pairs( DListTeams:GetLines() ) do
        if line:GetValue(1) == pl:Team() then
            DListTeams:SelectItem( line )
            break
        end
    end

    -- DListTeams.VBar = DListTeams:GetVBar()
    -- DListTeams.VBar.Paint = function( self, w, h ) end


    local def_list = baseclass.Get("DListView")
    function DListTeams:PerformLayout()
    -- timer.Simple(0,function()

        def_list.PerformLayout(self)
        DListTeams.VBar:SetSize( 6, DListTeams:GetTall() )
    end

    function DListTeams.VBar:PerformLayout()
        local Wide = self:GetWide()
        local Scroll = self:GetScroll() / self.CanvasSize
        local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( Wide * 2 ) ), 10 )
        local Track = self:GetTall() - BarSize
        Track = Track + 1

        Scroll = Scroll * Track

        self.btnGrip:SetPos( 0, Scroll )
        self.btnGrip:SetSize( Wide, BarSize )

        self.btnUp:SetPos( 0, 0, 0, 0 )
        self.btnUp:SetSize( 0, 0 )

        self.btnDown:SetPos( 0, self:GetTall() - 0, 0, 0 )
        self.btnDown:SetSize( 0, 0 )
    end
    DListTeams.VBar.Paint = function( self, w, h ) end
    DListTeams.VBar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 190)) end


    local function RePaintDListTeams()
        for k, line in pairs( DListTeams:GetLines() ) do
            for k, v in pairs(line.Columns) do
                v:SetText('')
            end

            line.Paint = function( self, w, h )
                if line:IsSelected() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))
                end

                local wi = 0
                for k, v in pairs(line.Columns) do
                    wi = k == 1 and wi or wi + line.Columns[k-1]:GetWide()
                    draw.SimpleText(v.Value, "DermaDefault", wi+4, 0, Color( 255, 255, 255, 255 ))
                end
            end
        end

    end
    RePaintDListTeams()

    for _, colum in pairs(DListTeams.Columns) do
        local text = colum.Header:GetText()
        colum.Header.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color(73+5, 111+5, 158+5))
            draw.SimpleText(text, "DermaDefault", w/2, 0, Color( 255, 255, 255, 255 ), 1, 0)
        end
        colum.Header:SetText('')
    end

    teams_search.OnChange = function( self )
        local value = self:GetValue()

        DListTeams:Clear()
        for k, v in pairs(meta.jobs) do
            local heckStart, heckEnd = string.find( v.Name, value:lower() )
            if heckStart then
                DListTeams:AddLine( k, v.Name )
            end
        end

        RePaintDListTeams()
    end

    table.insert(no_close_onedit, teams_search)

    -- for k, line in pairs( DListTeams:GetLines() ) do
    --     for k, v in pairs(line.Columns) do
    --         v:SetText('')
    --     end

    --     line.Paint = function( self, w, h )
    --         if line:IsSelected() then
    --             draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))
    --         end

    --         local wi = 0
    --         for k, v in pairs(line.Columns) do
    --             wi = k == 1 and wi or wi + line.Columns[k-1]:GetWide()
    --             draw.SimpleText(v.Value, "DermaDefault", wi+4, 0, Color( 255, 255, 255, 255 ))
    --         end
    --     end
    -- end

    local SpawnCheck = vgui.Create( "DCheckBoxLabel", DPanel )
    SpawnCheck:SetPos( 10, DPanel:GetTall() - 24 )
    SpawnCheck:SetText( "Заспаванить после выдачи" )
    SpawnCheck:SetValue( 0 )
    SpawnCheck:SizeToContents()

    local Save = vgui.Create( "DButton", DPanel )
    Save:SetSize( 200, 30 )
    Save:SetText('')
    Save:SetPos( DPanel:GetWide()-Save:GetWide()-18, DPanel:GetTall()-Save:GetTall()-2 )
    Save.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(119,184,0))
        draw.SimpleText('Выдать и закрыть', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    local function SendProfile()
        local features = {}
        for k, v in pairs(features_buttons) do
            features[k] = v:GetChecked()
        end

        netstream.Start('ProfileWhitelist_Change', {
            target = pl,
            rank = Rank:GetValue(),
            team_index = DListTeams:GetLine( DListTeams:GetSelectedLine() ):GetColumnText( 1 ),
            no_spawn = SpawnCheck:GetChecked(),
            features = features,
            model = modify_model:GetValue()
        })
    end

    Save.DoClick = function( self )
        SendProfile()

        DPanel:Remove()
        table.remove(tasks, i)
    end

    local Save = vgui.Create( "DButton", DPanel )
    Save:SetSize( 130, 30 )
    Save:SetText('')
    Save:SetPos( DPanel:GetWide()-Save:GetWide()-18-200, DPanel:GetTall()-Save:GetTall()-2 )
    Save.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(41,163,246))
        draw.SimpleText('Выдать', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    Save.DoClick = function( self )
        SendProfile()

        -- DPanel:Remove()
        -- table.remove(tasks, i)

        local features = {}
        for k, v in pairs(features_buttons) do
            features[k] = v:GetChecked()
        end

        netstream.Start('ProfileWhitelist_Change', {
            target = pl,
            rank = Rank:GetValue(),
            team_index = DListTeams:GetLine( DListTeams:GetSelectedLine() ):GetColumnText( 1 ),
            no_spawn = SpawnCheck:GetChecked(),
            features = features
        })
    end

    local Time = vgui.Create( "DButton", DPanel )
    Time:SetSize( 100, 30 )
    Time:SetText('')
    Time:SetPos( DPanel:GetWide()-Time:GetWide()-18-330, DPanel:GetTall()-Time:GetTall()-2 )
    Time.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(189,155,234))
        draw.SimpleText('На время', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    Time.DoClick = function( self )
        netstream.Start('ProfileWhitelist_ChangeToTime', {
            target = pl,
            rank = Rank:GetValue(),
            team_index = DListTeams:GetLine( DListTeams:GetSelectedLine() ):GetColumnText( 1 ),
            no_spawn = SpawnCheck:GetChecked()
        })
        DPanel:Remove()
    end

    DTLayout:Add( DPanel )
end

local DPanel = DPanel or nil
local layout = layout or nil
local PlayerPanels = PlayerPanels or nil

local alpha_lerp = 0
local alpha = 0


local function OpenContextMenu()
    alpha_lerp = 0
    alpha = 0

    -- local SearchPanel

	if IsValid(Menu) then
        Menu:SetVisible(true)
    else

        Menu = vgui.Create("DFrame")
        Menu:SetSize(ScrW(),ScrH())
        Menu:SetPos(0,0)
        Menu:SetDraggable(false)
        Menu:SetTitle('')
        Menu:ShowCloseButton(false)
        Menu.Paint = function( self, w, h )
            local x, y = self:GetPos()
            alpha = 160

            alpha_lerp = Lerp(FrameTime()*6,alpha_lerp or 0,alpha or 0) or 0
            -- draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), alpha_lerp/100 )

            draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 180))

            -- local level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
            -- local xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
            -- local reqxp = wOS.XPScaleFormula( level )
            -- local lastxp = 0
            -- if level > 0 then
            --     lastxp = wOS.XPScaleFormula( level - 1 )
            -- end
            -- local rat = ( xp - lastxp )/( reqxp - lastxp )
            -- if level == wOS.SkillMaxLevel then
            --     rat = 1
            -- end
            -- draw.RoundedBox( 0, (w - w*0.33 )/2, h-40, w*0.33*1, h*0.02, Color( 25, 25, 25, 90 ) )
            -- surface.SetDrawColor( Color(0,0,0,0) )
            -- surface.DrawOutlinedRect( ( w - w*0.33 )/2, h*0.005, w*0.33, h*0.02 )
            -- surface.DrawRect( (w - w*0.33 )/2, h-40, h*0.005, h*0.02 )
            -- surface.SetDrawColor( color_white )
            -- surface.DrawRect( (w - w*0.33 )/2, h-40, w*0.33*rat, h*0.02 )
            -- draw.ShadowSimpleText( ( level == wOS.SkillMaxLevel and "MAX" ) or lastxp, "font_base_18", ( w - w*0.33 )/2 - w*0.005, h-30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            -- draw.ShadowSimpleText( ( level == wOS.SkillMaxLevel and "LEVEL" ) or reqxp, "font_base_18", ( w + w*0.33 )/2 + w*0.005, h-30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            -- draw.ShadowSimpleText( level..' уровень', "font_base_24", w*0.5-4, h-58, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.ShadowSimpleText( formatMoney(LocalPlayer():PS_GetPoints()), "font_base_24", w*0.5+4, h-58, Color(92,184,92), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        Menu:MakePopup()

        local RadioWang = vgui.Create("DNumberWang",Menu)
        RadioWang:SetSize(right_side_width/2, 30)
        RadioWang:SetPos( Menu:GetWide()-RadioWang:GetWide()-50,10)
        RadioWang:SetPaintBorderEnabled( true )
        RadioWang:SetFont('font_base_22')
        -- RadioWang:SetText('')
        local radio = LocalPlayer():GetNVar('meta_radio') and LocalPlayer():GetNVar('meta_radio') or 0
        RadioWang:SetValue( radio )
        RadioWang:SetZPos(10)
        RadioWang.OnValueChange = function( self, value )
            value = (value and value ~= nil and value ~= '' and tonumber(value) >= 100) and 100 or (tonumber(value) or 0)
            self:SetValue( value )
        end

        RadioWang.Paint = function( self, w, h )
            draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 190))
            self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
        end

        table.insert(no_close_onedit, RadioWang)

        local SaveRadio = vgui.Create( "DButton", Menu )
        SaveRadio:SetSize( right_side_width/2.6, 30 )
        SaveRadio:SetText('')
        SaveRadio:SetPos( Menu:GetWide()-SaveRadio:GetWide()-RadioWang:GetWide()-54, 10 )
        SaveRadio:SetZPos(10)
        SaveRadio.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color(52, 73, 94))
            draw.SimpleText('Сохранить канал', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
        end

        SaveRadio.DoClick = function( self )
            netstream.Start("WalkieTalkie.ChangeChannel", { channel = RadioWang:GetValue() })
            Menu:Remove()
        end

        local Person = vgui.Create( "DButton", Menu )
        Person:SetSize( right_side_width/2.6, 30 )
        Person:SetText('')
        Person:SetPos( Menu:GetWide()-Person:GetWide()-SaveRadio:GetWide()-RadioWang:GetWide()-58, 10 )
        Person:SetZPos(10)
        Person.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color(52, 73, 94))
            draw.SimpleText('Третье лицо', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
        end
        Person:SetZPos( -10 )

        Person.DoClick = function( self )
            thirdperson_enabled = not thirdperson_enabled
            -- Menu:Remove()
        end

        if IsValid(LocalPlayer():GetNW2Entity( 'sneakyjetpack' )) then
            local MuguPidoras = vgui.Create( "DButton", Menu )
            MuguPidoras:SetSize( right_side_width/2.6, 30 )
            MuguPidoras:SetText('')
            MuguPidoras:SetPos( Menu:GetWide()-720, 10 )
            MuguPidoras:SetZPos(10)
            MuguPidoras.Paint = function( self, w, h )
                draw.RoundedBox(0, 0, 0, w, h, Color(231,108,54))
                draw.SimpleText('Снять джетпак', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
            end
            MuguPidoras:SetZPos( -10 )

            MuguPidoras.DoClick = function( self )
                RunConsoleCommand('pe_drop', 'sneakyjetpack')
                -- thirdperson_enabled = not thirdperson_enabled
                -- Menu:Remove()
            end
        end

        local Close = vgui.Create( "DButton", Menu )
        Close:SetSize( 30, 30 )
        Close:SetText('')
        Close:SetPos( Menu:GetWide()-Close:GetWide() - 10, 10 )
        Close.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color(52, 73, 94))
            draw.SimpleText('X', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
        end

        Close.DoClick = function( self )
            Menu:SetVisible(false)
        end

        DPanel = vgui.Create("DScrollPanel", Menu)
        DPanel:SetSize(right_side_width,Menu:GetTall()-20)
        DPanel:SetPos(10,10)

        DPanel.VBar:SetWide(0)

        local panel_wide, panel_tall = DPanel:GetWide(), DPanel:GetTall()
        DPanel.Paint = function( self, w, h ) end

        DTasks = vgui.Create("DScrollPanel", Menu)
        DTasks:SetSize(right_side_width*1.6,Menu:GetTall()-20)
        DTasks:SetPos(right_side_width+20,10)

        DTLayout = vgui.Create("DListLayout", DTasks)
        DTLayout:SetSize(right_side_width*1.6-18,Menu:GetTall()-20)
        DTLayout:SetPos(0,0)
        DTLayout:SetZPos(32767)

        for k, v in pairs(tasks) do
            if v and IsValid(v) then
                OpenNewTask(v)
            else
                table.remove(tasks, k)
            end
        end

        layout = vgui.Create( "DListLayout", DPanel )
        layout:SetSize( DPanel:GetWide(), DPanel:GetTall() )
        layout:SetPos( 0, 0 )

        -- SearchPanel = vgui.Create("DTextEntry",DPanel)
        -- SearchPanel:SetSize(layout:GetWide(), 30)
        -- SearchPanel:SetPos(0,0)
        -- SearchPanel:SetPaintBorderEnabled( true )
        -- SearchPanel:SetFont('font_base_22')
        -- SearchPanel:SetText('')

        -- SearchPanel.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(64, 105, 153, 190))
        --     self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
        -- end

        -- table.insert(no_close_onedit, SearchPanel)

        local max_x, max_y = 120, 100
        local Slider = vgui.Create( "DSlider", Menu )
        Slider:SetSize( 200, 200 )
        Slider:SetPos( Menu:GetWide() - Slider:GetWide() - 10, 50 )
        Slider:SetLockX()
        Slider:SetLockY()
        Slider:SetSlideY(tonumber(thirtperson.z:GetString()))
        Slider:SetSlideX(tonumber(thirtperson.y:GetString()))
        Slider.Knob:SetSize(14,14)
        Slider.Knob.Paint = function( self, w, h )
            -- local col = self.Depressed and Color(0,165,255,255) or (self:IsHovered() and Color(190,190,190,255) or color_white)
            local col = self.Depressed and Color(52, 73, 94,255) or Color(52, 73, 94,230)
            draw.RoundedBox(0,0,0,w,h,col)
        end
        Slider.Paint = function( self, w, h )
            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,90))
            local y, z = self:GetSlideX(), self:GetSlideY()
            surface.SetDrawColor(Color(255,255,255,90))
            surface.DrawLine(y*w,0,y*w,h)
            surface.DrawLine(0,z*h,w,z*h)

            surface.DrawLine(0,w*.5,w,w*.5)
            surface.DrawLine(h*.5,0,h*.5,h)
            draw.SimpleText(' '..y*100, "DermaDefault", y*w, 0, color_white, 1, 0)
            draw.SimpleText(' '..z*100, "DermaDefault", h, z*h, color_white, 2, 1)

            thirtperson.y:SetString(y)
            thirtperson.z:SetString(z)
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
        local ZSlider = vgui.Create( "DNumSlider", Menu )
        ZSlider:SetSize( 200, 20 )
        ZSlider:SetPos( Menu:GetWide() - ZSlider:GetWide() - 10, 250 )
        ZSlider.Paint = function( self, w, h )
            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,90))
            surface.SetDrawColor(Color(255,255,255,90))
            surface.DrawOutlinedRect( 0, 0, w, h )

            surface.DrawLine(w*.5,0,w*.5,w)
        end

        ZSlider:SetConVar('thirtperson_x')
        ZSlider:SetMin( 40 )
        ZSlider:SetMax( 200 )
        ZSlider:SetDecimals( 0 )

        ZSlider.PerformLayout = function()
            ZSlider:GetTextArea():SetWide(0)
            ZSlider.Label:SetWide(0)
            ZSlider.Slider:SetPos(0,0)
            ZSlider.Slider.Knob:SetSize(18,18)
            ZSlider.Slider.Paint = function( self, w, h ) end
            ZSlider.Slider.Knob.Paint = function( self, w, h )
                local col = self.Depressed and Color(52, 73, 94,255) or Color(52, 73, 94,230)
                local pos_x = ZSlider:GetValue() == ZSlider:GetMax() and -1 or (ZSlider:GetValue() == ZSlider:GetMin() and 1 or 0)

                draw.RoundedBox(0,pos_x,0,w,h,col)
            end
        end


        -- local max_x, max_y = 120, 100
        -- local Slider = vgui.Create( "DSlider", Menu )
        -- Slider:SetSize( 200, 200 )
        -- Slider:SetPos( Menu:GetWide() - Slider:GetWide() - 10, 50 )
        -- Slider:SetLockX()
        -- Slider:SetLockY()
        -- Slider:SetSlideY(tonumber(thirtperson.z:GetString()))
        -- Slider:SetSlideX(tonumber(thirtperson.y:GetString()))
        -- Slider.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(0,0,0,90))

        --     local y, z = self:GetSlideX(), self:GetSlideY()

        --     surface.SetDrawColor(Color(255,255,255,90))
        --     surface.DrawLine(y*w,0,y*w,h)
        --     surface.DrawLine(0,z*h,w,z*h)

        --     -- surface.DrawOutlinedRect( w*.5-3, h*.5-3, 6, 6 )
        --     surface.DrawOutlinedRect( 0, h*.5-3, w, 6 )
        --     surface.DrawOutlinedRect( w*.5-3, 0, 6, h )

        --     draw.SimpleText(' '..y*100, "DermaDefault", y*w, 0, color_white, 1, 0)
        --     draw.SimpleText(' '..z*100, "DermaDefault", h, z*h, color_white, 2, 1)


        --     -- thirtperson = {
        --     --     x = meta.thirtperson.x,
        --     --     y = y,
        --     --     z = z,
        --     -- }
        --     -- print(z,y)
        --     thirtperson.y:SetString(y)
        --     thirtperson.z:SetString(z)

        --     -- print(thirtperson.z:GetString())

        --     surface.DrawOutlinedRect( 0, 0, w, h )

        --     -- PrintTable(meta.thirtperson)
        -- end

        -- local ZSlider = vgui.Create( "DNumSlider", Menu )
        -- ZSlider:SetSize( 200, 20 )
        -- ZSlider:SetPos( Menu:GetWide() - ZSlider:GetWide() - 10, 250 )
        -- ZSlider:SetMin( 40 )
        -- ZSlider:SetMax( 200 )
        -- ZSlider:SetDecimals( 0 )
        -- ZSlider:SetConVar('thirtperson_x')
        -- -- ZSlider:SetValue(meta.thirtperson.x)
        -- -- function ZSlider:OnValueChanged( value )
        -- --     -- meta.thirtperson.x = value
        -- -- end
        -- ZSlider:SetText( "X pos" )

        local acts = {
            ['cheer'] = { text = 'Радость', icon = Material('materials/sup_ui/emotes/cheer_64.png')},
            ['laugh'] = { text = 'Смех', icon = Material('materials/sup_ui/emotes/laugh_64.png')},
            ['muscle'] = { text = 'Мускулы', icon = Material('materials/sup_ui/emotes/sexy_64.png')},
            ['zombie'] = { text = 'Зомби', icon = Material('materials/sup_ui/emotes/zombie_64.png')},
            ['robot'] = { text = 'Робот', icon = Material('materials/sup_ui/emotes/robot_64.png')},
            ['dance'] = { text = 'Танец', icon = Material('materials/sup_ui/emotes/dance_64.png')},
            ['agree'] = { text = 'Соглашение', icon = Material('materials/sup_ui/emotes/agree_64.png')},
            ['becon'] = { text = 'Позвать', icon = Material('materials/sup_ui/emotes/becon_64.png')},
            ['disagree'] = { text = 'Упрекнуть', icon = Material('materials/sup_ui/emotes/disagree_64.png')},
            ['salute'] = { text = 'Салют', icon = Material('materials/sup_ui/emotes/salute_64.png')},
            ['wave'] = { text = 'Приветствие', icon = Material('materials/sup_ui/emotes/wave_64.png')},
            ['forward'] = { text = 'Вперёд', icon = Material('materials/sup_ui/emotes/forward_64.png')},
            ['pers'] = { text = 'Напугать', icon = Material('materials/sup_ui/emotes/flamingo_64.png')},
			['bow'] = { text = 'Поклон', icon = Material('materials/sup_ui/emotes/bow_64.png')},
			['group'] = { text = 'Группа', icon = Material('materials/sup_ui/emotes/group_64.png')},
			['halt'] = { text = 'Остановка', icon = Material('materials/sup_ui/emotes/halt_64.png')}
        }

        do
            local i = 1
            for command, act in pairs(acts) do
                local btn = vgui.Create('DButton', Menu)
                btn:SetSize(160,28)
                btn:SetPos(Menu:GetWide() - btn:GetWide() - 10, 250+(30*i))
                btn:SetText('')
                btn.Paint = function( self, w, h )
                    draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
                    draw.SimpleText(act.text, "font_base_22", w - 10, h/2, Color( 255, 255, 255, 255 ), 2, 1)

                    -- -- surface.SetDrawColor(255,255,255,36)
                    -- surface.DrawOutlinedRect(0, 0, w, h)

					draw.Icon( 0, 0, h, h, act.icon, color_white )
                end
                btn.DoClick = function( self )
                    RunConsoleCommand('act', command)
                    -- PrintTable(command)

                    -- ConCommand('act '..command)
                end

                i = i + 1
            end
        end

        do
            local i = 1
            for command, act in pairs(SUP_ANIMATIONS) do
                local btn = vgui.Create('DButton', Menu)
                btn:SetSize(160,28)
                btn:SetPos(Menu:GetWide() - btn:GetWide() - 10 - 170, 250+(30*i))
                btn:SetText('')
                btn.Paint = function( self, w, h )
                    draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
                    draw.SimpleText(act.name, "font_base_22", w*.5, h*.5, Color( 255, 255, 255, 255 ), 1, 1)

                    -- -- surface.SetDrawColor(255,255,255,36)
                    -- surface.DrawOutlinedRect(0, 0, w, h)

					-- draw.Icon( 0, 0, h, h, act.icon, color_white )
                end
                btn.DoClick = function( self )
                    RunConsoleCommand('sup_act', command)
                    -- PrintTable(command)

                    -- ConCommand('act '..command)
                end

                i = i + 1
            end
        end
    end

    -- local players = {}


    -- SearchPanel.OnChange = function( self )
    --     -- print(self:GetValue())


    --     table.sort(players, function(a, b)
    --         local value = string.lower(self:GetValue())
    --         local A_heckStart, _ = string.find( string.lower(a:Name()), value )
    --         local B_heckStart, _ = string.find( string.lower(b:Name()), value )
    --         return A_heckStart > B_heckStart
    --     end)
    -- end

    -- local players = player.GetAll()

    PlayerPanels = PlayerPanels or {}
    for k, pnl in pairs(PlayerPanels) do
        pnl:Remove()
    end
    for k, pnl in pairs(defcons_buttons) do
        pnl:Remove()
    end

    if RadioScroll and IsValid(RadioScroll) then
        RadioScroll:Remove()
    end

    RadioScroll = vgui.Create( "DScrollPanel", Menu )
    RadioScroll:SetSize( 200, 200 )
    RadioScroll:SetPos( Menu:GetWide() - 200 - RadioScroll:GetWide() - 14, 50 )
    RadioScroll.Paint = function( self, w, h )
        -- draw.RoundedBox(0,0,0,w,h,ColorAlpha(team.GetColor(v:Team()), 90))
    end

    RadioScroll.VBar = RadioScroll:GetVBar()
    RadioScroll.VBar:SetWide(6)

    function RadioScroll.VBar:PerformLayout()
        local Wide = self:GetWide()
        local Scroll = self:GetScroll() / self.CanvasSize
        local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( Wide * 2 ) ), 10 )
        local Track = self:GetTall() - BarSize
        Track = Track + 1

        Scroll = Scroll * Track

        self.btnGrip:SetPos( 0, Scroll )
        self.btnGrip:SetSize( Wide, BarSize )

        self.btnUp:SetPos( 0, 0, 0, 0 )
        self.btnUp:SetSize( 0, 0 )

        self.btnDown:SetPos( 0, self:GetTall() - 0, 0, 0 )
        self.btnDown:SetSize( 0, 0 )
    end
    RadioScroll.VBar.Paint = function( self, w, h ) end
    RadioScroll.VBar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 190)) end


    local RadioList = vgui.Create( "DListLayout", RadioScroll )
    RadioList:Dock( FILL )
    RadioList:SetPos( 0, 0 )
    RadioList.Paint = function( self, w, h )
        -- draw.RoundedBox(0,0,0,w,h,ColorAlpha(team.GetColor(v:Team()), 90))
    end

    if LocalPlayer():GetNVar('meta_radio') ~= 0 then
        for k, v in pairs(player.GetAll()) do
            if v:GetNVar('meta_radio') == LocalPlayer():GetNVar('meta_radio') and IsValid(v) then
                -- table.remove(radio_players, k)
                -- radio_players[k] = nil
                local RadioPlayer = vgui.Create('DPanel')
                RadioPlayer:SetTall(20)
                RadioPlayer.Paint = function( self, w, h )
                    draw.RoundedBox(0,0,0,w,h,ColorAlpha(team.GetColor(v:Team()), 90))
                    draw.SimpleText(v:Name()..' ('..team.GetName(v:Team())..')', "DermaDefault", 24, h/2, color_white, 0, 1)
                end

                local RadioPlayerAvatar = vgui.Create('AvatarImage', RadioPlayer)
                RadioPlayerAvatar:SetSize(20,20)
                RadioPlayerAvatar:SetPos( 0, 0 )
                RadioPlayerAvatar:SetPlayer( v, 32 )

                RadioList:Add(RadioPlayer)
            end
        end
    end

    function OpenPlayersList()
        local players = {}
        -- players = player.GetAll()

        -- PrintTable(players)
        if LEGION_CMDS[LocalPlayer():Team()] or WHITELIST_ADMINS[LocalPlayer():GetUserGroup()] then
            players = player.GetAll()

            if not WHITELIST_ADMINS[LocalPlayer():GetUserGroup()] then
                for k, pl in pairs(players) do
                    local j = meta.jobs[pl:Team()] or meta.jobs[TEAM_CADET]
                    if LEGION_CMDS[LocalPlayer():Team()][j.legion] then

                    else
                        players[k] = false
                        table.remove(players, k)
                    end
                end
            end
            table.sort(players, function(a, b)
                return a:Name() < b:Name()
            end)

            -- print('update')

            -- table.sort(players, function(a, b)
            --     return a:Team() > b:Team()
            -- end)
        end

        for i, pl in pairs(players) do
            -- if pl:Team() == 1001 then
            --     return
            -- end

            PlayerPanels[i] = vgui.Create('DButton')
            PlayerPanels[i]:SetTall(30)
            PlayerPanels[i]:SetWide(DPanel:GetWide()-18)
            PlayerPanels[i]:SetText('')
            PlayerPanels[i].Paint = function( self, w, h )
                if not pl or not IsValid(pl) then
                    return
                end

                local pcol = team.GetColor(pl:Team())
                h = 28
                if pl and pcol then
                    draw.RoundedBox(0,0,0,w,h,Color(pcol.r, pcol.g, pcol.b, 250))

                    local rpid = pl:GetRPID()
                    rpid = rpid and ' '..rpid..'' or ''

                    local tm = pl:Team()
                    local rank = pl:GetNWString('meta_rank') or ''
                    rank = rank or ''

                    local name = pl:Name()
                    draw.SimpleText(name, "font_base_22", 32+1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
                    draw.SimpleText(name, "font_base_22", 32, h/2, Color( 255, 255, 255, 250 ), 0, 1)


                    -- draw.SimpleText(rpid, "font_base_22", 32 + wt + 4 +1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
                    -- draw.SimpleText(rpid, "font_base_22", 32 + wt + 4 , h/2, Color( 195, 195, 195, 255 ), 0, 1)

                    -- local tname = tm == 0 and '(Не выбрал персонажа)' or team.GetName(tm)
                    -- draw.SimpleText(tname, "font_base_22", w/2 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                    -- draw.SimpleText(tname, "font_base_22", w/2 , h/2, Color( 255, 255, 255, 255 ), 1, 1)

                    -- if rank then
                    --     draw.SimpleText(rank, "font_base_22", w/3 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                    --     draw.SimpleText(rank, "font_base_22", w/3 , h/2, Color( 255, 255, 255, 255 ), 1, 1)
                    -- end

                    local oldname = pl:OldName()
                    surface.SetFont('font_base_22')
                    local wt, _ = surface.GetTextSize(' '..rpid)

                    draw.RoundedBox(0, w-wt, 0, wt, h, Color(pcol.r-12,pcol.g-12,pcol.b-12,255))

                    if rank then
                        draw.SimpleText(rank..' '..rpid, "font_base_22", w - 4 +1, h/2+1, Color( 0, 0, 0, 60 ), 2, 1)
                        draw.SimpleText(rank..' '..rpid, "font_base_22", w - 4 , h/2, Color( 255, 255, 255, 255 ), 2, 1)
                    end

                    if self:IsHovered() then
                        draw.RoundedBox(0,0,0,w,h,Color(230, 230, 230, 4))
                    end
                end
            end

            local Avatar = vgui.Create( "AvatarImage", PlayerPanels[i] )
            Avatar:SetSize( 28, 28 )
            Avatar:SetPos( 0, 0 )
            Avatar:SetPlayer( pl, 64 )

            PlayerPanels[i].DoClick = function( self )
                local i = table.insert(tasks, pl)
                OpenNewTask(pl, i)
            end

            layout:Add( PlayerPanels[i] )
        end

        do
            if TEAMS_CANUSE_DEFCONS[LocalPlayer():Team()] then
                local i = 1
                for name, text in pairs(DEFCON_TYPES) do
                    defcons_buttons[i] = vgui.Create('DButton', Menu)
                    defcons_buttons[i]:SetSize(160,28)
                    defcons_buttons[i]:SetPos(Menu:GetWide() - defcons_buttons[i]:GetWide() - 10 - 342, 250+(30*i))
                    defcons_buttons[i]:SetText('')
                    defcons_buttons[i].Paint = function( self, w, h )
                        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
                        draw.SimpleText(name, "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
                        surface.SetDrawColor(255,255,255,0)
                        surface.DrawOutlinedRect(0, 0, w, h)
                    end
                    defcons_buttons[i].DoClick = function( self )
                        netstream.Start('SendCommandDefcon', { name = name })
                        -- RunConsoleCommand('act', command)
                    end
                    i = i + 1
                end
            end
        end
    end

    OpenPlayersList()
end

function GM:OnContextMenuOpen()
    gui.EnableScreenClicker(true)
    no_close_onedit = no_close_onedit or {}
    OpenContextMenu()
end

function GM:OnContextMenuClose()
    gui.EnableScreenClicker(false)
    no_close_onedit = no_close_onedit or {}
    if Menu and IsValid(Menu) then
        local no_cl = true
        for k, v in pairs(no_close_onedit) do
            if v and IsValid(v) then
                if v.IsEditing and v:IsEditing() then
                    return
                end

                if v.GetToggle and v:GetToggle() then
                    return
                end
            end
        end

        if Menu:IsVisible() and no_cl then
            -- Menu:SetVisible(false)
            Menu:Remove()
        end
    end
end

hook.Add('OnReloaded','ContextMenu_OnReloaded',function()
    if Menu and IsValid(Menu) then
        Menu:Remove()
    end
end)

if Menu and IsValid(Menu) then
    Menu:Remove()
end
