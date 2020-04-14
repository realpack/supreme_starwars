--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- Provides support for languages through the use of phrases.
-- @module serverguard.phrase

serverguard.phrase = serverguard.phrase or {
	currentLanguage = "english"
};

local languages = {};

--- Adds a language that phrases can use.
-- @string language The name of the language.
function serverguard.phrase:AddLanguage(language)
	languages[language] = {};
end;

--- Sets the language used for phrases.
-- @string language The name of the language.
function serverguard.phrase:SetLanguage(language)
	if (!languages[language]) then
		return;
	end;

	self.currentLanguage = language;
end;

--- Adds a phrase to the specified language. Supports string formatting with %s, etc.
-- @string language The name of the language.
-- @string unique The unique ID of the phrase.
-- @param format A string or table of strings/notify constants.
-- @usage serverguard.phrase:Add("english", "test_phrase", "This is a test.");
-- @usage serverguard.phrase:Add("english", "another_phrase", "This one has some %s formatting!");
-- @usage serverguard.phrase:Add("english", "test_phrase_three", {SERVERGUARD.NOTIFY.GREEN, "This", SERVERGUARD.NOTIFY.WHITE, " has some ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " formatting."});
function serverguard.phrase:Add(language, unique, format)
	if (!languages[language]) then
		return;
	end;

	languages[language][unique] = format;
end;

--- Adds languages and phrases specified in the table. See modules/sh_phrase.lua for an example table.
-- @table data Table of languages and phrases.
function serverguard.phrase:AddTable(data)
	for languageUnique, language in pairs(data) do
		if (!languages[language]) then
			self:AddLanguage(languageUnique);
		end;

		for phraseUnique, phrase in pairs(language) do
			self:Add(languageUnique, phraseUnique, phrase);
		end;
	end;
end;

--- Returns the text from a phrase.
-- @string unique The unique ID of the phrase.
-- @param ...[opt] Any parameters that the phrase may need.
-- @treturn string The text from the phrase.
function serverguard.phrase:Get(unique, ...)
	if (!languages[self.currentLanguage][unique]) then
		return "";
	end;

	local phrase = languages[self.currentLanguage][unique];
	local result = "";

	if (type(phrase) == "table") then
		for k, v in pairs(phrase) do
			if (type(v) == "string") then
				result = result .. v;
			end;
		end;
	else
		result = phrase;
	end;

	return string.format(result, ...);
end;

--- Returns the notify-formatted text from a phrase.
-- @string unique The unique ID of the phrase.
-- @param ...[opt] Any parameters that the phrase may need.
-- @treturn table A table formatted for use with serverguard.Notify().
-- @see SGPF
-- @see serverguard.Notify
function serverguard.phrase:GetFormatted(unique, ...)
	if (!languages[self.currentLanguage][unique]) then
		return {SERVERGUARD.NOTIFY.WHITE, ""};
	end;

	local phrase = languages[self.currentLanguage][unique];

	if (type(phrase) == "string") then
		return {SERVERGUARD.NOTIFY.WHITE, phrase};
	end;

	local arguments = {...};
	local currentArgument = 1;
	local result = {};

	for k, v in pairs(phrase) do
		if (type(v) != "string") then
			result[#result + 1] = v;
			continue;
		end;

		if (string.find(v, "%", 0, true)) then
			local argument = arguments[currentArgument];

			if (type(argument) == "table") then
				for k2, v2 in pairs(argument) do
					result[#result + 1] = v2;
				end;

				currentArgument = currentArgument + 1;
			else
				result[#result + 1] = string.format(v, arguments[currentArgument]);
				currentArgument = currentArgument + 1;
			end;

			continue;
		end;
		
		result[#result + 1] = v;
	end;

	return unpack(result);
end;

--- A shorthand function for serverguard.phrase:Get().
-- @string unique The unique ID of the phrase.
-- @param ...[opt] Any parameters that the phrase may need.
-- @see serverguard.phrase:Get
function SGP(unique, ...)
	return serverguard.phrase:Get(unique, ...);
end;

--- A shorthand function for serverguard.phrase:GetFormatted().
-- @string unique The unique ID of the phrase.
-- @param ...[opt] Any parameters that the phrase may need.
-- @see serverguard.phrase:GetFormatted
-- @usage serverguard.Notify(nil, SGFP("test_phrase_three", "awesome"));
function SGPF(unique, ...)
	return serverguard.phrase:GetFormatted(unique, ...);
end;

serverguard.phrase:AddTable({
	english = {
		player_cant_find_suitable = {SERVERGUARD.NOTIFY.RED, "Не удалось найти подходящих игроков!"},
		player_found_multiple = {SERVERGUARD.NOTIFY.RED, "С таким регистром не один игрок на сервере! \"%s\"!"},
		player_higher_immunity = {SERVERGUARD.NOTIFY.RED, "Этот игрок обладает более высоким иммунитетом, чем вы."},
		cant_find_location = {SERVERGUARD.NOTIFY.RED, "Не удалось найти подходящее место."},
		cant_find_player_with_identifier = {SERVERGUARD.NOTIFY.RED, "Невозможно найти игрока с этим идентификатором."},
		restricted = {SERVERGUARD.NOTIFY.RED, "Вы ограничены и не можете использовать эту функцию для %s."},

		-- Command phrases.
		command_ban_invalid_duration = {SERVERGUARD.NOTIFY.RED, "Вы ввели недопустимый срок! Попробуйте ввести номер или отформатировать его с помощью идентификаторов продолжительности. Например: 1w2d12h"},
		command_ban_exceed_banlimit = {SERVERGUARD.NOTIFY.RED, "Вы ввели длину, которая превышает максимально допустимый срок запрета вашего ранга. Попробуйте ввести меньшее число, чем %s!"},
		command_ban_cannot_permaban = {SERVERGUARD.NOTIFY.RED, "У вас нет разрешения на постоянную блокировку!"},
		command_ban_clamped_duration = {SERVERGUARD.NOTIFY.RED, "Одна или несколько ваших сроков дошли до 99 - длительность не может превышать 99."},
		command_ban = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " заблокировал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " на ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". Причина: %s"},
		command_ban_perma = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " заблокировал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ",", SERVERGUARD.NOTIFY.RED, " Навсегда", SERVERGUARD.NOTIFY.WHITE, ". Причина: %s"},

		command_unban = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " разблокировал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_no_entry = {SERVERGUARD.NOTIFY.RED, "Блокировок для данного Steam ID нет!"},

		command_rank = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " установил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "%s привелегию ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, ". Срок: ", SERVERGUARD.NOTIFY.RED, "%s."},
		command_rank_invalid_immunity = {SERVERGUARD.NOTIFY.RED, "Привелегия, который вы пытаетесь установить, имеет более высокий иммунитет, чем ваш."},
		command_rank_invalid_unique = {SERVERGUARD.NOTIFY.RED, "Такой привелегии нет '%s'."},
		command_rank_valid_list = {SERVERGUARD.NOTIFY.RED, "Вот несколько действительных привелегий: %s"},
		command_rank_cannot_set_own = {SERVERGUARD.NOTIFY.RED, "Вы можете установить себе привелегию в игре. Используйте \"serverguard_setrank <player>\" в серверную консоль."},

		command_goto = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " телепортировался к ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_bring = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " телепортировал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " к себе."},

		command_send_player = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " телепортировал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " к локации ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_send = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " телепортировал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " локации."},

		command_return = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " вернул на прежнюю локацию."},
		command_return_invalid = {SERVERGUARD.NOTIFY.RED, "У игрока нет прошлых локаций."},

		command_admintalk = {SERVERGUARD.NOTIFY.WHITE, "Отправить сообщение администраторам."},
		command_admintalk_invalid = {SERVERGUARD.NOTIFY.WHITE, "В сети нет администраторов."},

		command_god = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " активировал бессмертие ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_god_disable = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " отключил бессмертие ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},

		command_ignite = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " поджёг ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_extinguish = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " потушил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},

		command_spectate = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " начал следить за ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_spectate_invalid = {SERVERGUARD.NOTIFY.RED, "Вы не можете следить за самим собой!"},
		command_spectate_hint = {SERVERGUARD.NOTIFY.WHITE, "Нажмите Ctrl для прекращения слежки."},

		command_jail = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " посадил в тюрьму ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". Продолжительность: ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_unjail = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " освободил из тюрьмы ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_jailtp = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " телепортировал и посадил в тюрьму ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " в своей локации. Продолжительность: ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},

		command_kick = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " исключил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". Reason: %s"},
		command_maprestart = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " перезагрузит карту через ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " секунд!"},
		command_freezeprops = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " заморозил пропы."},
		command_stripweapons = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " забрал всё оружие у ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_respond_invalid = {SERVERGUARD.NOTIFY.RED, "У этого игрока нет ожидающего запроса помощи."},
		command_slay = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " убил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_giveweapon = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " выдал ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " a ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_armor = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " установил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " броню на ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_hp = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " установил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " здоровье на ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_respawn = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " возродил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_ammo = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " выдал ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " аммуницию на ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_slap = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " шлёпнул ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_npctarget = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " переключил видимость НИП ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_cleardecals = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " отчистил мусор на карте."},
		command_ragdoll = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " зарэгдоллил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_mute = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " отключил чат ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_unmute = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " включил чат ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_invisible = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " переключил режим невидимости ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_freeze = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " зафризил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_noclip = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " включил режим полёта ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_gag = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " отключил голосовой чат", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_ungag = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " включил голосовой чат ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_restrict = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, "ограничил ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "%s функции для ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
		command_unrestrict = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " снял ограничение ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "%s функций."},
        
        command_nocollide = {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " переключил столкновение ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."},
	}
});