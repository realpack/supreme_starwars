local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "ARF Eagle", "models/player/liquid/arf/eagle/eagletrooper.mdl" )
AddPlayerModel( "ARF Eagle Helmetless", "models/player/liquid/arf/eagle/eaglehelmetless.mdl" )
