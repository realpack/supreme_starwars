
-----------------------------------------------------
local hud_deathnotice_time = CreateConVar("hud_deathnotice_time", "6", FCVAR_REPLICATED, "Время отображения")

surface.CreateFont( "DeathFont", {
	font = "Play Bold",
	extended = true,
	size = 20,
	weight = 300,
})



local suicide_messages = {
	"%s решил прекратить свои мучения",
	"%s потерял смысл жизни",
	"%s ушел на быструю загрузку и умер",
	"%s призвал тот свет",
	"%s увидел свет в конце тоннеля",
	"%s стал атеистом и умер",
	"%s задержал дыхание и умер",
	"%s поверил в себя",
	"%s выпил татуинской бурды",
}



local fall_messages = {
	"%s забыл про парашут",
	"%s не обучен навыкам второго воздушного",
	"%s упал с небес",
	"%s выпал с ангара Ханамуры",
}



local kill_message = {
	"%s разобрался с %s",
	"%s пришел на забив и убил %s",
	"%s убил / уничтожил %s",}



-- local kill_color = {

-- 	Color(64, 105, 153, 0),
-- 	Color(64, 105, 153, 0),
-- 	Color(64, 105, 153, 0),
-- 	Color(64, 105, 153, 0),
-- 	Color(64, 105, 153, 0)

-- }



local special_kill_messages = {
	weapon_crowbar = "%s разбил лицо %s, используя монтировку",
	prop_physics = "%s шлёпнул %s пропом по лицу",
	sup_z6 = "%s используя Z6, не оставил живого места от %s",
	tfa_bowcaster = "%s используя арбалет Вуки оставил 3 дыры на теле %s",
	tfa_dc15x = "%s снайперским выстрелом DC15x снёс голову %s",
	tfa_dc15m = "%s дал Клятву Гиппократа на похоронах %s",}



--

local Deaths = {}



local function DrawDeath(x, y, death, hud_deathnotice_time)

	local fadeout = (death.time + hud_deathnotice_time) - CurTime()



	local col = Color(255, 255, 255)



	local alpha = math.Clamp(fadeout * 255, 0, 255)

	col.a = alpha

	col.a = alpha

	-- death.bg.a = math.Clamp(fadeout * 200, 0, 150)



	surface.SetFont("DeathFont")

	local wi, he = surface.GetTextSize(death.text)



	-- draw.RoundedBox(0, x - wi, y, wi + 17, he + 8, death.bg)

	draw.RoundedBox(0, x - wi, y, wi + 17, 1, Color(255, 255, 255, 0))

	draw.RoundedBox(0, x - wi, y + (he + 7), wi + 17, 1, Color(255, 255, 255, 0))

	draw.SimpleText(death.text, "DeathFont", x - wi + 20, y + 4, col)



	return y + he + 16

end



local function FindPlayer(info)

	local pls = player.GetAll()



	for k, v in pairs(pls) do

		if tonumber(info) == v:UserID() then

			return v

		end

	end



	for k, v in pairs(pls) do

		if string.find(string.lower(v:GetNWString("rpname")), string.lower(tostring(info))) ~= nil then

			return v

		end

	end

	return nil

end



local function Override()

	function GAMEMODE:AddDeathNotice(attacker, team1, inflictor, victim, team2)

		local Death = {}

		Death.time = CurTime()



		Death.left = attacker

		Death.right = victim

		Death.icon = inflictor



		local tx = ""

		if (attacker == "#worldspawn") then

			local str = fall_messages[math.random( 1, #fall_messages )]

			tx = string.format(str, victim)



			-- Death.bg = kill_color[math.random( 1, #kill_color )]

		elseif (attacker and attacker ~= victim) then

			local t = scripted_ents.Get(inflictor) or weapons.Get(inflictor)

			if (t and t.PrintName) then

				inflictor = t.PrintName

			end



			local str = special_kill_messages[inflictor] or kill_message[math.random( 1, #kill_message )]

			tx = string.format(str, attacker, victim, inflictor)



			-- Death.bg = kill_color[math.random( 1, #kill_color )]

		else

			local str = suicide_messages[math.random( 1, #suicide_messages )]

			tx = string.format(str, victim)



			-- Death.bg = kill_color[math.random( 1, #kill_color )]

		end

		Death.text = tx



		table.insert(Deaths, Death)

	end



	function GAMEMODE:DrawDeathNotice(x, y)

		local hud_deathnotice_time = hud_deathnotice_time:GetFloat()



		y = 55

		x = ScrW() - 20



		-- Draw

		for k, Death in pairs(Deaths) do

			if (Death.time + hud_deathnotice_time > CurTime()) then

				if (Death.lerp) then

					x = x * 0.3 + Death.lerp.x * 0.7

					y = y * 0.3 + Death.lerp.y * 0.7

				end



				Death.lerp = Death.lerp or {}

				Death.lerp.x = x

				Death.lerp.y = y



				y = DrawDeath(x, y, Death, hud_deathnotice_time)

			end

		end



		for k, Death in pairs(Deaths) do

			if (Death.time + hud_deathnotice_time > CurTime()) then

				return end

		end



		Deaths = {}

	end

end



hook.Add("InitPostEntity", "DeathNotice", function()

	Override()

end)

