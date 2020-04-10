hook.Add( "PreGamemodeLoaded", "widgets_disabler_cpu", function()
	MsgN( "Отключаем виджеты..." )
	function widgets.PlayerTick()
		-- empty
	end
	hook.Remove( "PlayerTick", "TickWidgets" )
	MsgN( "Виджеты отключены!" )
end )
