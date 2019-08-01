--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Event = setmetatable({this = script}, getmetatable(API))

local REMOTE_EVENTS = Instance.new('Folder')
REMOTE_EVENTS.Name = 'REMOTE_EVENTS'

local BINDABLE_EVENTS = Instance.new('Folder')
BINDABLE_EVENTS.Name = 'BINDABLE_EVENTS'

local REMOTE_FUNCTIONS = Instance.new('Folder')
REMOTE_FUNCTIONS.Name = 'REMOTE_FUNCTIONS'

function Event:FireServer(event_name, ...)
	local event = API:FindDescendant(script, 'REMOTE_EVENTS', event_name)
	return event and event:FireServer(...)
end

function Event:InvokeServer(function_name, ...)
	local func = API:FindDescendant(script, 'REMOTE_FUNCTIONS', function_name) or Event:CreateRemoteFunction(function_name)
	return func and func:InvokeServer(...)
end

function Event:FireClient(event_name, client, ...)
	local event = API:FindDescendant(script, 'REMOTE_EVENTS', event_name) or Event:CreateRemoteEvent(event_name)
	if client and typeof(client) == 'Instance' and client:IsA('Player') then
		event:FireClient(client, ...)
	else
		event:FireAllClients(client, ...)
	end
end

function Event:CreateBindable(event_name)
	local event = Instance.new('BindableEvent')
	event.Name = event_name
	return API:FindOrCreate(event, API:FindOrCreate(BINDABLE_EVENTS, script))
end

function Event:CreateRemoteEvent(event_name)
	if API.RunService:IsServer() then
		local event = Instance.new('RemoteEvent')
		event.Name = event_name
		return API:FindOrCreate(event, API:FindOrCreate(REMOTE_EVENTS, script))
	else
		warn('You can only create events from the server:', event_name)
	end
end

--	Shortcut to CreateRemoteEvent
function Event:CreateRemote(event_name)
	Event:CreateRemoteEvent(event_name)
end

function Event:CreateRemoteFunction(function_name)
	if API.RunService:IsServer() then
		local func = Instance.new('RemoteFunction')
		func.Name = function_name
		return API:FindOrCreate(func, API:FindOrCreate(REMOTE_FUNCTIONS, script))
	else
		warn('You can only create events from the server:', function_name)
	end
end

function Event:OnClientEvent(event_name)
	if API.RunService:IsClient() then
		local event = API:WaitForDescendant(script, 'REMOTE_EVENTS', event_name) or Event:CreateRemoteEvent(event_name)
		return event and event.OnClientEvent
	end
end

function Event:OnServerEvent(event_name)
	if API.RunService:IsServer() then
		local event = API:FindDescendant(script, 'REMOTE_EVENTS', event_name) or Event:CreateRemoteEvent(event_name)
		return event and event.OnServerEvent
	end
end

function Event:OnServerInvoke(function_name)
	local func = API:FindDescendant(script, 'REMOTE_FUNCTIONS', function_name) or Event:CreateRemoteFunction(function_name)
	return func
end

function Event:OnEvent(event_name)
	local event = API:FindDescendant(script, 'BINDABLE_EVENTS', event_name) or Event:CreateBindable(event_name)
	return event and event.Event
end

function Event:Fire(event_name, ...)
	local event = API:FindDescendant(script, 'BINDABLE_EVENTS', event_name) or Event:CreateBindable(event_name)
	event:Fire(...)
end

return Event
