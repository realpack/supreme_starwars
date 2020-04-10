// Destructable Fortifications Extension by Alydus

// If you'd like to modify this, go ahead, but please leave appropriate credit.
// Please do not reupload this code to the workshop, as it creates a multitude of problems - however, you can download it from the workshop and install it on your server to modify.
// Additionally, note that this addon will not function if the fortification builder tablet is not installed.

alydusDestructableFortificationExtension = true

CreateConVar("alydus_defaultfortificationhealth", 3500)

hook.Add("PlayerButtonDown", "Alydus_PlayerButtonDown_RepairFortificationsButton", function(ply, button)
	if button == KEY_G and IsValid(ply) and ply:IsPlayer() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "alydus_fortificationbuildertablet" and ply:GetActiveWeapon():GetNWBool("tabletBootup", false) == false and IsValid(ply:GetEyeTrace().Entity) and ply:GetEyeTrace().Entity:GetClass() == "alydus_destructablefortification" then
		local health = ply:GetEyeTrace().Entity:GetNWInt("fortificationHealth")
		if GetConVar("alydus_defaultfortificationhealth"):GetInt() > (tonumber(health) + 5) then
			ply:GetEyeTrace().Entity:SetNWInt("fortificationHealth", ply:GetEyeTrace().Entity:GetNWInt("fortificationHealth") + 5)
			ply:EmitSound("ambient/machines/catapult_throw.wav")
		end
	end
end)