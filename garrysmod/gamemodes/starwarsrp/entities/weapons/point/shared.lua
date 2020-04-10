if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end

SWEP.Category 				= "RP Weapons" 

SWEP.Base = "weapon_base"

SWEP.Spawnable     			= true
SWEP.AdminSpawnable  		= true

SWEP.UseHands				= true
SWEP.ViewModel				= "models/milrp/weapons/antitank/v_mine.mdl"
SWEP.WorldModel				= "models/milrp/weapons/antitank/w_mine.mdl"

SWEP.HoldType				= "slam"
SWEP.HoldTypeRaised			= "camera"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo 		= false
SWEP.Secondary.Automatic 	= true

SWEP.Zoom_Interval			= 2
SWEP.Zoom_Current			= 0
SWEP.Zoom_Min				= 2
SWEP.Zoom_Max				= 8
SWEP.Zoom_Delta				= 0.2
SWEP.Zoom_Zooming			= false
SWEP.Zoom_InZoom			= false

SWEP.Zoom_TransitionTime	= nil

SWEP.Zoom_Sound_In				= "weapons/sniper/sniper_zoomin.wav"
SWEP.Zoom_Sound_Out				= "weapons/sniper/sniper_zoomout.wav"
SWEP.Zoom_Sound_Cloth			= "foley/alyx_hug_eli.wav"

SWEP.HasNightVision			= false

SWEP.WalkSpeed				= 250
SWEP.RunSpeed				= 500

SWEP.WalkSpeedMod			= 250

SWEP.SpeedMult				= 0.6

SWEP.UUID					= nil

function SWEP:PrimaryAttack()
	if ( self.Zoom_Interval == 0 or self.Zoom_Min == self.Zoom_Max) then return end
	if ( self.Owner:KeyDown( IN_USE ) and self.HasNightVision ) then
		if ( self.HasNightVision ) then
			if self:GetNWBool( "nvon", true ) then 
				self:SetNWBool( "nvon", false )
				self:EmitSound( "items/flashlight1.wav", 60, 100 )
			else
				self:SetNWBool( "nvon", true )
				self:EmitSound( "items/flashlight1.wav", 60, 120 )
			end
		end
	elseif (self.Zoom_InZoom) then
		if (self.Zoom_Current >= self.Zoom_Max) then
			sound.Play( self.Zoom_Sound_Out, self.Owner:GetPos() )
			self.Zoom_Current = self.Zoom_Min
			self.Owner:SetFOV(90/self.Zoom_Current, self.Zoom_Delta)
		elseif ((self.Zoom_Current+self.Zoom_Interval)>= self.Zoom_Max) then
			sound.Play( self.Zoom_Sound_In, self.Owner:GetPos() )
			self.Zoom_Current = self.Zoom_Max
			self.Owner:SetFOV(90/self.Zoom_Current, self.Zoom_Delta)
		else
			sound.Play( self.Zoom_Sound_In, self.Owner:GetPos() )
			self.Zoom_Current = self.Zoom_Current + self.Zoom_Interval
			self.Owner:SetFOV(90/self.Zoom_Current, self.Zoom_Delta)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	self.WalkSpeed = self.Owner:GetWalkSpeed()
	self.RunSpeed = self.Owner:GetRunSpeed()
	self.WalkSpeedMod = self.WalkSpeed * self.SpeedMult
	self.Zoom_Current = self.Zoom_Min
	self.Zoom_InZoom = false
	self.Zoom_Zooming = false
	self:SetHoldType( self.HoldType )
	self:Idle()
end

function SWEP:Initialize()
	self.UUID = tostring(self:EntIndex())
	self.Zoom_Current = self.Zoom_Interval
	self:SetHoldType( self.HoldType )
end

function SWEP:Holster()
	if self.Zoom_Zooming then return false end
		if (self.Zoom_InZoom) then
			self.Owner:SetFOV( 0, self.Zoom_Delta )
		end
		self.Zoom_InZoom = false
		self.Zoom_Current = self.Zoom_Min
		self.Owner:SetDSP( 0, false )
		self.Owner:DrawViewModel( true, 0 )
		self.Owner:SetRunSpeed(self.RunSpeed)
		self.Owner:SetWalkSpeed(self.WalkSpeed)
	self:StopIdle()
	return true
end

-- function SWEP:Think()

-- 	if !(GetConVar("rpw_binoculars_hold"):GetBool()) then
	
-- 		if self.Owner:KeyPressed( IN_ATTACK2 ) then
-- 			if !(self.Zoom_Zooming) then
-- 				if (self.Zoom_InZoom) then
-- 					self:EndZoom()
-- 				else
-- 					self:SetZoom()
-- 				end
-- 			end
-- 		end
	
-- 	else

-- 		if self.Owner:KeyPressed( IN_ATTACK2 ) then
-- 			if !(self.Zoom_Zooming) then
-- 				self:SetZoom()
-- 			end
-- 		end
		
-- 		if self.Owner:KeyReleased( IN_ATTACK2 ) then
-- 			if !(self.Zoom_Zooming) then
-- 				self:EndZoom()
-- 			end
-- 		end
		
-- 	end
	
-- 	if ( self.Owner:KeyReleased( IN_ATTACK ) || ( !self.Owner:KeyDown( IN_ATTACK ) && self.Sound ) ) then		
-- 		self:Idle()
-- 	end
	
-- 	if ( self.Owner:KeyPressed( IN_USE ) and ( self.Zoom_InZoom ) ) then
-- 		timer.Simple( 0.01, function()
-- 			if !(self:IsValid()) then return end
-- 			self.Owner:DrawViewModel( false, 0 )
-- 		end)
-- 	end
	
-- end

-- function SWEP:SetZoom()
-- 	self.Zoom_Zooming = true
-- 	self:StopIdle()
	
-- 	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
-- 	self:EmitSound(self.Zoom_Sound_Cloth, 50, 110)
-- 	self.Owner:SetRunSpeed(self.WalkSpeedMod)
-- 	self.Owner:SetWalkSpeed(self.WalkSpeedMod)
-- 	self:SetHoldType( self.HoldTypeRaised )
-- 	timer.Simple(self:SequenceDuration()*4/5, function()
-- 		if !self:IsValid() then return end
-- 		self.Zoom_InZoom = true
-- 		self.Zoom_Current = self.Zoom_Interval
-- 		self.Owner:DrawViewModel( false, 0 )
-- 		self.Owner:SetFOV( 90/self.Zoom_Current, self.Zoom_Delta )
-- 		self.Owner:SetDSP( 30, false )
-- 	end)
-- 	timer.Simple(self:SequenceDuration(), function()
-- 		if !self:IsValid() then return end
-- 		self.Zoom_Zooming = false
-- 		if (GetConVar("rpw_binoculars_hold"):GetBool()) then
-- 			if !self.Owner:KeyDown( IN_ATTACK2 ) then
-- 				self:EndZoom()
-- 			end
-- 		end
-- 	end)
-- end

-- function SWEP:EndZoom()
-- 	self.Zoom_Zooming = true
	
-- 	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
-- 	self:EmitSound(self.Zoom_Sound_Cloth, 50, 90)
-- 	self.Owner:SetRunSpeed(self.RunSpeed)
-- 	self.Owner:SetWalkSpeed(self.WalkSpeed)
-- 	self:SetHoldType( self.HoldType )
-- 	timer.Simple(self:SequenceDuration()*1/5, function()
-- 		if !self:IsValid() then return end
-- 		self.Zoom_InZoom = false
-- 		self.Zoom_Current = self.Zoom_Interval
-- 		self.Owner:DrawViewModel( true, 0 )
-- 		self.Owner:SetFOV( 0, self.Zoom_Delta )
-- 		self.Owner:SetDSP( 0, false )
-- 	end)
-- 	timer.Simple(self:SequenceDuration(), function()
-- 		if !self:IsValid() then return end
-- 		self.Zoom_Zooming = false
-- 		self:Idle()
-- 		if (GetConVar("rpw_binoculars_hold"):GetBool()) then
-- 			if self.Owner:KeyDown( IN_ATTACK2 ) then
-- 				self:SetZoom()
-- 			end
-- 		end
-- 	end)
-- end

function SWEP:DoIdleAnimation()
	self:SendWeaponAnim( ACT_VM_IDLE )
end

function SWEP:DoIdle()
	self:DoIdleAnimation()

	timer.Adjust( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 0, function()
		if ( !IsValid( self ) ) then timer.Destroy( "weapon_idle" .. self:EntIndex() ) return end

		self:DoIdleAnimation()
	end )
end

function SWEP:StopIdle()
	timer.Destroy( "weapon_idle" .. self:EntIndex() )
end

function SWEP:Idle()
	if ( CLIENT || !IsValid( self.Owner ) ) then return end
	timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration() - 0.2, 1, function()
		if ( !IsValid( self ) ) then return end
		self:DoIdle()
	end )
end

local point_menu = point_menu or false
if CLIENT then
    meta.help_points = meta.help_points or {}
    function SWEP:PrimaryAttack()
        if point_menu then
            point_menu:Remove()
        end

        point_menu = vgui.Create('DFrame')
        point_menu:SetSize(210,160)
        point_menu:SetPos(ScrW()*.5-point_menu:GetWide()*.5, ScrH()*.5-point_menu:GetTall()*.5)
        point_menu:MakePopup()
        point_menu:SetTitle( 'Помощь в координации' )
        -- point_menu.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(64, 105, 153, 250))
        -- end
        point_menu:ShowCloseButton( true )


        -- local Close = vgui.Create( "DButton", point_menu )
        -- Close:SetSize( 30, 30 )
        -- Close:SetText('')
        -- Close:SetPos( point_menu:GetWide()-Close:GetWide(), 0 )
        -- -- Close.Paint = function( self, w, h )
        -- --     draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
        -- --     draw.SimpleText('X', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
        -- -- end

        -- Close.DoClick = function( self )
        --     point_menu:Remove()
        -- end

        local DComboBox = vgui.Create( "DComboBox", point_menu )
        DComboBox:SetPos( 5, 35 )
        DComboBox:SetSize( 200, 20 )
        DComboBox:SetValue( table.GetFirstKey( HELPPOINTS_TYPES ) )

        -- DComboBox.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 255))
        --     self:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
        -- end
        DComboBox.DoClick = function( self )
            if ( self:IsMenuOpen() ) then
                return self:CloseMenu()
            end

            self:OpenMenu()

            -- self.Menu.Paint = function( panel, w, h ) end

            -- for k, v in pairs(self.Menu:GetChildrens()) do
            for i = 1, self.Menu:ChildCount() do
                local pnl = self.Menu:GetChild(i)
                pnl.Paint = function( self, w, h )
                    draw.RoundedBox(0, 0, 0, w, h,Color(255, 255, 255, 255))
                    if self:IsHovered() then
                        draw.RoundedBox(0, 0, 0, w, h,Color(230, 230, 230, 255))
                    end
                end
                -- pnl:SetFont('font_base_22')
                pnl:SetTextColor(Color(0,0,0,200))
            end
        end
        DComboBox.DropButton:SetText('')
        -- DComboBox.DropButton.Paint = function( panel, w, h ) end

        for k, v in pairs(HELPPOINTS_TYPES) do
            DComboBox:AddChoice( k )
        end

        local DTextEntry = vgui.Create( "DTextEntry", point_menu )
        DTextEntry:SetPos( 5, 57 )
        DTextEntry:SetSize( 200, 20 )
        DTextEntry:SetPlaceholderColor( Color(0, 0, 0) )
        DTextEntry:SetPlaceholderText( 'Название' )

        -- DTextEntry.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 255))
        --     self:DrawTextEntryText(Color(17,17,17,255), Color(110,192,214,255), Color(17,17,17,255))
        -- end

        local DTextEntry2 = vgui.Create( "DTextEntry", point_menu )
        DTextEntry2:SetPos( 5, 79 )
        DTextEntry2:SetSize( 200, 20 )
        DTextEntry2:SetPlaceholderText( 'Текст' )

        -- DTextEntry2.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 255))
        --     self:DrawTextEntryText(Color(17,17,17,255), Color(110,192,214,255), Color(17,17,17,255))
        -- end

        local Time = vgui.Create( "DNumberWang", point_menu )
        Time:SetPos( 5, 79+22 )
        Time:SetSize( 200, 20 )
        Time:SetMinMax(10, 360)
        Time:SetValue(120)

        -- Time.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(255, 255, 255, 255))
        --     self:DrawTextEntryText(Color(17,17,17,255), Color(110,192,214,255), Color(17,17,17,255))
        -- end

        local DermaButton = vgui.Create( "DButton", point_menu )
        DermaButton:SetText( "Сохранить" )
        DermaButton:SetPos( 5, 101+23 )
        DermaButton:SetSize( 200, 30 )
        DermaButton.DoClick = function()
            netstream.Start('CreateHelpPoint', { type = DComboBox:GetValue(), title = DTextEntry2:GetValue(), text = DTextEntry:GetValue(), time = tonumber(Time:GetValue()) })

            point_menu:Remove()
        end
        -- DermaButton.Paint = function( self, w, h )
        --     draw.RoundedBox(0, 0, 0, w, h, Color(156,132,239))
        --     draw.SimpleText('Сохранить', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
        -- end
    end
end