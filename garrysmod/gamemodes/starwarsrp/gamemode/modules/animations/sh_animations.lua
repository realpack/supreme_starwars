function GM:PlayerShouldTaunt(ply, actid)
	return false
end

concommand.Remove('act')

if CLIENT then
	netstream.Hook("PlayAnimation", function(ply, act)
		local animation = SUP_ANIMATIONS[act]

		ply:AnimRestartMainSequence()

		if istable(animation) then
			if not animation.taunt then
				ply.sup_animation = act

				ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, ply:LookupSequence( act ), 0, true )
			else
				ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, animation.taunt, true )
			end
		else
			ply.sup_animation = nil

			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
		end
	end)
end