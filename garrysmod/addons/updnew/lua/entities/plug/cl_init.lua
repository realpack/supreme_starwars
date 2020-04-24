include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.

								  
    self:DrawModel()       -- Draw the model.
 


end

local dis = 150
hook.Add( "PreDrawHalos", "AddHalos", function()--cache a tracelocal
 tr = LocalPlayer():GetEyeTrace()

	--make sure the trace hit an entity, make sure that  it didn't hit the world, then we get teh squared distance which is way faster than getting the regular distance :D
	if (tr.Entity and tr.HitNonWorld and IsValid(tr.Entity) and LocalPlayer():GetPos():DistToSqr(tr.Entity:GetPos()) <= (dis * dis)) then
	if tr.Entity:GetClass() == "plug" then
        halo.Add({tr.Entity}, Color( 0, 0, 255 ))
	end
    end
	end)