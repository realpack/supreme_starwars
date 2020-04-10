BlobsPartyConfig = BlobsPartyConfig or {}

-- 1.0.9
-- If for some reason these do not work/display for you (Although they should) you can change them below
-- Note: Some text editors will show these as a square, though try to see them in-game as it works there.
BlobsPartyConfig.UpArrow = "▴"
BlobsPartyConfig.DownArrow = "▾"

-- 1.0.7
BlobsPartyConfig.DefaultTopUISpacing = 10 -- The distance between the top of the screen and the start of the Party members UI (Use this if you have a HUD that is being overlapped by the party members display)

-- 1.0.6 and below
BlobsPartyConfig.PartyCommands = { "!squad" } -- The command(s) that opens the party UI
BlobsPartyConfig.PartyChatCommands = { "!sq", "/sq" } -- The commands to use party chat (which is then followed by the message. example: /pc Hey everyone!)
BlobsPartyConfig.MinNameSize = 3 -- Minimum name length for party name
BlobsPartyConfig.MaxNameSize = 100 -- Maximum name length for party name
BlobsPartyConfig.MinSize = 1 -- Minimum size for party
BlobsPartyConfig.MaxSize = 100 -- Maximum size for party

BlobsPartyConfig.FriendlyFireToggle = true -- If this is set to true, then party owners have the option to enable/disable friendly fire within their party

--[[ HUD Styling ]]--
BlobsPartyConfig.FirstColor = Color(52, 73, 94, 155) -- This is the darkest color on the UI
BlobsPartyConfig.SecondColor = Color(52, 73, 94, 255) -- Slightly lighter than the previous color
BlobsPartyConfig.ThirdColor = Color(52, 73, 94, 255) -- The colour of the UI's main background
BlobsPartyConfig.BarColor = Color(64, 105, 153,255) -- This is the light blue color
BlobsPartyConfig.PartyChatColor = Color(255,255,255) -- The text color that party chat appears in
BlobsPartyConfig.PartyChatPrefixColor = Color(0,255,255) -- The color that the party chat prefix is -- (PARTY) default yellow

--[[ Language / Localization ]]--
-- When a language config setting contains {p}, this will be replaced by the name of the player that is relevant to that message!
BlobsPartyConfig.FriendlyFire = "Включить Урон по своим?"
BlobsPartyConfig.PartyList = "Список Отряда"
BlobsPartyConfig.PartyMenu = "Меню Отряда"
BlobsPartyConfig.PartyName = "Имя Отряда"
BlobsPartyConfig.PartySize = "Размер Отряда"
BlobsPartyConfig.Owner = "Командир Отряда"
BlobsPartyConfig.CreateParty = "Создать Отряд"
BlobsPartyConfig.EditParty = "Редактирование"
BlobsPartyConfig.PartySettings = "Настройки Отряда"
BlobsPartyConfig.ManagePlayers = "Настройка Бойцов"
BlobsPartyConfig.NoOtherPlys = "Нет других бойцов..."
BlobsPartyConfig.KickPly = "Выгнать Бойца"
BlobsPartyConfig.GiveOwner = "Передать права"
BlobsPartyConfig.ReqToJoin = "Запросить вход"
BlobsPartyConfig.Join = "Вступить"
BlobsPartyConfig.Ply = "Боец"
BlobsPartyConfig.AcceptReq = "Принять приглашение"
BlobsPartyConfig.OnlyLeaderCan = "Только лидер отряда может это делать!"
BlobsPartyConfig.NotInParty = "Вы не в отряде!"
BlobsPartyConfig.EnRing = "Создавать круг?"
BlobsPartyConfig.EnGlow = "Включить подсветку?"
BlobsPartyConfig.SetClr = "Сохранить"
BlobsPartyConfig.PartyLeader = "Офицер:"
BlobsPartyConfig.PartyMmbs = "Бойцы:"
BlobsPartyConfig.Mmbs = "Бойцы"
BlobsPartyConfig.OpenParty = "Открытый Отряд?"
BlobsPartyConfig.Yes = "Да"
BlobsPartyConfig.No = "Нет"
BlobsPartyConfig.CopyName = "Копировать Имя"
BlobsPartyConfig.CopySteamID = "Копировать SteamID"
BlobsPartyConfig.ViewSteamProfile = "STEAM Профиль"
BlobsPartyConfig.AlreadyOwn = "Вы уже Офицер!"
BlobsPartyConfig.AlreadyIn = "Вы уже в отряде!"
BlobsPartyConfig.Disband = "Расформировать"
BlobsPartyConfig.Leave = "Покинуть"
BlobsPartyConfig.HP = "HP"
BlobsPartyConfig.PartyChatPrefix = "(ОТРЯД)"
BlobsPartyConfig.NameTooShort = "Имя отряда короткое! (мин. 3 символа)"
BlobsPartyConfig.NameTooLong = "Имя отряда слишком длинное (макс. 100 символов)"
BlobsPartyConfig.SizeTooSmall = "Отряд слишком мал (мин. 1 боец)"
BlobsPartyConfig.SizeTooBig = "Слишком большой отряд (макс. 100 бойцов)"
BlobsPartyConfig.PartyNameExists = "Имя уже занято!"
BlobsPartyConfig.Full = "Отряд заполнен!"
BlobsPartyConfig.ReqSent = "Вы получили приглашение в отряд!"
BlobsPartyConfig.AlreadyRequested = "Вы уже приглашены в отряд!"
BlobsPartyConfig.OwnerLeaveDisband = "Отряд расформирован по причине ухода офицера!"
BlobsPartyConfig.PartyDisbanded = "Отряд расфомирован!"
BlobsPartyConfig.PlayerLeave = "{p} покинул отряд!"
BlobsPartyConfig.PlayerJoin = "{p} присоеденился к отряду!"
BlobsPartyConfig.PlayerKicked = "{p} исключён из отряда!"
BlobsPartyConfig.PlayerReqToJoin = "{p} запросил вступление в отряд!"
BlobsPartyConfig.NewOwner = "{p} теперь офицер отряда!"