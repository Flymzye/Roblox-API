--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local VectorTwo = setmetatable({this = script}, getmetatable(API))

function VectorTwo:GetDeltaPosition(vector2, radius)
	return vector2 / radius
end

function VectorTwo:GetDeltaDistance(vector2, radius)
	return vector2.magnitude / radius
end

function VectorTwo:GetDeltaRadial(vector2, radius)
	radius = radius or vector2.magnitude
	
	local delta_position = VectorTwo:GetDeltaPosition(vector2, radius)
	local delta_distance = VectorTwo:GetDeltaDistance(vector2, radius)
	local clamped_distance = math.clamp(delta_distance, 0, 1)
	
	return delta_position.Unit * clamped_distance
end

return VectorTwo