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
local click_effect_files = {
	"Sound/ClickSoundBase_1.wav",
	"Sound/ClickSoundBase_2.wav",
}
local ui_hover_effect_files = {
	"UIOnHover_1.wav",
	"UIOnHover_2.wav",
	"UIOnHover_3.wav",
	"UIOnHover_4.wav",
}

local function create_effect_variations(files)
	local variations = {}
	for i, file in ipairs(files) do
		variations[i] = love.audio.newSource(file, "static")
	end
	return variations
end

local function set_effect_volume(self, new_volume)
	for i = 1, #self do
		local audio_source = self[i]
		audio_source:setVolume(new_volume)
	end
end

function Sound:load()
	self.Music = love.audio.newSource(music_file, "stream")

	self.Effects = {
		block_steps = create_effect_variations(block_step_effect_files),
		clicks = create_effect_variations(click_effect_files),
		ui_hovers = create_effect_variations(ui_hover_effect_files),
	}

	function self.Effects:setVolume(new_volume)
		for _, effect in pairs(self) do
			if type(effect) == "table" then
				set_effect_volume(effect, new_volume)
			end
		end
	end
end

function Sound:update(dt)
	if not self.Music:isPlaying() then
		love.audio.play(self.Music)
	end
end

function Sound:set_volume(new_volume, sound_type)
	self[sound_type .. "_volume"] = new_volume

	if sound_type == SOUND_TYPE.MASTER or sound_type == SOUND_TYPE.MUSIC then
		self.Music:setVolume(self.master_volume * self.music_volume)
	end

	if sound_type == SOUND_TYPE.MASTER or sound_type == SOUND_TYPE.EFFECT then
		self.Effects:setVolume(self.master_volume * self.effect_volume)
	end
end

function Sound:play_sound_effect(sound_effect)
	local random_variation = nil

	if sound_effect == SOUND_EFFECT.BLOCK_STEP then
		random_variation = self.Effects.block_steps[math.random(#self.Effects.block_steps)]
	elseif sound_effect == SOUND_EFFECT.CLICK then
		random_variation = self.Effects.clicks[math.random(#self.Effects.clicks)]
	elseif sound_effect == SOUND_EFFECT.UI_HOVER then
		random_variation = self.Effects.ui_hovers[math.random(#self.Effects.ui_hovers)]
	end

	if random_variation then
		love.audio.play(random_variation)
	end
end
