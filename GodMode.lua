local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function keepHealthFull()
	humanoid.Health = humanoid.MaxHealth
end

game:GetService("RunService").Stepped:Connect(keepHealthFull)

humanoid.HealthChanged:Connect(function()
	if humanoid.Health < humanoid.MaxHealth then
		humanoid.Health = humanoid.MaxHealth
	end
end)
