-- Define a global shared table to store gamemode information.
meta = {
	config = config or {
		data = {}
	},
	items = {
		data = {}
	},
	jobs = {},
	util = util or {},
	cmd = cmd or {
		data = {}
	},
	ui = (meta and meta.ui) and meta.ui or {}
}


GM = GM or GAMEMODE
GAMEMODE = GM or GAMEMODE

-- Metatables.
pMeta = FindMetaTable( 'Player' )
eMeta = FindMetaTable( 'Entity' )
vMeta = FindMetaTable( 'Vector' )
paMeta = FindMetaTable( 'Panel' )

-- Set up basic gamemode values.
GM.Name 		= 'StarWarsRP' -- Gamemode name.
GM.Author 		= 'MetaHub team' -- Author name.
GM.Email 		= '_' -- Author email.
GM.Website 		= '' -- Website.

-- Fix for the name conflicts.
_player, _team, _file, _table, _sound = player, team, file, table, sound

-- DeriveGamemode('sandbox')
-- DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

meta.util.CurentMap = game.GetMap()

-- TODO: move
concommand.Remove( "gmod_admin_cleanup" )

--[[ Micro-optimizations --]]
local von = von;
local HITGROUP_RIGHTARM = HITGROUP_RIGHTARM;
local HITGROUP_RIGHTLEG = HITGROUP_RIGHTLEG;
local HITGROUP_LEFTARM = HITGROUP_LEFTARM;
local HITGROUP_LEFTLEG = HITGROUP_LEFTLEG;
local HITGROUP_STOMACH = HITGROUP_STOMACH;
local HITGROUP_CHEST = HITGROUP_CHEST;
local HITGROUP_HEAD = HITGROUP_HEAD;
local UnPredictedCurTime = UnPredictedCurTime;
local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local getmetatable = getmetatable;
local setmetatable = setmetatable;
local GetGlobalVar = GetGlobalVar;
local SetGlobalVar = SetGlobalVar;
local ErrorNoHalt = ErrorNoHalt;
local EffectData = EffectData;
local VectorRand = VectorRand;
local DamageInfo = DamageInfo;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local IsValid = IsValid;
local SysTime = SysTime;
local unpack = unpack;
local Format = Format;
local Vector = Vector;
local Color = Color;
local pairs = pairs;
local pcall = pcall;
local type = type;
local resource = resource;
local string = string;
local table = table;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local util = util;

--[[ Math Library Localizations --]]
local mathNormalizeAngle = math.NormalizeAngle;
local mathApproach = math.Approach;
local mathRandom = math.random;
local mathRound = math.Round;
local mathClamp = math.Clamp;
local mathFloor = math.floor;
local mathCeil = math.ceil;
local mathSin = math.sin;
local mathMin = math.min;
local mathMax = math.max;
local mathAbs = math.abs;

--[[ String Library Localizations --]]
local stringExplode = string.Explode;
local stringFormat = string.format;
local stringGmatch = string.gmatch;
local stringSub = string.utf8sub;
local stringLen = string.utf8len;
local stringLower = string.lower;
local stringUpper = string.upper;
local stringMatch = string.match;
local stringFind = string.find;
local stringGsub = string.gsub;
local stringByte = string.byte;
local stringRep = string.rep;

--[[ Table Library Localizations --]]
local tableHasValue = table.HasValue;
local tableInsert = table.insert;
local tableRemove = table.remove;
local tableCount = table.Count;
local tableSort = table.sort;
local tableAdd = table.Add;
