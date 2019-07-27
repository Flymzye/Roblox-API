--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Query = setmetatable({this = script}, getmetatable(API))

--	Takes a string to search for, and a tuple of instances to search through
function Query:FindChild(query, ...)
	local instances = API:TupleToArgs(...)
	instances = API:FilterByType('Instance', instances)
	for _, instance in next, instances do
		for _, child in next, instance:GetChildren() do
			if child.Name == query then
				return child
			end
		end
	end
end

--	Takes an instance to search for, and an instance to search
--	If it does not find the query, it will create it
function Query:FindOrCreate(query, parent)
	local children_of_class = API:FilterByClass(query.ClassName, parent:GetChildren())
	local querried_children = API:FilterByName(query.Name, children_of_class)
	query = #querried_children > 0 and querried_children[1] or query
	query.Parent = parent
	
	return query
end


--	Takes a string to wait for, and a tuple of instances to search through
function Query:WaitForChild(query, ...)
	local args = API:TupleToArgs(...)
	local max_query_time = 3
	local start_tick = tick()
	
	local child = nil
	
	connection = API.RunService.Stepped:Connect(function(step)
		if tick() - start_tick > max_query_time then
			connection:Disconnect()
			warn('Did not find', query)
			return
		end
		
		child = API:FindChild(query, args)
		
		if child then
			connection:Disconnect()
		end
	end)
	
	repeat wait() until child or tick() - start_tick > max_query_time
	
	return child
end

--	Takes a string to search for, and a tuple of instances to search through
function Query:FindDescendant(...)
	local args = API:TupleToArgs(...)
	local initial = args[1]
	local path = nil
	
	--	Remove initial from the tuple so we do not check if it is its own parent
	table.remove(args, 1)
	
	if initial and typeof(initial) == 'Instance' then
		path = initial
		for _, str in next, args do
			if not path then
				break
			end
			path = path:FindFirstChild(str)
		end
	end
	
	return path
end

--	This method lets you wait for a descendant without waiting for every ancestor of that descendant
--	@return		Instance	- The deepest instance along the path
--	Takes a tuple. First argument should be an instance. All following should be strings, which act as a directory
function Query:WaitForDescendant(...)
	local args = API:TupleToArgs(...)
	local max_query_time = 3
	local initial = args[1]
	local path = nil
	
	--	Remove initial from the tuple so we do not check if it is its own parent
	table.remove(args, 1)
	
	if initial and typeof(initial) == 'Instance' then
		path = initial
		if #args == 0 then
			return path
		end
		for _, str in next, args do
			path = path:WaitForChild(str, max_query_time) or path
		end
	else
		return
	end
	
	if tostring(path) ~= args[#args] then
		local message = tostring(initial)
		for _, str in next, args do
			message = message .. '.' .. str
		end
		warn('Did not find', message)
		return
	end
	
	return path
end

--	Same as WaitForDescendant but this lets you wait for a descendant of a specified class, which allows you to have Instances of different classes but the same name
--	@return		Instance	- The deepest instance along the path
--	Takes a tuple. First argument should be an instance. Second argument should be the class name. All following should be strings, which act as a directory
function Query:WaitForDescendantOfClass(...)
	local args = API:TupleToArgs(...)
	local class = args[#args]
	
	table.remove(args, #args)
	
	local path = Query:WaitForDescendant(args)
	
	if path then
		path = path:FindFirstChildOfClass(class)
	end
	
	return path
end

--	@return		Table		- An array of instances who are of the given class.
--	Takes an instance to search and a class to search for
function Query:GetChildrenOfClass(instance, class, deep_search)
	local children = deep_search and instance:GetDescendants() or instance:GetChildren()
	children = API:FilterByClass(class, children)
	for i = #children, 1, -1 do
		local child = children[i]
		if child.ClassName ~= class then
			table.remove(children, i)
		end
	end
	return children
end

--	@return		Table		- An array of instances who are of the given class.
--	Takes an instance to search and a class to search for
function Query:GetDescendantsOfClass(instance, class)
	return Query:GetChildrenOfClass(instance, class, true)
end

return Query
