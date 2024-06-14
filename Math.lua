function math.clamp(x, min, max)
	if x < min then
		return min
	elseif x > max then
		return max
	else
		return x
	end
end

function math.lerp(a, b, t)
	return a + t * (b - a)
end

function math.damp(current, target, smoothing, dt)
	return math.lerp(current, target, 1 - smoothing ^ dt)
	-- return math.lerp(current, target, 1 - math.exp(-smoothing * dt))
end
