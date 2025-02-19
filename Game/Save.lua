Save = {
	unlocked_levels = 0,
	fullscreen = false,
	vsync = false,
	master_volume = 1.0,
	music_volume = 1.0,
	effect_volume = 1.0,
}

local save_file = "save.txt"

function Save:save_data()
	-- Serialize
	local serialized_data = ""
	for key, value in pairs(self) do
		serialized_data = serialized_data .. key .. "=" .. tostring(value) .. "\n"
	end

	-- Write data to file
	local success, message = love.filesystem.write(save_file, serialized_data)
	if not success then
		print("Failed to save data:", message)
	else
		print("Game saved successfully")
	end
end

function Save:load_data()
	-- Check if file exist
	if not love.filesystem.getInfo(save_file) then
		print("No save file found")
		return
	end

	-- Read file
	local serialized_data = love.filesystem.read(save_file)

	-- Deserialize
	for line in serialized_data.gmatch("[^\r\n]+") do
		local key, value = line.match("(.+)=(.+)")
		if key and value then
			self[key] = value
		end
	end
end
