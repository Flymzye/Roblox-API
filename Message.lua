--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Message = setmetatable({this = script}, getmetatable(API))

function Message:Display(content, name, title)
	local hud = API:FindChild('HUD', API:WaitForChild('PlayerGui', API.Players.LocalPlayer))
	local chat = hud and API:FindChild('Chat', hud)
	local messages = chat and API:FindChild('Messages', chat)
	local message_template = messages and API:FindChild('Template', messages)
	
	if message_template then
		local message_label = message_template:Clone()
		local content_label = API:WaitForChild('Content', message_label)
		local title_label = API:WaitForChild('Title', message_label)
		local name_label = API:WaitForChild('Name', message_label)
		
		if content_label then
			content_label.Text = content or ''
		end
		
		if title_label then
			title_label.Text = title or ''
		end
		
		if name_label then
			name_label.Text = name or ''
		end
		
		message_label.Visible = true
		message_label.Name = 'Message'
		message_label.Parent = messages
		message_label.LayoutOrder = #API:FilterByClass('Frame', messages:GetChildren())
		
		API.Chat:FitContent(message_label)
	end
end

function Message:Send(content)
	if API.RunService:IsClient() then
		API:FireServer('ChatMessage', content)
	end
end

return Message