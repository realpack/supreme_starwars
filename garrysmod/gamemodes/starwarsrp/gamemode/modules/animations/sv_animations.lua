netstream.Hook("ReqAnimation", function(ply, act)
	print(ply, act)
	if not act or not SUP_ANIMATIONS[act] then return end
	-- ply:Freeze(true)
	ply.sup_act = act
	netstream.Start(player.GetAll(), "ActAnimation", ply, act)

	local time = SUP_ANIMATIONS[act].time

	if time > 0 then
		timer.Simple(time, function()
			ply.sup_act = nil
			-- ply:Freeze(false)
		end)
	end
end)

local keys = {
	[IN_SPEED] = true,
	[IN_WALK] = true,
	[IN_JUMP] = true,
	[IN_FORWARD] = true,
	[IN_RUN] = true,
	[IN_USE] = true,
	[IN_RIGHT] = true,
	[IN_LEFT] = true,
	[IN_BACK] = true,
}

-- function GM:Move( ply, mv )
hook.Add('Move', 'Animations_Move', function( ply, mv )
	if not ply.sup_act then return end

	for key, _ in pairs(keys) do
		if mv:KeyDown( key ) then
			netstream.Start(player.GetAll(), "ActAnimation", ply, nil)
			ply.sup_act = nil
			break
		end
	end
end)