--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Array = setmetatable({this = script}, getmetatable(API))

function Array:FilterByType(_type, ...)
	local args = API:TupleToArgs(...)
	for i = #args, 1, -1 do
		local arg = args[i]
		if typeof(arg) ~= _type then
			table.remove(args, i)
		end
	end
	return args
end

function Array:FilterByClass(class, ...)
	local args = API:TupleToArgs(...)
	for i = #args, 1, -1 do
		local arg = args[i]
		if typeof(arg) ~= 'Instance' or arg.ClassName ~= class then
			table.remove(args, i)
		end
	end
	return args
end

function Array:FilterByName(name, ...)
	local args = API:TupleToArgs(...)
	for i = #args, 1, -1 do
		local arg = args[i]
		if typeof(arg) ~= 'Instance' or arg.Name ~= name then
			table.remove(args, i)
		end
	end
	return args
end

return Array
