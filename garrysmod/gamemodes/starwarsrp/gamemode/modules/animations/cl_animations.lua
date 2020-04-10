hook.Add( "CalcMainActivity", "wOS.RollMod.Animations", function( ply, velocity )
	if ply.sup_act then
		local seq = ply.sup_act or 'tlc_animation_otjim'
		local seqid = ply:LookupSequence( seq or "" )

		ply:SetPlaybackRate( 0.05 )

		return -1, seqid or nil
	end
end )

netstream.Hook("ActAnimation", function(ply, act)
	if not act or not SUP_ANIMATIONS[act] then
		ply.sup_act = nil
		return
	end
	ply.sup_act = act

	local time = SUP_ANIMATIONS[act].time
	if time > 0 then
		timer.Simple(time, function()
			ply.sup_act = nil
		end)
	end
end)

concommand.Add( "sup_act", function( ply, cmd, args )
	if not args or not args[1] or not SUP_ANIMATIONS[args[1]] then return end
	netstream.Start('ReqAnimation', args[1])
end )