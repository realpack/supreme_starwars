CreateConVar( "sv_hurtsounds", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY } )

-- local clone = {
--     "models/player/banks/phase_1/ctt/p1_ct_trooper.mdl",
--     "models/player/banks/phase_1/ctspecialist/p1_ct_specialist.mdl",
--     "models/player/banks/phase_1/ctsgt/p1_ct_sergeant.mdl",
--     "models/player/banks/phase_1/ctlt/p1_ct_lieutenant.mdl",
--     "models/player/banks/phase_1/ctheavy/p1_ct_heavy.mdl",
--     "models/player/banks/phase_1/ctcom/p1_ct_commander.mdl",
--     "models/player/banks/phase_1/ctcap/p1_ct_captain.mdl",
--     -- "",
--     -- "",
--     -- "",
--     -- "",
--     -- "",
--     -- "",
--     -- "",
--     -- "",
-- }

--=====================================================================================================

hook.Add( "PlayerDeath", "DeathSounds", function(ply)
    if ply and IsValid(ply) and meta.jobs[ply:Team()] then
		local job = meta.jobs[ply:Team()]
		if TYPE_CLONE and job and job.Type == TYPE_CLONE then
        	ply:EmitSound("sup_sound/death_sounds/death_"..math.random(1,31)..".mp3")
		elseif TYPE_DROID and job.Type == TYPE_DROID then
			ply:EmitSound("galactic/characters/droid/hit/droid_hit_0"..math.random(1,6)..".wav")
		end
    end
end)

--=====================================================================================================

for i = 1, 6 do
    local snd = "sup_sound/footsteps/footstep-heavy-0"..tostring(i)..".mp3"
    util.PrecacheSound( snd )

	local snd = "galactic/footsteps/droid/dr_run_0"..tostring(i)..".wav"
    util.PrecacheSound( snd )
end

hook.Add('PlayerFootstep', "PlayerFootstep_Sounds", function( ply, pos, foot, sound, volume, filter)
    local snd = "sup_sound/footsteps/footstep-heavy-0"..math.random( 1, 6 )..".mp3"

	local job = meta.jobs[ply:Team()]
    if ply and job and job.Type == TYPE_CLONE then
        ply:EmitSound(snd, 26)
		return true
    end

	local snd = "galactic/footsteps/droid/dr_run_0"..math.random( 1, 6 )..".wav"
    if ply and job and job.Type == TYPE_DROID then
        ply:EmitSound(snd, 26)
		return true
    end

	return false
end)

--=====================================================================================================

local tblhurtsounds = {
    'clone_hurt_sound_5',
    'clone_hurt_sound_15',
    'clone_hurt_sound_21',
    'clone_hurt_sound_29',
    'clone_hurt_sound_30',
    'clone_hurt_sound_31',
    'clone_hurt_sound_38',
    'clone_hurt_sound_39',
}

local tblhurtsounds2 = {
    'hurt_01',
    'hurt_02',
    'hurt_03',
}

for k, v in pairs(tblhurtsounds) do
    local snd = "sup_sound/hurt_sounds/clones/"..v..'.mp3'
    util.PrecacheSound( snd )
end

for k, v in pairs(tblhurtsounds2) do
    local snd = "sup_sound/hurt_sounds/clones/"..v..'.mp3'
    util.PrecacheSound( snd )
end

hook.Add('PlayerShouldTakeDamage', 'PlayerShouldTakeDamage_Sounds', function( ply, att )
    local snd = "sup_sound/hurt_sounds/clones/"..table.Random(tblhurtsounds)..'.mp3'

    ply.nextSound = ply.nextSound or 0
    if ((ply.nextSound or 0) >= CurTime()) then
		return
	end

    ply.nextSound = CurTime() + 3

    if ply and IsValid(att) and att:IsPlayer() then
		if meta.jobs[ply:Team()].Type == TYPE_CLONE then
        	ply:EmitSound("sup_sound/hurt_sounds/clones/"..table.Random(tblhurtsounds)..'.mp3', 100)
		elseif meta.jobs[ply:Team()].Type == TYPE_DROID then
			ply:EmitSound("galactic/characters/droid/hurt/"..table.Random(tblhurtsounds2)..'.wav', 100)
		end
    end
end)
