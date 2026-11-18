local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = players.LocalPlayer

local function setupTool(character)
	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			child.Activated:Connect(function()
				local attackEvent = replicatedStorage:FindFirstChild("SwordAttackEvent")
				if attackEvent then
					attackEvent:FireServer()
				end
			end)
		end
	end)
end

if player.Character then
	setupTool(player.Character)
end
player.CharacterAdded:Connect(setupTool)