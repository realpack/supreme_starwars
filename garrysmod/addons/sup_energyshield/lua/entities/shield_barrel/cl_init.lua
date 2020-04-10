include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local ang = Angle(0,LocalPlayer():GetAngles().y-90,-90)
	local pos = self:GetPos()+Vector(0,0,20) + ang:Up() * -20

	cam.Start3D2D( pos, ang, .4 )
		draw.RoundedBox(0,-50,0,100,18,Color(0,0,0,190))
		draw.RoundedBox(0,-50,0,self:GetStability(),18,Color(246,84,106,190))

		draw.RoundedBox(0,-50,-20,100,18,Color(0,0,0,190))
		draw.RoundedBox(0,-50,-20,self:GetCircleHealth()/20,18,Color(39,147,232,190))
	cam.End3D2D()
end