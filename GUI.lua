--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Gui = setmetatable({this = script}, getmetatable(API))

local DEFAULT_PADDING = Instance.new('UIPadding')
DEFAULT_PADDING.PaddingBottom = UDim.new(0, 5)
DEFAULT_PADDING.PaddingLeft = UDim.new(0, 5)
DEFAULT_PADDING.PaddingRight = UDim.new(0, 5)
DEFAULT_PADDING.PaddingTop = UDim.new(0, 5)

--	Pads all given elements with the given padding, or a default padding of 5 pixels on all sides
--	First instance can be a UIPadding
function Gui:Pad(...)
	local args = API:TupleToArgs(...)
	local padding = typeof(args[1]) == 'Instance' and args[1].ClassName == 'UIPadding' and args[1] or DEFAULT_PADDING
	local elements = API:FilterByType('Instance', args)
	for _, element in next, elements do
		local clone = padding:Clone()
		clone.Parent = element
	end
end

--	Same as Pad except it pads by giving the element's parent a UIPadding
function Gui:Push(...)
	local args = API:TupleToArgs(...)
	local padding = typeof(args[1]) == 'Instance' and args[1].ClassName == 'UIPadding' and args[1] or DEFAULT_PADDING
	local elements = API:FilterByType('Instance', args)
	for _, element in next, elements do
		local clone = padding:Clone()
		clone.Parent = element.Parent
	end
end

return Gui