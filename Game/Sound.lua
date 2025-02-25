require("Utility.SoundTypeEnum")
require("Utility.SoundEffectEnum")

Sound = {}

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
local block_bounce_effect_files = {
	"Sound/BlockBounce_1.wav",
	"Sound/BlockBounce_2.wav",
	"Sound/BlockBounce_3.wav",
	"Sound/BlockBounce_4.wav",
	"Sound/BlockBounce_5.wav",
	"Sound/BlockBounce_6.wav",
}
local click_effect_files = {
	"Sound/ClickSoundBase_1.wav",
	"Sound/ClickSoundBase_2.wav",
}
local ui_hover_effect_files = {
	"Sound/UIOnHover_1.wav",
	"Sound/UIOnHover_2.wav",
	"Sound/UIOnHover_3.wav",
	"Sound/UIOnHover_4.wav",
}
local level_complete_effect_file = "Sound/WinSound.wav"

local function create_effect_variations(files)
	local variations = {}
	for i, file in ipairs(files) do
		variations[i] = love.audio.newSource(file, "static")
	end
	return variations
end

-- local function setVolume(self, new_volume)
-- 	for i = 1, #self do
-- 		local audio_source = self[i]
-- 		audio_source:setVolume(new_volume)
-- 	end
-- end

function Sound:load()
	self.Music = love.audio.newSource(music_file, "stream")
	self.master_volume = Save.master_volume
	self.music_volume = Save.music_volume
	self.effect_volume = Save.effect_volume

	--set table of sound effects and variations
	self.Effects = {
		block_step = create_effect_variations(block_step_effect_files),
		block_bounce = create_effect_variations(block_bounce_effect_files),
		clicks = create_effect_variations(click_effect_files),
		ui_hovers = create_effect_variations(ui_hover_effect_files),
		level_complete = love.audio.newSource(level_complete_effect_file, "static"),
	}

	--set volume for all sound effects
	function self.Effects:setVolume(new_volume)
		for _, effect in pairs(self) do
			effect:setVolume(new_volume)
		end
	end
end

function Sound:update(_)
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

	print("changing ", self[sound_type .. "volume"], "to ", new_volume)
end

function Sound:play_sound_effect(sound_effect)
	local random_variation = nil

	--get random variation of sound effect
	if sound_effect == SOUND_EFFECT.BLOCK_STEP then
		random_variation = self.Effects.block_step[math.random(#self.Effects.block_steps)]
	elseif sound_effect == SOUND_EFFECT.CLICK then
		random_variation = self.Effects.clicks[math.random(#self.Effects.clicks)]
	elseif sound_effect == SOUND_EFFECT.UI_HOVER then
		random_variation = self.Effects.ui_hovers[math.random(#self.Effects.ui_hovers)]
	elseif sound_effect == SOUND_EFFECT.BLOCK_BOUNCE then
		random_variation = self.Effects.block_bounce[math.random(#self.Effects.block_bounce)]
	elseif sound_effect == SOUND_EFFECT.LEVEL_COMPLETE then
		random_variation = self.Effects.level_complete
	end

	--play variation of sound
	if random_variation ~= nil then
		love.audio.play(random_variation)
	end
end
