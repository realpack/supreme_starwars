
--[[-------------------------------------------------------------------
	The Last Stand Shared Core:
		Core files in shared form
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


wOS.LastStand.ReviveTime = CreateConVar( "wos_ls_revivetime", "5", { FCVAR_ARCHIVE, FCVAR_REPLICATED  } )
wOS.LastStand.Percent = CreateConVar( "wos_ls_percent", "0.25", { FCVAR_ARCHIVE, FCVAR_REPLICATED } )
wOS.LastStand.CanShoot = CreateConVar( "wos_ls_canshoot", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED } )
wOS.LastStand.RevivePercent = CreateConVar( "wos_ls_revived_percent", "0.5", { FCVAR_ARCHIVE, FCVAR_REPLICATED } )
wOS.LastStand.JobRestrict = CreateConVar( "wos_ls_enable_jobrestrict", "0", { FCVAR_ARCHIVE, FCVAR_REPLICATED } )

wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}
wOS.LastStand.InLastStand = wOS.LastStand.InLastStand or {}

wOS.LastStand.JobTable = {}

function wOS.LastStand:AddJob( teamnum )
	if not teamnum then return end
	wOS.LastStand.JobTable[ teamnum ] = true
end

hook.Add( "DoAnimationEvent" , "wOS.LastStand.CallIncap" , function( ply, event, data )
	if event == PLAYERANIMEVENT_ATTACK_GRENADE  then
		local seq
		if data == 981 then
			seq = ply:LookupSequence( "wos_l4d_collapse_to_incap" )
		elseif data == 982 then
			seq = ply:LookupSequence( "wos_l4d_getup_from_pounced" )
		end
		if not seq or seq < 0 then return end
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, seq, 0, true ) 
		return ACT_INVALID
	end
end )

hook.Add( "CalcMainActivity", "wOS.LastStand.IdleAnim", function( ply )
	if !wOS.LastStand.InLastStand[ ply ] and !ply:GetNW2Bool( "wOS.LS.IsReviving", false ) then return end
	local seq = ply:LookupSequence( "wos_l4d_idle_incap_pistol" )
	if ply:GetNW2Bool( "wOS.LS.IsReviving", false ) then
		seq = ply:LookupSequence( "wos_l4d_heal_incap_crouching" )
	end
	if seq < 0 then return end
	return -1, seq
end )

hook.Add( "Move", "wOS.LastStand.DontMove", function( ply, mv ) 
	if !wOS.LastStand.InLastStand[ ply ] and !ply.WOS_LastStandIsReviving then return end
	mv:SetForwardSpeed( 0.1 )
	mv:SetSideSpeed( 0.1 )
	mv:SetUpSpeed( 0.1 )
end )

hook.Add( "KeyPress", "wOS.LastStand.ReviveCheck", function( ply, key )
	if wOS.LastStand.JobRestrict:GetBool() and not wOS.LastStand.JobTable[ ply:Team() ] then return end
	if ply.WOS_LastStandKT and ply.WOS_LastStandKT >= CurTime() then return	end
	if ( key == IN_USE ) and ply:KeyDown( IN_DUCK ) then
		local tr = util.TraceLine( util.GetPlayerTrace( ply ) )
		if tr.Entity and tr.Entity:GetPos():DistToSqr( ply:GetPos() ) <= 7000 and tr.Entity:IsPlayer() then
			if wOS.LastStand.InLastStand[ tr.Entity ] then
				ply.WOS_LastStandIsReviving = true
				ply:SetCycle( 0 )
				ply.WOS_LastStandHeld = CurTime()
				ply.WOS_LastStandChild = tr.Entity
				if SERVER then
					ply:SetNW2Bool( "wOS.LS.IsReviving", true )
				end
			end
		end
		ply.WOS_LastStandKT = CurTime() + 0.2
	end
end )

hook.Add( "KeyRelease", "wOS.LastStand.ReviveUncheck", function( ply, key )
	if ply.WOS_LastStandIsReviving and ( key == IN_USE ) then
		ply.WOS_LastStandKT = CurTime() + 0.2
		ply.WOS_LastStandIsReviving = false
		if SERVER then
			ply:SetNW2Bool( "wOS.LS.IsReviving", false )
			if CurTime() - ply.WOS_LastStandHeld >= wOS.LastStand.ReviveTime:GetFloat() then
				if IsValid( ply.WOS_LastStandChild ) and ply.WOS_LastStandChild:WOSGetIncapped() then
					ply.WOS_LastStandChild.WOS_ReviveMe = true
					if !ply.WOS_LastStandChild:IsBot() then
						ply.WOS_LastStandChild:ConCommand( "wos_ls_force_revive" )
					else
						ply.WOS_LastStandChild:WOSRevive()
					end
				end
			end
		end
		ply.WOS_LastStandChild = nil
		ply.WOS_LastStandHeld = nil
	end
end )
