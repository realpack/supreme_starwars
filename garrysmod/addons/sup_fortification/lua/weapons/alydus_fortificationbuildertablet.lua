AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Фортификация"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	surface.CreateFont("Alydus.FortificationsTablet.Title", {font = "Play Bold", extended = true, size = 50})
	surface.CreateFont("Alydus.FortificationsTablet.Subtitle", {font = "Play Bold", extended = true, size = 30})

	if GAMEMODE.IsSandboxDerived then
		language.Add("SBoxLimit_fortifications", "Вы достигли лимита создании Фортификаций!")
	end

	language.Add("Undone_Fortification", "Убрана Фортификация")

	language.Add("Cleanup_fortifications", "Фортификации")
	language.Add("Cleaned_fortifications", "Очтчищены все Фортификации")
elseif SERVER then
	CreateConVar("sbox_maxfortifications", 35)
end

cleanup.Register("fortifications")

SWEP.Author = "Alydus"
SWEP.Instructions = "A utility weapon that allows the user to build fortifications."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.WorldModel = ""
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "SUP | Инженерный Взвод"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 3.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 3.5

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel				= "models/milrp/weapons/antitank/v_mine.mdl"
SWEP.WorldModel				= "models/milrp/weapons/antitank/w_mine.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Fortifications = {
	{name = "Укрытие #1", model = "models/props/swsandbags.mdl"},
	{name = "Укрытие #2", model = "models/props/swsandbuild1.mdl"},
	{name = "Укрытие #3", model = "models/galactic/me3fix/wall_cover01_l.mdl"},
	{name = "Укрытие #4", model = "models/props/swfortification.mdl"},
	{name = "Укрытие #5", model = "models/galactic/me3fix/wall_concrete01.mdl"},
}

hook.Add("Alydus.FortificationBuilderTablet.AddFortification", "Alydus_FortificationBuilderTablet_AddFortificationHook", function(fortification)
	if fortification["name"] and fortification["model"] then
		table.insert(SWEP.Fortifications, fortification)
	else
		print("Недопустимые данные фортификации, не удалось добавить фортификацию. Укажите название и модель.")
	end
end)

SWEP.FortificationsModelList = {}

print("Кэширование моделей укреплений для укрытий...")

for _, fortification in pairs(SWEP.Fortifications) do
	util.PrecacheModel(fortification["model"])
	table.insert(SWEP.FortificationsModelList, fortification["model"])
end

print("Fortifications models successfully cached.")

if SERVER then

	hook.Add("KeyPress", "Alydus_KeyPress_HandleBuildTabletHologramFinished", function(ply, key)
		if key == IN_USE and IsValid(ply) and ply:Alive() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "alydus_fortificationbuildertablet" and ply:GetActiveWeapon().fortificationSelection and ply:GetEyeTrace().HitPos:Distance(ply:GetPos()) <= 250 then
			if ply:GetCount("fortifications") < GetConVar("sbox_maxfortifications"):GetInt() then
				if (ply:GetEyeTrace().Entity and ply:GetEyeTrace().Entity:IsPlayer()) or ply:Crouching() or (IsValid(ply:GetEyeTrace().Entity) and table.HasValue(ply:GetActiveWeapon().FortificationsModelList, ply:GetEyeTrace().Entity:GetModel())) or hook.Call("Alydus.FortificationBuilderTablet.CanBuildFortification", ply) or (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "alydus_fortificationbuildertablet" and ply:GetActiveWeapon():GetNWBool("tabletBootup", false) == true) then
					ply:SendLua("surface.PlaySound(\"common/warning.wav\")")
				else
					local fortificationClass = "prop_physics"
					if alydusDestructableFortificationExtension then
						fortificationClass = "alydus_destructablefortification"
					end

					local fortification = ents.Create(fortificationClass)
					fortification:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
					fortification:SetPos(ply:GetEyeTrace().HitPos - ply:GetEyeTrace().HitNormal * ply.fortificationHologram:OBBMins().z)
					if alydusDestructableFortificationExtension then
						fortification:SetNWInt("fortificationHealth", GetConVar("alydus_defaultfortificationhealth"):GetInt())
					else
						fortification:SetModel(ply:GetActiveWeapon().Fortifications[ply:GetActiveWeapon().fortificationSelection]["model"])
					end
					fortification:Spawn()
					if alydusDestructableFortificationExtension then
						fortification:SetModel(ply:GetActiveWeapon().Fortifications[ply:GetActiveWeapon().fortificationSelection]["model"])
					end
					fortification:SetGravity(150)
					fortification.isPlayerPlacedFortification = ply

					ply:AddCount("fortifications", fortification)
					ply:AddCleanup("fortifications", fortification)

					fortification:EmitSound("physics/concrete/rock_impact_hard" .. math.random(1, 6) .. ".wav")

					local phys = fortification:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetMass(50000)
						phys:EnableMotion(false)
					end

					undo.Create("Fortification")
						undo.AddEntity(fortification)
						undo.SetPlayer(ply)
					undo.Finish()
				end
			else
				ply:LimitHit("fortifications")
			end
		end
	end)

	hook.Add("PlayerSwitchWeapon", "Alydus_PlayerSwitchWeapon_FortificationBuilderTabletBootup", function(ply, oldWep, newWep)
		if newWep:GetClass() == "alydus_fortificationbuildertablet" and newWep:GetNWBool("tabletBootup", false) != true then
			newWep:SetNWBool("tabletBootup", true)
			newWep.fortificationSelection = newWep.fortificationSelection or 1
			timer.Simple(2.5, function()
				if ply:GetNWBool("tabletBootup", false) == false and ply:HasWeapon("alydus_fortificationbuildertablet") then
					ply:EmitSound("npc/scanner/combat_scan4.wav")
					newWep:SetNWBool("tabletBootup", false)
				end
			end)
		elseif ply:HasWeapon("alydus_fortificationbuildertablet") and IsValid(oldWep) and oldWep:GetClass() == "alydus_fortificationbuildertablet" then
			ply:EmitSound("npc/roller/mine/combine_mine_deactivate1.wav")

			if ply.fortificationHologram != nil and IsValid(ply.fortificationHologram) then
				ply.fortificationHologram:Remove()
				ply.fortificationHologram = nil
			end
		end
	end)
	hook.Add("PlayerTick", "Alydus_PlayerTick_FortificationBuilderTabletHologram", function(ply, mv)
		local wep = ply:GetActiveWeapon()
		local ang = ply:GetAngles()
		local tr = ply:GetEyeTrace()

		if IsValid(ply) and ply:Alive() and ply:HasWeapon("alydus_fortificationbuildertablet") and IsValid(wep) and wep:GetClass() == "alydus_fortificationbuildertablet" and wep:GetNWBool("tabletBootup", false) == false and wep.fortificationSelection != nil then
			if not IsValid(ply.fortificationHologram) then
				ply.fortificationHologram = ents.Create("prop_physics")
				if ply.fortificationHologram and IsValid(ply.fortificationHologram) and tr and tr.HitPos and isvector(tr.HitPos) and tr.HitNormal and isvector(tr.HitNormal) then
					ply.fortificationHologram:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
					ply.fortificationHologram:SetPos(tr.HitPos - tr.HitNormal * ply.fortificationHologram:OBBMins().z)
					ply.fortificationHologram:SetColor(Color(46, 204, 113, 150))
					ply.fortificationHologram:SetModel(wep.Fortifications[wep.fortificationSelection]["model"])
					ply.fortificationHologram:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
					ply.fortificationHologram:SetRenderMode(RENDERMODE_TRANSALPHA)
					ply.fortificationHologram:Spawn()
					ply.fortificationHologram:SetNWString("alydusFortificationHologramName", wep.Fortifications[wep.fortificationSelection]["name"])
					ply.fortificationHologram:EmitSound("physics/concrete/rock_impact_hard1.wav")
				else
					ply.fortificationHologram = nil
				end
			elseif IsValid(ply.fortificationHologram) then
				if ply:Crouching() or ply:GetVelocity():Length() > 15 or (IsValid(tr.Entity) and table.HasValue(wep.FortificationsModelList, tr.Entity:GetModel())) then
					ply.fortificationHologram:SetColor(Color(255, 255, 255, 0))
				else
					if ply.fortificationHologram:GetModel() != wep.Fortifications[wep.fortificationSelection]["model"] then
						ply.fortificationHologram:SetModel(wep.Fortifications[wep.fortificationSelection]["model"])
						ply.fortificationHologram:SetNWString("alydusFortificationHologramName", wep.Fortifications[wep.fortificationSelection]["name"])
					end
					ply.fortificationHologram:SetPos(tr.HitPos - tr.HitNormal * ply.fortificationHologram:OBBMins().z)
					ply.fortificationHologram:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
					if tr.HitPos:Distance(ply:GetPos()) >= 250 then
						ply.fortificationHologram:SetColor(Color(255, 255, 255, 0))
					elseif ply.fortificationHologram:GetColor().a == 0 then
						ply.fortificationHologram:SetColor(Color(46, 204, 113, 150))
					end
				end
			end
		elseif ply.fortificationHologram != nil and IsValid(ply.fortificationHologram) then
			ply.fortificationHologram:Remove()
			ply.fortificationHologram = nil
		end
	end)
else
	hook.Add("PostDrawTranslucentRenderables","Alydus_PostDrawOpaqueRenderables_EntityDisplays", function()
		local ply = LocalPlayer()

		-- Selected Fortification Display
		if IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "alydus_fortificationbuildertablet" and ply:Alive() and not ply:Crouching() and ply:GetVelocity():Length() < 25 then
			for _, v in pairs(ents.GetAll()) do
				if IsValid(v) and v:GetPos():Distance(LocalPlayer():GetPos()) <= 250 then
					if v:GetClass() == "prop_physics" and v:GetNWString("alydusFortificationHologramName", false) != false and not (ply:GetEyeTrace().Entity and (ply:GetEyeTrace().Entity:GetClass() == "prop_physics" or ply:GetEyeTrace().Entity:GetClass() == "alydus_destructablefortification")) then
						local offset = Vector(0, 0, 50)
						local ang = LocalPlayer():EyeAngles()
						local pos = v:GetPos() + offset + ang:Up()

						ang:RotateAroundAxis(ang:Forward(), 90)
						ang:RotateAroundAxis(ang:Right(), 90)

						local fade = math.abs(math.sin(CurTime() * 3))

						cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.10)
							draw.DrawText("Выбор Фортификаций", "Alydus.FortificationsTablet.Title", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
							draw.DrawText(v:GetNWString("alydusFortificationHologramName", "Unknown Fortification"), "Alydus.FortificationsTablet.Subtitle", 0, 60, Color(150, 150, 150), TEXT_ALIGN_CENTER)
						cam.End3D2D()
					elseif v:GetClass() == "alydus_destructablefortification" and v:GetNWInt("fortificationHealth", false) != false then
						local offset = Vector(0, 0, 65)
						local ang = LocalPlayer():EyeAngles()
						local pos = v:GetPos() + offset + ang:Up()

						ang:RotateAroundAxis(ang:Forward(), 90)
						ang:RotateAroundAxis(ang:Right(), 90)

						local fade = math.abs(math.sin(CurTime() * 3))

						cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.10)
							draw.DrawText("Разрушаемое Укрытие", "Alydus.FortificationsTablet.Title", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
							draw.DrawText(math.Round(v:GetNWInt("fortificationHealth", 0)) .. " целостность", "Alydus.FortificationsTablet.Subtitle", 0, 60, Color(150, 150, 150), TEXT_ALIGN_CENTER)
						cam.End3D2D()
					end
				end
			end
		end
	end)
end

function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		if IsValid(ply) and ply:Alive() and IsValid(ply.fortificationHologram) and self.fortificationSelection != nil and not ply:Crouching() and ply:GetVelocity():Length() < 25 then
			if ply:GetEyeTrace().HitPos:Distance(ply:GetPos()) >= 250 then
				ply:SendLua("surface.PlaySound(\"common/warning.wav\")")
				return
			end
			if self.Fortifications[self.fortificationSelection + 1] then
				self.fortificationSelection = self.fortificationSelection + 1
			else
				self.fortificationSelection = 1
			end
			ply.fortificationHologram:EmitSound("physics/concrete/rock_impact_hard1.wav")
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		if IsValid(ply) and ply:Alive() and IsValid(ply.fortificationHologram) and self.fortificationSelection != nil and not ply:Crouching() and ply:GetVelocity():Length() < 25 then
			if ply:GetEyeTrace().HitPos:Distance(ply:GetPos()) >= 250 then
				ply:SendLua("surface.PlaySound(\"common/warning.wav\")")
				return
			end
			if self.Fortifications[self.fortificationSelection - 1] then
				self.fortificationSelection = self.fortificationSelection - 1
			else
				self.fortificationSelection = table.Count(self.Fortifications)
			end
			ply.fortificationHologram:EmitSound("physics/concrete/rock_impact_hard3.wav")
		end
	end
end

function SWEP:Reload()
	if SERVER then
		local ply = self:GetOwner()
		if not self.Owner:KeyPressed(IN_RELOAD) then 
			return
		end
		if IsValid(ply) and ply:Alive() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "alydus_fortificationbuildertablet" and ply:GetActiveWeapon().fortificationSelection then
			if ply:GetEyeTrace().Entity.isPlayerPlacedFortification == ply then
				ply:GetEyeTrace().Entity:EmitSound("physics/concrete/rock_impact_hard" .. math.random(1, 6) .. ".wav")
				ply:GetEyeTrace().Entity:Remove()
			end
		end
		return
	end
end

if CLIENT then
	local wrenchMat = Material("alydus/icons/wrench.png")
	local nextMat = Material("alydus/icons/next.png")
	local lastMat = Material("alydus/icons/last.png")
	local shieldMat = Material("alydus/icons/shield.png")
	local refreshMat = Material("alydus/icons/refresh.png")

	local toolsMat = Material("alydus/icons/tools.png")

	local useBind = input.LookupBinding("+use") or "E"
	local reloadBind = input.LookupBinding("+reload") or "R"
end

function SWEP:GetViewModelPosition( pos, ang )
	self.SwayScale = 0;
	self.BobScale = 0.1;

	return pos, ang;
end

function SWEP:Initialize()
	self:SetHoldType("slam")
	if CLIENT then
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v)
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

