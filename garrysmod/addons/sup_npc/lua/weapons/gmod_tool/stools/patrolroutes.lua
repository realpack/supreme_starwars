TOOL.Category = "Max Shadow Tools"
TOOL.Name = "Patrol Routes"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.CurrentPoints = { }

AddCSLuaFile( "includes/modules/pon.lua" )
require("pon")

if CLIENT then
	TOOL.ClientConVar["show"] = 1
	TOOL.ClientConVar["showchance"] = 0
	TOOL.ClientConVar["autolink"] = 1
	TOOL.ClientConVar["walk"] = 0
	TOOL.ClientConVar["type"] = 0
	TOOL.ClientConVar["undirected"] = 0
	TOOL.ClientConVar["strict"] = 0
	TOOL.ClientConVar["wait"] = 0
	TOOL.ClientConVar["chance"] = 1
	TOOL.ClientConVar["initnode"] = 1
	TOOL.ClientConVar["aarange"] = 100
	TOOL.ClientConVar["aafilter"] = "npc_citizen,npc_combine_s"
	TOOL.ClientConVar["toolmode"] = "npc"
	
	language.Add( "tool.patrolroutes.name", "Patrol Routes" )
    language.Add( "tool.patrolroutes.desc", "Make patrol routes for your NPCs." )
    language.Add( "tool.patrolroutes.0", "Read the tool settings for help." )

	local PatrolPoints = {}
	local PatrolLinks = {}
	local PointEffects = {}
	local selected = -1
	
	-- ###################################################### --
	-- #################### FUNCTIONS ####################### --
	-- ###################################################### --
	
	local function CreatePatrolPointEffect(pos)
		local new = patrolPoint();
        if(!new) then return end
        new:SetOrigin(pos)
        return new
	end
	
	
	local function GetTraceEffect()
		local pl = LocalPlayer()
		local pos = pl:GetShootPos()
		local dir = pl:GetAimVector()
		local eClosest
		local distClosest = math.huge
		for _,e in ipairs(PointEffects) do
			local hit,norm = util.IntersectRayWithOBB(pos,dir *32768,e:GetPos(),Angle(0,0,0),e:GetRenderBounds())
			if(hit) then
				local d = e:GetPos():Distance(pos)
				if(d < distClosest) then
					distClosest = d
					eClosest = _
				end
			end
		end
		return PointEffects[eClosest],eClosest
	end
	
	local mat = Material("trails/physbeam")
	
	local function ShowPatrolPoints(b)
		hook.Remove("RenderScreenspaceEffects","patrolroutes_renderpoints")
		for _,ent in ipairs(PointEffects) do ent.pr_remove = true end
		table.Empty(PointEffects)
		--print(b)
		if(!b) then return end
		for k,point in ipairs(PatrolPoints) do
			PointEffects[k] = CreatePatrolPointEffect(point[1])
			if PointEffects[k] and PointEffects[k]:IsValid() then
				PointEffects[k]:SetID(k)
				PointEffects[k]:SetWait(point[2])
			end
		end
		local offset = Vector(0,0,0)
		local colDefault = Color(255,255,255,255)
		local colHighlighted = Color(0,255,0,255)
		local colSelected = Color(255,0,0,255)
		hook.Add("RenderScreenspaceEffects","patrolroutes_renderpoints",function()
			if (#PointEffects == 0 and #PatrolLinks == 0) then return end
			cam.Start3D(EyePos(),EyeAngles())
			render.SetMaterial(mat)
			local num = #PatrolLinks
			local effect = GetTraceEffect()
			for i = 1,num do
				local p = PointEffects[PatrolLinks[i][2]]
				local pPrev = PointEffects[PatrolLinks[i][1]]
				local distance = pPrev:GetPos():Distance(p:GetPos())
				if pPrev == effect then render.DrawBeam(pPrev:GetPos() +offset,p:GetPos() +offset,5,CurTime()+(2*(distance/75)),CurTime(),colHighlighted)
				else render.DrawBeam(pPrev:GetPos() +offset,p:GetPos() +offset,5,CurTime()+(2*(distance/75)),CurTime(),colDefault) end
			end
			if GetConVarNumber("patrolroutes_showchance") != 0 then
				for i = 1,num do
					local p = PointEffects[PatrolLinks[i][2]]
					local pPrev = PointEffects[PatrolLinks[i][1]]
					local ang = LocalPlayer():EyeAngles()
					local pos = (pPrev:GetPos()+p:GetPos())/2 + Vector(0,0,20)
					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Right(),90)	
					cam.Start3D2D(pos,Angle(0,ang.y,90),0.5)
					if pPrev == effect then draw.DrawText("Chance: "..PatrolLinks[i][3],"default",2,2,colHighlighted,TEXT_ALIGN_CENTER)
					else draw.DrawText("Chance: "..PatrolLinks[i][3],"default",2,2,colDefault,TEXT_ALIGN_CENTER) end
					cam.End3D2D()
				end
			end
			cam.End3D()
			for k,v in pairs(PointEffects) do
				if k == selected then v:SetColor(colSelected)
				elseif v == effect then v:SetColor(colHighlighted)
				else v:SetColor(colDefault) end
			end
		end)
	end
	
	local pointsvisible = false
	-- This check is probably extremelly inefficient, but I had to do it because TOOL:Deploy() and TOOL:Holster() are extremely buggy:
	-- Both TOOL:Deploy() and TOOL:Holster() are executed more than once when you do one of those actions
	-- Also, when you do LocalPlayer():GetActiveWeapon() inside those functions, it returns the weapon you're switching to in singleplayer,
	-- but in multiplayer it returns the weapon you're switching from!
	-- I had to completely remove the deploy and holster event.
	hook.Add("Think","patrolroutes_checkvisibility",function()
		if pointsvisible == true then
			if (GetConVarNumber("patrolroutes_show") == 0 or !IsValid(LocalPlayer()) or !LocalPlayer():Alive() or !IsValid(LocalPlayer():GetActiveWeapon()) or LocalPlayer():GetActiveWeapon():GetClass()!="gmod_tool" or LocalPlayer():GetActiveWeapon():GetMode()!="patrolroutes") then
				pointsvisible = false
				ShowPatrolPoints(false)
			end
		else
			if (GetConVarNumber("patrolroutes_show") != 0 and IsValid(LocalPlayer()) and LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()=="gmod_tool" and LocalPlayer():GetActiveWeapon():GetMode()=="patrolroutes") then
				pointsvisible = true
				ShowPatrolPoints(true)
			end
		end
	end)
	
	
	local function CreatePatrolPoint(pos,wait,chance)
		if(GetConVarNumber("patrolroutes_show") != 0) then
			local e = CreatePatrolPointEffect(pos)
			if(e) then
				e:SetID(table.insert(PointEffects,e))
				e:SetWait(wait)
			end
		end
		local point = table.insert(PatrolPoints,{pos,wait})
		if(GetConVarNumber("patrolroutes_autolink") != 0) and point != 1 and chance > 0 then
			table.insert(PatrolLinks,{point-1,point,chance})
		end
		net.Start("sv_patrolroutes_createundo")
		net.SendToServer()
	end
	
	cvars.AddChangeCallback("patrolroutes_show",function(cvar,old,new)
		ShowPatrolPoints(tobool(new))
	end)
	
	-- What about this?
	--local cvPPointSelected = CreateClientConVar("patrolroutes_ppoints_select",0,true)
	
	-- This is useless
	--[[concommand.Add("patrolroutes_ppoints_add",function(pl,cmd,args)
		local tr = util.TraceLine(util.GetPlayerTrace(pl))
		CreatePatrolPoint(tr.HitPos,GetConVarNumber("patrolroutes_patrolwait"))
	end)]]--
	
	local function RemovePatrolPoint(ID)
		if(!PatrolPoints[ID]) then return end
		table.remove(PatrolPoints,ID)
		for i = #PatrolLinks,1,-1 do
			if (PatrolLinks[i][1]==ID or PatrolLinks[i][2]==ID) then table.remove(PatrolLinks,i)
			else
				if PatrolLinks[i][1]>ID then PatrolLinks[i][1]=PatrolLinks[i][1]-1 end
				if PatrolLinks[i][2]>ID then PatrolLinks[i][2]=PatrolLinks[i][2]-1 end
			end
		end
		local ent = PointEffects[ID]
		if(ent && ent:IsValid()) then
			ent.pr_remove = true
			table.remove(PointEffects,ID)
		end
		for i = ID,#PatrolPoints do
			local e = PointEffects[i]
			e:SetID(i)
		end
	end
	
	--local function ClearPatrolPoints()
	function patrolroutes_clear()
		for _,ent in ipairs(PointEffects) do
			if(ent:IsValid()) then ent.pr_remove = true end
		end
		table.Empty(PatrolPoints)
		table.Empty(PointEffects)
		table.Empty(PatrolLinks)
		net.Start("patrolroutes_clearundo")
		net.SendToServer()
	end
	
	-- #################################################### --
	-- #################### NET CLIENT #################### --
	-- #################################################### --
	
	
	net.Receive("cl_patrolroutes_clear",function() patrolroutes_clear() end)
	
	net.Receive("cl_patrolroutes_removelastpoint",function(len) RemovePatrolPoint(#PatrolPoints) end)
	
	net.Receive("cl_patrolroutes_createpoint",function(len)
		local effect,effectID = GetTraceEffect()
		if(effect) then
			if(LocalPlayer():KeyDown(IN_USE)) then
				if selected == -1 then
					selected = effectID
					hook.Add("Think","CheckUnselect",function()
						if(!LocalPlayer():KeyDown(IN_USE)) then
							selected = -1
							hook.Remove("Think","CheckUnselect")
						end
					end)
				elseif selected == effectID then
					for i = #PatrolLinks,1,-1 do
						if (PatrolLinks[i][1]==effectID or PatrolLinks[i][2]==effectID) then table.remove(PatrolLinks,i) end
					end
				elseif (selected != effectID) then
					local found = false
					for k,v in pairs(PatrolLinks) do
						if found == false then
							if v[2] == effectID and v[1] == selected then
								found = true
								table.remove(PatrolLinks,k)
							elseif v[1] == effectID and v[2] == selected then
								found = true
								notification.AddLegacy( "Two way links are not permitted", NOTIFY_ERROR, 3 )
								surface.PlaySound( "buttons/button10.wav" )
							end
						end
					end
					if found == false then
						table.insert(PatrolLinks,{selected,effectID,GetConVarNumber("patrolroutes_chance")})
					end
				end
			else 
				RemovePatrolPoint(effectID)
				return
			end
		else
			if(!LocalPlayer():KeyDown(IN_USE)) then
				local pos = net.ReadVector()
				local wait = GetConVarNumber("patrolroutes_wait")
				local chance = GetConVarNumber("patrolroutes_chance")
				CreatePatrolPoint(pos,wait,chance)
			end
		end
	end)
	
	net.Receive("cl_patrolroutes_createautoassigner",function(len)
		if(!LocalPlayer():KeyDown(IN_USE)) then
			if(GetConVarString("patrolroutes_toolmode") == "auto" or GetConVarString("patrolroutes_toolmode") == "wire" ) then
				local pos = net.ReadVector()
				--local range = GetConVarNumber("patrolroutes_aarange")
				--local controller = CreateAutoassigner(pos)
				--if !IsValid(controller) then return end
				net.Start("sv_patrolroutes_createautoassigner")
					net.WriteVector(pos,12)
					net.WriteUInt(GetConVarNumber("patrolroutes_walk"),1)
					net.WriteUInt(GetConVarNumber("patrolroutes_type"),2)
					net.WriteUInt(GetConVarNumber("patrolroutes_undirected"),2)
					net.WriteUInt(GetConVarNumber("patrolroutes_strict"),1)
					net.WriteUInt(GetConVarNumber("patrolroutes_initnode"),12)
					net.WriteUInt(GetConVarNumber("patrolroutes_aarange"),12)
					net.WriteString(GetConVarString("patrolroutes_aafilter"))
					net.WriteString(GetConVarString("patrolroutes_toolmode"))
					local numPPoints = #PatrolPoints
					net.WriteUInt(numPPoints,12)
					for i = 1,numPPoints do
						net.WriteVector(PatrolPoints[i][1])
						net.WriteFloat(PatrolPoints[i][2])
					end
					local numPLinks = #PatrolLinks
					net.WriteUInt(numPLinks,12)
					for i = 1,numPLinks do
						net.WriteUInt(PatrolLinks[i][1],12)
						net.WriteUInt(PatrolLinks[i][2],12)
						net.WriteUInt(PatrolLinks[i][3],12)
					end
				net.SendToServer()
			end
		end
	end)
	
	net.Receive("cl_patrolroutes_recoverpoints",function(len)
		local numPPoints = net.ReadUInt(12)
		patrolroutes_clear()
		if !numPPoints then return end
		for i = 1,numPPoints do
			local node = net.ReadVector()
			local wait = net.ReadFloat()
			CreatePatrolPoint(node,wait,-1)
		end
		for i = 1,numPPoints do
			local numLinks = net.ReadUInt(12)
			for j = 1,numLinks do
				local next = net.ReadUInt(12)
				local chance = net.ReadUInt(12)
				table.insert(PatrolLinks,{i,next,chance})
			end
		end
	end)
	
	net.Receive("cl_patrolroutes_recoverpoints2",function(len)
		local numPPoints = net.ReadUInt(12)
		patrolroutes_clear()
		if !numPPoints then return end
		for i = 1,numPPoints do
			local node = net.ReadVector()
			local wait = net.ReadFloat()
			CreatePatrolPoint(node,wait,-1)
		end
		local numLinks = net.ReadUInt(12)
		for i = 1,numLinks do
			local prev = net.ReadUInt(12)
			local next = net.ReadUInt(12)
			local chance = net.ReadUInt(12)
			table.insert(PatrolLinks,{prev,next,chance})
		end
	end)
	
	net.Receive("cl_patrolroutes_npcpatrol",function(len)
		local ent = net.ReadEntity()
		if(LocalPlayer():KeyDown(IN_USE)) then
			net.Start("sv_patrolroutes_recoverpoints")
				net.WriteEntity(ent)
			net.SendToServer()
		else
			if (GetConVarString("patrolroutes_toolmode") == "npc" and ent:IsNPC()) then
				net.Start("sv_patrolroutes_npcpatrol")
					net.WriteEntity(ent)
					net.WriteUInt(GetConVarNumber("patrolroutes_walk"),1)
					net.WriteUInt(GetConVarNumber("patrolroutes_type"),2)
					net.WriteUInt(GetConVarNumber("patrolroutes_undirected"),2)
					net.WriteUInt(GetConVarNumber("patrolroutes_strict"),1)
					net.WriteUInt(GetConVarNumber("patrolroutes_initnode"),12)
					local numPPoints = #PatrolPoints
					net.WriteUInt(numPPoints,12)
					for i = 1,numPPoints do
						net.WriteVector(PatrolPoints[i][1])
						net.WriteFloat(PatrolPoints[i][2])
					end
					local numPLinks = #PatrolLinks
					net.WriteUInt(numPLinks,12)
					for i = 1,numPLinks do
						net.WriteUInt(PatrolLinks[i][1],12)
						net.WriteUInt(PatrolLinks[i][2],12)
						net.WriteUInt(PatrolLinks[i][3],12)
					end
				net.SendToServer()
			elseif (ent:GetClass() == "ent_prautoassigner" or ent:GetClass() == "ent_prwireassigner") then
				net.Start("sv_patrolroutes_updateautoassigner")
					net.WriteEntity(ent)
					net.WriteUInt(GetConVarNumber("patrolroutes_walk"),1)
					net.WriteUInt(GetConVarNumber("patrolroutes_type"),2)
					net.WriteUInt(GetConVarNumber("patrolroutes_undirected"),2)
					net.WriteUInt(GetConVarNumber("patrolroutes_strict"),1)
					net.WriteUInt(GetConVarNumber("patrolroutes_initnode"),12)
					net.WriteUInt(GetConVarNumber("patrolroutes_aarange"),12)
					net.WriteString(GetConVarString("patrolroutes_aafilter"))
					net.WriteString(GetConVarString("patrolroutes_toolmode"))
					local numPPoints = #PatrolPoints
					net.WriteUInt(numPPoints,12)
					for i = 1,numPPoints do
						net.WriteVector(PatrolPoints[i][1])
						net.WriteFloat(PatrolPoints[i][2])
					end
					local numPLinks = #PatrolLinks
					net.WriteUInt(numPLinks,12)
					for i = 1,numPLinks do
						net.WriteUInt(PatrolLinks[i][1],12)
						net.WriteUInt(PatrolLinks[i][2],12)
						net.WriteUInt(PatrolLinks[i][3],12)
					end
				net.SendToServer()
				notification.AddLegacy( "Route and settings updated", NOTIFY_HINT , 3 )
			--elseif (GetConVarString("patrolroutes_toolmode") == "auto" and ent:GetClass() == "ent_prautoassigner") then
			--	net.Start("sv_patrolroutes_removeautoassigner")
			--		net.WriteEntity(ent)
			--	net.SendToServer()
			end
		end
	end)

	--[[
	net.Receive("patrolroutes_deploy",function(len)
		if(GetConVarNumber("patrolroutes_show") != 0) then ShowPatrolPoints(true) end
	end)
	
	net.Receive("patrolroutes_holster",function(len)
		local pl = LocalPlayer()
		local wep = pl:GetActiveWeapon()
		print(wep:GetClass().."/"..wep:GetMode())
		if(wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "patrolroutes") then
			if(GetConVarNumber("patrolroutes_show") != 0) then ShowPatrolPoints(true) end
			return
		end
		ShowPatrolPoints(false)
	end)
	]]--
	
	-- ##################################################### --
	-- #################### PANEL BUILD #################### --
	-- ##################################################### --
	
	function TOOL.BuildCPanel(Panel)

		Panel:AddControl("Header", {Text = "#tool.patrolroutes.name", Description = "Usage:"})
		
		Panel:AddControl("Label", {Text = "------------------------------------\n\nMouse1: Add/Remove node.\n\n(E+Mouse1): Select node.\n-->  Mouse1 on node: Add/Remove link.\n-->  Mouse1 on selected: Remove all links.\n-->  Release E: Deselect node.\n\nMouse2: Assign route to NPC/Create assigner/Update assigner\n\n(E + Mouse2): Recover route from NPC or assigner.\n\nReload: Clear nodes.\n\n------------------------------------"})
	
		Panel:AddControl("ComboBox", {
			Label = "Tool Mode",
			--MenuButton = "1",
			--Folder = "patrolroutes",

			Options = {
				["Single NPC"] = {
					patrolroutes_toolmode = "npc"
				},
				["Autoassigner"] = {
					patrolroutes_toolmode = "auto"
				},
				["Wire Assigner"] = {
					patrolroutes_toolmode = "wire"
				}
			}

			--CVars = {
			--	[0] = "patrolroutes_toolmode"
			--}
		})
		
		Panel:AddControl("CheckBox", {Label = "Show Points", Command = "patrolroutes_show"})
		
		Panel:AddControl("CheckBox", {Label = "Show Chances", Command = "patrolroutes_showchance"})
		
		Panel:AddControl("CheckBox", {Label = "Autolink", Command = "patrolroutes_autolink"})
		
		Panel:AddControl("CheckBox", {Label = "Walk", Command = "patrolroutes_walk"})
		
		Panel:AddControl("CheckBox", {Label = "Strict", Command = "patrolroutes_strict"})
		
		Panel:AddControl("CheckBox", {Label = "Back and Forth", Command = "patrolroutes_type"})
		
		Panel:AddControl("CheckBox", {Label = "Undirected Links", Command = "patrolroutes_undirected"})
	
		Panel:AddControl("Slider", {Label = "Wait Time", Type = "Integer", Min = 0, Max = 100, Command = "patrolroutes_wait"})
		
		Panel:AddControl("Slider", {Label = "Chance", Type = "Integer", Min = 1, Max = 100, Command = "patrolroutes_chance"})
		
		Panel:AddControl("Slider", {Label = "Starting Node", Type = "Integer", Min = 1, Max = 100, Command = "patrolroutes_initnode"})
		
		Panel:AddControl("Slider", {Label = "Autoassigner Range", Type = "Integer", Min = 1, Max = 500, Command = "patrolroutes_aarange"})
		
		--Panel:AddControl("TextEntry", {Label = "Autoassigner Filter", Command = "patrolroutes_aafilter", MaxLength = "48"})
		
		Panel:AddControl("textbox", {Label = "Autoassigner Filter",	Command = "patrolroutes_aafilter"})
		
		local function reloadlist(List, prefix)
			if file.Exists( "patrolroutes" , "DATA") and file.IsDir( "patrolroutes", "DATA") then
				local files = file.Find( "patrolroutes/*.txt", "DATA" )
				List:Clear()
				for k,v in pairs(files) do
					local data = string.Explode( "(-)", v )
					if data[1] == prefix and data[2] == game.GetMap() then List:AddLine( string.Explode(".txt", data[3])[1] ) end
				end
			else
				file.CreateDir("patrolroutes")
			end
		end
		
		Panel:AddControl("Label", {Text = "\nSave / Load Patrol Route:"})
		
		local RouteList = vgui.Create( "DListView" )
		RouteList:SetMultiSelect( false )
		RouteList:AddColumn( "Name" )
		RouteList:SetMultiSelect( false )
		RouteList:SetTall( 100 )
		reloadlist(RouteList,"route")
		
		Panel:AddItem(RouteList)
		
		local Button = Panel:AddControl("Button", {
			Label = "Reload List",
			Command = ""
		})
		Button.DoClick = function() 
			reloadlist(RouteList,"route")
		end
		Button:SetTall(20)
		
		local Button = Panel:AddControl("Button", {
			Label = "Load",
			Command = ""
		})
		Button.DoClick = function() 
			if RouteList:GetSelected() != nil then
				local data = "patrolroutes/route(-)"..game.GetMap().."(-)"..RouteList:GetSelected()[1]:GetValue(1)..".txt"
				if file.Exists( data , "DATA") and !file.IsDir( data, "DATA") then
					local contents = string.Explode( "(_-_)" , file.Read(data , "DATA"))
					patrolroutes_clear()
					local points = pon.decode(contents[1])
					for k,v in pairs(points) do
						CreatePatrolPoint(points[k][1],points[k][2],-1)
					end
					PatrolLinks = pon.decode(contents[2])
				end
			end
		end
		Button:SetTall(20)
		
		local Button = Panel:AddControl("Button", {
			Label = "Delete",
			Command = ""
		})
		Button.DoClick = function() 
			if RouteList:GetSelected() != nil then
				local data = "patrolroutes/route(-)"..game.GetMap().."(-)"..RouteList:GetSelected()[1]:GetValue(1)..".txt"
				if file.Exists( data , "DATA") and !file.IsDir( data, "DATA") then
					file.Delete(data)
					reloadlist(RouteList,"route")
				end
			end
		end
		Button:SetTall(20)
		
		local RouteName = Panel:AddControl("textbox", {
			Label = "Name",
			Command = ""
		})
		
		local Button = Panel:AddControl("Button", {
			Label = "Save",
			Command = ""
		})
		Button.DoClick = function()
			if RouteName:GetValue() != "" then
				file.Write( "patrolroutes/route(-)"..game.GetMap().."(-)"..RouteName:GetValue()..".txt", pon.encode(PatrolPoints).."(_-_)"..pon.encode(PatrolLinks)) 
				reloadlist(RouteList,"route")
			end
		end
		Button:SetTall(20)
	end
	
else

	util.AddNetworkString("cl_patrolroutes_createpoint")
	util.AddNetworkString("sv_patrolroutes_createpoint")
	-- Modified --
	util.AddNetworkString("cl_patrolroutes_npcpatrol")
	util.AddNetworkString("sv_patrolroutes_npcpatrol")
	util.AddNetworkString("cl_patrolroutes_createautoassigner")
	util.AddNetworkString("sv_patrolroutes_createautoassigner")
	util.AddNetworkString("sv_patrolroutes_updateautoassigner")
	util.AddNetworkString("sv_patrolroutes_removeautoassigner")
	-- -- -- -- --
	util.AddNetworkString("patrolroutes_clearundo")
	--util.AddNetworkString("patrolroutes_holster")
	--util.AddNetworkString("patrolroutes_deploy")
	util.AddNetworkString("cl_patrolroutes_clear")
	util.AddNetworkString("sv_patrolroutes_createundo")
	util.AddNetworkString("cl_patrolroutes_removelastpoint")
	util.AddNetworkString("cl_patrolroutes_recoverpoints")
	util.AddNetworkString("cl_patrolroutes_recoverpoints2")
	util.AddNetworkString("sv_patrolroutes_recoverpoints")
	
	-- #################################################### --
	-- #################### NET SERVER #################### --
	-- #################################################### --
	
	net.Receive("patrolroutes_clearundo",function(len,pl)
		for _,undo in pairs(undo.GetTable()) do
			for i = #undo,1,-1 do
				local data = undo[i]
				if(data.Name == "PatrolPoint" && data.Owner == pl) then
					table.remove(undo,i)
				end
			end
		end
	end)
	
	net.Receive("sv_patrolroutes_createundo",function(len,pl)
		undo.Create("PatrolPoint")
			undo.AddFunction(function()
				net.Start("cl_patrolroutes_removelastpoint")
				net.Send(pl)
			end)
			undo.SetPlayer(pl)
			undo.SetCustomUndoText("Undone Patrol Point")
		undo.Finish("Patrol Point")
	end)
	
	net.Receive("sv_patrolroutes_recoverpoints",function(len,pl)
		local ent = net.ReadEntity()
		if ent:IsNPC() then
			if !ent.pr_prcontroller or !IsValid(ent.pr_prcontroller) then return end
			net.Start("cl_patrolroutes_recoverpoints")
				local numPPoints = #ent.pr_prcontroller.pr_nodes
				net.WriteUInt(numPPoints,12)
				for i = 1,numPPoints do
					net.WriteVector(ent.pr_prcontroller.pr_nodes[i][1])
					net.WriteFloat(ent.pr_prcontroller.pr_nodes[i][2])
				end
				for i = 1,numPPoints do
					local numLinks = #ent.pr_prcontroller.pr_links[i][1]
					net.WriteUInt(numLinks,12)
					for j = 1,numLinks do
						net.WriteUInt(ent.pr_prcontroller.pr_links[i][1][j][1],12)
						net.WriteUInt(ent.pr_prcontroller.pr_links[i][1][j][2],12)
					end
				end
			net.Send(pl)
		elseif ent:GetClass() == "ent_prautoassigner" then
			net.Start("cl_patrolroutes_recoverpoints2")
				local numPPoints = #ent.pr_nodes
				net.WriteUInt(numPPoints,12)
				for i = 1,numPPoints do
					net.WriteVector(ent.pr_nodes[i][1])
					net.WriteFloat(ent.pr_nodes[i][2])
				end
				local numLinks = #ent.pr_links
				net.WriteUInt(numLinks,12)
				for i = 1,numLinks do
					net.WriteUInt(ent.pr_links[i][1],12)
					net.WriteUInt(ent.pr_links[i][2],12)
					net.WriteUInt(ent.pr_links[i][3],12)
				end
			net.Send(pl)
		end 
		
	end)
	
	net.Receive("sv_patrolroutes_npcpatrol",function(len,pl)
		local npc = net.ReadEntity()
		local patrolwalk = net.ReadUInt(1)
		local patroltype = net.ReadUInt(2)
		local patrolundirected = net.ReadUInt(2)
		local patrolstrict = net.ReadUInt(1)
		local patrolstart = net.ReadUInt(12)
		local numPPoints = net.ReadUInt(12)
		
		if IsValid(npc.pr_prcontroller) then npc.pr_prcontroller:Remove() end
		
		if numPPoints > 0 then
			controller = ents.Create("ent_prcontroller")
			controller:Spawn()
			controller:Activate()
			if !IsValid(controller) then return end
			npc:DeleteOnRemove(controller)
			
			for i = 1,numPPoints do
				local pos = net.ReadVector()
				local wait = net.ReadFloat()
				controller:AddNode({pos,wait})
			end
			
			local numPLinks = net.ReadUInt(12)
			for i = 1,numPLinks do
				local a = net.ReadUInt(12)
				local b = net.ReadUInt(12)
				local chance = net.ReadUInt(12)
				controller:AddLink({a,b,chance})
			end
			
			controller:SetWalk(patrolwalk)
			controller:SetType(patroltype)
			controller:SetUndirected(patrolundirected)
			controller:SetStrictMovement(patrolstrict)
			controller:SetStart(math.Clamp(patrolstart,1,numPPoints))
			
			npc.pr_prcontroller = controller
			--npc.pr_prcontroller:SetParent(npc)
			npc.pr_prcontroller:AddNPC(npc)
		else
			npc.pr_prcontroller = nil
		end
	end)
	
	net.Receive("sv_patrolroutes_updateautoassigner",function(len,pl)
		local ent = net.ReadEntity()
		local patrolwalk = net.ReadUInt(1)
		local patroltype = net.ReadUInt(2)
		local patrolundirected = net.ReadUInt(2)
		local patrolstrict = net.ReadUInt(1)
		local patrolstart = net.ReadUInt(12)
		local range = net.ReadUInt(12)
		local filter = net.ReadString()
		local mode = net.ReadString()
		local numPPoints = net.ReadUInt(12)
		
		--if IsValid(ent.pr_prcontroller) then ent.pr_prcontroller:Remove() end
		
		ent:RemoveRoute()
		if numPPoints > 0 then
			for i = 1,numPPoints do
				local pos = net.ReadVector()
				local wait = net.ReadFloat()
				ent:AddNode({pos,wait})
			end
			
			local numPLinks = net.ReadUInt(12)
			for i = 1,numPLinks do
				local a = net.ReadUInt(12)
				local b = net.ReadUInt(12)
				local chance = net.ReadUInt(12)
				ent:AddLink({a,b,chance})
			end
			
			ent:SetWalk(patrolwalk)
			ent:SetType(patroltype)
			ent:SetUndirected(patrolundirected)
			ent:SetStrictMovement(patrolstrict)
			ent:SetStart(math.Clamp(patrolstart,1,numPPoints))
			if (mode == "auto") then 
				ent:SetRange(range)
				ent:SetFilter(filter)
				ent:SetNWInt("Range",range)
			end
			
			--npc.pr_prent = ent
			--npc.pr_prent:SetParent(npc)
			--npc.pr_prent:AddNPC(npc)
		--else
			--npc.pr_prent = nil
			
			-- Undo
		end
	end)
	
	net.Receive("sv_patrolroutes_createautoassigner",function(len,pl)
		local entpos = net.ReadVector()
		--local npc = net.ReadEntity()
		local patrolwalk = net.ReadUInt(1)
		local patroltype = net.ReadUInt(2)
		local patrolundirected = net.ReadUInt(2)
		local patrolstrict = net.ReadUInt(1)
		local patrolstart = net.ReadUInt(12)
		local range = net.ReadUInt(12)
		local filter = net.ReadString()
		local mode = net.ReadString()
		local numPPoints = net.ReadUInt(12)
		
		if numPPoints > 0 then
			local controller = nil
			if (mode == "auto") then 
				controller = ents.Create("ent_prautoassigner")
			elseif (mode == "wire") then
				if WireAddon == nil then return end
				controller = ents.Create("ent_prwireassigner")
			else return end
			controller:Spawn()
			controller:Activate()
			controller:SetPos(entpos)
			--if !IsValid(controller) then return end
			--npc:DeleteOnRemove(controller)
			
			for i = 1,numPPoints do
				local pos = net.ReadVector()
				local wait = net.ReadFloat()
				controller:AddNode({pos,wait})
			end
			
			local numPLinks = net.ReadUInt(12)
			for i = 1,numPLinks do
				local a = net.ReadUInt(12)
				local b = net.ReadUInt(12)
				local chance = net.ReadUInt(12)
				controller:AddLink({a,b,chance})
			end
			
			controller:SetWalk(patrolwalk)
			controller:SetType(patroltype)
			controller:SetUndirected(patrolundirected)
			controller:SetStrictMovement(patrolstrict)
			controller:SetStart(math.Clamp(patrolstart,1,numPPoints))
			if (mode == "auto") then 
				controller:SetRange(range)
				controller:SetFilter(filter)
				controller:SetNWInt("Range",range)
			end
			
			--npc.pr_prcontroller = controller
			--npc.pr_prcontroller:SetParent(npc)
			--npc.pr_prcontroller:AddNPC(npc)
		--else
			--npc.pr_prcontroller = nil
			
			-- Undo
			undo.Create("Autoassigner")
				undo.AddEntity(controller)
				undo.SetPlayer(pl)
				if (mode == "auto") then undo.SetCustomUndoText("Undone Autoassigner")
				else undo.SetCustomUndoText("Undone Wire Assigner") end
			undo.Finish("Autoassigner")
		end
	end)
	
	net.Receive("sv_patrolroutes_removeautoassigner",function(len,pl)
		local ent = net.ReadEntity()
		if IsValid( pl ) and pl:IsPlayer() and IsValid(ent) and ent:GetClass()=="ent_prautoassigner" then
			ent:Remove()
		end
	end)
	
	-- -- -- -- --
end

	-- ######################################################## --
	-- #################### TOOL FUNCTIONS #################### --
	-- ######################################################## --

function TOOL:Reload(tr)
	if(CLIENT) then return true end
	net.Start("cl_patrolroutes_clear")
	net.Send(self:GetOwner())
	return true
end

function TOOL:RightClick(tr)
	if(CLIENT) then return true	end
	if(tr.Entity:IsValid() && ((tr.Entity:IsNPC()) || (tr.Entity:GetClass() == "ent_prautoassigner") || (tr.Entity:GetClass() == "ent_prwireassigner"))) then
		net.Start("cl_patrolroutes_npcpatrol")
			net.WriteEntity(tr.Entity)
		net.Send(self:GetOwner())
		return true
	else
		net.Start("cl_patrolroutes_createautoassigner")
			net.WriteVector(tr.HitPos + (tr.HitNormal * 6))
		net.Send(self:GetOwner())
	return true
	end
end

function TOOL:LeftClick(tr)
	if(CLIENT) then return true end
	net.Start("cl_patrolroutes_createpoint")
		net.WriteVector(tr.HitPos + (tr.HitNormal * 6))
	net.Send(self:GetOwner())
	return true
end

function TOOL:Deploy()
	--[[
	if(CLIENT) then return end
	print("deploy")
	net.Start("patrolroutes_deploy")
	net.Send(self:GetOwner())
	return true
	]]--
end

function TOOL:Holster()
	--[[
	if(CLIENT) then return end
	print("holster")
	net.Start("patrolroutes_holster")
	net.Send(self:GetOwner())
	return true
	]]--
end