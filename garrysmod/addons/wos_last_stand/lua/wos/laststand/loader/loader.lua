
--[[-------------------------------------------------------------------
	The Last Stand Real Loader:
		We do all the actual loading here
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


wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}

local dir = "wos/laststand"

if SERVER then
	AddCSLuaFile( dir .. "/core/sh_core.lua" )
	AddCSLuaFile( dir .. "/core/cl_core.lua" )
	include( dir .. "/core/sv_core.lua" )
else
	include( dir .. "/core/cl_core.lua" )
end

include( dir .. "/core/sh_core.lua" )