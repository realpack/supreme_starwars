local right_side_wide = 180

local names = {
	first = {
		"Liam","Noah","Mason","Ethan","Logan","Lucas","Jackson","Aiden","Oliver",
		"Jacob","Elijah","Alexander","James","Benjamin","Jack","Luke","William",
		"Michael","Owen","Daniel","Carter","Gabriel","Henry","Matthew","Wyatt",
		"Caleb","Jayden","Nathan","Ryan","Isaac","Emma","Olivia","Ava","Sophia",
		"Isabella","Mia","Charlotte","Amelia","Emily","Madison","Harper","Abigail",
		"Avery","Lily","Ella","Chloe","Evelyn","Sofia","Aria","Ellie","Aubrey",
		"Scarlett","Zoey","Hannah","Audrey","Grace","Addison","Zoe","Elizabeth","Nora",
		"Abramson","Adamson","Adderiy","Addington","Adrian","Albertson","Aldridge",
		"Allford","Alsopp","Anderson",	"Andrews","Archibald","Arnold","Arthurs",
		"Atcheson","Attwood","Audley","Austin","Ayrton","Babcock","Backer","Baldwin",
		"Bargeman","Barnes","Barrington","Bawerman","Becker","Benson","Berrington",
		"Birch","Bishop","Black","Blare","Blomfield","Boolman","Bootman","Bosworth",
		"Bradberry","Bradshaw","Brickman","Brooks","Brown","Bush","Calhoun","Campbell",
		"Carey","Carrington","Carroll","Carter","Chandter","Chapman","Charlson",
		"Chesterton","Clapton","Clifford","Coleman","Conors","Cook","Cramer","Creighton",
		"Croftoon","Crossman","Daniels","Davidson","Day","Dean","Derrick","Dickinson",
		"Dodson","Donaldson","Donovan","Douglas","Dowman","Dutton","Duncan","Dunce",
		"Durham","Dyson","Eddington","Edwards","Ellington","Elmers","Enderson","Erickson",
		"Evans","Faber","Fane","Farmer","Farrell","Ferguson","Finch","Fisher","Fitzgerald",
		"Flannagan","Flatcher","Fleming","Ford","Forman","Forster","Foster","Francis",
		"Fraser","Freeman","Fulton","Galbraith","Gardner","Garrison","Gate","Gerald",
		"Gibbs","Gilbert","Gill","Gilmore","Gilmore","Gimson","Goldman","Goodman",
		"Gustman","Haig","Hailey","Hamphrey","Hancock","Hardman","Harrison","Hawkins",
		"Higgins","Hodges","Hoggarth","Holiday","Holmes","Howard","Jacobson","James",
		"Jeff","Jenkin","Jerome","Johnson","Jones","Keat","Kelly","Kendal","Kennedy",
		"Kennett","Kingsman","Kirk","Laird","Lamberts","Larkins","Lawman","Leapman",
		"Leman","Lewin","Little","Livingston","Longman","MacAdam","MacAlister",
		"MacDonald","Macduff","Macey","Mackenzie","Mansfield","Marlow","Marshman",
		"Mason","Mathews","Mercer","Michaelson","Miers","Miller","Miln","Milton",
		"Molligan","Morrison","Murphy","Nash","Nathan","Neal","Nelson","Nevill",
		"Nicholson","Nyman","Oakman","Ogden","Oldman","Oldridge","Oliver","Osborne",
		"Oswald","Otis","Owen","Page","Palmer","Parkinson","Parson","Pass","Paterson",
		"Peacock","Pearcy","Peterson","Philips","Porter","Quincy","Raleigh","Ralphs",
		"Ramacey","Reynolds","Richards","Roberts","Roger","Russel","Ryder","Salisburry",
		"Salomon","Samuels","Saunder","Shackley","Sheldon","Sherlock","Shorter","Simon",
		"Simpson","Smith","Stanley","Stephen","Stevenson","Sykes","Taft","Taylor","Thomson",
		"Thorndike","Thornton","Timmons","Tracey","Turner","Vance","Vaughan","Wainwright",
		"Walkman","Wallace","Waller","Walter","Ward","Warren","Watson",	"Wayne",
		"Webster","Wesley","White","WifKinson","Winter","Wood","Youmans","Young",
	},
}

-- local mysound = CreateSound( "sup_sound/ui/background.mp3" )

function textWrap(text, font, pxWidth)
	local total = 0

	surface.SetFont(font)

	local spaceSize = surface.GetTextSize(' ')
	text = text:gsub("(%s?[%S]+)", function(word)
			local char = string.sub(word, 1, 1)
			if char == "\n" or char == "\t" then
				total = 0
			end

			local wordlen = surface.GetTextSize(word)
			total = total + wordlen

			-- Wrap around when the max width is reached
			if wordlen >= pxWidth then -- Split the word if the word is too big
				local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
				total = splitPoint
				return splitWord
			elseif total < pxWidth then
				return word
			end

			-- Split before the word
			if char == ' ' then
				total = wordlen - spaceSize
				return '\n' .. string.sub(word, 2)
			end

			total = wordlen
			return '\n' .. word
		end)

	return text
end

local CreationMenu = CreationMenu or nil
local function OpenCharacterMenu(data)
	local characters = data.characters
	local err = data.err
	if IsValid(CreationMenu) then CreationMenu:Remove() end

	local list_models = {}

	-- mysound:Play()

	CreationMenu = vgui.Create("DFrame")
	CreationMenu:SetPos(0,0)
	CreationMenu:SetSize(ScrW(),ScrH())
	CreationMenu:SetDraggable(false)
	CreationMenu:SetTitle('')
	CreationMenu:ShowCloseButton(false)
	CreationMenu.Paint = function( self, w, h )
		local x, y = self:GetPos()
		draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), 2 )

		draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 250))

		if err then
			surface.SetFont('font_base_22')
			local wt, _ = surface.GetTextSize(err)
			draw.RoundedBox(0,10,10,wt+6,26,Color(52, 73, 94, 250))
			draw.SimpleText(err, "font_base_22", 12, 12, Color( 255, 255, 255, 255 ))
		end
	end

	timer.Simple(5, function()
		err = nil
	end)

	CreationMenu:MakePopup()

	local DPanel = vgui.Create("DPanel", CreationMenu)
	DPanel:SetSize(ScrW()/1.2,ScrH()/1.8)
	DPanel:SetPos(CreationMenu:GetWide()*.5 - DPanel:GetWide()*.5,CreationMenu:GetTall()*.5 - DPanel:GetTall()*.5)



	local panel_wide, panel_tall = DPanel:GetWide(), DPanel:GetTall()
	DPanel.Paint = function( self, w, h )
		-- draw.RoundedBox(4,0,0,w,h,Color(0,0,0,90))

		-- draw.SimpleText('Пол:', "DermaDefault", panel_wide - right_side_wide + 6, 10, Color( 190, 190, 190, 190 ))
		-- draw.SimpleText('Имя и фамилия персонажа:', "DermaDefault", panel_wide - right_side_wide + 6, 35, Color( 190, 190, 190, 190 ))
	end

	-- for k, char in pairs(characters) do
	--     PrintTable(char)
	-- end

	local DHorizontalScroller = vgui.Create( "DHorizontalScroller", DPanel )
	DHorizontalScroller:Dock( FILL )
	DHorizontalScroller:SetOverlap( -4 )

	function DHorizontalScroller.btnLeft:Paint( w, h )
		draw.SimpleText('⯇', "font_base_24", 0, -4, Color( 255, 255, 255, 255 ), 0, 0)
		-- draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0 ) )
	end
	function DHorizontalScroller.btnRight:Paint( w, h )
		draw.SimpleText('⯈', "font_base_24", 0, -4, Color( 255, 255, 255, 255 ), 0, 0)
		-- draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 100, 200 ) )
	end

	local max_characters = GROUPS_RELATION[LocalPlayer():GetUserGroup()] or 1

	characters = characters or {}
	for k, char in pairs(characters) do
		local CharPanel = vgui.Create('DPanel')
		CharPanel:SetWide(300)
		CharPanel.Paint = function( self, w, h )
		end

		local DModel = vgui.Create('DModelPanel', CharPanel)
		local model = meta.jobs[char.team_index].WorldModel
		if istable(model) then
			model = table.Random(model)
		end

		if char.model then
			model = char.model
		end

		DModel:SetModel(model)
		DModel:Dock(FILL)

		DModel:SetFOV(40)

		DModel.Angles = Angle(0,0,0)
		local rnd = 2
		function DModel:LayoutEntity( ent )
			if ( self.bAnimated ) then
				self:RunAnimation()
			end

			if ( self.Pressed ) then
				local mx, my = gui.MousePos()
				self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

				self.PressX, self.PressY = gui.MousePos()
			end

			ent:SetAngles( self.Angles )
			ent:SetSequence(ent:LookupSequence("pose_standing_0"..rnd))
		end
		DHorizontalScroller:AddPanel( CharPanel )

		local SelectChar = vgui.Create('DButton', CharPanel)
		SelectChar:Dock(FILL)
		SelectChar:SetText('')
		SelectChar.Paint = function( self, w, h )
			local a = self:IsHovered() and 10 or 5
			draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, a))
			draw.SimpleText(char.character_name, "font_base_24", 10, 10, Color( 255, 255, 255, 255 ), 0, 0)
			draw.SimpleText(char.rpid, "font_base_18", 10, 32, Color( 255, 255, 255, 255 ), 0, 0)
		end

		function SelectChar:DragMousePress()
			DModel.PressX, DModel.PressY = gui.MousePos()
			DModel.Pressed = true
		end
		function SelectChar:DragMouseRelease()
			timer.Simple(0.01,function()
				if DModel and DModel.Pressed and self then
					DModel.Pressed = false
				end
			end)
		end

		SelectChar.DoClick = function(self)
			if DModel.Pressed then
				netstream.Start('SpawnPlayerCharacter', {character_id = char.character_id})
				CreationMenu:Remove()
				RunConsoleCommand('stopsound')
			end
		end

		function SelectChar:DoRightClick()
			local menu = DermaMenu()
			menu:AddOption( "Удалить персонажа", function()
				netstream.Start('RemovePlayerCharacter', {character_id = char.character_id})
				CreationMenu:Remove()
			end )
			menu:Open()
		end
	end


	local function OpenNewCharacterMenu(characters)
		Menu = vgui.Create("DFrame")
		Menu:SetPos(0,0)
		Menu:SetSize(ScrW(),ScrH())
		Menu:SetDraggable(false)
		Menu:SetTitle('')
		Menu:ShowCloseButton(false)
		Menu.Paint = function( self, w, h )
			local x, y = self:GetPos()
			draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), 2 )

			draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 250))
		end

		Menu:MakePopup()

		local DBack = vgui.Create("DButton", Menu)
		DBack:SetSize(30+70,30)
		DBack:SetPos(10,10)
		DBack:SetText('')

		DBack.Paint = function( self, w, h )
			-- draw.Icon(0,0,w,h, )
			draw.SimpleText('◄ Назад', "font_base_24", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
		end

		DBack.DoClick = function(self)
			OpenCharacterMenu({ characters = characters })
			Menu:Remove()
		end

		local DPanel = vgui.Create("DPanel", Menu)
		DPanel:SetSize(600,800)
		DPanel:SetPos(Menu:GetWide()*.5 - DPanel:GetWide()*.5, Menu:GetTall()*.5 - DPanel:GetTall()*.5)

		DPanel.Paint = function( self, w, h )
		end

		local text = [[Великая армия Республики (ВАР) была главной частью вооружённых сил Галактической Республики в её последние годы. За исключением сепаратистских сил, она стала одной из крупнейших армий, когда-либо созданных. Солдаты ВАР выращивались на Камино, и с самого раннего детства их тренировали стать идеальными военными — наиболее эффективной вооруженной силой в истории галактики. Клонам прививалась преданность Галактической Республике и её руководителю — Верховному Канцлеру Палпатину.]]


		local DLabel = vgui.Create( "DLabel", DPanel )
		DLabel:SetSize( 600, 300 )
		DLabel:SetPos( 10, 50 )
		DLabel:SetFont('font_notify')
		DLabel:SetText( textWrap(text, 'font_notify', 600) )
		DLabel:SetContentAlignment( 7 )
		DLabel:SetAutoStretchVertical( true )


		-- local NumberWrang = vgui.Create("DTextEntry",DPanel)
		-- NumberWrang:SetSize(100, 30)
		-- NumberWrang:SetPos(10+120+2,10)
		-- NumberWrang:SetPaintBorderEnabled( true )
		-- NumberWrang:SetFont('font_base_22')
		-- NumberWrang:SetText(math.random(0,9)..math.random(0,9)..math.random(0,9)..math.random(0,9))

		-- NumberWrang.OnChange = function( self )
		--     local text = tonumber(self:GetValue())
		--     if not isnumber(text) or text > 9999 or text < 1000 then
		--         self:SetText(math.random(0,9)..math.random(0,9)..math.random(0,9)..math.random(0,9))
		--     end
		-- end

		-- NumberWrang.Paint = function( self, w, h )
		--     draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 5))
		--     self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
		-- end

		local NameEntry = vgui.Create("DTextEntry",DPanel)
		NameEntry:SetSize(DPanel:GetWide()-20, 30)
		NameEntry:SetPos(160+10+4,10)
		NameEntry:SetPaintBorderEnabled( true )
		NameEntry:SetFont('font_base_22')
		NameEntry:SetAllowNonAsciiCharacters( false )
		NameEntry:SetText(table.Random(names.first))
		NameEntry.Paint = function( self, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 5))
			self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
		end

		local RandomID = vgui.Create("DButton",DPanel)
		RandomID:SetSize(160, 30)
		RandomID:SetPos(10,10)
		RandomID:SetText('')
		RandomID.Paint = function( self, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
			-- self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
			draw.SimpleText('Случайное имя', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
		end
		RandomID.DoClick = function( self )
			-- NumberWrang:SetText(math.random(0,9)..math.random(0,9)..math.random(0,9)..math.random(0,9))
			NameEntry:SetText(table.Random(names.first))
		end

		local Save = vgui.Create("DButton",DPanel)
		Save:SetSize(120, 30)
		local _, y_lab = DLabel:GetPos()
		Save:SetPos(10,y_lab+DLabel:GetTall()/2)
		Save:SetText('')

		Save.Paint = function( self, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
			-- self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
			draw.SimpleText('Сохранить', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
		end

		local Close = vgui.Create("DButton",DPanel)
		Close:SetSize(100, 30)
		local _, y_lab = DLabel:GetPos()
		Close:SetPos(10+120+2,y_lab+DLabel:GetTall()/2)
		Close:SetText('')

		Close.Paint = function( self, w, h )
			-- mysound:Stop()
			draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
			-- self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
			draw.SimpleText('Отмена', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
		end

		Close.DoClick = function(self)
			OpenCharacterMenu({characters = characters})
			Menu:Remove()
		end

		local select_team_group = false
		if WHITELIST_GROUP_TEAMS[LocalPlayer():GetUserGroup()] then
			local group_teams = table.GetKeys( WHITELIST_GROUP_TEAMS[LocalPlayer():GetUserGroup()] )
			select_team_group = first_team

			local DLabelGroup = vgui.Create( "DLabel", DPanel )
			DLabelGroup:SetSize( 600, 20 )
			DLabelGroup:SetPos( 10, y_lab+DLabel:GetTall()/2+Save:GetTall()+6 )
			DLabelGroup:SetFont('font_notify')
			DLabelGroup:SetText( string.format('Вам доступна группа "%s". Вы можете выбрать начальную профессию:', LocalPlayer():GetUserGroup()) )
			DLabelGroup:SetContentAlignment( 7 )
			DLabelGroup:SetAutoStretchVertical( true )

			local JobGroup = vgui.Create( "DComboBox", DPanel )
			JobGroup:SetSize( 200, 26 )
			JobGroup:SetPos( 10, y_lab+DLabel:GetTall()/2+Save:GetTall()+DLabelGroup:GetTall()+12 )

			JobGroup:SetTextColor(Color(255, 255, 255, 255))

			local choices = {}
			for i, job in pairs(group_teams) do
				JobGroup:AddChoice( team.GetName(job) )
				table.insert(choices, i, job)
			end

			local first_team = group_teams[1]
			JobGroup:SetValue(team.GetName(first_team))

			JobGroup.OnSelect = function( panel, index, value )
				select_team_group = choices[index]
			end

			JobGroup.Paint = function( self, w, h )
				draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 255))
				self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
			end
			JobGroup.DoClick = function( self )
				if ( self:IsMenuOpen() ) then
					return self:CloseMenu()
				end

				self:OpenMenu()

				self.Menu.Paint = function( panel, w, h ) end

				for i = 1, self.Menu:ChildCount() do
					local pnl = self.Menu:GetChild(i)
					pnl.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, h,Color(52, 73, 94, 255))
					end
					pnl:SetTextColor(color_white)
				end
			end
			JobGroup.DropButton:SetText('')
			JobGroup.DropButton.Paint = function( panel, w, h ) end
		end

		Save.DoClick = function(self)
			netstream.Start("NewPlayerCharacter", {
				name = NameEntry:GetValue(),
				start_team = select_team_group
			})
			Menu:Remove()
			if bgsound then
			  bgsound:Stop()
			end
		end
	end

	if max_characters > #characters then
		local AddChar = vgui.Create('DButton')
		AddChar:SetWide(300)
		AddChar:SetText('')
		AddChar.Paint = function( self, w, h )
			local a = self:IsHovered() and 10 or 5
			draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, a))
			draw.SimpleText('+', "font_base_84_normal", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
		end

		AddChar.DoClick = function(self)
			OpenNewCharacterMenu(characters)
			CreationMenu:Remove()
		end

		DHorizontalScroller:AddPanel( AddChar )
	end

	-- end

	-- CreationMenu:MakePopup()

	-- local DScrollPanel = vgui.Create( "DScrollPanel", DPanel )
	-- DScrollPanel:SetPos(4,2)
	-- DScrollPanel:SetSize(panel_wide - right_side_wide - 5,DPanel:GetTall())

	-- DScrollPanel.sbar = DScrollPanel:GetVBar()
	-- DScrollPanel.sbar.Paint = function( self, w, h ) end

	-- DScrollPanel.sbar:SetWide(6)

	-- function DScrollPanel.sbar:PerformLayout()
	-- 	local Wide = self:GetWide()
	-- 	local Scroll = self:GetScroll() / self.CanvasSize
	-- 	local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( Wide * 2 ) ), 10 )
	-- 	local Track = self:GetTall() - BarSize
	-- 	Track = Track + 1

	-- 	Scroll = Scroll * Track

	-- 	self.btnGrip:SetPos( 0, Scroll )
	-- 	self.btnGrip:SetSize( Wide, BarSize )

	-- 	self.btnUp:SetPos( 0, 0, 0, 0 )
	-- 	self.btnUp:SetSize( 0, 0 )

	-- 	self.btnDown:SetPos( 0, self:GetTall() - 0, 0, 0 )
	-- 	self.btnDown:SetSize( 0, 0 )
	-- end
	-- DScrollPanel.sbar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(130, 130, 130, 190)) end

	-- local List = vgui.Create( "DIconLayout", DScrollPanel )
	-- List:Dock( FILL )
	-- List:SetSpaceY( 5 )
	-- List:SetSpaceX( 5 )

	-- local DComboBox = vgui.Create( "DComboBox", DPanel )
	-- DComboBox:SetSize( 140, 26 )
	-- DComboBox:SetPos( DPanel:GetWide() - DComboBox:GetWide() - 4, 4 )
	-- DComboBox:SetValue( "Gender" )

	-- local Choices = {
	-- 	{ text = GENDER_STRING[GENDER_MALE], gender = GENDER_MALE, icon = 'metahub/masculine.png' },
	-- 	{ text = GENDER_STRING[GENDER_FEMALE], gender = GENDER_FEMALE, icon = 'metahub/femenine.png' }
	-- }

	-- for _, v in pairs(Choices) do
	-- 	DComboBox:AddChoice( v.text )
	-- end

	-- DComboBox:ChooseOption( GENDER_STRING[DEFAULT_GENDER] )
	-- DComboBox:SetTextColor(Color(190, 190, 190, 190))

	-- do
	-- 	local tl, tr, bl, br

	-- 	DComboBox.Paint = function( self, w, h )
	-- 		if self.Menu ~= nil and IsValid(self.Menu) then
	-- 			tl, tr, bl, br = true, true, false, false
	-- 		else
	-- 			tl, tr, bl, br = true, true, true, true
	-- 		end
	-- 		draw.RoundedBoxEx( 4, 0, 0, w, h, Color(50, 50, 50, 255), tl, tr, bl, br )
	-- 	end

	-- 	function DComboBox:OpenMenu( pControlOpener )
	-- 		if ( pControlOpener && pControlOpener == self.TextEntry ) then
	-- 			return
	-- 		end

	-- 		if ( #self.Choices == 0 ) then return end

	-- 		if ( IsValid( self.Menu ) ) then
	-- 			self.Menu:Remove()
	-- 			self.Menu = nil
	-- 		end

	-- 		self.Menu = DermaMenu( false, self )

	-- 		local sorted = {}
	-- 		for k, v in pairs( Choices ) do
	-- 			local val = tostring( v.text ) --tonumber( v.text ) || v.text -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
	-- 			if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( "#" ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
	-- 			table.insert( sorted, { id = k, data = v.text, label = val, icon = v.icon } )
	-- 		end

	-- 		for k, v in SortedPairsByMemberValue( sorted, "label" ) do
	-- 			local DMenuPanel = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
	-- 			DMenuPanel:SetTextColor( Color(190, 190, 190, 190) )
	-- 			DMenuPanel.Icon = Material(v.icon)
	-- 			DMenuPanel.Paint = function( self, w, h )
	-- 				local row = k ~= #sorted and true or false

	-- 				draw.Icon(6,2,16,16,self.Icon,color_white)

	-- 				if DMenuPanel:IsHovered() then
	-- 					draw.RoundedBoxEx(4, 0, 0, w, h, Color(255,255,255,20), false, false, row, row)
	-- 				end
	-- 			end
	-- 		end

	-- 		local x, y = self:LocalToScreen( 0, self:GetTall() )

	-- 		self.Menu:SetMinimumWidth( self:GetWide() )
	-- 		self.Menu:Open( x, y, false, self )
	-- 		self.Menu.Paint = function( self, w, h )
	-- 			draw.RoundedBoxEx( 4, 0, 0, w, h, Color(50, 50, 50, 255), false, false, true, true )
	-- 		end
	-- 	end
	-- end

	-- local NameEntry = vgui.Create("DTextEntry",DPanel)
	-- NameEntry:SetSize(170, 26)
	-- NameEntry:SetPos(DPanel:GetWide() - NameEntry:GetWide() - 4, 54)
	-- NameEntry:SetPaintBorderEnabled( true )
	-- NameEntry:SetAllowNonAsciiCharacters( false )
	-- NameEntry:SetText(table.Random(names.first))
	-- NameEntry.Paint = function( self, w, h )
	-- 	draw.RoundedBox(4,0,0,w,h,Color(240,240,240,255))
	-- 	self:DrawTextEntryText(Color(47,47,47,255), Color(0,165,255,255), Color(47,47,47,255))
	-- end

	-- local Model = vgui.Create('DModelPanel', DPanel)
	-- Model:SetSize( right_side_wide-10, right_side_wide-10 )
	-- Model:SetPos(DPanel:GetWide() - Model:GetWide() - 4, DPanel:GetTall() - Model:GetTall() - 38)
	-- local player_model = table.GetFirstKey(DEFAULT_MODELS[DEFAULT_GENDER])
	-- Model:SetModel( player_model )

	-- local eyepos = Model.Entity:GetBonePosition( Model.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	-- eyepos:Add( Vector( 0, 0, 0 ) )
	-- Model:SetLookAt( eyepos )
	-- Model:SetCamPos( eyepos-Vector( -18, 5, -2 ) )
	-- Model.Angles = Angle(0,0,0)
	-- Model:SetFOV(60)
	-- function Model:DragMousePress()
	-- 	self.PressX, self.PressY = gui.MousePos()
	-- 	self.Pressed = true
	-- end
	-- function Model:DragMouseRelease()
	-- 	self.Pressed = false
	-- end
	-- function Model:LayoutEntity( ent )
	-- 	if ( self.bAnimated ) then
	-- 		self:RunAnimation()
	-- 	end

	-- 	if ( self.Pressed ) then
	-- 		local mx, my = gui.MousePos()
	-- 		self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

	-- 		self.PressX, self.PressY = gui.MousePos()
	-- 	end

	-- 	ent:SetAngles( self.Angles )
	-- end



	-- local function DrawPlayerModels(gender)
	-- 	for model,_ in pairs(DEFAULT_MODELS[gender]) do
	-- 		local ListItem = List:Add( "ModelImage" )
	-- 		ListItem:SetSize( 64, 64 )
	-- 		ListItem:SetModel( model )

	-- 		table.insert(list_models, ListItem)

	-- 		local Button = vgui.Create( "DButton", ListItem )
	-- 		Button:SetSize( 64, 64 )
	-- 		Button:SetPos( 0, 0 )

	-- 		Button:SetText( '' )
	-- 		Button.DoClick = function()
	-- 			Model:SetModel(model)
	-- 			player_model = model
	-- 		end
	-- 		Button.Paint = function( self, w, h )
	-- 		end
	-- 	end
	-- end

	-- DrawPlayerModels(DEFAULT_GENDER)

	-- local Button = vgui.Create('DButton',DPanel)

	-- Button:SetSize(172,30)
	-- Button:SetPos(DPanel:GetWide() - Button:GetWide() - 4,DPanel:GetTall() - Button:GetTall() - 4)

	-- Button:SetText('')
	-- Button.Paint = function( self, w, h )
	-- 	draw.RoundedBox(4,0,0,w,h,Color(109,192,102,190))
	-- 	draw.SimpleText('Сохранить настройки','font_base_small',w/2,h/2,Color(255,255,255,255),1,1)
	-- end
	-- Button.DoClick = function()
	-- 	CreationMenu:Remove()

	-- 	netstream.Start('NewPlayerCharacter',{
	-- 		name = NameEntry:GetValue(),
	-- 		gender = Choices[DComboBox:GetSelectedID() or DEFAULT_GENDER].gender,
	-- 		model = player_model
	-- 	})

	-- 	CreationMenu:Remove()
	-- end

	-- DComboBox.OnSelect = function( self, gender )
	-- 	Model:SetModel(table.GetFirstKey(DEFAULT_MODELS[gender]))

	-- 	for _, panel in pairs(list_models) do
	-- 		panel:Remove()
	-- 	end

	-- 	DrawPlayerModels(gender)
	-- end
end

-- local i = 0

netstream.Hook("OpenInitCharacterMenu", function(characters)
  local Menu = vgui.Create("DFrame")
	Menu:SetPos(0,0)
	Menu:SetSize(ScrW(),ScrH())
	Menu:SetDraggable(false)
	Menu:SetTitle('')
	Menu:ShowCloseButton(false)
	Menu.Paint = function( self, w, h )
		local x, y = self:GetPos()
		draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), 2 )

		draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 250))
	end

	Menu:MakePopup()

	local NextButton = vgui.Create('DButton',Menu)
	NextButton:SetSize(160,30)
	NextButton:SetPos(Menu:GetWide()*.5 - NextButton:GetWide()*.5,Menu:GetTall()*.5 - NextButton:GetTall()*.5)
	NextButton:SetText('')
	NextButton.Paint = function( self, w, h )
		draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 195))
		draw.SimpleText('Продолжить', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
	end

	NextButton.DoClick = function(self)
		OpenCharacterMenu(characters)
		Menu:Remove()
	end

	surface.PlaySound('sup_sound/ui/background.mp3')
end)


netstream.Hook("OpenCharacterMenu", function(characters)
	surface.PlaySound('sup_sound/ui/background.mp3')
	OpenCharacterMenu(characters)
end)
-- local function get_current_pos()
-- 	local map = string.lower(game.GetMap())
-- 	local result = LOADING_CAM_POS[map] and LOADING_CAM_POS[map] or LOADING_CAM_POS['Default']
-- 	return result.pos, result.ang
-- end

-- hook.Add("CalcView", "LoadingScreen_CalcView", function(ply, origin, angles, fov, znear, zfar)
-- 	if not ply:GetNVar('is_load_char') then

-- 		origin, angles = get_current_pos()
-- 		return { origin = origin, angles = angles, fov = fov, znear = znear, zfar = zfar }
-- 	end
-- end)

-- hook.Add("HUDPaint", "LoadingScreen_HUDPaint", function()
-- 	local ply = LocalPlayer()
-- 	local scr_w, scr_h = ScrW(), ScrH()

-- 	if not ply:GetNVar('is_load_char') and not IsValid(CreationMenu) then
-- 		draw.DrawBlur( 0, 0, ScrW(), ScrH(), 2 )
-- 		draw.ShadowSimpleText("Загрузка данных...", "font_base_45", scr_w/2, scr_h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
-- 	end
-- end)
