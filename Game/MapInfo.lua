local Map_info = { width = 1, height = 1 }
Map_info.__index = Map_info

function Map_info.new(type)
	return setmetatable({ type = type or BLOCK_TYPE.STATIC_BLOCK }, Map_info)
end

return Map_info
