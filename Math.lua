--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Math = setmetatable({this = script}, getmetatable(API))

function Math.Floor(position)
	if typeof(position) == 'Vector3' then
		return Vector3.new(math.floor(position.X), math.floor(position.Y), math.floor(position.Z))
	elseif typeof(position) == 'CFrame' then
		return CFrame.new(math.floor(position.X), math.floor(position.Y), math.floor(position.Z))
	elseif typeof(position) == 'Vector2' then
		return Vector2.new(math.floor(position.X), math.floor(position.Y))
	end
end

return Math