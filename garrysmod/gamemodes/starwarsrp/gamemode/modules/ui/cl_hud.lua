surface.CreateFont ("Playernik1", {      

        size = 84,

        weight = 800,

        antialias = true,

        additive = false,		

        font = "Tahoma"})

surface.CreateFont ("Playernik1.1", {      

        size = 84,

        weight = 800,

        antialias = true,

		additive = false,

		blursize = 10,   		

        font = "Tahoma"})

local scr_w, scr_h = ScrW(), ScrH()
local show_hud = true

function draw.Arc( center, startang, endang, radius, roughness, thickness, color )
	draw.NoTexture()
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	local segs, p = roughness, {}
	for i2 = 0, segs do
		p[i2] = -i2 / segs * (math.pi/180) * endang - (startang/57.3)
	end
	for i2 = 1, segs do
		if endang <= 90 then
			segs = segs/2
		elseif endang <= 180 then
			segs = segs/4
		elseif endang <= 270 then
			segs = segs/6
		else
			segs = segs
		end
		local r1, r2 = radius, math.max(radius - thickness, 0)
		local v1, v2 = p[i2 - 1], p[i2]
		local c1, c2 = math.cos( v1 ), math.cos( v2 )
		local s1, s2 = math.sin( v1 ), math.sin( v2 )
		surface.DrawPoly{
			{ x = center.x + c1 * r2, y = center.y - s1 * r2 },
			{ x = center.x + c1 * r1, y = center.y - s1 * r1 },
			{ x = center.x + c2 * r1, y = center.y - s2 * r1 },
			{ x = center.x + c2 * r2, y = center.y - s2 * r2 },
		}
	end
end

local oy = 0
local drawplayers = {}
local frames = 0
local view_fov = 0
local fadedist = 512

local scale = 0.05

hook.Add("RenderScene", "NameTags", function(vector, ang, fov)
	frames = FrameNumber()
	view_fov = fov
end)

function draw.SimpleTagText(str, font, color)
	surface.SetFont(font)

	local w, h = surface.GetTextSize(str)
	oy = oy - h + 10

	-- draw.ShadowSimpleText(str, font.."_s", 0, oy, Color(0,0,200), TEXT_ALIGN_CENTER)
	draw.ShadowSimpleText(str, font, 0, oy, color, TEXT_ALIGN_CENTER)
end

local voice_icon = Material('sup_ui/metaui/talking.vmt', 'noclamp smooth')
local time_icon = Material('sup_ui/metaui/time.png', 'noclamp smooth')
hook.Add("PostDrawTranslucentRenderables", "NameTags", function(depth, sky)
	if depth or sky then return end

	local ang = Angle(0, EyeAngles().y - 90, 90)
	local eyepos = EyePos()

	local counter = 0
	local cfn = frames-1
	for pPlayer, frames in pairs(drawplayers) do
		if not pPlayer:IsValid() then
			drawplayers[pPlayer] = nil
			continue
		end

		local rank = pPlayer:GetNWString('meta_rank')

		if pPlayer.Alive and not pPlayer:Alive() then continue end
		if cfn ~= frames and (cfn+1) ~= frames then continue end
		if LocalPlayer():GetEyeTrace().Entity ~= pPlayer then
			continue
		end

		local eye

		local boneId = pPlayer:LookupBone("ValveBiped.Bip01_Head1")
		if boneId then
			eye = (pPlayer:GetBonePosition(boneId))
		else
			eye = pPlayer:GetPos()
		end

		-- if pPlayer.InVehicle and pPlayer:InVehicle() then
			-- -- eye.z = math.max(eye.z + 9, getroof(pPlayer:GetVehicle()) + 5)
		-- else
			eye.z = eye.z - 6
			
		-- end

		if cfn == frames and (eyepos:Distance(eye) > (fadedist * 100 / view_fov) ) then continue end

		counter = counter + 1
		oy = 0

		-- local rpid = pPlayer:GetRPID()

		cam.Start3D2D(eye, ang, scale)
			if pPlayer:IsPlayer() then
				oy = oy - 20

				-- if rpid then
				-- 	for i = 1, (4-#tostring(rpid)) do rpid = '0'..rpid end
				-- else
				-- 	rpid = ''
				-- end

				-- if tostring(rpid) == '0000' then
				-- 	rpid = ''
				-- end

				-- local line1 = rpid..' '..pPlayer:GetNWString( "rpname" )
				-- if not LocalPlayer():IsAdmin() then
				-- 	if HIDE_NICKS_RANKS[rank] then
				-- 		line1 = rpid
				-- 	else
				-- 		line1 = pPlayer:GetNWString( "rpname" )
				-- 	end
				-- end

				-- local w1, _ = surface.GetTextSize(line1)

				if LocalPlayer():GetEyeTrace().Entity == pPlayer then
				    -- draw.ShadowSimpleText(pPlayer:GetNWString('meta_rank'), 'font_base_normal', 0, oy-40, Color(130,130,130,255), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				    draw.ShadowSimpleText(math.Round(pPlayer:Health())..'%', 'font_base_normal', 430, oy+10, Color(214,45,32,255), 0, TEXT_ALIGN_BOTTOM)
				    draw.ShadowSimpleText(math.Round(pPlayer:Armor())..'%', 'font_base_normal', 430, oy+10, Color(10, 230, 255,255), 2, TEXT_ALIGN_BOTTOM)
				    oy = oy - 110
				end

				local w2 = 0
				if pPlayer:IsSpeaking() then
					draw.Icon( 300, -6+oy, 60, 60, voice_icon )
					w2 = w2 + 68
					-- draw.Icon( -32, -32-160+oy, 64, 64, voice_icon, color_orange )
				end

				-- draw.ShadowSimpleText(pPlayer:Name(), 'font_base_84', 300, oy, team.GetColor(pPlayer:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.ShadowSimpleText(pPlayer:Name(), 'Playernik1', 300, oy, team.GetColor(pPlayer:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.ShadowSimpleText(pPlayer:Name(), 'Playernik1.1', 300, oy, team.GetColor(pPlayer:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.ShadowSimpleText(rank, 'font_base_54', w2+300, oy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				local features = pPlayer:GetNVar('meta_features')
				if istable(features) then
					for i, b in pairs(features) do
						if b then
							-- draw.ShadowSimpleText(FEATURES_TO_NORMAL[i].name, 'font_base_54', oy+430, oy+120, Color(190,190,190,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						end
					end
				end
				-- PrintTable(pPlayer:GetNVar('meta_features'))

				-- draw.ShadowSimpleText(team.GetName(pPlayer:Team()), 'font_base_normal', 0, oy-70, team.GetColor(pPlayer:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

				-- draw.SimpleTagText(line1, "font_base_big", color_white)
				-- draw.SimpleTagText(team.GetName(pPlayer:Team()), "font_base_normal", team.GetColor(pPlayer:Team()))
                if pPlayer:IsArrested() and pPlayer:GetNVar('ArrestedTime') then
                    local strtime = math.ceil(pPlayer:GetNVar('ArrestedTime') - CurTime())

                    surface.SetFont('font_base_84')
                    local wt, _ = surface.GetTextSize(strtime)
                    -- draw.RoundedBox(10, wt*-.5-64-4, -70-32-30f0+oy-4, wt+64+8, 64+8, Color(255,64,64,230))
                    draw.Icon( wt*-.5-64+2, -70-32-300+oy+2, 64, 64, time_icon, Color(0,0,0,90) )
                    draw.Icon( wt*-.5-64, -70-32-300+oy, 64, 64, time_icon )
                    draw.ShadowSimpleText(strtime, 'font_base_84', 0, -32-300+oy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

                end
				-- draw.SimpleTagText(line1, "font_base_big", color_white)
				-- draw.SimpleTagText(team.GetName(pPlayer:Team()), "font_base_normal", team.GetColor(pPlayer:Team()))
			end
		cam.End3D2D()
	end
end)

hook.Add("UpdateAnimation", "NameTags", function(pPlayer)
	-- if not (pPlayer ~= LocalPlayer() and not pPlayer:ShouldDrawLocalPlayer()) then return end
	if pPlayer == LocalPlayer() then return end
	drawplayers[pPlayer] = frames
end)

hook.Add("Think", "HandlerContextMenu", function()
	show_hud = not input.IsKeyDown( KEY_C )
end)

-- local standing = Material('metahub/stamina/standing.png', 'noclamp smooth')
-- local walking = Material('metahub/stamina/walking.png', 'noclamp smooth')
-- local run = Material('metahub/stamina/run.png', 'noclamp smooth')
-- local nostamina = Material('metahub/stamina/nostamina.png', 'noclamp smooth')
-- local stomach = Material('metahub/stamina/stomach.png', 'noclamp smooth')

-- if CLIENT then
-- 	hook.Add('HUDPaint', 'Stamina_HUDPaint', function()
-- 		local mat_stamina = standing

--         if LocalPlayer():KeyDown( IN_SPEED ) then
-- 			mat_stamina = run
-- 		elseif LocalPlayer():KeyDown( IN_FORWARD ) or LocalPlayer():KeyDown( IN_BACK ) then
-- 			mat_stamina = walking
-- 		end

-- 		draw.Icon(10,20,48,48,mat_stamina)
-- 	end)
-- end

local function hideElements(name)
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudSuitPower" or name == "CHudAmmo" or name == "CTargetID" or name == "CHudSecondaryAmmo" then
		return false
	end
end
hook.Add("HUDShouldDraw", "hideElements", hideElements)

function GM:HUDDrawTargetID()
	return false
end

local elements = {
	{ x = -450, letter = "", color = Color(29,161,242) },
	{ x = -360, letter = "С", color = Color(29,161,242) },
	{ x = -315, letter = "СЗ", color = Color(29,161,242) },
	{ x = -270, letter = "З", color = Color(29,161,242) },
	{ x = -225, letter = "ЮЗ", color = Color(29,161,242) },
	{ x = -180, letter = "Юг", color = Color(29,161,242) },
	{ x = -135, letter = "ЮЗ", color = Color(29,161,242) },
	{ x = -90, letter = "З", color = Color(29,161,242) },
	{ x = -45, letter = "СЗ", color = Color(29,161,242) },

	{ x = 0, letter = "С", color = Color(252,175,23) },

	{ x = 45, letter = "СВ", color = Color(29,161,242) },
	{ x = 90, letter = "В", color = Color(29,161,242) },
	{ x = 135, letter = "ЮВ", color = Color(29,161,242) },
	{ x = 180, letter = "Юг", color = Color(29,161,242) },
	{ x = 225, letter = "ЮЗ", color = Color(29,161,242) },
	{ x = 270, letter = "З", color = Color(29,161,242) },
	{ x = 315, letter = "СЗ", color = Color(29,161,242) },
	{ x = 360, letter = "С", color = Color(29,161,242) },
	{ x = 450, letter = "З", color = Color(29,161,242) },

	{ x = 15 },
	{ x = 30 },
	{ x = 60 },
	{ x = 75 },
	-- { x = 90 },
	{ x = 105 },
	{ x = 120 },
	{ x = 150 },
	{ x = 165 },
	{ x = 195 },
	{ x = 210 },
	{ x = 240 },
	{ x = 255 },
	{ x = 285 },
	{ x = 300 },
	{ x = 330 },
	{ x = 345 },

	{ x = -15 },
	{ x = -30 },
	{ x = -60 },
	{ x = -75 },
	{ x = -105 },
	{ x = -120 },
	{ x = -150 },
	{ x = -165 },
	{ x = -195 },
	{ x = -210 },
	{ x = -240 },
	{ x = -255 },
	{ x = -285 },
	{ x = -300 },
	{ x = -330 },
	{ x = -345 },
}

local line_wide = 400

local stripes = surface.GetTextureID"vgui/alpha-back"
local starttime = 0
local lerp_health, lerp_armor
local y_defcon = 0

local event_parse = markup.Parse( GetGlobalString('EventTask') or '' )
netstream.Hook('OpenChangeEventTask', function( text )
	event_parse = markup.Parse( text or GetGlobalString('EventTask') )
end)

local surface_SetFont 		= surface.SetFont
local surface_GetTextSize 	= surface.GetTextSize
local string_Explode 		= string.Explode
local ipairs 				= ipairs

function string.Wrap(font, text, width)
	surface_SetFont(font)

	local sw = surface_GetTextSize(' ')
	local ret = {}

	local w = 0
	local s = ''

	local t = string_Explode('\n', text)
	for i = 1, #t do
		local t2 = string_Explode(' ', t[i], false)
		for i2 = 1, #t2 do
			local neww = surface_GetTextSize(t2[i2])

			if (w + neww >= width) then
				ret[#ret + 1] = s
				w = neww + sw
				s = t2[i2] .. ' '
			else
				s = s .. t2[i2] .. ' '
				w = w + neww + sw
			end
		end
		ret[#ret + 1] = s
		w = 0
		s = ''
	end

	if (s ~= '') then
		ret[#ret + 1] = s
	end

	return ret
end

local show_laws = CreateClientConVar("show_laws", "1")
local time = CurTime()
hook.Add("Think", "laws_think", function()
	if time > CurTime() then return end

	if input.IsKeyDown(KEY_F7) then
		show_laws:SetBool(not show_laws:GetBool())
		time = CurTime() + 0.3
	end
end)

local laws_box_wide = 500
local mat_defcon = Material('sup_ui/hud/lockdown.vmt', 'noclamp smooth')
local mat_laws = Material('transmission/rep_officer_orders_display.png', 'noclamp smooth')

hook.Add('HUDPaint','ewrgere',function()
	draw.SimpleText('discord.gg/AvuMqXy - общение на сервере', "font_base_18", 10, 10, Color( 224, 99, 27, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	-- draw.RoundedBox(0, ScrW()/2-line_wide/2, ScrH()-60, line_wide, 16, Color(0,0,0,90))

	if not LocalPlayer():Alive() then
		return
	end

	if Menu and Menu:IsVisible() then
		return
	end

	local max_health = LocalPlayer():GetMaxHealth() or 100
	local max_armor = LocalPlayer():GetNVar('maxArmor') or 255
	local health = (LocalPlayer():Health()/max_health)*100
	local armor = (LocalPlayer():Armor()/max_armor)*100

	-- print(LocalPlayer():GetNVar('maxArmor'), armor)

	lerp_health = Lerp(FrameTime()*2, lerp_health or 0, health or 0)
	lerp_armor = Lerp(FrameTime()*2, lerp_armor or 0, armor or 0)

	-- draw.RoundedBox(0, (ScrW()/2)-lerp_armor*2+2, ScrH()-120+2, lerp_armor*2+lerp_health*2, 16, Color(0,0,0,90))

	draw.RoundedBox(0, ScrW()/2, ScrH()-120, lerp_health*2, 5, Color(188,46,45,255))
	draw.RoundedBox(0, (ScrW()/2)-lerp_armor*2, ScrH()-120, lerp_armor*2, 5, Color(45,127,200,255))

	draw.SimpleText(math.Round((lerp_health/100)*max_health), "font_base_18", ScrW()/2+lerp_health*2+4+1, ScrH()-120-1+1, Color(0,0,0,90), 0, 0)
	draw.SimpleText(math.Round((lerp_health/100)*max_health), "font_base_18", ScrW()/2+lerp_health*2+4, ScrH()-120-1, color_white, 0, 0)
	draw.SimpleText(math.Round((lerp_armor/100)*max_armor), "font_base_18", (ScrW()/2-lerp_armor*2)-3+1, ScrH()-120-1+1, Color(0,0,0,90), 2, 0)
	draw.SimpleText(math.Round((lerp_armor/100)*max_armor), "font_base_18", (ScrW()/2-lerp_armor*2)-3, ScrH()-120-1, color_white, 2, 0)


	local wep = LocalPlayer():GetActiveWeapon()
	if wep and IsValid(wep) then
		local max_clip = LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() )
		local ammo_clip1 = wep:Clip1()

		surface.SetFont('font_base')
		local aw, _ = surface.GetTextSize(max_clip)

		-- print(max_clip1)
		if wep:Clip1() ~= -1 then
			draw.ShadowSimpleText(max_clip, "font_base", ScrW()-60, ScrH()-30, Color( 200, 200, 200, 140 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			draw.ShadowSimpleText(ammo_clip1, "font_base_54", ScrW()-66-aw, ScrH()-30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		end
	end

	local defcon = GetGlobalString('meta_defcon')
	do -- defcons

		if defcon and defcon ~= '' then
			defcon = DEFCON_TYPES[defcon]

			local fade = (RealTime() - starttime) * 0.5
			local alpha = (fade < 0 and 0 or fade > 1 and 1 or fade) * 200
			local wide = ScrW()
			local tall = 22
			surface.SetDrawColor(30, 30, 30, alpha)
			surface.DrawRect(0, 0, wide, tall)
			starttime = (starttime) + .6

			-- frac = frac < 0 and 0 or frac > 1 and 1 or frac
			local pos = starttime
			surface.SetTexture(stripes)
			surface.SetDrawColor(0, 70, 132, 255)
			surface.DrawTexturedRectUV(0, 0, wide, tall, 0, 0, 10, 1)

			surface.SetFont('font_base_warning')
			local tw, _ = surface.GetTextSize(defcon.text)
			y_defcon = y_defcon + 1
			if y_defcon >= ScrW()*2 then
				y_defcon = 20 - tw
			end
			draw.SimpleText(defcon.text,'font_base_warning',y_defcon,0,Color(255,255,255,255))
			draw.SimpleText(defcon.text,'font_base_warning',y_defcon-ScrW(),0,Color(255,255,255,255))

			draw.Icon( -64/2, -10, 64, 64, mat_defcon, color_white )
			draw.Icon( ScrW() - 64/2, -10, 64, 64, mat_defcon, color_white )
		end
	end

	local compass_x = 25

	do -- Compass made by roni_sl: http://steamcommunity.com/id/roni_sl/
		local offLimit = ScrW() / 6

		local offset = LocalPlayer():GetAngles().y
		local high = LocalPlayer():GetAngles().x

		local offset_x = offset > 0 and offset - 360 or offset
		draw.ShadowSimpleText( '( '..tostring(math.Round(offset_x*-1,1))..', '..tostring(math.Round(high*1.124,1))..' )', "font_base_small", ScrW() / 2, compass_x+34, color_white, 1, 0, 1, Color(0,0,0,255))
		for i, el in ipairs(elements) do
			local x = (el.x + offset) * 3
			if x < -offLimit then continue end
			if x > offLimit then continue end

			local alpha = (offLimit - math.abs(x)) / offLimit * 255
			local draw_x = ScrW() / 2 + x

			draw_x = math.Approach(
				draw_x, draw_x,
				math.Clamp(
					math.abs((draw_x - draw_x) * FrameTime() * 2),
					FrameTime()*2,
					FrameTime()*2
				)
			)

			surface.SetDrawColor(Color(255,255,255,alpha))
			-- ColorAlpha(table color, number alpha)

			local color = el.color and ColorAlpha(el.color, alpha*6) or ColorAlpha(color_white, alpha)

			draw.RoundedBox(0,draw_x-21, compass_x+24,40,2,color)
			if el.letter then
				draw.ShadowSimpleText( el.letter, "font_base_24", draw_x-2, compass_x-4, color, 1, 0, 1, Color(0,0,0,alpha/2))
			else
				local x_ = el.x > 0 and el.x or 360 + el.x
				draw.ShadowSimpleText( x_, "font_base_small", draw_x, compass_x+4, ColorAlpha(color, color.a-30), 1, 0, 1, Color(0,0,0,alpha/2))
			end
		end
		draw.SimpleText("▼", "font_base_18", ScrW()/2, compass_x-22, Color(255,255,255,46), 1, 0)
	end

	--Arrested HUD
	do
    if LocalPlayer():IsArrested() then
      local info = LocalPlayer():GetNVar('ArrestedTime')
      draw.ShadowSimpleText('Вы были арестованы', 'font_base', ScrW() / 2, ScrH() * 0.1 - 10, Color(255,255,255), 1, 1)
      draw.ShadowSimpleText('Осталось: ' .. math.ceil(info - CurTime()) .. ' секунд.', 'font_base_24', ScrW() / 2, ScrH() * 0.1 + 25, Color(255,255,255), 1, 1)
		end
	end

	do -- laws
		local laws = GetGlobalString('Laws')
		if not laws or laws == '' or laws == ' ' then return end
		if not show_laws:GetBool() then return end

		local x = 30 + - 10
		local text = string.Wrap('font_base_18', laws, 320)

		-- draw.RoundedBox(0, x, 17, laws_box_wide, 34 + (#text * 18), Color(0,0,0,90))
		-- surface.SetDrawColor(255,255,255,255)
		-- surface.SetMaterial(mat_laws)
		draw.Icon(x, -30, laws_box_wide, 220, mat_laws)

		-- draw.SimpleText('(F7 - Закрыть правила)', 'font_base_18', 30 + 70, 20+28, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT)

		for k, v in ipairs(text) do
			draw.SimpleText(v, 'font_base_small', 30 + 100, 34 + (k * 18) + 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end)


--------------------------------------------------------------------




-----------------------------------------------------

local ScreenPos = ScrH() - 200







local Colors = {}



Colors[NOTIFY_GENERIC] = Color(52, 73, 94)



Colors[NOTIFY_ERROR] = Color(52, 73, 94)



Colors[NOTIFY_UNDO] = Color(52, 73, 94)



Colors[NOTIFY_HINT] = Color(52, 73, 94)



Colors[NOTIFY_CLEANUP] = Color(52, 73, 94)







local LoadingColor = Color(52, 73, 94)







local Icons = {}



Icons[NOTIFY_GENERIC] = Material("sup_ui/vgui/gicons/info.png")



Icons[NOTIFY_ERROR] = Material("sup_ui/metaui/warning.png")



Icons[NOTIFY_UNDO] = Material("sup_ui/vgui/gicons/backward-time.png")



Icons[NOTIFY_HINT] = Material("sup_ui/metaui/question.png")



Icons[NOTIFY_CLEANUP] = Material("sup_ui/metaui/warning.png")







local LoadingIcon = Material("sup_ui/vgui/gicons/info.png")







local Notifications = {}







surface.CreateFont( "ModernNotification", {



	font = "Roboto",



	size = 20,



} )







local Theme = {



	BG = Color(0, 0, 0, 220),



	Outline = Color(0, 0, 0, 255),



	Text = Color(255, 255, 255, 255),



}







local function DrawNotification(x, y, w, h, text, icon, col, progress, notif)



	local frac = (notif.time - CurTime()) / (notif.time - notif.start)



	

  

    draw.RoundedBoxEx( 0, x, y, h, h, Color(52, 73, 94), true, false, true, false )



	draw.RoundedBoxEx( 0, x + h - 1, y, 1, h, color_white, true, false, true, false )



	draw.RoundedBoxEx( 0, x + h, y, w - h, h, Color(0, 0, 0, 220), false, true, false, true )



	draw.RoundedBoxEx( 0, x + h, y, (w - h) * frac, h, Color(64, 105, 153), false, true, false, true )



	--draw.RoundedBox( 0, x + h, y + h - 3, (w - h) * frac, 3, Color(245, 75, 35))







	draw.SimpleText(text, "ModernNotification", x + 32 + 10, y + h / 2, Theme.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)







	surface.SetDrawColor(Theme.Text)



	surface.SetMaterial(icon)







	if (progress) then



		surface.DrawTexturedRectRotated(x + 16, y + h / 2, 16, 16, -CurTime() * 360 % 360)



	else



		surface.DrawTexturedRect(x + 8, y + 8, 16, 16)



	end



end







function notification.AddLegacy(text, type, time)



	surface.SetFont("ModernNotification")







	local w = surface.GetTextSize(text) + 20 + 32



	local h = 32



	local x = ScrW()



	local y = ScreenPos + 120







	table.insert(Notifications, 1, {



		x = x,



		y = y,



		w = w,



		h = h,







		text = text,



		col = Colors[type],



		icon = Icons[type],



		start = CurTime(),



		time = CurTime() + time,







		progress = false,



	})



end







function notification.AddProgress(id, text)



	surface.SetFont("ModernNotification")







	local w = surface.GetTextSize(text) + 20 + 32



	local h = 32



	local x = ScrW()



	local y = ScreenPos







	table.insert(Notifications, 1, {



		x = x,



		y = y,



		w = w,



		h = h,







		id = id,



		text = text,



		col = LoadingColor,



		icon = LoadingIcon,



		time = math.huge,







		progress = true,



	})	



end







function notification.Kill(id)



	for k, v in ipairs(Notifications) do



		if v.id == id then v.time = 0 end



	end



end







hook.Add("HUDPaint", "DrawNotifications", function()



	for k, v in ipairs(Notifications) do



		DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, v.col, v.progress, v)







		v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w or ScrW() + 1)



		v.y = Lerp(FrameTime() * 10, v.y, ScreenPos - (k - 4.5) * (v.h + 5))



	end







	for k, v in ipairs(Notifications) do



		if v.x >= ScrW() and v.time < CurTime() then



			table.remove(Notifications, k)



		end



	end



end)



