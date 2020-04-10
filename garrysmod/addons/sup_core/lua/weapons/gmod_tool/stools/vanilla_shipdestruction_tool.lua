-- Why hello there!

TOOL.Category		= "Vanilla"
TOOL.Name			= "Vanilla's Ship Destruction Tool"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.AdminOnly		= true

if ( CLIENT ) then
    language.Add( "Tool.vanilla_shipdestruction_tool.name", "Vanilla's Ship Destruction Tool" )
    language.Add( "Tool.vanilla_shipdestruction_tool.desc", "Destroy ships, in style!" )
    language.Add( "Tool.vanilla_shipdestruction_tool.left", "Target a entity or prop to destroy.")
end

TOOL.Information = {

    { name = "left" }

}

TOOL.ClientConVar[ "length" ] = "16"
TOOL.ClientConVar[ "explosize" ] = "1"
TOOL.ClientConVar[ "finalsize" ] = "5"
TOOL.ClientConVar[ "turnrate" ] = "0.06"
TOOL.ClientConVar[ "fallrate" ] = "5"
TOOL.ClientConVar[ "forwardrate" ] = "5"
TOOL.ClientConVar[ "flip" ] = "0"

function TOOL:LeftClick( trace )
    if (!trace.Entity) then return false end
    if (CLIENT) then return true end
    local ent = trace.Entity
    if ent == "vanilla_shipdestruction" then print("tes") end

    local ship = ents.Create("vanilla_shipdestruction")
    ship:SetPos(ent:GetPos())
    ship:SetAngles(ent:GetAngles())
    ship:SetModel(ent:GetModel())
    ship:SetKeyValue("Length",self:GetClientInfo("length"))
    ship:SetKeyValue("ExplosionSize",self:GetClientInfo("explosize"))
    ship:SetKeyValue("FinalSize",self:GetClientInfo("finalsize"))
    ship:SetKeyValue("Flip",self:GetClientInfo("flip"))
    ship:SetKeyValue("TurnRate",self:GetClientInfo("turnrate"))
    ship:SetKeyValue("FallRate",self:GetClientInfo("fallrate"))
    ship:SetKeyValue("ForwardRate",self:GetClientInfo("forwardrate"))
    if ! util.IsValidModel(ent:GetModel()) then return end
    ship:Spawn()
    ent:Remove()

    undo.Create("Destruction")
        undo.AddEntity(ship)
        undo.SetCustomUndoText("Undone Ship Destruction")
        undo.SetPlayer(self:GetOwner())
    undo.Finish()

    return true
end

function TOOL:RightClick( trace )
end

function TOOL:Reload( trace )
end

function TOOL:Think()
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
    CPanel:SetName("Vanilla's Ship Destruction Tool")

    CPanel:Help("Version 1.1")

    CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "vanilla_shipdestruction_tool", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

    CPanel:NumSlider("Destruction Length","vanilla_shipdestruction_tool_length","1","120","1")
    CPanel:ControlHelp("Sets the length of the ship explosion. (in seconds)")

    CPanel:NumSlider("Explosion Size","vanilla_shipdestruction_tool_explosize","0","5","0")
    CPanel:ControlHelp("Sets the standard explosion size.")

    CPanel:NumSlider("Final Explosion Size","vanilla_shipdestruction_tool_finalsize","0","20","0")
    CPanel:ControlHelp("Sets the final explosion size.")

    CPanel:NumSlider("Tilt Rate","vanilla_shipdestruction_tool_turnrate","0","1","2")
    CPanel:ControlHelp("Sets how fast the ship tilts down.")

    CPanel:NumSlider("Fall Rate","vanilla_shipdestruction_tool_fallrate","0","10","0")
    CPanel:ControlHelp("Sets how fast the ship falls down.")

    CPanel:NumSlider("Forward Rate","vanilla_shipdestruction_tool_forwardrate","0","10","0")
    CPanel:ControlHelp("Sets how fast the ship is moving forward")

    CPanel:CheckBox("Flip","vanilla_shipdestruction_tool_flip")
    CPanel:ControlHelp("Tick if the ship is turning/moving in the wrong direction.")

end
