function EFFECT:Init(data)
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	--self:SetModel("models/XQM/Rails/trackball_1.mdl")
	--self:SetModelScale( 0.4, 0 ) 
	self.pr_visible = true
end

function EFFECT:SetID(ID) self.pr_id = ID end
function EFFECT:GetID() return self.pr_id end
function EFFECT:SetWait(wait) self.pr_wait = wait end
function EFFECT:GetWait() return self.pr_wait end

function EFFECT:OnRemove()
end

function EFFECT:SetOrigin(pos) self.pr_origin = pos; self:SetPos(pos) end

function EFFECT:SetVisible(b) self.pr_visible = b end

function EFFECT:Think()
	self:SetPos(self.pr_origin)
	return !self.pr_remove
end

local colText = Color(255,255,255,255)
function EFFECT:Render()
	if(!self.pr_visible) then return end
	self:DrawModel()
	local id = self:GetID()
	local wait = self:GetWait()
	if(id) then
		local ang = LocalPlayer():EyeAngles()
		local pos = self:GetPos() +Vector(0,0,30)
		ang:RotateAroundAxis(ang:Forward(),90)
		ang:RotateAroundAxis(ang:Right(),90)
		cam.Start3D2D(pos,Angle(0,ang.y,90),0.5)
			draw.DrawText(id,"default",0,0,colText,TEXT_ALIGN_CENTER)
			if wait and wait > 0 then draw.DrawText("Wait: "..wait,"default",0,10,colText,TEXT_ALIGN_CENTER) end
		cam.End3D2D()
	end
end