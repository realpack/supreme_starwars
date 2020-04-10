SWEP.BlendPos = Vector(0, 0, 0)
SWEP.BlendAng = Vector(0, 0, 0)
SWEP.OldDelta = Angle(0, 0, 0)
SWEP.AngleDelta = Angle(0, 0, 0)
SWEP.FireMove = 0
SWEP.ViewModelMovementScale = 1
SWEP.Sequence = ""
SWEP.Cycle = 0
SWEP.NoStockShells = true
SWEP.NoStockMuzzle = true

local Vec0 = Vector(0, 0, 0)
local TargetPos, TargetAng, cos1, sin1, tan, ws, rs, mod, EA, delta, sin2, mul, vm, muz, muz2, tr, att
local td = {}

local reg = debug.getregistry()
local GetVelocity = reg.Entity.GetVelocity
local Length = reg.Vector.Length
local Right = reg.Angle.Right
local Up = reg.Angle.Up
local Forward = reg.Angle.Forward
local RotateAroundAxis = reg.Angle.RotateAroundAxis

function SWEP:GetTracerOrigin()
	if self.dt.State == SWB_AIMING and self.SimulateCenterMuzzle then
		return self.CenterPos
	end
end

function SWEP:CreateShell(sh)
	if not IsValid(self.Owner) or self.Owner:ShouldDrawLocalPlayer() or self.NoShells then
		return
	end
	
	sh = self.Shell or sh
	vm = self.Owner:GetViewModel()
	
	if not IsValid(vm) then
		return
	end

	att = vm:GetAttachment(2)
	
	if att then
		if self.InvertShellEjectAngle then
			dir = -att.Ang:Forward()
		else
			dir = att.Ang:Forward()
		end
		
		SWB_MakeFakeShell(sh, att.Pos + dir, EyeAngles(), dir * 200, 0.6, 10, self.ShellScale)
	end
end

function SWEP:CreateMuzzle(pos, ang)
	if self.Owner:ShouldDrawLocalPlayer() then
		return
	end

	vm = self.Owner:GetViewModel()
	
	if IsValid(vm) then
		vm:StopParticles()

		muz = vm:LookupAttachment("1")
		
		if muz then
			muz2 = vm:GetAttachment(muz)
			
			if muz2 then
				EA = EyeAngles()
				
				if self.MuzzlePosMod then
					pos = pos + EA:Right() * self.MuzzlePosMod.x + EA:Forward() * self.MuzzlePosMod.y + EA:Up() * self.MuzzlePosMod.z
				end
				
				if self.dt.State == SWB_AIMING and self.SimulateCenterMuzzle then
					pos = self.Owner:GetShootPos() + EA:Forward() * 15 - EA:Up() * 6
					self.CenterPos = pos
				end
				
				if self.dt.Suppressed then
					if self.MuzzleEffectSupp then
						if not self.NoSilMuz then
							if self.dt.State == SWB_AIMING and self.SimulateCenterMuzzle then
								ParticleEffect(self.MuzzleEffectSupp, pos + self.Owner:GetVelocity() * 0.03, EA, vm)
							else
								if self.PosBasedMuz then
									ParticleEffect(self.MuzzleEffectSupp, pos + self.Owner:GetVelocity() * 0.03, EA, vm) -- using velocity to add to the position 'simulates' attaching it to a control point
								else
									ParticleEffectAttach(self.MuzzleEffectSupp, PATTACH_POINT_FOLLOW, vm, muz)
								end
							end
						end
					end
				else
					if self.MuzzleEffect then
						if self.dt.State == SWB_AIMING and self.SimulateCenterMuzzle then
							ParticleEffect(self.MuzzleEffect, pos + self.Owner:GetVelocity() * 0.03, EA, vm)
						else
							if self.PosBasedMuz then
								ParticleEffect(self.MuzzleEffect, pos + self.Owner:GetVelocity() * 0.03, EA, vm)
							else
								ParticleEffectAttach(self.MuzzleEffect, PATTACH_POINT_FOLLOW, vm, muz)
							end
						end
					end
					
					dlight = DynamicLight(self:EntIndex())
					
					dlight.r = 255 
					dlight.g = 218
					dlight.b = 74
					dlight.Brightness = 4
					dlight.Pos = pos + self.Owner:GetAimVector() * 3
					dlight.Size = 96
					dlight.Decay = 128
					dlight.DieTime = CurTime() + FrameTime()
				end
			end
		end
	end
end

SWBShells = {}
SWBShells["mainshell"] = {m = "models/weapons/rifleshell.mdl", s = {"player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav"}}
SWBShells["shotshell"] = {m = "models/weapons/Shotgun_shell.mdl", s = {"weapons/fx/tink/shotgun_shell1.wav", "weapons/fx/tink/shotgun_shell2.wav", "weapons/fx/tink/shotgun_shell3.wav"}}
SWBShells["smallshell"] = {m = "models/weapons/shell.mdl", s = {"player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav"}}

function SWB_MakeFakeShell(shell, pos, ang, vel, time, removetime, shellscale)
	if not shell or not pos or not ang then
		return
	end

	local t = SWBShells[shell]
	
	if not t then
		return
	end
	
	vel = vel or Vector(0, 0, -100)
	vel = vel + VectorRand() * 5
	time = time or 0.5
	removetime = removetime or 5
	shellscale = shellscale or 1
	
	local ent = ClientsideModel(t.m, RENDERGROUP_BOTH) 
	ent:SetPos(pos)
	ent:PhysicsInitBox(Vector(-0.5, -0.15, -0.5), Vector(0.5, 0.15, 0.5))
	ent:SetAngles(ang)
	ent:SetModelScale(shellscale, 0)
	ent:SetMoveType(MOVETYPE_VPHYSICS) 
	ent:SetSolid(SOLID_VPHYSICS) 
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	local phys = ent:GetPhysicsObject()
	phys:SetMaterial("gmod_silent")
	phys:SetMass(10)
	phys:SetVelocity(vel)

	timer.Simple(time, function()
		if t.s then
			ent:EmitSound(table.Random(t.s), 35, 100)
		end
	end)
	
	SafeRemoveEntityDelayed(ent, removetime)
end

function SWEP:FireAnimationEvent(pos, ang, ev, name)
	if ev == 5001 then
		if self.MuzzleEffect then
			self:CreateMuzzle(pos, ang)
		end
		
		if self.NoStockMuzzle then
			return true
		end
		
		return self.dt.Suppressed
	end
	
	if ev == 20 then
		if self.Shell then
			self:CreateShell()
		end
		
		return self.NoStockShells
	end
end

SWEP.ApproachSpeed = 10
local SP = game.SinglePlayer() 
local PosMod, AngMod = Vector(0, 0, 0), Vector(0, 0, 0)
local CurPosMod, CurAngMod = Vector(0, 0, 0), Vector(0, 0, 0)
local veldepend = {pitch = 0, yaw = 0, roll = 0}
local mod2 = 0
local EA2

function SWEP:PreDrawViewModel()
	CT = UnPredictedCurTime()
	vm = self.Owner:GetViewModel()
	
	self.Sequence = vm:GetSequenceName(vm:GetSequence())
	self.IsReloading = self.Sequence:find("reload")
	
	if not self.IsReloading then
		self.IsReloading = self.Sequence:find("insert")
	end
	
	if not self.IsReloading then
		self.IsFiddlingWithSuppressor = self.Sequence:find("silencer")
	end
	
	self.Cycle = vm:GetCycle()
	
	EA = EyeAngles()
	FT = FrameTime()
	
	delta = Angle(EA.p, EA.y, 0) - self.OldDelta
	delta.p = math.Clamp(delta.p, -10, 10)
		
	self.OldDelta = Angle(EA.p, EA.y, 0)
	self.AngleDelta = LerpAngle(math.Clamp(FT * 10, 0, 1), self.AngleDelta, delta)
	self.AngleDelta.y = math.Clamp(self.AngleDelta.y, -10, 10)

	vel = GetVelocity(self.Owner)
	len = Length(vel)
	ws = self.Owner:GetWalkSpeed()
	
	PosMod, AngMod = Vec0 * 1, Vec0 * 1
	mod2 = 1
	
	veldepend.roll = math.Clamp((vel:DotProduct(EA:Right()) * 0.04) * len / ws, -5, 5)
	
	if self.dt.State == SWB_AIMING then
		mod2 = 0.2
		TargetPos, TargetAng = self.AimPos * 1, self.AimAng * 1
		self.ApproachSpeed = math.Approach(self.ApproachSpeed, 8, FT * 100)
	elseif self.dt.State == SWB_ACTION then
		TargetPos, TargetAng = self.SwimPos * 1, self.SwimAng * 1
		self.ApproachSpeed = math.Approach(self.ApproachSpeed, 5, FT * 100)
	elseif self.dt.State == SWB_RUNNING or (((len > ws * 1.2 and self.Owner:KeyDown(IN_SPEED)) or len > ws * 3 or (self.ForceRunStateVelocity and len > self.ForceRunStateVelocity)) and self.Owner:OnGround()) then
		if self.IsReloading and self.Cycle < 0.9 then
			TargetPos, TargetAng = Vec0 * 1, Vec0 * 1
		else
			if self.SprintingEnabled then
				TargetPos, TargetAng = self.SprintPos * 1, self.SprintAng * 1
			else
				TargetPos, TargetAng = Vec0 * 1, Vec0 * 1
			end
		end
		
		rs = self.Owner:GetRunSpeed()
		mod = 7 + math.Clamp(rs / 100, 0, 6)
		mul = math.Clamp(len / rs, 0, 1)
		sin1 = math.sin(CT * mod) * mul
		cos1 = math.cos(CT * mod) * mul
		tan1 = math.tan(sin1 * cos1) * mul
		
		if (self.IsReloading or self.IsFiddlingWithSuppressor) and self.Cycle <= 0.9 then
			AngMod.x = AngMod.x + tan1 * 0.2 * self.ViewModelMovementScale * mul
			AngMod.y = AngMod.y - cos1 * 1.5 * self.ViewModelMovementScale * mul
			AngMod.z = AngMod.z + cos1 * 3 * self.ViewModelMovementScale * mul
			PosMod.x = PosMod.x - sin1 * 1.2 * self.ViewModelMovementScale * mul
			PosMod.y = PosMod.y + tan1 * 3 * self.ViewModelMovementScale * mul
			PosMod.z = PosMod.z + tan1 * 1.5 * self.ViewModelMovementScale * mul
			
			self.ApproachSpeed = math.Approach(self.ApproachSpeed, 4, FT * 100)
		else
			AngMod.x = AngMod.x + tan1 * 0.2 * self.ViewModelMovementScale * mul
			AngMod.y = AngMod.y - cos1 * 1.5 * self.ViewModelMovementScale * mul
			AngMod.z = AngMod.z + cos1 * 3 * self.ViewModelMovementScale * mul
			PosMod.x = PosMod.x - sin1 * 1.2 * self.ViewModelMovementScale * mul
			PosMod.y = PosMod.y + tan1 * 3 * self.ViewModelMovementScale * mul
			PosMod.z = PosMod.z + tan1 * 1.5 * self.ViewModelMovementScale * mul
			
			self.ApproachSpeed = math.Approach(self.ApproachSpeed, 6, FT * 100)
		end
	else
		if self.dt.Safe then
			TargetPos, TargetAng = self.SprintPos * 1, self.SprintAng * 1
		else
			TargetPos, TargetAng = Vec0 * 1, Vec0 * 1
		end

		self.ApproachSpeed = math.Approach(self.ApproachSpeed, 10, FT * 100)
		
		td.start = self.Owner:GetShootPos()
		td.endpos = td.start + self.Owner:EyeAngles():Forward() * 30
		td.filter = self.Owner
		
		tr = util.TraceLine(td)
		
		if tr.Hit then
			self.NearWall = true
			TargetPos.y = TargetPos.y - math.Clamp(30 * (1 - tr.Fraction), 0, 15)
		end
	end
	
	if len < 10 or not self.Owner:OnGround() then
		if self.dt.State != SWB_AIMING then
			cos1, sin1 = math.cos(CT), math.sin(CT)
			tan = math.atan(cos1 * sin1, cos1 * sin1)
			
			AngMod.x = AngMod.x + tan * 1.15
			AngMod.y = AngMod.y + cos1 * 0.4
			AngMod.z = AngMod.z + tan
			
			PosMod.y = PosMod.y + tan * 0.2 * mod2
		end
	elseif len > 10 and len < ws * 1.2 then
		mod = 6 + ws / 130
		mul = math.Clamp(len / ws, 0, 1)
		sin1 = math.sin(CT * mod) * mul
		cos1 = math.cos(CT * mod) * mul
		tan1 = math.tan(sin1 * cos1) * mul
		
		AngMod.x = AngMod.x + tan1 * self.ViewModelMovementScale * mod2
		AngMod.y = AngMod.y - cos1 * self.ViewModelMovementScale * mod2
		AngMod.z = AngMod.z + cos1 * self.ViewModelMovementScale * mod2
		PosMod.x = PosMod.x - sin1 * 0.4 * self.ViewModelMovementScale * mod2
		PosMod.y = PosMod.y + tan1 * 1 * self.ViewModelMovementScale * mod2
		PosMod.z = PosMod.z + tan1 * 0.5 * self.ViewModelMovementScale * mod2
	end
	
	FT = FrameTime()
	
	TargetAng.z = TargetAng.z + veldepend.roll
	self.BlendPos = LerpVector(FT * self.ApproachSpeed, self.BlendPos, TargetPos)
	self.BlendAng = LerpVector(FT * self.ApproachSpeed, self.BlendAng, TargetAng)
	
	CurPosMod = LerpVector(FT * 10, CurPosMod, PosMod)
	CurAngMod = LerpVector(FT * 10, CurAngMod, AngMod)
	
	self.FireMove = Lerp(FT * 15, self.FireMove, 0)
end

function SWEP:GetViewModelPosition(pos, ang)
	CT = UnPredictedCurTime()
	
	if self.InstantDissapearOnAim and self.dt.State == SWB_AIMING then
		self.ViewModelFOV = 90
		pos = pos - ang:Forward() * 100
		return pos, ang
	end
	
	if self.MoveWepAwayWhenAiming and CT > self.AimTime and self.dt.State == SWB_AIMING then
		self.ViewModelFOV = 90
		pos = pos - ang:Forward() * 100
		return pos, ang
	end
	
	self.ViewModelFOV = self.ViewModelFOV_Orig
	
	RotateAroundAxis(ang, Right(ang), CurAngMod.x + self.BlendAng.x + self.AngleDelta.p * mod2)
	
	if not self.ViewModelFlip then
		RotateAroundAxis(ang, Up(ang), CurAngMod.y + self.BlendAng.y + self.AngleDelta.y * 0.3 * mod2)
		RotateAroundAxis(ang, Forward(ang), CurAngMod.z + self.BlendAng.z + self.AngleDelta.y * 0.3 * mod2)
	else
		RotateAroundAxis(ang, Up(ang), CurAngMod.y + self.BlendAng.y - self.AngleDelta.y * 0.3 * mod2)
		RotateAroundAxis(ang, Forward(ang), CurAngMod.z - self.BlendAng.z - self.AngleDelta.y * 0.3 * mod2)
	end

	if not self.ViewModelFlip then
		pos = pos + (CurPosMod.x + self.BlendPos.x + self.AngleDelta.y * 0.1 * mod2) * Right(ang)
	else
		pos = pos + (CurPosMod.x + self.BlendPos.x - self.AngleDelta.y * 0.1 * mod2) * Right(ang)
	end
	
	pos = pos + (CurPosMod.y + self.BlendPos.y - self.FireMove) * Forward(ang)
	pos = pos + (CurPosMod.z + self.BlendPos.z - self.AngleDelta.p * 0.1) * Up(ang)
	
	return pos, ang
end

local wm, pos, ang
SWEP.wRenderOrder = nil

function SWEP:DrawWorldModel()
	if self.dt.Safe then
		if self.CHoldType != self.RunHoldType then
			self:SetHoldType(self.RunHoldType)
			self.CHoldType = self.RunHoldType
		end
	else
		if self.dt.State == SWB_RUNNING or self.dt.State == SWB_ACTION then
			if self.CHoldType != self.RunHoldType then
				self:SetHoldType(self.RunHoldType)
				self.CHoldType = self.RunHoldType
			end
		else
			if self.CHoldType != self.NormalHoldType then
				self:SetHoldType(self.NormalHoldType)
				self.CHoldType = self.NormalHoldType
			end
		end
	end
				
	if self.DrawTraditionalWorldModel then
		self:DrawModel()
	else
		wm = self.WMEnt
		
		if IsValid(wm) then
			if IsValid(self.Owner) then
				pos, ang = GetBonePosition(self.Owner, self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				
				if pos and ang then
					RotateAroundAxis(ang, Right(ang), self.WMAng[1])
					RotateAroundAxis(ang, Up(ang), self.WMAng[2])
					RotateAroundAxis(ang, Forward(ang), self.WMAng[3])

					pos = pos + self.WMPos[1] * Right(ang) 
					pos = pos + self.WMPos[2] * Forward(ang)
					pos = pos + self.WMPos[3] * Up(ang)
					
					wm:SetRenderOrigin(pos)
					wm:SetRenderAngles(ang)
					wm:DrawModel()
				end
			else
				wm:SetRenderOrigin(self:GetPos())
				wm:SetRenderAngles(self:GetAngles())
				wm:DrawModel()
				wm:DrawShadow()
			end
		else
			self:DrawModel()
		end
	end

	do
		-- if (self.ShowWorldModel == nil or self.ShowWorldModel) then
		-- 	self:DrawModel()
		-- end
		
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
end



do
	-- SWEP.vRenderOrder = nil
	-- function SWEP:ViewModelDrawn()

	-- end

	-- SWEP.wRenderOrder = nil
	-- function SWEP:DrawWorldModel()

	-- end

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

function RtCircleScane()
	local wep = ply:GetActiveWeapon()

	if IsValid(wep) and wep.VElements and wep.VElements["rt"] and wep.ScopeScene2 then
		local ply = LocalPlayer()

		wep.ScopeTexture:SetTexture("$basetexture", wep.ScopeScene2)
			
			local old = render.GetRenderTarget( )

			local CamData = {}
			CamData.angles = ply:GetViewModel():GetAngles()
			CamData.origin = ply:GetShootPos()
			CamData.x = 0
			CamData.y = 0
			CamData.w = 400
			CamData.h = 400
			CamData.fov = 4
			CamData.drawviewmodel = false
			CamData.drawhud = false
			render.SetRenderTarget(wep.ScopeScene2)
			render.SetViewPort(0, 0, ScrW(), ScrH())
			
			cam.Start2D()
				render.RenderView(CamData)

				if wep.ScopeMaterial then
					surface.SetMaterial(wep.ScopeMaterial)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(0,0,ScrW(), ScrH())
				end
			cam.End2D()
					
			render.SetViewPort(0, 0, ScrW(), ScrH())
			render.SetRenderTarget(old)
	end
end
hook.Add("RenderScene", "RtCircleScane", RtCircleScane)