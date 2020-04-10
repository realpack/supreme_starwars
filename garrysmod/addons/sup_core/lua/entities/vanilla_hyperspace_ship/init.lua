AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self:SetName("Hyperspace")
	self.OriginalPos = self:GetPos()
	self:SetPos(self:GetPos() - (self:GetForward() * 15800))
	if self.FlipValue == 1 then
		self:SetPos(self:GetPos() + (self:GetForward() * (15800 + 15800)))
	end
	self:PhysicsInit( SOLID_NONE  )
	self:SetMoveType( MOVETYPE_FLY  )
	self:SetSolid(SOLID_NONE  )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.afterjump = false
	self.jump = true
	if self.ShakeValue == 1 then
		util.ScreenShake(self:GetPos(),100000,5,2,100000)
	end

	self.VanillaTimer = tostring(self:EntIndex() .. self:GetName())

	if self.jump == true and self.FlipValue ~= 1 then
		timer.Create(self.VanillaTimer,0,0,function()
			if not self:IsValid() then return end
			self:SetPos(self:GetPos() + self:GetForward() * 450)
		end)
	elseif self.jump == true and self.FlipValue == 1 then
		timer.Create(self.VanillaTimer .. "Backwards",0,0,function()
			if not self:IsValid() then return end
			self:SetPos(self:GetPos() - self:GetForward() * 450)
		end)
	end

	self.StopTimer = (self.VanillaTimer .. "Stop")

	timer.Create(self.StopTimer,0,0,function()
		if not IsValid(self) then return end
		if self:GetPos():IsEqualTol(self.OriginalPos,500) then
			timer.Remove(self.VanillaTimer)
			timer.Remove(self.VanillaTimer .. "Backwards")
			self:SetPos(self.OriginalPos)
			self.jump = false
			self.afterjump = true
			self:Remove()
		end
	end)
end

function ENT:KeyValue( key, value )
	if ( key == "SpawnModel" ) then
		self.SpawnModelValue = tonumber(value)
	end

	if ( key == "ActualModel" ) then
		self.ActualModelValue = value
		if self.SpawnModelValue == 1 then
			if not util.IsValidModel(value) then self:Remove() end
		end
	end

	if ( key == "AI") then
		self.AIValue = tonumber(value)
	end

	if ( key == "Freeze" ) then
		self.FreezeValue = tonumber(value)
	end

	if (key == "Flip" ) then
		self.FlipValue = tonumber(value)
	end

	if (key == "Shake") then
		self.ShakeValue = tonumber(value)
	end

	if (key == "Owner") then
		if not IsValid(value) then return end
		self.OwnerValue = value
	end

	if (key == "Sound") then
		self:SetPlaySound(value)
	end

	if ( key == "Entity" ) then
		if self.SpawnModelValue == 0 then
			self.VANILLAENTITY = value
			local ent = ents.Create(self.VANILLAENTITY)
			ent:SetRenderMode(RENDERMODE_NONE)
			ent:PhysicsInit(SOLID_NONE)
			ent:SetPos(Vector(0,0,0))
			ent:SetAngles(Angle(0,0,0))
			ent:Spawn()
			for k, v in pairs( ents.FindByClass( self.VANILLAENTITY ) ) do
				self:SetModel(v:GetModel())
			end
			ent:Remove()
		else
			self:SetModel(self.ActualModelValue)
			self.VANILLAENTITY = "vanilla_modelship"
		end
	end
end

function ENT:Think()
end

function ENT:OnRemove()
	if self.afterjump == true then
		local afterjump = ents.Create(self.VANILLAENTITY)
		afterjump:SetPos(self:GetPos())
		afterjump:SetAngles(self:GetAngles())
		afterjump:SetKeyValue("Model", self.ActualModelValue)
		afterjump:Spawn()
		if self.AIValue == 1 then
			for k, v in pairs(simfphys.LFS:PlanesGetAll()) do
				if v == afterjump then
					afterjump:SetAI(true)
				end
			end
		end
		if self.FreezeValue == 1 then
			afterjump:SetMoveType(MOVETYPE_FLY)
		end

		undo.Create( "Ship" )
			undo.AddEntity( afterjump )
			undo.SetPlayer( self:GetOwner() )
			undo.SetCustomUndoText("Undone Ship")
		undo.Finish()
	end
	timer.Remove(self.VanillaTimer)
	timer.Remove(self.StopTimer)
end
