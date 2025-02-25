Save = {
	unlocked_levels = 0,
	fullscreen = false,
	vsync = false,
	master_volume = 1.0,
	music_volume = 1.0,
	effect_volume = 1.0,
}

local save_file = "GameData.txt"

function Save:save_data()
	-- Serialization
	local save_data = "return {\n"
	for key, value in pairs(self) do
		if type(value) == "number" or type(value) == "boolean" then
			save_data = save_data .. string.format("    %s = %s,\n", key, tostring(value))
		elseif type(value) == "string" then
			save_data = save_data .. string.format('    %s = "%s",\n', key, value)
		end
	end

	save_data = save_data .. "}"

	--Write Data to file
	love.filesystem.write(save_file, save_data)
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
	local data_chunk = load(serialized_data)

	if not data_chunk then
		print("Error: Failed to load save data")
		return
	end

	local saved_data = data_chunk()
	for key, value in pairs(saved_data) do
		self[key] = value
	end
end
