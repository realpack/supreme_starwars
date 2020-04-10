local matBeam = Material("cable/rope")

function DrawRopeKnives()
	for k,ent in pairs(ents.FindByClass("sent_rope_knife")) do
		if LocalPlayer():GetPos():Distance( ent:GetPos() ) > 16000 then continue end
		if !ent:GetNWBool("Stuck") and !ent:GetNWBool("Useless") and IsValid(ent:GetNWEntity("Owner")) then
			
			local att = ent:GetNWEntity("Owner"):GetAttachment(ent:GetNWEntity("Owner"):LookupAttachment("anim_attachment_RH"))
			if !att then continue end
			local pos = att.Pos
			
			render.SetMaterial(matBeam)
			render.DrawBeam(ent:GetPos(), pos, 2, 0, 1, Color(255,255,255))
		
		elseif !ent:GetNWBool("Useless") and ent:GetNWBool("Stuck") then
			
			local pos = ent:GetPos()
			
			local line = {}
			line.start = pos
			line.endpos = pos + Vector(0,0,-16000)
			line.filter = {ent}
			for k,ply in pairs(player.GetAll()) do
				table.insert(line.filter, ply)
			end
			
			local tr = util.TraceLine( line )
			
			render.SetMaterial(matBeam)
			render.DrawBeam(pos, tr.HitPos, 2, 0, 1, Color(255,255,255))
			
		end
	end
end
hook.Add("PostDrawOpaqueRenderables","DrawRopeKnives",DrawRopeKnives)

hook.Add( "ShouldDrawLocalPlayer", "DrawClimbPlayer", function()
	if IsValid(LocalPlayer():GetNWEntity("ClimbingEnt")) and LocalPlayer():GetMoveType() == MOVETYPE_CUSTOM and GetConVarString( "gk_thirdperson" ) == "1" and GetConVarString( "gk_forcefirstperson" ) == "0" then return true end
end )

function FollowClimbHead( ply, pos, angle, fov )
    if ( !ply:IsValid() or !ply:Alive() or ply:GetViewEntity() != ply ) then return end
	if ply:InVehicle() or !IsValid(ply:GetNWEntity("ClimbingEnt")) or GetConVarString( "gk_thirdperson" ) == "0" or GetConVarString( "gk_forcefirstperson" ) == "1" then return end
	
	pos = pos - angle:Forward()*64
	
	local view = {}
	view.origin = pos
	view.angles = angle
	view.fov = fov
	
	return view
end
hook.Add( "CalcView", "RopeKnifeFollowHead", FollowClimbHead )

function RopeKnifeAnimation( ply, velocity, maxseqgroundspeed )
    if IsValid(ply:GetNWEntity("ClimbingEnt")) and ply:GetMoveType() == MOVETYPE_CUSTOM then
		local speed = ply:GetNWInt("MoveSpeed")
		
		if ply:GetNWEntity("ClimbingEnt"):GetNWBool("MultiAngle") then
			ply:SetRenderAngles( ply:GetNWVector("ClimbNormal"):Angle() )
		else
			ply:SetRenderAngles( ply:GetNWEntity("ClimbingEnt"):GetNWVector("HitNormal"):Angle() )
		end
		ply.CalcSeqOverride = ply:LookupSequence( "zombie_climb_loop" )
		ply:SetSequence( ply.CalcSeqOverride )
		ply:SetPlaybackRate( speed/180 )
		return true
    end
end
hook.Add("UpdateAnimation", "RopeKnifeAnimation", RopeKnifeAnimation)