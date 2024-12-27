require("Utility.SoundTypeEnum")
require("Utility.SoundEffectEnum")

Sound = {}
Sound.__index = Sound

local music_file = "Sound/Soundtrack_T.wav"

function Sound:load()
	Sound.Music = love.audio.newSource(music_file, "stream")
	Sound.Music:setVolume(0.5)
end

function Sound:update(dt)
	if not Sound.Music:isPlaying() then
		love.audio.play(Sound.Music)
	end
end
