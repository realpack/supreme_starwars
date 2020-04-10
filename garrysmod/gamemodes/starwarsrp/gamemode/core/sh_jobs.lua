local indexnum = 1
function meta.util.addjob(strName, tblTeam)
    indexnum = indexnum + 1

    team.SetUp( indexnum, strName, tblTeam.Color )
    -- print(strName..' - '..indexnum)
    -- print(team.GetName(indexnum))
	tblTeam['index'] = indexnum
	tblTeam.Name = strName or ''
	table.insert( meta.jobs, indexnum,  tblTeam )

	local models = tblTeam.WorldModel

	if SERVER and models then
		if istable(models) then
			for k,v in pairs(models) do
				util.PrecacheModel(v)
			end
		else
			util.PrecacheModel(models)
		end
	end

	return indexnum
end

function FindJob(index)
	return meta.jobs[index] or false
end

function FindJobByID(strID)
	for _, tblJob in pairs(meta.jobs) do
		if tblJob.jobID == strID then
			return tblJob
		end
	end
end

function isMaxPlayers(index)
	local maxPlayers = FindJob(index).maxPlayers or 0
	if maxPlayers and (maxPlayers == 0 or maxPlayers == nil)  then
		return true
	end
	return maxPlayers > #team.GetPlayers(index)
end

function pMeta:CanChangeJob(team)
	local job_type = meta.jobs[team].Type
	if job_type == TYPE_SUP or job_type == TYPE_COMBINE or job_type == TYPE_SCPU then
		return true
	end

    local pjob_type = meta.jobs[self:Team()]
    if pjob_type == TYPE_SUP or pjob_type == TYPE_COMBINE or pjob_type == TYPE_SCPU or pjob_type == TYPE_RABEL then
		return true
	end

	local _, count_doors = self:CheckMaxDoors()
	return count_doors > 0
end
