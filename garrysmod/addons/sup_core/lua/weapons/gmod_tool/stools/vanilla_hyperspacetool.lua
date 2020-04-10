-- Hey! How amazing must I be that you extracted my addon to see this code!
-- It's a bit sloppy but whatever. :P
-- While you're here, check out Imperial Gaming, the server I orignally made this tool for.

-- Also, if you're a beginner at GLUA, feel free to (hopefully) learn something from this code. <3
-- Good day! o7

TOOL.Category = "Vanilla"

TOOL.Name = "Vanilla's Hyperspace Tool"

if ( CLIENT ) then
    language.Add( "Tool.vanilla_hyperspacetool.name", "Vanilla's Hyperspace Tool" )
    language.Add( "Tool.vanilla_hyperspacetool.desc", "Make any entity emerge or jump to hyperspace" )
	language.Add( "Tool.vanilla_hyperspacetool.left", "Choose the location for the entity to jump to" )
    language.Add( "Tool.vanilla_hyperspacetool.right", "Choose an entity to jump into hyperspace")
end

TOOL.ClientConVar[ "height" ] = "0"
TOOL.ClientConVar[ "angle" ] = "0"
TOOL.ClientConVar[ "ship" ] = ""
TOOL.ClientConVar[ "ai" ] = "0"
TOOL.ClientConVar[ "freeze" ] = "0"
TOOL.ClientConVar[ "flip" ] = "0"
TOOL.ClientConVar[ "shake" ] = "0"
TOOL.ClientConVar[ "sound" ] = "0"
TOOL.ClientConVar[ "delay" ] = "0"
TOOL.ClientConVar[ "model" ] = ""
TOOL.ClientConVar[ "spawnmodel" ] = "0"



TOOL.Information = {

	{ name = "left" },
    { name = "right" }

}




function TOOL:LeftClick( trace, attach )
    if (!trace.HitPos) then return false end


    local Delay = self:GetClientInfo("delay")
    local Height = self:GetClientNumber("height")
    local vAngle = self:GetClientNumber("angle")
    local Ship = self:GetClientInfo("ship")
    local AI = self:GetClientInfo("ai")
    local Freeze = self:GetClientInfo("freeze")
    local Flip = self:GetClientInfo("flip")
    local Shake = self:GetClientInfo("shake")
    local vSound = self:GetClientInfo("sound")
    local vModel = self:GetClientInfo("model")
    local SpawnModel = self:GetClientInfo("spawnmodel")

    local Valid = false

    for k, v in pairs(scripted_ents.GetList()) do
        if Ship == v.t.ClassName then
            Valid = true
        end
    end

    if SpawnModel == "1" then
        Valid = true
    end

    if Valid == true then
        timer.Simple(Delay, function()
            local ent = ents.Create("vanilla_hyperspace_ship")
            ent:SetKeyValue("AI", AI)
            ent:SetKeyValue("Freeze", Freeze)
            ent:SetKeyValue("Flip", Flip)
            ent:SetKeyValue("Shake", Shake)
            ent:SetKeyValue("Sound", vSound)
            ent:SetKeyValue("SpawnModel", SpawnModel)
            ent:SetKeyValue("ActualModel", vModel)
            ent:SetKeyValue("Entity", Ship)
            ent:SetOwner(self:GetOwner())
            ent:SetPos(trace.HitPos + Vector(0,0,Height))
            ent:SetAngles(Angle(0,0,0) + Angle(0,vAngle,0))
            ent:Spawn()
            ent:SetMoveType(MOVETYPE_NONE)

            undo.Create( "Ship" )
                undo.AddEntity( ent )
                undo.SetPlayer( self:GetOwner() )
                undo.SetCustomUndoText("Undone Ship")
            undo.Finish()
            return false
        end)
    end
end

function TOOL:RightClick( trace )
    local ent = trace.Entity
    local sound = ents.Create("vanilla_highwake")
    self.Timer = tostring(math.random(0,50000))

    if not IsValid(ent) then return end
    sound:SetPos(ent:GetPos())
    sound:Spawn()
    sound:SetNoDraw(true)

    if IsValid(ent) then
        timer.Simple(3,function()
            if not IsValid(ent) then return end
            timer.Create(self.Timer,0,0.2,function()
                if not ent:IsValid() then return end
                if self:GetClientInfo("flip") == "0" then
                    ent:SetPos(ent:GetPos() + ent:GetForward() * 700)
                else
                    ent:SetPos(ent:GetPos() - ent:GetForward() * 700)
                end
            end)
        end)
        timer.Create(self.Timer .. "Ender",5+ 1,1,function()
            timer.Remove(self.Timer)
            if not IsValid(ent) then return end
            ent:Remove()
        end)
    end
end

function TOOL:Think()
    if timer.RepsLeft(self.Timer .. "Ender") == 0 then
        timer.Remove(self.Timer .. "Ender")
    end
end


function TOOL:UpdateGhost( ent, pl )
	if ( !IsValid( ent ) ) then return end
	local trace = pl:GetEyeTrace()
	if ( !trace.Hit ) then
		ent:SetNoDraw( true )
		return
	end
	ent:SetPos( trace.HitPos + Vector(0,0,self:GetClientNumber("height")) )
    if self:GetClientNumber("flip") == 0 then
        ent:SetAngles( (Angle(0,0,0) + Angle(0,90,0)) + Angle(0,self:GetClientNumber("angle"),0) )
    else
        ent:SetAngles( Angle(0,0,0) + Angle(0,270,0) + Angle(0,self:GetClientNumber("angle"),0))
    end
	ent:SetNoDraw( false )
    ent:SetMaterial("phoenix_storms/dome",true)
    ent:SetColor(Color(0,255,0,125))

end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) ) then
		self:MakeGhostEntity( "models/xqm/jetbody3_s5.mdl", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	self:UpdateGhost( self.GhostEntity, self:GetOwner() )
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )
    if not CLIENT then return end

    CPanel:SetName( "Vanilla's Hyperspace Tool" )

    CPanel:Help( "Version: 1.8" )

    CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "vanilla_hyperspacetool", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

    CPanel:NumSlider("Height", "vanilla_hyperspacetool_height", 0, 10000)
    CPanel:ControlHelp("Sets the height of the spawned ship.")

    CPanel:NumSlider("Angle", "vanilla_hyperspacetool_angle", 0, 360)
    CPanel:ControlHelp("Sets the angle of the spawned ship.")

    CPanel:NumSlider("Delay", "vanilla_hyperspacetool_delay", 0, 10, 1)
    CPanel:ControlHelp("Sets the delay (in seconds) of the spawned ship.")

    CPanel:TextEntry("Entity Name", "vanilla_hyperspacetool_ship")
    CPanel:ControlHelp("The entity name of the desired ship.")

    CPanel:CheckBox("Spawn Model?", "vanilla_hyperspacetool_spawnmodel")
    CPanel:ControlHelp("Tick this if you would like to spawn in a model instead of an entity.")

    CPanel:TextEntry("Model Name", "vanilla_hyperspacetool_model")
    CPanel:ControlHelp("*NOT REQUIRED* Only use if you would like to spawn in a model that is not an entity.")

    CPanel:CheckBox("Enable AI","vanilla_hyperspacetool_ai")
    CPanel:ControlHelp("Enables AI for the spawned ship. (LFS ONLY)")

    CPanel:CheckBox("Freeze","vanilla_hyperspacetool_freeze")
    CPanel:ControlHelp("Freezes the spawned ship.")

    CPanel:CheckBox("Flip","vanilla_hyperspacetool_flip")
    CPanel:ControlHelp("Flips the spawned ship. (For ships with models that are backwards.) Effects the direction the ship will jump to aswell.")

    CPanel:CheckBox("Enable Screenshake","vanilla_hyperspacetool_shake")
    CPanel:ControlHelp("Enables screenshake for people near the ship.")

    CPanel:CheckBox("Enable Sound","vanilla_hyperspacetool_sound")
    CPanel:ControlHelp("Plays sound of the ship jumping in to all players.")

end
