--[[ 
	© Alydus.net
	Do not reupload lua to workshop without permission of the author

	Star Wars Fusion Cutter Repairer
	
	Alydus: (officialalydus@gmail.com | STEAM_0:1:57622640)
--]]

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "F-187 Fusion Cutter"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	surface.CreateFont("Orbitron40", {font = "Orbitron Regular", size = 40})
end

SWEP.Author = "Alydus"
SWEP.Instructions = "A repairing utility weapon."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.WorldModel = ""
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "Alydus's Weapons"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.5

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "error.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Pin"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.297, 0), angle = Angle(0, 0, 0) }
}

SWEP.IronSightsPos = Vector(-13.04, 0, 1.24)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.VElements = {
	["holotablet"] = { type = "Model", model = "models/props/starwars/weapons/fusion_cutter.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.519, 0.518, 1.557), angle = Angle(162.468, -180, 24.545), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["lighteffect"] = { type = "Sprite", sprite = "sprites/animglow02", bone = "ValveBiped.Grenade_body", rel = "holotablet", pos = Vector(9.869, -0.519, 16.104), size = { x = 10, y = 10 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["lighteffect+"] = { type = "Sprite", sprite = "sprites/animglow02", bone = "ValveBiped.Grenade_body", rel = "holotablet", pos = Vector(-1.558, -0.519, 9.67), size = { x = 1.599, y = 1.599 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}

SWEP.WElements = {
	["holotablet"] = { type = "Model", model = "models/props/starwars/weapons/fusion_cutter.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 4.675, 3.635), angle = Angle(-8.183, -17.532, -146.105), size = Vector(0.885, 0.885, 0.885), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["lighteffect"] = { type = "Sprite", sprite = "sprites/animglow02", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.104, -1.558, -12.988), size = { x = 10, y = 10 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}

if SERVER then
	hook.Add("PlayerSwitchWeapon", "Alydus_PlayerSwitchWeapon_FusionCutterInit", function(ply, oldWep, newWep)
		if IsValid(ply) and IsValid(oldWep) and IsValid(newWep) then
			if newWep:GetClass() == "alydus_fusioncutter" then
				ply:EmitSound("HL1/fvox/blip.wav")
			elseif ply:HasWeapon("alydus_fusioncutter") and IsValid(oldWep) and oldWep:GetClass() == "alydus_fusioncutter" then
				ply:EmitSound("HL1/fvox/hiss.wav")
			end
		end
	end)

	repairDatabase = {}
	repairDatabase["func_door"] = function(fusionCutter, ent, trace)
		ent:Fire("Unlock", 1, 0)
		ent:Fire("Open", 1, 0)

		ParticleEffect("electrical_arc_01_system", ent:GetPos(), Angle(0, 0, 0))
	end
	repairDatabase["func_door_rotating"] = function(fusionCutter, ent, trace)
		repairDatabase["func_door"](fusionCutter, ent, trace)
	end
	repairDatabase["prop_door"] = function(fusionCutter, ent, trace)
		repairDatabase["func_door"](fusionCutter, ent, trace)
	end
	repairDatabase["prop_door_rotating"] = function(fusionCutter, ent, trace)
		repairDatabase["func_door"](fusionCutter, ent, trace)
	end
	repairDatabase["alydus_destructablefortification"] = function(fusionCutter, ent, trace)
		if alydusDestructableFortificationExtension and GetConVar("alydus_defaultfortificationhealth") then
			local defaultHealth = GetConVar("alydus_defaultfortificationhealth"):GetInt()
			local hp = ent:GetNWInt("fortificationHealth", false)

			if hp == false then
				return false
			end

			if hp <= defaultHealth - 50 then
				hp = hp + 50
			else
				hp = defaultHealth
			end

			if hp != ent:GetNWInt("fortificationHealth") then
				ent:SetNWInt("fortificationHealth", hp)
				return true
			else
				return false
			end
		end
	end

	repairDatabase["droneRefuel"] = function(fusionCutter, ent, trace)
		if ent:IsDroneDestroyed() then
			return false
		else
			if math.Round(ent:GetFuel()) < ent.MaxFuel then
				ent:SetFuel(ent:GetFuel() + 10)
				return true
			else
				return false
			end
		end
	end
	repairDatabase["starwarsVehicleRepair"] = function(fusionCutter, ent, trace)
		local hp = ent:GetNWInt("Health", 0)

		if hp <= ent.StartHealth - 50 then
			hp = hp + 50
		else
			hp = ent.StartHealth
		end

		if hp != ent:GetNWInt("Health", 0) then
			ent:SetNWInt("Health", hp)
			return true
		else
			return false
		end
	end
	repairDatabase["lfsVehicleRepair"] = function(fusionCutter, ent, trace)
		local hp = ent:GetHP()

		if hp <= ent.MaxHealth - 50 then
			hp = hp + 50
		else
			hp = ent.MaxHealth
		end

		if hp != ent:GetHP() then
			ent:SetHP(hp)
			return true
		else
			return false
		end
	end
	repairDatabase["scarsVehicleRepair"] = function(fusionCutter, ent, trace)
		if ent:IsDamaged() then
			ent.DoRepair = true
			ent:EmitSound("carStools/tune.wav", 100, math.random(80, 150))
			return true
		end
		
		return false
	end

	function exceptionContinue(ent)
		if ent.IS_DRR then
			return "droneRefuel"
		elseif ent.IsSWVehicle then
			return "starwarsVehicleRepair"
		elseif ent.LFS then
			return "lfsVehicleRepair"
		elseif string.find(ent:GetClass(), "sent_sakarias_car") or string.find(ent:GetClass(), "sent_sakarias_carwheel") or string.find(ent:GetClass(), "sent_sakarias_carwheel_punked") then
			return "scarsVehicleRepair"
		end
		return false
	end
end

function SWEP:PostDrawViewModel(vm, wep, ply)
	if CLIENT then
		local ply = self:GetOwner()
		local fade = math.abs(math.sin(CurTime() * 1.15))
		local bone = "ValveBiped.Grenade_body"

		if IsValid(vm) and IsValid(ply) and ply:HasWeapon(self:GetClass()) and vm:LookupBone(bone) then
			local atch = vm:GetBoneMatrix(vm:LookupBone(bone))
			local pos, ang = vm:GetBonePosition(vm:LookupBone(bone)), vm:GetBoneMatrix(vm:LookupBone(bone)):GetAngles()
			ang:RotateAroundAxis(ang:Right(), 90)

			cam.Start3D2D(pos - ang:Right() * 6 - ang:Forward() * 6.5 + ang:Right() * 5.65, Angle(0, ply:EyeAngles().y, ang.z) + Angle(180, 90, 160), 0.01)
				draw.SimpleText("| F-187 Fusion Cutter |", "Orbitron40", -300, -180, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("LMB: Attempt Repair", "Orbitron40", -300, -140, Color(200, 200, 200, 255 * fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local plyEyeTrace = ply:GetEyeTrace()
		local vm = ply:GetViewModel()
		local bone = "ValveBiped.Grenade_body"

		if IsValid(ply) and IsValid(plyEyeTrace.Entity) then
			if repairDatabase[plyEyeTrace.Entity:GetClass()] or exceptionContinue(plyEyeTrace.Entity) != false then
				if ply:GetPos():Distance(plyEyeTrace.Entity:GetPos()) > 300 then
					ply:EmitSound("items/medshotno1.wav")
				else
					local success = false
					if exceptionContinue(plyEyeTrace.Entity) == false then
						success = repairDatabase[plyEyeTrace.Entity:GetClass()](self, plyEyeTrace.Entity, plyEyeTrace)
					else
						success = repairDatabase[exceptionContinue(plyEyeTrace.Entity)](self, plyEyeTrace.Entity, plyEyeTrace)
					end

					if success == true then
						local effectdata = EffectData()
						effectdata:SetOrigin(plyEyeTrace.HitPos)
						effectdata:SetMagnitude(3)
						effectdata:SetScale(5)
						effectdata:SetRadius(2)
						util.Effect("cball_explode", effectdata, true, true)

						sound.Play("HL1/ambience/port_suckin1.wav", plyEyeTrace.HitPos, 75, 100, 1)

						if IsValid(vm) and vm:LookupBone(bone) then
							local atch = vm:GetBoneMatrix(vm:LookupBone(bone))
							local pos, ang = vm:GetBonePosition(vm:LookupBone(bone)), vm:GetBoneMatrix(vm:LookupBone(bone)):GetAngles()

							local effectData = EffectData()
							effectData:SetOrigin(pos)
							util.Effect("MuzzleFlash", effectData, true, true)

							local effectData = EffectData()
							effectData:SetOrigin(pos)
							effectData:SetNormal(pos:GetNormalized())
							effectData:SetMagnitude(1)
							effectData:SetScale(1)
							effectData:SetRadius(2)
							util.Effect("Sparks", effectData)
						end
					else
						ply:EmitSound("items/medshotno1.wav")
					end
				end
			else
				ply:EmitSound("items/medshotno1.wav")
			end

			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Initialize()
	self:SetHoldType("slam")
	if CLIENT then
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)

		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)
		
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
				local fade = math.abs(math.sin(CurTime() * 1.15))
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				if name != "lighteffect+" then
					render.DrawSprite(drawpos, v.size.x, v.size.y, Color(192, 57, 43, 255 * fade))
				else
					render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				end
				
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

	function SWEP:CreateModels( tab )
		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

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