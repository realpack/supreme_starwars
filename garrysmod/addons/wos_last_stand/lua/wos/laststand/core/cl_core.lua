--[[-------------------------------------------------------------------
	The Last Stand Client Core:
		Core files in client form
			Powered by
						  _ _ _    ___  ____
				__      _(_) | |_ / _ \/ ___|
				\ \ /\ / / | | __| | | \___ \
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/

 _____         _                 _             _
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/
----------------------------- Copyright 2018 ]]--[[

	Lua Developer: King David
	Contact: www.wiltostech.com
]]--

local w,h = ScrW(), ScrH()

wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}

wOS.LastStand.InLastStand = wOS.LastStand.InLastStand or {}

net.Receive( "wOS.LastStand.ToggleLS", function()

	local toggle = net.ReadBool()
	local ent = net.ReadEntity()

	wOS.LastStand.InLastStand[ ent ] = toggle

end )

net.Receive( "wOS.LastStand.SendLastCache", function()

	local num = net.ReadInt( 32 )

	for i=1, num do
		local id = net.ReadEntity()
		if wOS.LastStand.InLastStand[ id ] then continue end
		wOS.LastStand.InLastStand[ id ] = net.ReadBool()
	end

end )

hook.Add( "CalcView", "wOS.LastStand.FirstPerson", function( ply, pos, ang )

	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	if !wOS.LastStand.InLastStand[ ply ] and !ply.WOS_LastStandIsReviving then return end

	local angs = ang
	local eyes = ply:GetAttachment( ply:LookupAttachment( "eyes" ) );
	angs = eyes.Ang
	local forward = ang:Forward()
	local up = ang:Up()

	return {
		origin = eyes.Pos + ( up + forward )*1.5,
		angles = angs,
		fov = GetConVar( "fov_desired" ):GetInt(),
		drawviewer = true
	}

end )

hook.Add( "HUDPaint", "wOS.LastStand.ProgressBar", function()
	local ply = LocalPlayer()
	if not IsValid( ply.WOS_LastStandChild ) or not ply.WOS_LastStandHeld or not ply.WOS_LastStandIsReviving then return end

	local tim = wOS.LastStand.ReviveTime:GetFloat()
	local rat = math.Clamp( CurTime() - ply.WOS_LastStandHeld, 0, tim ) / tim

	local ww, hh = w*0.3, 20

	draw.RoundedBox( 0, w*0.5 - ww/2, h*0.6, ww, hh, Color( 0, 0, 0, 55 ) )
	draw.RoundedBox( 0, w*0.5 - ww/2, h*0.6, ww*rat, hh, Color( 0, 125, 255, 155 ) )
	local text = ( rat >= 1 and "Отпусти кнопку!" ) or "Лечение " .. ply.WOS_LastStandChild:Nick() .. " ( " .. math.Round( rat * 100 ) .. "% )"
	draw.ShadowSimpleText( text, "font_base_18", w*0.5 - ww/2, h*0.6 - 3, color_white, 0, TEXT_ALIGN_BOTTOM )

end )

local lastuse = 0
hook.Add( "HUDPaint", "wOS.LastStand.KillYourselfHUD", function()
	local ply = LocalPlayer()
	if not wOS.LastStand.InLastStand[ LocalPlayer() ] then return end

	local tim = 3
	local rat = math.Clamp( lastuse, 0, tim ) / tim

	local ww, hh = w*0.3, 20
	draw.RoundedBox( 0, w*0.5 - ww/2, h*0.6, ww, hh, Color( 0, 0, 0, 55 ) )
	draw.RoundedBox( 0, w*0.5 - ww/2, h*0.6, ww*rat, hh, Color( 255, 255, 255, 155 ) )
	draw.ShadowSimpleText( "Зажми кнопку USE и закончи свои мучения ( " .. math.Round( rat * 100 ) .. "% )", "font_base_18", w*0.5 - ww/2, h*0.6 - 3, color_white, 0, TEXT_ALIGN_BOTTOM )

end )

hook.Add( "Think", "wOS.LastStand.KillYourself", function()
	if not wOS.LastStand.InLastStand[ LocalPlayer() ] then return end
	if LocalPlayer():KeyDown( IN_USE ) then
		if not lastuse then lastuse = 0 end
		lastuse = lastuse + FrameTime()
	else
		lastuse = 0
	end
	if not lastuse then return end
	if lastuse >= 3 then
		RunConsoleCommand( "kill" )
		lastuse = 0
	end
end )

hook.Add( "CreateMove", "wOS.LastStand.PreventAttack", function( cmd/* ply, mv, cmd*/ )
	if !wOS.LastStand.InLastStand[ LocalPlayer() ] and !LocalPlayer():GetNW2Bool( "wOS.LS.IsReviving", false ) then return end
	cmd:RemoveKey( IN_JUMP )
	if wOS.LastStand.CanShoot:GetBool() and !LocalPlayer():GetNW2Bool( "wOS.LS.IsReviving", false ) then return end
	cmd:RemoveKey( IN_ATTACK )
	cmd:RemoveKey( IN_ATTACK2 )
end )
