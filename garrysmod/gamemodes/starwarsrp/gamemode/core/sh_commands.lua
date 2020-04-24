meta.cmd.data = meta.cmd.data or {}

function meta.cmd.callback( pPlayer, cmd, args, str )
	if (!(args[1]) or args == {}) then
		print('This is a basic command for meta gamemode.')
	end
	if table.HasValue(table.GetKeys(meta.cmd.data),args[1]) then
		local com = args[1]
		-- table.remove(args, 1);
		meta.cmd.data[com](pPlayer,cmd,args)
	elseif (args[1] or args == {}) then
		print('Errors of the argument!')
	end
end

function meta.cmd.autoComplete(commandName,args)
	local return_table = {}
	for _, name in pairs(table.GetKeys(meta.cmd.data)) do
		table.insert(return_table,string.format('meta %s',name))
	end
	return return_table
end

function meta.cmd.add(arg,callback)
	meta.cmd.data[arg] = callback
end

function CharacterChange( pPlayer, cmd, args )
    pPlayer:RequestCharacters(function(characters, player_data)
        netstream.Start(pPlayer, "OpenCharacterMenu", { characters = characters })
    end)
end
meta.cmd.add('char',CharacterChange)

function Helmet( pPlayer, cmd, args )
    pPlayer.helmet = not pPlayer.helmet

	local bnum = pPlayer.helmet and 1 or 0

	for k, v in pairs(pPlayer:GetBodyGroups()) do
		if v.name == 'helmet' or v.name == 'visor' then
			pPlayer:SetBodygroup(v.id, bnum)
		end
	end
end
meta.cmd.add('helmet',Helmet)

-- function Whitelist( pPlayer, cmd, args )
--     netstream.Start(pPlayer, "OpenWhitelistMenu")
-- end
-- meta.cmd.add('whitelist',Whitelist)
-- meta.cmd.add('w',Whitelist)

function EventRoom( pPlayer, cmd, args )
    if not pPlayer:IsAdmin() then return end

    netstream.Start(pPlayer, "OpenEventroomMenu")
end
meta.cmd.add('eventroom',EventRoom)

function Event( pPlayer, cmd, args )
    if not pPlayer:IsAdmin() then return end

	table.remove(args, 1)
	local message = string.Implode(' ', args)

    netstream.Start(player.GetAll(), "EventMessage", string.Implode(' ', args))
end
meta.cmd.add('event',Event)

plogs.Register('/comms', false)

local function comms( pPlayer, cmd, args )
    if not pPlayer:IsAdmin() then return end

	table.remove(args, 1)
	local message = string.Implode(' ', args)

	plogs.PlayerLog(pPlayer, '/comms', pPlayer:NameID() .. ' изменил текст на "' .. message .. '".', {
		['Name']	= pPlayer:Name(),
		['SteamID']	= pPlayer:SteamID(),
	})

	local snd = 'transmission/launch.wav'
	if message == '' or message == ' ' then
		snd = 'transmission/close.wav'
	end

	BroadcastLua( [[surface.PlaySound(']].. snd ..[[')]] )

	SetGlobalBool('Laws', message)
end
meta.cmd.add('comms',comms)

if CLIENT then
	netstream.Hook("EventMessage", function(message)
		event_text = message

		timer.Remove('EventMessage')
		timer.Create( "EventMessage", 8, 1, function() event_text = nil end )
	end)

	hook.Add('HUDPaint', 'EventMessage', function()
		if event_text then
			draw.SimpleText('Информация', "font_base_rotate", ScrW()*.5, 200, Color( 51, 167, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(event_text, "font_base_hud", ScrW()*.5, 250, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end)
end

meta.cmd.add('thirdperson',function( pPlayer )
	netstream.Start(pPlayer, "thirdperson_toggle")
end)

if SERVER then
	concommand.Add( "meta", meta.cmd.callback, meta.cmd.autoComplete, 'This is a basic command for meta gamemode.' )
	netstream.Hook("meta.command.SendCommandsToServer", function(pPlayer, data)
		meta.cmd.callback(pPlayer, data.cmd, data.args)
	end);

	hook.Add("PlayerSay","meta.command.PlayerSay",function(pPlayer,strMsg)
	 	strMsg = string.Explode(" ",strMsg)

	 	for k, v in pairs(meta.cmd.data) do
	 		if "/"..k == strMsg[1] then
	 			strMsg[1] = string.gsub(strMsg[1], "/", "")
				v(pPlayer, "meta", strMsg)
				return ''
	 		end
	 	end
	 end)
else
	concommand.Add( "meta", function(pPlayer,cmd,args)
		netstream.Start("meta.command.SendCommandsToServer", {
			args = args,
			cmd = cmd
		})
	end, meta.cmd.autoComplete, 'This is a basic command for meta gamemode.' )

	netstream.Hook("ChatMassage", function(data)
		pCaller = data.pPlayer
		if pCaller and pCaller:IsPlayer() then
			color, pre = data.color, data.pre
			postcolor = data.postcolor == false and '' or Color(255,255,255)
			postname = data.postcolor == false and ' ' or ': '
			chat.AddText(color, pre, team.GetColor(pCaller:Team()), pCaller:Name(), postcolor, postname, data.text)
		end
	end);

	netstream.Hook("RPCommands", function(...)
		chat.AddText(...)
	end);
end

meta.cmd.data = meta.cmd.data or {}

function meta.cmd.callback( pPlayer, cmd, args, str )
	if (!(args[1]) or args == {}) then
		print('This is a basic command for meta gamemode.')
	end
	if table.HasValue(table.GetKeys(meta.cmd.data),args[1]) then
		local com = args[1]
		-- table.remove(args, 1);
		meta.cmd.data[com](pPlayer,cmd,args)
	elseif (args[1] or args == {}) then
		print('Errors of the argument!')
	end
end

function meta.cmd.autoComplete(commandName,args)
	local return_table = {}
	for _, name in pairs(table.GetKeys(meta.cmd.data)) do
		table.insert(return_table,string.format('meta %s',name))
	end
	return return_table
end

function meta.cmd.add(arg,callback)
	meta.cmd.data[arg] = callback
end

function CharacterChange( pPlayer, cmd, args )
    pPlayer:RequestCharacters(function(characters, player_data)
        netstream.Start(pPlayer, "OpenCharacterMenu", { characters = characters })
    end)
end
meta.cmd.add('char',CharacterChange)

function Whitelist( pPlayer, cmd, args )
    netstream.Start(pPlayer, "OpenWhitelistMenu")
end
meta.cmd.add('whitelist',Whitelist)
meta.cmd.add('w',Whitelist)

meta.cmd.add('thirdperson',function( pPlayer )
	netstream.Start(pPlayer, "thirdperson_toggle")
end)

if SERVER then
	concommand.Add( "meta", meta.cmd.callback, meta.cmd.autoComplete, 'This is a basic command for meta gamemode.' )
	netstream.Hook("meta.command.SendCommandsToServer", function(pPlayer, data)
		meta.cmd.callback(pPlayer, data.cmd, data.args)
	end);

	hook.Add("PlayerSay","meta.command.PlayerSay",function(pPlayer,strMsg)
	 	strMsg = string.Explode(" ",strMsg)

	 	for k, v in pairs(meta.cmd.data) do
	 		if "/"..k == strMsg[1] then
	 			strMsg[1] = string.gsub(strMsg[1], "/", "")
				v(pPlayer, "meta", strMsg)
				return ''
	 		end
	 	end
	 end)
else
	concommand.Add( "meta", function(pPlayer,cmd,args)
		netstream.Start("meta.command.SendCommandsToServer", {
			args = args,
			cmd = cmd
		})
	end, meta.cmd.autoComplete, 'This is a basic command for meta gamemode.' )

	netstream.Hook("ChatMassage", function(data)
		pCaller = data.pPlayer
		if pCaller and pCaller:IsPlayer() then
			color, pre = data.color, data.pre
			postcolor = data.postcolor == false and '' or Color(255,255,255)
			postname = data.postcolor == false and ' ' or ': '
            local text_color = data.text_color or Color(255,255,255)
            local name = data.drawname and data.drawname or pCaller:Name()
			chat.AddText(color, pre, team.GetColor(pCaller:Team()), name, postcolor, postname, text_color, data.text)
		end
	end);

	netstream.Hook("RPCommands", function(...)
		chat.AddText(...)
	end);
end

meta.cmd.data = meta.cmd.data or {}

function meta.cmd.callback( pPlayer, cmd, args, str )
	if (!(args[1]) or args == {}) then
		print('This is a basic command for meta gamemode.')
	end
	if table.HasValue(table.GetKeys(meta.cmd.data),args[1]) then
		local com = args[1]
		-- table.remove(args, 1);
		meta.cmd.data[com](pPlayer,cmd,args)
	elseif (args[1] or args == {}) then
		print('Errors of the argument!')
	end
end

function meta.cmd.autoComplete(commandName,args)
	local return_table = {}
	for _, name in pairs(table.GetKeys(meta.cmd.data)) do
		table.insert(return_table,string.format('meta %s',name))
	end
	return return_table
end

function meta.cmd.add(arg,callback)
	meta.cmd.data[arg] = callback
end

meta.cmd.add('thirdperson',function( pPlayer )
	netstream.Start(pPlayer, "thirdperson_toggle")
end)

function OOCMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local strMsg = string.Implode( " ", args )
	netstream.Start(player.GetAll(), 'ChatMassage', {
		pPlayer = pPlayer,
		pre = "OOC | ",
		color = Color(238,50,57),
		text = strMsg
	} )
end
meta.cmd.add('ooc',OOCMassage)
meta.cmd.add('c',OOCMassage)
meta.cmd.add('/',OOCMassage)

-- function DropMoney( pPlayer, cmd, args )
-- 	local moneyCount
-- 	if (args and args[2]) then
-- 		moneyCount = tonumber(args[2])
-- 		if pPlayer:isEnoughMoney(moneyCount) then
-- 			pPlayer:AddMoney(-moneyCount)

-- 			local trace = {}
-- 			trace.start = pPlayer:EyePos()
-- 			trace.endpos = trace.start + pPlayer:GetAimVector() * 85
-- 			trace.filter = pPlayer

-- 			local tr = util.TraceLine(trace)
-- 			CreateMoneyBag(tr.HitPos,moneyCount)
-- 		end
-- 	end
-- end
-- meta.cmd.add('dropmoney',DropMoney)

-- function AddMoney( pPlayer, cmd, args )
-- 	local moneyCount
-- 	if (args and args[2]) then
-- 		moneyCount = tonumber(args[2])
-- 		if pPlayer:isEnoughMoney(moneyCount) then
--             local trace = pPlayer:GetEyeTrace()
--             local target = trace.Entity

--             if target and IsValid(target) and target:IsPlayer() then
--                 pPlayer:AddMoney(-moneyCount)
--                 target:AddMoney(moneyCount)
--             end
-- 		end
-- 	end
-- end
-- meta.cmd.add('addmoney',AddMoney)

function AdvertMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local strMsg = string.Implode( " ", args )

	if pPlayer:GetNVar('meta_features')['comm'] then
		netstream.Start(player.GetAll(), 'ChatMassage', {
			pPlayer = pPlayer,
			pre = "Защищенная Сеть | ",
			color = Color(85,153,0),
			text = strMsg,
			text_color = Color(255, 238, 0)
		} )
	else
		netstream.Start(player.GetAll(), 'ChatMassage', {
			pPlayer = pPlayer,
			pre = "Незащищенная Сеть | ",
			color = Color(39,147,232),
			text = strMsg,
			text_color = Color(255, 238, 0)
		} )
	end
end
meta.cmd.add('advert',AdvertMassage)
meta.cmd.add('ad',AdvertMassage)


function RP1Massage( pPlayer, cmd, args )
	table.remove(args,1)
	local strMsg = string.Implode( " ", args )
		netstream.Start(player.GetAll(), 'ChatMassage', {
			pPlayer = pPlayer,
			pre = "РП | ",
			color = Color(39,147,232),
			text = strMsg,
			text_color = Color(69, 136, 237)
		} )
end
meta.cmd.add('rp',RP1Massage)

function Advert2Massage( pPlayer, cmd, args )
	table.remove(args,1)
	local strMsg = string.Implode( " ", args )
	netstream.Start(player.GetAll(), 'ChatMassage', {
		pPlayer = pPlayer,
		-- drawname = '',
		pre = "Локальная Базовая Сеть | ",
		color = Color(8,219,114),
		text = strMsg,
        text_color = Color(255, 238, 0)
	} )
end
meta.cmd.add('comm',Advert2Massage)

function AdvertCISMassage( pPlayer, cmd, args )
    if not pPlayer:IsAdmin() then return end

	table.remove(args,1)
	local strMsg = string.Implode( " ", args )
	netstream.Start(player.GetAll(), 'ChatMassage', {
		pPlayer = pPlayer,
        -- drawname = '',
		pre = "Армия Дроидов | ",
		color = Color(33, 155, 255),
		text = strMsg,
        text_color = Color(2, 255, 242)
	} )
end
meta.cmd.add('cis',AdvertCISMassage)


function AdvertRANDOMMassage( pPlayer, cmd, args )
    if not pPlayer:IsAdmin() then return end

	table.remove(args,1)
	local strMsg = string.Implode( " ", args )
	netstream.Start(player.GetAll(), 'ChatMassage', {
		pPlayer = pPlayer,
        drawname = '',
		pre = "Неизвестная Частота | ",
		color = Color(33, 155, 255),
		text = strMsg,
        text_color = Color(2, 255, 242)
	} )
end
meta.cmd.add('rnd',AdvertRANDOMMassage)

function MeMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),300)) do
		table.insert(tblPlayers,v)
	end
	netstream.Start(tblPlayers, 'ChatMassage', {
		pPlayer = pPlayer,
		pre = "",
		color = team.GetColor(pPlayer:Team()),
		text = string.Implode( " ", args ),
		postcolor = false,
        text_color = team.GetColor(pPlayer:Team())
	} )
end
meta.cmd.add('me',MeMassage)

function NoRPMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	local strMsg = string.Implode( " ", args )
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),300)) do
		table.insert(tblPlayers,v)
	end
	netstream.Start(tblPlayers, 'ChatMassage', {
		pPlayer = pPlayer,
		pre = "LOOC | ",
		color = Color(186,218,85),
		text = strMsg
	} )
end
meta.cmd.add('l',NoRPMassage)
meta.cmd.add('looc',NoRPMassage)

function YellMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	local strMsg = string.Implode( " ", args )
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),650)) do
		table.insert(tblPlayers,v)
	end
	netstream.Start(tblPlayers, 'ChatMassage', {
		pPlayer = pPlayer,
		pre = "Крик | ",
		color = Color(186, 50, 50),
		text = strMsg
	} )
end
meta.cmd.add('y',YellMassage)


function WhisperMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	local strMsg = string.Implode( " ", args )
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),50)) do
		table.insert(tblPlayers,v)
	end
	netstream.Start(tblPlayers, 'ChatMassage', {
		pPlayer = pPlayer,
		pre = "Шёпот | ",
		color = Color(186, 50, 50),
		text = strMsg
	} )
end
meta.cmd.add('w',WhisperMassage)

function DoMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),300)) do
		table.insert(tblPlayers,v)
	end
    local rand = tostring(math.random(1,100))
	netstream.Start(tblPlayers, 'RPCommands', team.GetColor(pPlayer:Team()), string.Implode( " ", args ), " (( "..pPlayer:Name().." ))" )
end
meta.cmd.add('do',DoMassage)


function RollMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),300)) do
		table.insert(tblPlayers,v)
	end
    local rand = tostring(math.random(1,100))
	netstream.Start(tblPlayers, 'RPCommands', pPlayer, Color(240,240,240,255), ' кинул кубики, и ему выпало ', Color(0,165,240,255), rand, Color(240,240,240,255), '.' )
end
meta.cmd.add('roll',RollMassage)

function TryMassage( pPlayer, cmd, args )
	table.remove(args,1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(pPlayer:GetPos(),300)) do
		table.insert(tblPlayers,v)
	end
	local try = math.random(0,6)%2 == 1 and 'неудача' or 'успех'
	netstream.Start(tblPlayers, 'RPCommands', team.GetColor(pPlayer:Team()), pPlayer, Color(240,240,240,255), ' ', string.Implode( " ", args ), ', ', Color(0,165,240,255), try, Color(240,240,240,255), '.'  )
end
meta.cmd.add('try',TryMassage)

