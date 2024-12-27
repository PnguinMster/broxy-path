require("Utility.SoundTypeEnum")
require("Utility.SoundEffectEnum")

Sound = {}
Sound.__index = Sound

Sound.master_volume = 1
Sound.music_volume = 1
Sound.effect_volume = 1

local music_file = "Sound/Soundtrack_T.wav"
local block_step_effect_files = {
	"Sound/BlockStep_1.wav",
	"Sound/BlockStep_2.wav",
	"Sound/BlockStep_3.wav",
	"Sound/BlockStep_4.wav",
	"Sound/BlockStep_5.wav",
	"Sound/BlockStep_6.wav",
}
local click_efffect_files = {
	"Sound/ClickSoundBase_1.wav",
	"Sound/ClickSoundBase_2.wav",
}
local ui_hover_effect_files = {
	"UIOnHover_1.wav",
	"UIOnHover_2.wav",
	"UIOnHover_3.wav",
	"UIOnHover_4.wav",
}

function Sound:load()
	Sound.Effects = {}
	Sound.Music = love.audio.newSource(music_file, "stream")
end

function Sound:update(dt)
	if not Sound.Music:isPlaying() then
		love.audio.play(Sound.Music)
	end
end

function Sound:set_volume(new_volume, sound_type)
	Sound[sound_type .. "_volume"] = new_volume

	if sound_type == SOUND_TYPE.MASTER or sound_type == SOUND_TYPE.MUSIC then
		Sound.Music:setVolume(Sound.master_volume * Sound.music_volume)
	end

	if sound_type == SOUND_TYPE.MASTER or sound_type == SOUND_TYPE.EFFECT then
		Sound.Effects:setVolume(Sound.master_volume * Sound.effect_volume)
	end
end
