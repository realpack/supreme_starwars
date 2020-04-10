Decals.incsh "shared.lua"
Decals.inccl "cl_init.lua"

function ENT:Initialize()
    self:SetOpacity( 255 )
    self:SetDecalColor( Vector( 1, 1, 1 ) )
    self:SetScale( Vector( 3000, 3000, 0 ) )

    self:SetModel "models/hunter/plates/plate1x1.mdl"

    self:DrawShadow( false )

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    self:SetURL( Decals.cfg.DefaultImage )
end

function ENT:Use( act, ply )
    if ply:IsValid() and Decals.Authed( ply ) then
        net.Start "Decals.Edit"
        net.WriteEntity( self )
        net.Send( ply )
    end
end
