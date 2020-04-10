local meta = FindMetaTable("Player")

function meta:addMoney(value)
    self:AddMoney(value)
end

function meta:SteamName()
	return self:OldName()
end
