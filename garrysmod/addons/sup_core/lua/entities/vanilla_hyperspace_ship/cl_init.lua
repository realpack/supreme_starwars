include("shared.lua")

function ENT:Initialize()
    local sound1 = "vanilla/hyperspace/vanilla_hyperspace_01.wav"
    local sound2 = "vanilla/hyperspace/vanilla_hyperspace_02.wav"

    if self:GetPlaySound() == "1" then
        local choose = math.random(0,1)
    	if choose == 0 then
    		surface.PlaySound(sound1)
    	else
    		surface.PlaySound(sound2)
    	end
    end
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()

end

function ENT:OnRemove()
end

/*

    Update Logs
    - 21/09/19 (1.0)
    - Uploaded to the workshop

    - 21/09/19 (1.1)
    - Added feature to undo ships.
    - Added option to toggle sound.
    - Added outline of ship.
    - Fixed jump position being slightly off.
    - Fixed an error that would occur when AI was ticked on a non LFS ship.

    - 23/09/19 (1.2)
    - Added version indicator
    - Cleaned up options
    - Added delay slider
    - Added presets
    - Fixed an error that would occur when using an in valid entity.

    - 24/09/19 (1.3)
    - Added help text
    - Added the ability to jump ships into hyperspace

    - 29/09/19 (1.4)
    - Cleaned up undo text

    - 30/09/19 (1.5)
    - Fixed a bug where ships would freeze if tool is spammed.
    - Fixed ghost to properly show the angle of the ship when 'Flip' is ticked.
    - Fixed a bug where ship would not jump properly if tickrate was different.
    - Fixed a bug where the hyperspace jump sound would play even if something wasn't jumping.
    - Made the hyperspace jump a bit faster.
    - Added the ability to use models.

    - 30/09/19 (1.6)
    - Fixed a bug where putting in invalid model would return an error.
    - Fixed a bug where a ship wouldn't spawn at all.

*/
