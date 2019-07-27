--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Mouse = setmetatable({this = script}, getmetatable(API))

--	Settings
local GUI_OFFSET = Vector2.new(0, -36) -- How many pixels the gui inset takes up
local DEFAULT_ORIGIN = workspace.CurrentCamera.ViewportSize / 2
local DEFAULT_CURSOR = 'rbxassetid://1435770904'
local DEFAULT_OFFSET = Vector2.new()
local DEFAULT_RADIUS = 150

--	Variables
local Offset = Vector2.new()
local Origin
local Radius

--[[Getters]]--
function Mouse:GetRadius()
	return Radius or DEFAULT_RADIUS
end

function Mouse:GetOffset()
	return Offset or DEFAULT_OFFSET
end

function Mouse:GetOrigin()
	return Origin or DEFAULT_ORIGIN
end

function Mouse:GetPosition()
	return API.UserInputService:GetMouseLocation() + GUI_OFFSET + Offset
end

function Mouse:GetUDim2()
	return UDim2.new(0, Mouse:GetPosition().X, 0, Mouse:GetPosition().Y)
end

function Mouse:GetDelta()
	local delta_radial = API:GetDeltaRadial(API.Floor(Mouse:GetPosition() - Mouse:GetOrigin()), Mouse:GetRadius())
	return delta_radial
end

function Mouse:ToggleCursor()
	Mouse:Create()
end

--[[Setters]]--
function Mouse:SetRadius(radius)
	Radius = radius
end

function Mouse:SetOffset(position)
	Offset = -API.UserInputService:GetMouseLocation() + position
end

function Mouse:SetOrigin(origin)
	Origin = origin 
end

return Mouse