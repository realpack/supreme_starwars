concommand.Add("sup_act", function( ply, cmd, args )
	local animation = SUP_ANIMATIONS[args[1]]

	if istable(animation) then
		ply.sup_animation = animation
		netstream.Start(player.GetAll(), "PlayAnimation", ply, args[1])
	end
end)

local keys = {
	[IN_SPEED] = true,
	[IN_WALK] = true,
	[IN_JUMP] = true,
	[IN_FORWARD] = true,
	[IN_RUN] = true,
	[IN_USE] = true,
	-- [IN_RIGHT] = true,
	-- [IN_LEFT] = true,
	[IN_BACK] = true,
	[IN_DUCK] = true,
}

-- function GM:Move( ply, mv )
hook.Add('Move', 'Animations_Move', function( ply, mv )
	if not ply.sup_animation then return end

	for key, _ in pairs(keys) do
		if mv:KeyDown( key ) then
			netstream.Start(player.GetAll(), "PlayAnimation", ply, nil)
			ply.sup_animation = nil
			break
		end
	end
end)