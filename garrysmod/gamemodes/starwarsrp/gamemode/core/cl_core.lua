local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudDamageIndicator = true,
	CHudHintDisplay = true,
	CHudZoom = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

	-- Don't return anything here, it may break other addons that rely on this hook.
end )

function draw.Icon( x, y, w, h, Mat, tblColor )
	surface.SetMaterial(Mat)
	surface.SetDrawColor(tblColor or Color(255,255,255,255))
	surface.DrawTexturedRect(x, y, w, h)
end

function GM:SpawnMenuOpen()
    if not LocalPlayer():IsAdmin() then
        return
    end

	-- GAMEMODE:SuppressHint( "OpeningMenu" )
	-- GAMEMODE:AddHint( "OpeningContext", 20 )

	return true

end


hook.Add( "ChatText", "hide_joinleave", function( index, name, text, typ )
	if ( typ == "joinleave" ) then return true end
end )
