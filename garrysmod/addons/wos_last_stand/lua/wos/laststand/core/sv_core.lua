
--[[-------------------------------------------------------------------
	The Last Stand Server Core:
		Core files for the server to use
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

util.AddNetworkString( "wOS.LastStand.ToggleLS" )
util.AddNetworkString( "wOS.LastStand.SendLastCache" )

wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}
wOS.LastStand.InLastStand = wOS.LastStand.InLastStand or {}

hook.Add( "ScalePlayerDamage", "wOS.LastStand.Reduce", function( ply, hitgroup, dmginfo )
	if ply:WOSGetIncapped() then
		dmginfo:ScaleDamage( 1 )
	end
end )

hook.Add( "EntityTakeDamage", "wOS.LastStand.Incap", function( ply, dmginfo )
	if not ply:IsPlayer() then return end
	if ply:WOSGetIncapped() then return end
	if not ply:Alive() then return end

    local tm = ply:Team()
    if not meta.jobs[ply:Team()] or meta.jobs[ply:Team()].Type == TYPE_JEDI or meta.jobs[ply:Team()].Type == TYPE_DROID then return end

	local diff =  ply:Health() - dmginfo:GetDamage()
	if diff <= 0 then return end
	if diff <= ply:GetMaxHealth()*wOS.LastStand.Percent:GetFloat() then
		ply.WOS_IncapMe = true
		if !ply:IsBot() then
			ply:ConCommand( "wos_ls_force_incap" )
		else
			ply:WOSIncap()
		end
	end
end )

hook.Add( "PlayerDeath", "wOS.LastStand.UndoLastStand", function( ply, hitgroup, dmginfo )
	ply:WOSRevive( true )
end )

hook.Add( "PlayerDisconnected", "wOS.LastStand.UndoLastStand", function( ply, hitgroup, dmginfo )
	wOS.LastStand.InLastStand[ ply ] = nil
end )

hook.Add( "PlayerInitialSpawn", "wOS.LastStand.SendLastStands", function( ply, hitgroup, dmginfo )
	net.Start( "wOS.LastStand.SendLastCache" )
		net.WriteInt( #wOS.LastStand.InLastStand, 32 )
		for id, status in pairs( wOS.LastStand.InLastStand ) do
			net.WriteEntity( id )
			net.WriteBool( status )
		end
	net.Send( ply )
end )

local meta = FindMetaTable( "Player" )

function meta:WOSGetIncapped()
	return self.WOS_InLastStand
end

function meta:WOSSetIncap( bool )
	self.WOS_InLastStand = bool
end

function meta:WOSIncap()
	if self:WOSGetIncapped() then return end
	self.WOS_LastSMinHull, self.WOS_LastSMaxHull = self:GetHull()
	self.WOS_LastSCMinHull, self.WOS_LastSCMaxHull = self:GetHullDuck()
	self:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 24 ) )
	self:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 24 ) )
	self:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE, 981 )
	self:WOSSetIncap( true )
	wOS.LastStand.InLastStand[ self ] = true
	net.Start( "wOS.LastStand.ToggleLS" )
		net.WriteBool( true )
		net.WriteEntity( self )
	net.Broadcast()
end

function meta:WOSRevive( respawn )
	if !self:WOSGetIncapped() then return end
    -- local tm = self:Team()
    -- if meta.jobs[self:Team()].Type == TYPE_JEDI or meta.jobs[self:Team()].Type == TYPE_DROID then return end
	self:SetHull( self.WOS_LastSMinHull, self.WOS_LastSMaxHull )
	self:SetHullDuck( self.WOS_LastSCMinHull, self.WOS_LastSCMaxHull )
	self:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE, 982 )
	self:WOSSetIncap( false )
	wOS.LastStand.InLastStand[ self ] = nil
	net.Start( "wOS.LastStand.ToggleLS" )
		net.WriteBool( false )
		net.WriteEntity( self )
	net.Broadcast()
	if not respawn then
		self:SetHealth( math.max( wOS.LastStand.RevivePercent:GetFloat()*self:GetMaxHealth(), self:Health() ) )
	end
end

hook.Add( "Move", "wOS.LastStand.DontMove", function( ply, mv )
	if !ply:WOSGetIncapped() then return end
	mv:SetForwardSpeed( 0.1 )
	mv:SetSideSpeed( 0.1 )
	mv:SetUpSpeed( 0.1 )
end )

--If you ask me a question about why I'm using console commands trust me, this shit is golden
concommand.Add( "wos_ls_force_incap", function( ply, cmd, args )
	if not ply.WOS_IncapMe then return end
	ply:WOSIncap()
	ply.WOS_IncapMe = nil
end )

concommand.Add( "wos_ls_force_revive", function( ply, cmd, args )
	if not ply.WOS_ReviveMe then return end
	ply:WOSRevive()
	ply.WOS_ReviveMe = nil
end )
