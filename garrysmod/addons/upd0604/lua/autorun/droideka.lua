

player_manager.AddValidModel( "Droideka", 		"models/starwars/stan/droidekas/droideka.mdl" );
list.Set( "PlayerOptionsModel", "Droideka", 	"models/starwars/stan/droidekas/droideka.mdl" );

local settings = {
	["name"] = "Droideka",
	["model"] = "models/starwars/stan/droidekas/droideka.mdl",
	["scale"] = 1,
	["developermode"] = false,
	["viewoffset"] = 100,
	["duckviewoffset"] = 90,
	["seatoffset"] = 4,
	["bodygrouptalking"] = false,
	["talkingspeed"] = 0,
	["mouthbodygroup"] = 0,
	["mouthframes"] = 0,
	["mouthstandingframe"] = 0,
	["mouthstartingframe"] = 0
}

local mEnt = FindMetaTable("Entity")

mEnt.NewSetModel = mEnt.NewSetModel || mEnt.SetModel

function mEnt:SetModel(model)

	self.NewSetModel(self, model)

	if(self:IsPlayer()) then

		hook.Run("SPM_ModelChange", self)

	end

end

if(SERVER) then

	util.AddNetworkString(settings["name"].."ResetModel")
	util.AddNetworkString(settings["name"].."RescaleModel")

else

	net.Receive(settings["name"].."ResetModel", function()

		local ply = LocalPlayer()

		if(IsValid(ply)) then

			ply:SetModelScale(1)
			ply:ResetHull()
			ply:SetViewOffset(Vector(0, 0, 64))
			ply:SetViewOffsetDucked(Vector(0, 0, 28))

		end

	end)

	net.Receive(settings["name"].."RescaleModel", function()

		local ply = LocalPlayer()

		if(IsValid(ply)) then

			ply:SetModelScale(settings["scale"])
			ply:SetViewOffset(Vector(0, 0, settings["viewoffset"]))
			ply:SetViewOffsetDucked(Vector(0, 0, settings["duckviewoffset"]))

		end

	end)

end

hook.Add("Tick", settings["name"].."ModelFixes", function()

	for k,v in pairs(player.GetAll()) do

		if(settings["bodygrouptalking"]) then

			if(v:GetNWBool("Is"..settings["name"].."Talking") == true) then

				v:SetBodygroup(settings["mouthbodygroup"], math.floor(CurTime()*settings["talkingspeed"]%settings["mouthframes"]) + settings["mouthstartingframe"])

			else

				if(v:GetModel() == settings["model"]) then

					v:SetBodygroup(settings["mouthbodygroup"], settings["mouthstandingframe"])

				end

			end

		end

	end

end)

hook.Add("SPM_ModelChange", settings["name"].."SpawningFunction", function(ply)

	timer.Simple(0, function()

		if(SPM_Pool[ply:GetModel()] == nil) then

			ply:SetModelScale(1)
			ply:ResetHull()
			ply:SetViewOffset(Vector(0, 0, 64))
			ply:SetViewOffsetDucked(Vector(0, 0, 28))

			net.Start(settings["name"].."ResetModel")
			net.Send(ply)

		end

	end)

	timer.Simple(FrameTime(), function()

		if(SPM_Pool[ply:GetModel()] != nil) then

			local tab = SPM_Pool[ply:GetModel()]

			ply:SetModelScale(tab["scale"])
			ply:SetViewOffset(Vector(0, 0, tab["viewoffset"]))
			ply:SetViewOffsetDucked(Vector(0, 0, tab["duckviewoffset"]))
			net.Start(tab["name"].."RescaleModel")
			net.Send(ply)

		end

	end)

end)


hook.Add("PlayerEnteredVehicle", settings["name"].."VehicleOffset", function(ply, veh)

	if(ply:InVehicle()) then

		if(ply:GetModel() == settings["model"]) then

			ply:SetPos(Vector(0, 0, settings["seatoffset"]))

		end

	end

end)

hook.Add("PostPlayerDeath", settings["name"].."RemoveDeathRagdoll", function(ply)

	if(ply:GetModel() == settings["model"]) then

		local rag = ply:GetRagdollEntity()

		if(IsValid(rag)) then

			rag:Remove()

		end

	end

end)

hook.Add("PostDrawTranslucentRenderables", settings["name"].."DeveloperMode", function()

	local ply = LocalPlayer()

	if(settings["developermode"] == true) then

		if(ply:GetModel() == settings["model"]) then

			local ePos = ply:EyePos()
			local eOffset = (ePos - ply:GetPos()).Z

			if(eOffset == settings["duckviewoffset"]) then
			end

			render.SetColorMaterial()
			render.DrawBox(ply:GetPos() , Angle(0, 0, 0), min, max, Color(255, 0, 0, 150))
			render.DrawBox(ply:EyePos(), Angle(0, 0, 0), Vector(min.X, min.Y, -1), Vector(max.X, max.Y, 1), Color(255, 255, 0, 100))

		end

	end

end)

hook.Add("Initialize", settings["name"].."SetPool", function()

	SPM_Pool = {}

	timer.Simple(FrameTime(), function()

		SPM_Pool[settings["model"]] = settings

	end)

end)
