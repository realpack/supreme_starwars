
-----------------------------------------------------
if SERVER then

	util.AddNetworkString( "switch_weapon" )

	net.Receive( "switch_weapon", function(l,ply)

		ply:SelectWeapon(net.ReadString())

	end)

end



AddCSLuaFile()



local PREFIX = {Color(71, 141, 255), ""}



local text = Color(71, 141, 255)

local lime = Color(71, 141, 255)

local yellow = Color(255, 255, 255)

local orange = Color(255, 50, 20)



local MESSAGES = {

	{text, "Третье лицо можно включить, используя F1. Настройка в С меню!"},

	{text, "Расширяем наше Супримовское Семейство! Вступай к нам в сообщество vk.com/supgmod"},

	{text, "Если вы заметили нарушение или есть вопросы к высшим силам в лице администраторов, то создайте тикет!"},

	{text, "Голосовое общение на нашем сервере discord.gg/6K5UzWz"},

	{text, "Уважайте ваших сослуживцев и братьев по оружию! Они ваша опора и надежные союзники в бою"},

	{text, "Не забывайте что Неопределённые Солдаты Клоны - временное подразделение. В нём задерживатся нельзя!"},

	{text, "Не подводи администрацию! Не будь НОНрпшером"},

	{text, "Аккуратнее при стрельбе! Не убей своего!"},

	{text, "Не нарушая устав и правила сервера, вы обойдете блокировки и посиделки в карцере!"},

	{text, "Спасибо что играете на Supreme Servers! Мы стараемся ради вас!"},

	{text, "Покука внутриигровых товаров (F6) помогает нашему серверу покупать рекламу и жить дальше!"},

	{text, "Ты же знаешь что SUP лучший ( ͡° ͜ʖ ͡°)"},

	{text, "Вместе мы создадим лучший SWRP сервер!"},

	{text, "А ты знал что дефектов-клонов не существует? Это намёк на то, чтобы ты не глупил, юный клон..."},

	{text, "В медицинском блоке спирт спрятан, даже не пытайся его украсть"},

	{text, "В нашем Discord канале множество информации и общение с Супримовским Семейством!"},

	{text, "Признак культурного военнослужащего - отсутствие матов в его речи!"},

	{text, "Используй /advert и /comm с умом! Болтун - находка для шпиона КНС"},

	{text, "SUP ME - верь нам! Верь в своё сообщество!"},

	{text, "Не нажимай на кнопки в диспетчерской - будет только хуже!"},

	{text, "Находясь на сервере в составе легиона (Неопределённые Солдаты Клоны не в счёт) вы обязаны находится в Discord!"},
}


if (SERVER) then

	local CYCLE_TIME = 120

	

	util.AddNetworkString("AutoChatMessage")

	local curmsg = 1

	

	timer.Create("AutoChatMessages", CYCLE_TIME, 0, function()

		net.Start("AutoChatMessage")

			net.WriteUInt(curmsg, 16)

		net.Broadcast()



		curmsg = curmsg + 1

		if (curmsg > #MESSAGES) then

			curmsg = 1

		end

	end)

else

	net.Receive("AutoChatMessage", function()

		local t = {}

		table.Add(t, PREFIX)

		table.Add(t, MESSAGES[net.ReadUInt(16)])

		

		chat.AddText(unpack(t))

	end)

end