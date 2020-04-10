SWEP.ViewModelFOV = 20
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_bugbait.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["bucket"] = { type = "Model", model = "models/galactic/me3fix/ammocase02.mdl", bone = "ValveBiped.cube", rel = "", pos = Vector(0,0, -1.593), angle = Angle(-69.873, 54.22, -3.241), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["bucket"] = { type = "Model", model = "models/galactic/me3fix/ammocase02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.17, 5.129, 0.8), angle = Angle(5.981, 64.361, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.UseHands = false
SWEP.Slot = 5 
SWEP.HoldType = "slam" 
SWEP.PrintName = "Выдача Боеприпасов"  
SWEP.Author = "Attache+KTKyct" 
SWEP.Spawnable = true  
SWEP.Weight = 5 
SWEP.DrawCrosshair = true 
SWEP.Category 				= "SUP | Инженерный Взвод"
SWEP.SlotPos = 5 
SWEP.DrawAmmo = true  
SWEP.Instructions = "Left click to spawn sw ammo!"   
SWEP.Contact = ""  
SWEP.Purpose = "The clips are limited" 
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 12  
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipMax = 16
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = "AR2AltFire"  
--SWEP.Secondary.NumShots = 1
SWEP.Secondary.ClipSize = -1
--SWEP.Secondary.DefaultClip = 10
--SWEP.Secondary.Clipmax = 10
--SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"    
SWEP.Atypes = 1
--
function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
--
function SWEP:Reload()
	--if self.Owner:GetAmmoCount( self.Primary.Ammo ) == 0 then return end
	--if self:Clip1() == 6 then return end
	--self:DefaultReload( ACT_VM_RELOAD ) -- animation for reloading
    if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
self:DefaultReload( ACT_VM_RELOAD )
                local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
             self.ReloadingTime = CurTime() + AnimationTime

if self.Atypes == 1 then
self.Atypes = 2
if (CLIENT) then 
            self.Owner:PrintMessage( HUD_PRINTTALK,  "SMG(Снайперки)" )
        end

elseif self.Atypes == 2 then
self.Atypes = 3
if (CLIENT) then 
                self.Owner:PrintMessage( HUD_PRINTTALK, "RPG_ROUND(гранатки)" )
        end

elseif self.Atypes == 3 then
self.Atypes = 1
if (CLIENT) then 
            self.Owner:PrintMessage( HUD_PRINTTALK, "AR2")
        end

end
end


--
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:PrimaryAttack()
    if self:Clip1() <= 0 then return end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound("physics/metal/metal_grenade_impact_hard1.wav")
    --Start cycle (AR2-1)
    if self.Atypes == 1 then
	   if SERVER then
		  local grenade = ents.Create("AR2_blasters")
		  --grenade:SetOwner(self.Owner)
		  grenade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 50))
		  grenade:SetAngles(self.Owner:GetAngles())
            self.Owner:MuzzleFlash()
		  grenade:Spawn()
		  grenade:Activate()
            self.Weapon:TakePrimaryAmmo(1)
            --self.Weapon:Reload() // If you want to make their life harder...
		  local phys = grenade:GetPhysicsObject()
		  phys:ApplyForceCenter(self.Owner:GetAimVector() * 250)
		  self:SetNextPrimaryFire(CurTime() + 0.3)
        --   timer.Create( "CleanTheCrap", 10, 1, function() self.Entity:Remove() end )
        end
	end
    
    -- Second cycle (SMG)
    if self.Atypes == 2 then
	   if SERVER then
		  local grenade = ents.Create("SMG_Snipers")
		  --grenade:SetOwner(self.Owner)
		  grenade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 50))
		  grenade:SetAngles(self.Owner:GetAngles())
            self.Owner:MuzzleFlash()
		  grenade:Spawn()
		  grenade:Activate()
            self.Weapon:TakePrimaryAmmo(1)
            --self.Weapon:Reload() // If you want to make their life harder...
		  local phys = grenade:GetPhysicsObject()
		  phys:ApplyForceCenter(self.Owner:GetAimVector() * 250)
		  self:SetNextPrimaryFire(CurTime() + 0.3)
        --   timer.Create( "CleanTheCrap", 10, 1, function() self.Entity:Remove() end )
        end
	end
    -- Third cycle (RPG)
        if self.Atypes == 3 then
	   if SERVER then
		  local grenade = ents.Create("RPG_grenades")
		  --grenade:SetOwner(self.Owner)
		  grenade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 50))
		  grenade:SetAngles(self.Owner:GetAngles())
            self.Owner:MuzzleFlash()
		  grenade:Spawn()
		  grenade:Activate()
            self.Weapon:TakePrimaryAmmo(1)
            --self.Weapon:Reload() // If you want to make their life harder...
		  local phys = grenade:GetPhysicsObject()
		  phys:ApplyForceCenter(self.Owner:GetAimVector() * 250)
		  self:SetNextPrimaryFire(CurTime() + 0.3)
        --   timer.Create( "CleanTheCrap", 10, 1, function() self.Entity:Remove() end )
        end
	end
    --
    
end

function SWEP:SecondaryAttack()
    if self:Clip1() <= 0 then return end
--if (self.Owner:IsPlayer()) then
    if self.Atypes == 1 then
            if (SERVER) then
		      self.Owner:GiveAmmo(100,"ar2");
        end
            if (CLIENT) then
		      self.Owner:PrintMessage( HUD_PRINTTALK, "Вы приобрели 100 патронов ar2(бластеры)" )
        end
        self.Weapon:TakePrimaryAmmo(1)
        self:SetNextSecondaryFire(CurTime() + 0.7)
--	end
    end
        if self.Atypes == 2 then
            if (SERVER) then
		      self.Owner:GiveAmmo(50,"smg1");
        end
            if (CLIENT) then
		      self.Owner:PrintMessage( HUD_PRINTTALK, "Вы получили 50 патронов SMG (снайперки)" )
        end
        self.Weapon:TakePrimaryAmmo(1)
        self:SetNextSecondaryFire(CurTime() + 0.7)
--	end
    end
        if self.Atypes == 3 then
            if (SERVER) then
		      self.Owner:GiveAmmo(1,"rpg_round");
        end
            if (CLIENT) then
		      self.Owner:PrintMessage( HUD_PRINTTALK, "Вы получили 1 снаряд (RPG)" )
        end
        self.Weapon:TakePrimaryAmmo(1)
        self:SetNextSecondaryFire(CurTime() + 0.7)
--	end
    end
end
    
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

--EndCode

function SWEP:Initialize()


self:SetHoldType("slam")



	// other initialize code goes here

	if CLIENT then
	
	

		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
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
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
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
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
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
				// !! ----------- !! //
				
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

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
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
local l = 0
function SWEP:CalcViewModelView( vm,  oldPos, oldAng,  pos,  ang )








	
	if self.Owner:KeyReleased(IN_ATTACK) then
	
		l = 0
	end
	
	
	if self.Owner:KeyDown(IN_ATTACK) then
	
		l = l +0.05
		
		
			if l > 1 then
			l = 1
			end
		
		
		ang = oldAng+LerpAngle(l,Angle(0,0,0),Angle(0,0,-30))
	end
	
	
return pos ,  ang

end