local replicatedStorage = game:GetService("ReplicatedStorage")
local attackEvent = replicatedStorage:WaitForChild("SwordAttackEvent")

local DAMAGE = 25
local COOLDOWN_TIME = 0.5
local MAX_DISTANCE = 8
local cooldowns = {}

attackEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	local rootPart = character.HumanoidRootPart
	local currentTime = os.clock()
	
	if cooldowns[player] then
		local timeElapsed = currentTime - cooldowns[player]
		if timeElapsed < COOLDOWN_TIME then
			return
		end
	end
	cooldowns[player] = currentTime
	
	local hitboxSize = Vector3.new(4, 4, 5)
	local hitboxCFrame = rootPart.CFrame * CFrame.new(0, 0, -3)
	
	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = {character}
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local hitParts = workspace:GetPartBoundsInBox(hitboxCFrame, hitboxSize, overlapParams)
	
	local damagedEntities = {}
	local hitDetected = false
	
	for _, part in ipairs(hitParts) do
		local hitModel = part:FindFirstAncestorOfClass("Model")
		if hitModel and hitModel ~= character then
			local humanoid = hitModel:FindFirstChildOfClass("Humanoid")
			local hrp = hitModel:FindFirstChild("HumanoidRootPart") or hitModel:FindFirstChild("Head")
			
			if humanoid and hrp and humanoid.Health > 0 and not damagedEntities[hitModel] then
				damagedEntities[hitModel] = true
				
				local distance = (rootPart.Position - hrp.Position).Magnitude
				
				if distance <= MAX_DISTANCE then
					hitDetected = true
					humanoid:TakeDamage(DAMAGE)
					
					print("--------------------------------------------------")
					print("[M1 ATTACK HIT SUCCESS]")
					print("Player: " .. player.Name)
					print("Target Hit: " .. hitModel.Name)
					print("Distance: " .. string.format("%.2f", distance) .. " studs")
					print("Damage Dealt: " .. DAMAGE)
					print("Target HP Left: " .. humanoid.Health)
					print("--------------------------------------------------")
				end
			end
		end
	end
	
	if not hitDetected then
		print("[M1 ATTACK] " .. player.Name .. " swung, but no target was in range.")
	end
end)