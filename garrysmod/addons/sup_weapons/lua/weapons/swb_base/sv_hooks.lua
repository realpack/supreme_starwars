local att, wep, dist, mul

local function SWB_EntityTakeDamage(ent, d)
	att = d:GetInflictor()
	
	
	if att:IsPlayer() then
		wep = att:GetActiveWeapon()

		if wep.DamageFallOff == 0 then
			d:ScaleDamage( 0 )

			ent:Freeze(true)

			timer.Simple(4, function()
				ent:Freeze(false)
			end)
			return
		end

		if IsValid(wep) and wep.SWBWeapon and not wep.NoDistance and wep.EffectiveRange then
			dist = ent:GetPos():Distance(att:GetPos())
			
			if dist >= wep.EffectiveRange * 0.5 then
				dist = dist - wep.EffectiveRange * 0.5
				mul = math.Clamp(dist / wep.EffectiveRange, 0, 1)
							
				d:ScaleDamage(1 - wep.DamageFallOff * mul)
			end
		end
	end
end

hook.Add("EntityTakeDamage", "SWB_EntityTakeDamage", SWB_EntityTakeDamage)