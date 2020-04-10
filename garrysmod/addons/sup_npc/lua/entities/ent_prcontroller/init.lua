
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

AccessorFunc(ENT,"pr_Walk","Walk",FORCE_BOOL)
AccessorFunc(ENT,"pr_Type","Type",FORCE_NUMBER)
AccessorFunc(ENT,"pr_Undirected","Undirected",FORCE_NUMBER)
AccessorFunc(ENT,"pr_Strict","StrictMovement",FORCE_BOOL)

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetNoDraw(true)
	self.pr_NPC = nil
	self.pr_NPCID = nil
	-- pr_nodes structure:
	-- {Position (Vector), Wait Time (Float)}
	self.pr_nodes = {}
	-- pr_links structure:
	-- { {{Next Node, chance}} , {{Previous Node, chance}}, Chance Sum Next, Chance Sum Prev}
	self.pr_links = {}
	self.pr_currentnode = 1
	self.pr_lastvisited = nil
	self.pr_patrolback = false
	self.chancenext = 0
	self.chanceprev = 0
	self.entID = nil
	self.waiting = false
	self.waitdone = false
end

function ENT:AddNode(node)
	self.pr_nodes[#self.pr_nodes+1]={node[1],node[2]}
	self.pr_links[#self.pr_links+1]={{},{},0,0}
end

function ENT:AddLink(link)
	-- More memory used, but less processing (I hope)
	table.insert(self.pr_links[link[1]][1], {link[2],link[3]})
	self.pr_links[link[1]][3] = self.pr_links[link[1]][3] + link[3]
	table.insert(self.pr_links[link[2]][2], {link[1],link[3]})
	self.pr_links[link[2]][4] = self.pr_links[link[2]][4] + link[3]
end

function ENT:AddNPC(ent)
	self.pr_NPC = ent
	self.pr_NPCID = ent:EntIndex()
end

function ENT:SetStart(start)
	self.pr_currentnode = start
end

function ENT:GetNextPoint()
	if #self.pr_links[self.pr_currentnode][1] > 1 then
		local dice = math.random(1,self.pr_links[self.pr_currentnode][3])
		for k,v in pairs(self.pr_links[self.pr_currentnode][1]) do
			if dice <= v[2] then
				return v[1]
			else
				dice = dice - v[2]
			end
		end
	elseif self.pr_links[self.pr_currentnode][1][1] then return self.pr_links[self.pr_currentnode][1][1][1] 
	else return -1 end
end

function ENT:GetPrevPoint()
	if #self.pr_links[self.pr_currentnode][2] > 1 then
		local dice = math.random(1,self.pr_links[self.pr_currentnode][4])
		for k,v in pairs(self.pr_links[self.pr_currentnode][2]) do
			if dice <= v[2] then
				return v[1]
			else
				dice = dice - v[2]
			end
		end
	elseif self.pr_links[self.pr_currentnode][2][1] then return self.pr_links[self.pr_currentnode][2][1][1] 
	else return -1 end
end

function ENT:GetRandPoint(last)
	local mergedtable = {}
	local chancesum = 0
	for i=1, #self.pr_links[self.pr_currentnode][1] do
		if self.pr_links[self.pr_currentnode][1][i][1] != last then
			mergedtable[#mergedtable+1] = self.pr_links[self.pr_currentnode][1][i]
			chancesum = chancesum + self.pr_links[self.pr_currentnode][1][i][2]
		end
	end
	for i=1, #self.pr_links[self.pr_currentnode][2] do
		if self.pr_links[self.pr_currentnode][2][i][1] != last then
			mergedtable[#mergedtable+1] = self.pr_links[self.pr_currentnode][2][i]
			chancesum = chancesum + self.pr_links[self.pr_currentnode][2][i][2]
		end
	end
	
	if #mergedtable > 1 then
		local dice = math.random(1,chancesum)
		for k,v in pairs(mergedtable) do
			if dice <= v[2] then
				return v[1]
			else
				dice = dice - v[2]
			end
		end
	elseif mergedtable[1] then
		return mergedtable[1][1] 
	else return -1 end
end

local idle = {
	ACT_IDLE,
	ACT_IDLE_STEALTH,
	ACT_IDLE_ANGRY_MELEE,
	ACT_IDLE_RELAXED,
	ACT_IDLE_SMG1_RELAXED,
	ACT_IDLE_AIM_STEALTH,
	ACT_IDLE_MANNEDGUN,
	ACT_IDLE_ANGRY_PISTOL,
	ACT_IDLE_SHOTGUN_RELAXED,
	ACT_IDLE_RIFLE,
	ACT_IDLE_AIM_RELAXED,
	ACT_IDLE_ON_FIRE,
	ACT_IDLE_SHOTGUN_AGITATED,
	ACT_IDLE_ANGRY_SMG1,
	ACT_IDLE_PISTOL,
	ACT_IDLE_AIM_RIFLE_STIMULATED,
	ACT_IDLE_AGITATED,
	ACT_IDLE_CARRY,
	ACT_IDLE_RPG,
	ACT_IDLE_HURT,
	ACT_IDLE_ANGRY_RPG,
	ACT_IDLE_ANGRY_SHOTGUN,
	ACT_IDLE_SUITCASE,
	ACT_IDLE_SMG1_STIMULATED,
	ACT_IDLE_MELEE,
	ACT_IDLE_ANGRY,
	ACT_IDLE_AIM_STIMULATED,
	ACT_IDLE_AIM_AGITATED,
	ACT_IDLE_PACKAGE,
	ACT_IDLE_STEALTH_PISTOL,
	ACT_IDLE_SMG1,
	ACT_IDLE_RPG_RELAXED,
	ACT_IDLE_SHOTGUN_STIMULATED,
	ACT_IDLE_STIMULATED
}

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self.pr_NPC = CreatedEntities[self.pr_NPCID]
	self.pr_NPCID = self.pr_NPC:EntIndex()
	self:SetParent(self.pr_NPC)
	self.pr_NPC.pr_prcontroller = self
end

function ENT:Think()
	if !IsValid(self.pr_NPC) and IsValid(self.entpos) then
		local ent = ents.FindInSphere( self.entpos, 2 )[1]
		if IsValid(ent) then
			self.pr_NPC = ent
			self:SetParent(self.pr_NPC)
			self.pr_NPC.pr_prcontroller = self
		end
	end
	if IsValid(self.pr_NPC) and self.pr_NPC:Health() > 0 and self.pr_currentnode > 0 then
		local ent = self.pr_NPC
		local pos = self.pr_nodes[self.pr_currentnode][1]
		self.entpos = pos
		local wait = self.pr_nodes[self.pr_currentnode][2]
		-- DEBUG --
		--print(ent:GetActivity())
		--print(ent:GetCurrentSchedule())
		--if ( !IsValid( ent ) ) then return end
		--print( ent:GetClass().." ( "..ent:EntIndex().." ) has conditions:" )
		--for c = 0, 100 do
		--	if ( ent:HasCondition( c ) ) then
		--		print( ent:ConditionName( c ) )
		--	end
		--end
		-----------
		if((self.GetState && ent:GetState() || (ent:GetNPCState()) <= NPC_STATE_ALERT && !ent:HasCondition( 7 )) || self:GetStrictMovement()) then
			local posEnt = ent:GetPos()
			local dist = pos:Distance(posEnt)
			local compdist = 50
			-- Cheap Workaround. A tracer to the ground would be better, but also less efficient.
			if self.pr_NPC:GetClass() == "npc_strider" then compdist = 500 end
			if(dist <= compdist) then
				if self.pr_nodes[self.pr_currentnode][2] != 0 and self.waitdone == false then
					self.waiting = true
					self.waitdone = true
					timer.Simple(self.pr_nodes[self.pr_currentnode][2], function() self.waiting = false end)
				end
				if self.waiting == true then return end
				local NextPoint = -1
				if (self:GetUndirected() != 0) then
					-- If graph is undirected, pick a random point
					if !self.pr_lastvisited then self.pr_lastvisited = self.pr_currentnode end
					NextPoint = self:GetRandPoint(self.pr_lastvisited)
					if(NextPoint == -1 && self:GetType() == 1) then
						NextPoint = self.pr_lastvisited
					end
				else
					if (self.pr_patrolback) then
						-- If NPC is moving backward
						NextPoint = self:GetPrevPoint()
						if(NextPoint == -1 && self:GetType() == 1) then
							self.pr_patrolback = false
							NextPoint = self:GetNextPoint()
						end
					else
						-- If NPC is moving forward
						NextPoint = self:GetNextPoint()
						if(NextPoint == -1 && self:GetType() == 1) then
							self.pr_patrolback = true
							NextPoint = self:GetPrevPoint()
						end
					end
				end
				--
				if(NextPoint != -1) then
					self.pr_lastvisited = self.pr_currentnode
					self.pr_currentnode = NextPoint
					ent:SetLastPosition(self.pr_nodes[NextPoint][1] +Vector(0,0,6))
					if(self:GetWalk()) then ent:SetSchedule(SCHED_FORCED_GO)
					else ent:SetSchedule(SCHED_FORCED_GO_RUN) end
				end
				self.waitdone = false
			else
				local act = ent:GetActivity()
				if( (table.HasValue(idle,act) or (act == ACT_WALK and !ent:IsCurrentSchedule(SCHED_FORCED_GO)) ) and (!ent.sm_investigating or ent.sm_investigating == 0)) then
					ent:SetLastPosition(pos +Vector(0,0,6))
					local schd
					if(self:GetWalk()) then schd = SCHED_FORCED_GO
					else schd = SCHED_FORCED_GO_RUN end
					ent:SetSchedule(schd)
				end
			end
		else
			if( ent:IsCurrentSchedule(SCHED_FORCED_GO) or ent:IsCurrentSchedule(SCHED_FORCED_GO_RUN)) then
				ent:ClearSchedule()
			end
		end
	end
end
