--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Event = setmetatable({this = script}, getmetatable(API))

local REMOTE_EVENTS = Instance.new('Folder')
REMOTE_EVENTS.Name = 'REMOTE_EVENTS'

function Event:FireServer(event_name, ...)
	local event = API:FindDescendant(script, 'REMOTE_EVENTS', event_name)
	if event then
		event:FireServer(...)
	end
end

function Event:FireClient(event_name, client, ...)
	local event = API:FindDescendant(script, 'REMOTE_EVENTS', event_name) or Event:CreateRemote(event_name)
	if event then
		if client and typeof(client) == 'Instance' and client:IsA('Player') then
			event:FireClient(client, ...)
		else
			event:FireAllClients(client, ...)
		end
	end
end

function Event:CreateRemote(event_name)
	if API.RunService:IsServer() then
		local event = Instance.new('RemoteEvent')
		event.Name = event_name
		
		event = API:FindOrCreate(event, API:FindOrCreate(REMOTE_EVENTS, script))
		
		return event
	else
		warn('You can only create events from the server:', event_name)
	end
end

function Event:OnClientEvent(event_name)
	if API.RunService:IsClient() then
		local event = API:WaitForDescendant(script, 'REMOTE_EVENTS', event_name)
		return event and event.OnClientEvent
	end
end

function Event:OnServerEvent(event_name)
	if API.RunService:IsServer() then
		local event = API:FindDescendant(script, 'REMOTE_EVENTS', event_name) or Event:CreateRemote(event_name)
		return event and event.OnServerEvent
	end
end

return Event
