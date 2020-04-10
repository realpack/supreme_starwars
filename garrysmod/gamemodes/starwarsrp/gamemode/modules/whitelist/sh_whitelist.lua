function pMeta:CanUseWhitelist()
    return WHITELIST_ADMINS[self:GetUserGroup()] or LEGION_CMDS[LocalPlayer():Team()]
end

function pMeta:CanGiveTeam(tm)
    if WHITELIST_ADMINS[self:GetUserGroup()] then
        return true
    end

    local job = meta.jobs[tm] or meta.jobs[TEAM_CADET]
    if LEGION_CMDS[self:Team()][job.legion] then
        return true
    end
    return false
end
