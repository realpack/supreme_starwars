include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-45,0,45) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "SPEEDERBIKE_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		--self.DIST = CreateSound( self, "LFS_SPITFIRE_DIST" )
		--self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:ExhaustFX()
    if not self:GetEngineActive() then return end
    
    self.nextEFX = self.nextEFX or 0
    
    local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
    
    local Driver = self:GetDriver()
    if IsValid( Driver ) then
        local W = Driver:KeyPressed( IN_FORWARD )
        if W ~= self.oldW then
            self.oldW = W
            if W then
                self.BoostAdd = 100
            end
        end
    end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
    if self.ENG then
        self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + Pitch * 45, 50,255) + Doppler,0,255) )
        self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
    end
    
    if self.DIST then
        self.DIST:ChangePitch(  math.Clamp(math.Clamp(  Pitch * 150, 50,255) + Doppler,0,255) )
        self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
    end
end