local function rgb_byte(self)
	return self.r, self.g, self.b
end

local function rgb_color(self)
	return love.math.colorFromBytes(self.r, self.g, self.b)
end

local function equals(self, other)
	return self.r == other.r and self.g == other.g and self.b == other.b
end

local function has_values(self, r, g, b)
	return self.r == r and self.g == g and self.b == b
end

COLOR = {
	LIME = {
		r = 168,
		g = 202,
		b = 88,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	WHITE = {
		r = 235,
		g = 237,
		b = 233,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	LIGHT_BLUE = {
		r = 115,
		g = 190,
		b = 211,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	DARK_BLUE = {
		r = 37,
		g = 58,
		b = 94,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	ORANGE = {
		r = 218,
		g = 134,
		b = 62,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	RED = {
		r = 207,
		g = 87,
		b = 60,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	MAROON = {
		r = 117,
		g = 36,
		b = 56,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	PURPLE = {
		r = 122,
		g = 54,
		b = 123,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	PINK = {
		r = 223,
		g = 132,
		b = 165,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	GRAY = {
		r = 87,
		g = 114,
		b = 119,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	BLACK = {
		r = 25,
		g = 18,
		b = 28,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
	GREEN = {
		r = 117,
		g = 167,
		b = 67,
		rgb_byte = rgb_byte,
		rgb_color = rgb_color,
		equals = equals,
		has_values = has_values,
	},
}
