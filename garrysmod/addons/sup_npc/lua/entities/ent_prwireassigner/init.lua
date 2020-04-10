
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

AccessorFunc(ENT,"pr_Walk","Walk",FORCE_BOOL)
AccessorFunc(ENT,"pr_Type","Type",FORCE_NUMBER)
AccessorFunc(ENT,"pr_Undirected","Undirected",FORCE_NUMBER)
AccessorFunc(ENT,"pr_Strict","StrictMovement",FORCE_BOOL)
AccessorFunc(ENT,"pr_Range","Range",FORCE_NUMBER)
AccessorFunc(ENT,"pr_HasRoute","HasRoute",FORCE_BOOL)
AccessorFunc(ENT,"pr_Filter","Filter",FORCE_STRING)

ENT.WireDebugName = "Door Controller"

function ENT:Initialize()
	self:SetModel("models/XQM/Rails/trackball_1.mdl")
	self:SetModelScale( 0.5 )
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self:SetNoDraw(false)
	--self.pr_NPC = nil
	--self.pr_NPCID = nil
	-- pr_nodes structure:
	-- {Position (Vector), Wait Time (Float)}
	self.pr_nodes = {}
	-- pr_links structure:
	-- { {{Next Node, chance}} , {{Previous Node, chance}}, Chance Sum Next, Chance Sum Prev}
	self.pr_links = {}
	self.pr_currentnode = 1
	--self.pr_lastvisited = nil
	--self.pr_patrolback = false
	--self.chancenext = 0
	--self.chanceprev = 0
	----self.entID = nil
	--self.waiting = false
	--self.waitdone = false
	--self:SetNWInt("Range",self:GetRange())
	
	self:SetRange(0)
	self:SetNWInt("Range",self:GetRange())
	self:SetFilter("")
	self.pr_npc = nil
	self.pr_assigning = 0
	if WireAddon ~= nil then
		self.Inputs = WireLib.CreateSpecialInputs(self, {
			"AssignNPC",
			"AssignInRange",
			"NPC",
			"Range",
			"Filter"
		}, {
			"NORMAL",
			"NORMAL",
			"ENTITY",
			"NORMAL",
			"STRING"
		})
	end
end

function ENT:TriggerInput(iname, value)
	if (iname == "AssignNPC") and (value != 0) then
		self:WireAssignNPC()
	elseif(iname == "AssignInRange")then
		if (value != 0) then
			self:WireAssignInRange()
		end
		self.pr_assigning = value
	elseif(iname == "NPC") then
		self.pr_npc = value
	elseif(iname == "Range") then
		if (value >= 0) then
			self:SetRange(value)
		else
			self:SetRange(0)
		end
		self:SetNWInt("Range",self:GetRange())
		if (self.pr_assigning ~= 0) then
			self:WireAssignInRange() -- When "AssignInRange" and "Range" are wired to the same output
		end
	elseif(iname == "Filter") then
		self:SetFilter(value)
	end
end

function ENT:WireAssignNPC()
	if self.pr_npc and IsValid(self.pr_npc) and self.pr_npc:IsNPC() and self.pr_npc:Health() > 0 then
		self:CreateRoute(self.pr_npc)
	end
end

function ENT:WireAssignInRange()
	if (self:GetRange() <= 0) then return end
	local filters = nil
	local ents = ents.FindInSphere( self:GetPos(), self:GetRange() ) 
	local range = self:GetRange()
	timer.Simple(.1, function()
		for k,v in pairs(ents) do
			if IsValid(v) and v:IsNPC() and v:Health() > 0 then
				if (self:GetFilter() == "") then
					self:CreateRoute(v)
				else
					filters = string.Split( self:GetFilter(), "," )
					if table.HasValue(filters,v:GetClass()) then 
						self:CreateRoute(v)
					end
				end
			end
		end
	end)
end

function ENT:AddNode(node)
	--self.pr_nodes[#self.pr_nodes+1]={node[1],node[2]}
	--self.pr_links[#self.pr_links+1]={{},{},0,0}
	table.insert(self.pr_nodes, node)
end

function ENT:AddLink(link)
	-- More memory used, but less processing (I hope)
	--table.insert(self.pr_links[link[1]][1], {link[2],link[3]})
	--self.pr_links[link[1]][3] = self.pr_links[link[1]][3] + link[3]
	--table.insert(self.pr_links[link[2]][2], {link[1],link[3]})
	--self.pr_links[link[2]][4] = self.pr_links[link[2]][4] + link[3]
	table.insert(self.pr_links, link)
end

--[[
function ENT:AddNPC(ent)
	self.pr_NPC = ent
	self.pr_NPCID = ent:EntIndex()
end
]]--

function ENT:SetStart(start)
	self.pr_currentnode = start
	self:SetHasRoute(true)
end

function ENT:CreateRoute(npc)
	if self:GetHasRoute() == false then return end
	local controller = ents.Create("ent_prcontroller")
	controller:Spawn()
	controller:Activate()
	if !IsValid(controller) then return end
	--if (self:GetFilter() != "") then
	--	local filters = string.Split( self:GetFilter(), "," )
	--	if !table.HasValue(filters,npc:GetClass()) then return end
	--end
	
	if IsValid(npc.pr_prcontroller) then npc.pr_prcontroller:Remove() end
	npc:DeleteOnRemove(controller)
	self:DeleteOnRemove(controller)
	
	for i = 1,#self.pr_nodes do
		--local pos = net.ReadVector()
		--local wait = net.ReadFloat()
		controller:AddNode({self.pr_nodes[i][1],self.pr_nodes[i][2]})
	end
	
	--local numPLinks = net.ReadUInt(12)
	for i = 1,#self.pr_links do
		--local a = net.ReadUInt(12)
		--local b = net.ReadUInt(12)
		--local chance = net.ReadUInt(12)
		controller:AddLink({self.pr_links[i][1],self.pr_links[i][2],self.pr_links[i][3]})
	end
	
	controller:SetWalk(self:GetWalk())
	controller:SetType(self:GetType())
	controller:SetUndirected(self:GetUndirected())
	controller:SetStrictMovement(self:GetStrictMovement())
	controller:SetStart(self.pr_currentnode)
	
	npc.pr_prcontroller = controller
	--npc.pr_prcontroller:SetParent(npc)
	npc.pr_prcontroller:AddNPC(npc)
end

function ENT:RemoveRoute()
	self.pr_nodes = {}
	self.pr_links = {}
	self.pr_currentnode = 1
	self:SetHasRoute(false)
end