function math.clamp(x, min, max)
	return x < min and min or x > max and max or x
end

function math.lerp(a, b, t)
	return a + t * (b - a)
end

function math.damp(current, target, smoothing, dt)
	return math.lerp(current, target, 1 - smoothing ^ dt)
end

function math.round_to_nearest_step(value, min, max, steps)
	local step_size = (max - min) / steps
	return math.floor((value - min) / step_size + 0.5) * step_size + min
end
