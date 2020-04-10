ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = "Shield Base"
ENT.Author = "pack"
ENT.Category = "SUP | Разработки"

ENT.Spawnable = true

util.PrecacheSound("squadshield/impact1.wav")
util.PrecacheSound("squadshield/impact2.wav")
util.PrecacheSound("squadshield/impact3.wav")
util.PrecacheSound("squadshield/impact4.wav")

function ENT:Initialize()
	local scale = Vector(4,4,4)

	if SERVER then
		self:SetModel('models/maxofs2d/cube_tool.mdl')

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		local phys = self.Entity:GetPhysicsObject()
		if TypeID( phys ) == TYPE_PHYSOBJ and phys:IsValid() then
			phys:EnableMotion( false )
			phys:Wake()
		end
	end

	self:SetCustomCollisionCheck( true )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end


hook.Add("ShouldCollide", "ShieldBase_ShouldCollide", function( ent1, ent2 )
	if IsValid( ent1 ) and IsValid( ent2 )  then
		if (ent1:IsPlayer() and ent2:GetClass() == 'shield_circle') or (ent2:IsPlayer() and ent1:GetClass() == 'shield_circle') then
			return false
		end
	end

	return true
end)

-- local meta = FindMetaTable('Entity')
-- local oldFireBullets = meta.FireBullets;

-- local ricochets = {};
-- function meta:FireBullets( bullet )
-- 	bullet.sRicochet = 0;

-- 	-- print(bullet.Src, bullet.Dir, bullet.Distance)

-- 	if bullet.sRicochet < 3 then
-- 		bullet.Callback = function(attacker, tr, dmginfo)
-- 			table.insert(ricochets, {trace = tr, origbullet = bullet});
-- 		end
-- 	end

-- 	oldFireBullets(self, bullet);
-- 	for _, ric in ipairs(ricochets) do
-- 		if ric.trace.Hit then
-- 			local norm = ric.trace.Normal;
-- 			local ang = norm:Angle();
-- 			ang:RotateAroundAxis(ric.trace.HitNormal, 180);
-- 			local dir = ang:Forward()*-1;
-- 			local bullet = {
-- 				Src			= ric.trace.HitPos,
-- 				Dir			= dir;
-- 				Force		= ric.origbullet.Force;
-- 				Spread		= 0,
-- 				Attacker	= ric.origbullet.Attacker;
-- 				Num			= 1;
-- 				Damage		= ric.origbullet.Damage,
-- 				Tracer		= ric.origbullet.Tracer,
-- 				TracerName	= ric.origbullet.TracerName,
-- 				Ricochet	= ric.origbullet.sRicochet + 1;
-- 			}
-- 			table.remove(ricochets, _);
-- 			oldFireBullets(self, bullet);
-- 		end
-- 	end
-- end
