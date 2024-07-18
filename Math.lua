function math.clamp(x, min, max)
	return x < min and min or x > max and max or x
end

function math.lerp(a, b, t)
	return a + t * (b - a)
end

function math.damp(current, target, smoothing, dt)
	return math.lerp(current, target, 1 - math.exp(-smoothing * dt))
end
