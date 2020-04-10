function pMeta:IsArrested()
	return self:GetNWBool("Arrested") or self:GetNVar("Arrested")
end
