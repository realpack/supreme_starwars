local decalsEnabled = CreateClientConVar( "decals_enabled", 1, true, false )

include "shared.lua"

AccessorFunc( ENT, "Editing", "Editing", FORCE_BOOL )
AccessorFunc( ENT, "Decal", "Decal" )
AccessorFunc( ENT, "Loaded", "Loaded", FORCE_BOOL )

AccessorFunc( ENT, "EditURL", "EditURL" )
AccessorFunc( ENT, "EditScale", "EditScale" )
AccessorFunc( ENT, "EditOpacity", "EditOpacity" )
AccessorFunc( ENT, "EditColor", "EditColor" )

function ENT:Initialize()
    self:SetEditing( false )
    self:SetLoaded( false )

    self:SetDecal( Material "icon16/error.png" )

    self:ResetEditing()
end

function ENT:ResetEditing()
    self:SetEditURL( self:GetURL() )
    self:SetEditScale( self:GetScale() )
    self:SetEditOpacity( self:GetOpacity() )
    self:SetEditColor( self:GetDecalColor() )
end

function ENT:Load()
    local url = self:GetEditing() and self:GetEditURL() or self:GetURL()

    Decals.Load.URL( url, function( mat )
        if mat then
            self:SetDecal( mat )

            self:SetLoaded( true )
        end
    end )
end

function ENT:Think()
    if !self:GetLoaded() and self:GetDecal():GetName() == "icon16/error" then
        self:Load()
    end
end

function ENT:Draw()
	if !decalsEnabled:GetBool() then return end

    local scale = self:GetScale()
    local opacity = self:GetOpacity()
    local col = ColorAlpha( self:GetDecalColor():ToColor(), opacity )

    if self:GetEditing() then
        scale = self:GetEditScale()
        opacity = self:GetEditOpacity()
        col = ColorAlpha( self:GetEditColor():ToColor(), opacity )
    end

    local ang = self:GetAngles()
    ang:RotateAroundAxis( ang:Up(), 90 )

    local w, h = scale.x, scale.y

    cam.Start3D2D( self:GetPos(), ang, .05 )
        surface.SetMaterial( self:GetDecal() )
        surface.SetDrawColor( col )
        surface.DrawTexturedRect( -w / 2, -h / 2, w, h )
    cam.End3D2D()
end
