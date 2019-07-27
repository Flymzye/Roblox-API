--	Author: Flymzye
local API = setmetatable({this = script}, {
	__index = function(t, index)
		local this = t.this
		if not rawget(t, index) then
			--	If this check is successful, we will return a module.
			--	local mouse = API:Mouse
			if this:FindFirstChild(index) and this:FindFirstChild(index):IsA('ModuleScript') then
				return require(this[index])
			end
			
			local descendants = this:GetDescendants()
			--	Search every descendant module until we find our index or we run out of modules
			for _, descendant in next, descendants do
				if descendant.ClassName == 'ModuleScript' then
					if rawget(require(descendant), index) then
						return(require(descendant)[index])
					end
				end
			end
			
			local descendants = this:GetDescendants()
			--	Search every descendant module until we find our index or we run out of modules
			for _, descendant in next, descendants do
				if descendant.ClassName == 'ModuleScript' then
					if descendant.Name == index then
						return(require(descendant))
					end
				end
			end
			
			--	If this check is successful, we will return a service. No more using "game:GetService()" in every script.
			--	local player = API:Players.LocalPlayer
			local service
			local success, message = pcall(function()
				-- For some reason, game:GetService() can return nil instead of throwing an error for some strings, e.g. "WaitForChild"
 				service = game:GetService(tostring(index))
			end)
			
			if service then
				return service
			end
			
			descendants = this:GetChildren()
			for _, descendant in next, descendants do
				local children = descendant:GetChildren()
				for _, child in next, children do
					descendants[#descendants + 1] = child
				end
				local i, j = string.find(index, descendant.Name)
				local module = string.find(index, descendant.Name) and string.sub(index, i, j)
				local command = string.find(index, descendant.Name) and string.sub(index, 1, i - 1) .. string.sub(index, j + 1)
				if module then
					return require(descendant)[command]
				end
			end
			
			--	We couldn't find this index
			return function()
				warn(this, 'could not find:', index)
			end
		end
	end,
})

--	Converts tuples to tables of arguments
function API:TupleToArgs(...)
	if ... and typeof(...) == 'table' then
		return ...
	end
	return {...}
end

return API