--	Author: Flymzye
local API = require(game:GetService('ReplicatedStorage'):WaitForChild('API'))

local Chat = setmetatable({this = script}, getmetatable(API))

local Enabled = false
local Focused = false

local Connections = {}

function Disconnect()
	for _, connection in next, Connections do
		if connection then
			connection:Disconnect()
		end
	end
end

--	Turns on the chat module
function Chat:ToggleCustom(...)
	local args = API:TupleToArgs(...)
	local player = API:FilterByClass('Player', args)[1]
	local enabled = API:FilterByType('boolean', args)[1]
	
	Enabled = not enabled
	
	if API.RunService:IsClient() then
		if Enabled then
			API.StarterGui:SetCoreGuiEnabled('Chat', false)
			
			local hud = API:WaitForChild('HUD', API.Players.LocalPlayer.PlayerGui)
			local input_box = API:WaitForDescendantOfClass(hud, 'Chat', 'Input', 'TextBox')
			
			Connections.Focused = input_box.Focused:Connect(function()
				if not Focused then
					API.RunService:BindToRenderStep('ChatInput', Enum.RenderPriority.Input.Value, function(step)
						Chat:FitContent(input_box.Parent)
					end)
				end
				Focused = true
			end)
			
			Connections.Input = API.UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
				if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.T then
					input_box:CaptureFocus()
				end
			end)
			
			--	Clear the chat if Escape was pressed to unfocus
			Connections.FocusLost = input_box.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
				if enterPressed and string.len(input_box.Text) > 0 then
					Chat.Message:Send(input_box.Text)
					input_box.Text = ''
				end
				
				if inputThatCausedFocusLoss.KeyCode == Enum.KeyCode.Escape then
					input_box.Text = ''
				end
				Chat:FitContent(input_box.Parent)
				API.RunService:UnbindFromRenderStep('ChatInput')
				Focused = false
			end)
			
			Connections.NewMessage = API:OnClientEvent('ChatMessage'):Connect(function(content, name, title)
				Chat.Message:Display(content, name, title)
			end)
		else
			Disconnect()
		end
	elseif API.RunService:IsServer() then
		if not player then
			if Enabled then
				Connections.NewMessage = API:OnServerEvent('ChatMessage'):Connect(function(player, content)
					warn('New message:', tostring(player) .. ': ' .. content)
					API:FireClient('ChatMessage', content, player.Name)
				end)
				
				Connections.NewPlayer = API.Players.PlayerAdded:Connect(function(player)
					API:FireClient('CustomChat', player)
				end)
			else
				Disconnect()
			end
		end
		
		API:FireClient('CustomChat', player, enabled)
	end
end

function Chat:FitContent(element)
	local content = API:FindChild('Content', element)
	if not content.TextFits then
		element.Size = UDim2.new(element.Size.X.Scale, 0, 0, content.TextSize)
		repeat element.Size = element.Size + UDim2.new(0, 0, 0, content.TextSize)
		until content.TextFits
	elseif content.AbsoluteSize.Y - content.TextBounds.Y > 0 then
		repeat element.Size = element.Size - UDim2.new(0, 0, 0, content.TextSize)
		until not (content.AbsoluteSize.Y - content.TextBounds.Y > 0)
	end
end

return Chat