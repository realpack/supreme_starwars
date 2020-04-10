AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Phys = self:GetPhysicsObject()
	self.timername = tostring(self:EntIndex() .. self:GetName())

	self:InitiateTheBeautifulAndMajesticDestructionProcedure()
end

function ENT:KeyValue( key, value )
	if ( key == "Length" ) then
		self.vLength = tonumber(value)
	end
	if ( key == "ExplosionSize" ) then
		self.ExplosionSize = tonumber(value)
	end
	if ( key == "FinalSize" ) then
		self.FinalSize = tonumber(value)
	end
	if ( key == "Flip" ) then
		self.Flip = tonumber(value)
	end
	if ( key == "TurnRate" ) then
		self.TurnRate = tonumber(value)
	end
	if ( key == "FallRate" ) then
		self.FallRate = tonumber(value)
	end
	if ( key == "ForwardRate" ) then
		self.ForwardRate = tonumber(value)
	end
end

function ENT:InitiateTheBeautifulAndMajesticDestructionProcedure()
	local max, mins = self:GetHitBoxBounds( 0, 0 )

	self:Boom(self:GetPos(),self.ExplosionSize,false)
	timer.Create(self.timername .. "Boom Boom",1,self.vLength,function()
		if not self:IsValid() then return end
		timer.Simple(1, function()
			if not self:IsValid() then return end
			local set = math.random(1,2)
			if set == 1 then self:Boom(self:LocalToWorld(LerpVector(math.Rand(0.4,0.8),-max,-mins)),self.ExplosionSize,false) end
			if set == 2 then self:Boom(self:LocalToWorld(LerpVector(math.Rand(0.4,0.8),max,mins)),self.ExplosionSize,false) end

		end)
	end)
	timer.Create(self.timername .. "Down Down",0,900,function()
		if not self:IsValid() then return end
		if flip == 0 then
			self:SetAngles(self:GetAngles() + Angle(self.TurnRate * 0.1,0,0))
		else
			self:SetAngles(self:GetAngles() + Angle(-self.TurnRate * 0.1,0,0))
		end
	end)
	timer.Create(self.timername .. "Down Down But Actually",0,0,function()
		if not self:IsValid() then return end
		self:SetPos(self:GetPos() - Vector(0,0,self.FallRate * 0.1))
	end)
	timer.Create(self.timername .. "Forward Forward",0,0,function()
		if not self:IsValid() then return end
		if flip == 0 then
			self:SetPos(self:GetPos() - Vector(0,-self.ForwardRate * 0.1,0))
		else
			self:SetPos(self:GetPos() - Vector(0,self.ForwardRate * 0.1,0))
		end
	end)
end

function ENT:Think()
	if timer.RepsLeft(self.timername .. "Boom Boom") == 1 then
		self:Boom(self:GetPos(),self.FinalSize,true)
		self:Remove()
	end
end

function ENT:Boom(pos, scale, final)
	local lastrandom = 0
	local randomsound = math.random(1, 6)

	repeat
	    randomsound = math.random(1, 6)
	until randomsound ~= lastrandom

	lastrandom = randomsound
	if final == false then
		self:EmitSound("vanilla/vanilla_explosion_" .. randomsound .. ".wav",500,100,0.7,CHAN_AUTO)
	else
		self:EmitSound("vanilla/vanilla_final_explosion.wav",500,100,1,CHAN_AUTO)
	end

	local Pos = pos
	local Scale = scale
	local effectdata = EffectData()
	effectdata:SetStart( Pos )
	effectdata:SetOrigin( Pos )
	effectdata:SetScale( Scale )
	util.Effect( "vanilla_ship_explosion", effectdata )
	util.BlastDamage( self, self, self:GetPos(), 50, 1000 )
end

function ENT:Remove()
	timer.Remove(self.timername .. "Boom Boom")
	timer.Remove(self.timername .. "Down Down")
	timer.Remove(self.timername .. "Down Down But Actually")
	timer.Remove(self.timername .. "Forward Forward")
end
