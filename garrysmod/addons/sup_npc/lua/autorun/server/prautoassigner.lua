hook.Add("OnEntityCreated","CheckAARange",function(ent)
	local filters = nil
	if ent:IsNPC() then
		timer.Simple(.1, function()
			if !IsValid(ent) then return end
			aaents = ents.FindByClass( "ent_prautoassigner" ) 
			if aaents and #aaents > 0 then
				for k,v in pairs(aaents) do
					if(ent:GetPos():Distance(v:GetPos()) < v:GetRange()) then
						if (v:GetFilter() == "") then
							v:CreateRoute(ent)
							break
						else
							filters = string.Split( v:GetFilter(), "," )
							if table.HasValue(filters,ent:GetClass()) then 
								v:CreateRoute(ent)
								break
							end
						end
					end
				end
			end
		end)
	end
end)