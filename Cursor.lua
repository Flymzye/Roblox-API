--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Cursor = setmetatable({this = script}, getmetatable(API))

--	Settings
local DEFAULT_POINTER = 'rbxassetid://1435770904'
local DEFAULT_ORIGIN = workspace.CurrentCamera.ViewportSize / 2
local DEFAULT_OFFSET = Vector2.new()
local DEFAULT_RADIUS = 150
local GUI_OFFSET = Vector2.new(0, -36) -- How many pixels the gui inset takes up

--	Variables
local Pointer
local Offset = Vector2.new()
local Origin
local Radius

--[[Functions]]--
function Cursor:Create(pointer)
	local hud = Instance.new('ScreenGui')
	hud.Name = 'HUD'
	hud = API:FindOrCreate(hud, API.Players.LocalPlayer.PlayerGui)

	if pointer then
		Pointer = pointer
	else
		Pointer = Instance.new('ImageLabel')
		Pointer.Size = UDim2.new(0, 24, 0, 24)
		Pointer.Image = DEFAULT_POINTER
		Pointer.BackgroundTransparency = 1
		Pointer.AnchorPoint = Vector2.new(.5, .5)
	end
	
	Pointer.Name = 'Cursor'
	
	pointer = API:FindOrCreate(Pointer, hud)
	
	API.RunService:BindToRenderStep('Cursor', Enum.RenderPriority.First.Value, function(step)
		if not pointer then
			API.RunService:UnbindFromRenderStep('Cursor')
			return
		end
		pointer.Position = API:GetUDim2()
	end)
end

return Cursor