local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "Croc", "models/player/swtor/arsenic/drakzor/croc.mdl" )
AddPlayerModel( "Croc2", "models/player/swtor/arsenic/drakzor/croc2.mdl" )
