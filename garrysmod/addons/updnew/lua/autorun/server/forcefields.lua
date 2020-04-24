print"lol"
if engine.ActiveGamemode() == "cwhl2rp" then
local PLUGIN = PLUGIN;





-- A function to save the fields.
function LoadFields()
	local fields = Clockwork.kernel:RestoreSchemaData("plugins/forcefields_new/"..game.GetMap());
	
	for k, v in pairs(fields) do
		local entity = ents.Create("forcefield_new");
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		print"AAAAA"
		entity:Activate();

		local physicsObject = entity:GetPhysicsObject();
		
		if ( IsValid(physicsObject) ) then
			physicsObject:EnableMotion(false);
		end;
	end;
end;



-- A function to save the fields.
function SaveFields()
	local fields = {};
	
	for k, v in pairs(ents.FindByClass("forcefield_new")) do
		local position = v:GetPos();
		local angles = v:GetAngles();
		local mode = v.mode or false;
		fields[#fields + 1] = {
			position = position,
			angles = angles,
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/forcefields_new/"..game.GetMap(), fields);
end;
-- Called when OpenAura has loaded all of the entities.
hook.Add( "InitPostEntity", "some_unique_name", function()
    LoadFields();
end )


-- Called when data should be saved.
timer.Create( "SaveForceFields", 3, 0, function()
	SaveFields();
end)

end


