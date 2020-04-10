ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "item"
ENT.Author = "Krede"

function ENT:PhysicsCollide( cdata, obj )
	
	if( SERVER ) then
		
		local line = {}
		line.start = self:GetPos()
		line.endpos = line.start + ( ( cdata.HitPos - line.start ) * 2 ) 
		line.filter = {self}
		
		local tr = util.TraceLine( line )
		
		if IsValid(tr.Entity) then
			tr.Entity:TakeDamage(10, self:GetNWEntity("Owner"), self:GetNWEntity("Owner"))
		end
		
		if tr.HitSky or !tr.HitWorld or cdata.HitNormal.z < 0 then
			self:SetNWBool("Useless", true)
			SafeRemoveEntityDelayed( self, 2 )
			local phys = self:GetPhysicsObject()
			phys:EnableGravity(true)
			return
		end
		
		if self:GetNWBool("Useless") then return end
		
		self:SetAngles( cdata.HitNormal:Angle() + Angle(90,0,0) )
		
		self:SetPos( cdata.HitPos - cdata.HitNormal*12 )
		
		self:SetNotSolid(true)
		
		if cdata.HitNormal.z == 0 then
			self:SetNWVector("HitNormal", cdata.HitNormal)
		elseif cdata.HitNormal.z == 1 then
			local norm = cdata.HitNormal
			norm.z = 0
			self:SetNWVector("HitNormal", norm)
			self:SetNWBool("MultiAngle", true)
		else
			local norm = cdata.HitNormal
			norm.z = 0
			self:SetNWVector("HitNormal", norm)
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) and !IsValid(cdata.HitEntity) and !self.Weld then
			phys:EnableMotion(false)
		end
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetNWBool("Stuck", true)
		
		local pos = self:GetPos()
		
		local line = {}
		line.start = pos
		line.endpos = pos + Vector(0,0,-16000)
		line.filter = {}
		for k,sent in pairs(ents.GetAll()) do
			table.insert(line.filter, sent)
		end
		
		local tr = util.TraceLine( line )
		
		self:SetNWVector("DownHit", tr.HitPos)
		
	end
	
end