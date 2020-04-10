-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply ) -- modify first person camera view here
	--[[
	if ply == self:GetDriver() then
		-- driver view
	elseif ply == self:GetGunner() then
		-- gunner view
	else
		-- everyone elses view
	end
	]]--
	
	return view
end

function ENT:Draw()
	self:DrawModel()
	self.Startup = 0
	if not self:GetEngineActive() then return end
	
	local Boost = self.BoostAdd or 0
	
	local Size = 70 + (self:GetRPM() / self:GetLimitRPM()) * 100 + Boost
	local Size2 = 150 + (self:GetRPM() / self:GetLimitRPM()) * 50 + Boost

	render.SetMaterial(Material("sprites/light_glow02_add"))
	render.DrawSprite( self:LocalToWorld( Vector(-570,35.5,150) ), Size, Size, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-570,35.5,215) ), Size, Size, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-570,-35.5,215) ), Size, Size, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-570,-35.5,150) ), Size, Size, Color( 25, 200, 255, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(-590,-124,150) ), Size2, Size2+150, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-590,124,150) ), Size2, Size2+150, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-590,160,130) ), Size2, Size2+150, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-590,-160,130) ), Size2, Size2+150, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-590,206,110) ), Size2, Size2+150, Color( 25, 200, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-590,-206,110) ), Size2, Size2+150, Color( 25, 200, 255, 255) )



end

function ENT:LFSCalcViewThirdPerson( view, ply ) -- modify third person camera view here
	return view
end

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end

function ENT:LFSHudPaintPassenger( X, Y, ply ) -- all except driver
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp( 60 + Pitch * 40 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "VANILLA_NUSHUTTLE_HUM" )
		self.ENG:PlayEx(0,0)
		self.DIST = CreateSound( self, "VANILLA_NUSHUTTLE_HUM" )
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
	
	if IsValid( self.TheRotor ) then -- if we have an rotor
		self.TheRotor:Remove() -- remove it
	end
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimCabin()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimLandingGear()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:ExhaustFX()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end
