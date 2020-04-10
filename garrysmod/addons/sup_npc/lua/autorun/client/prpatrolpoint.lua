PATROL_POINTS = PATROL_POINTS || {}
patrolPoint = {}
patrolPoint.__index = patrolPoint
setmetatable(patrolPoint, { __call = function (c, ...) return c.create(...) end})

function patrolPoint.create()
    local self = {}
    setmetatable(self, patrolPoint)
    self:SetPos(Vector(0, 0, 0))
	self.Color = Color(255,255,255,255)
    self:Init()
    table.insert(PATROL_POINTS, self)
    return self
end

function patrolPoint:SetPos(pos)
    self.Pos = pos
end

function patrolPoint:GetRenderBounds()
    if (self.myModel) then
        return self.myModel:GetRenderBounds()
    end
end

function patrolPoint:SetColor(col)
	if (self.myModel) then
		self.Color = col
        self.myModel:SetColor(col)
    end
end

function patrolPoint:GetPos(pos)
    return self.Pos
end

function patrolPoint:SetModel(mdl)
    self.myModel = ClientsideModel(mdl)
    self.myModel:SetNoDraw(true)
end

function patrolPoint:IsValid()
    return true;
end

function patrolPoint:DrawModel()
    if (self.myModel) then
		render.SetColorModulation(self.Color.r/255,self.Color.g/255,self.Color.b/255)
        self.myModel:SetPos(self.Pos)
        self.myModel:DrawModel()
    end
end

function patrolPoint:Init(data)
    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    --self:SetModel("models/XQM/Rails/trackball_1.mdl")
    --self:SetModelScale( 0.4, 0 )
    self.pr_visible = true
end

function patrolPoint:SetID(ID) self.pr_id = ID end
function patrolPoint:GetID() return self.pr_id end
function patrolPoint:SetWait(wait) self.pr_wait = wait end
function patrolPoint:GetWait() return self.pr_wait end

function patrolPoint:OnRemove()
    if (self.myModel) then
        self.myModel:Remove()
    end
end

function patrolPoint:SetOrigin(pos) self.pr_origin = pos self:SetPos(pos) end

function patrolPoint:SetVisible(b) self.pr_visible = b end

function patrolPoint:Think()
    self:SetPos(self.pr_origin)
    return !self.pr_remove
end

hook.Add("Think", "patrolThink", function()
    for i = #PATROL_POINTS, 1, -1 do
        local v = PATROL_POINTS[i]
        if (v) then
            if (v.Think && !v:Think()) then
                if (v.OnRemove) then
                    v:OnRemove()
                end
                table.remove(PATROL_POINTS, i)
            end
        end
    end
end)

local colText = Color(255,255,255,255)

function patrolPoint:Render()
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

--Or translucent renderable hook here..
hook.Add("PostDrawOpaqueRenderables", "drawPatrols", function()
    for k, v in pairs(PATROL_POINTS) do
        if (v && v.Render) then
            v:Render()
        end
    end
end)