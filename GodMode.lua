-- LocalScript, StarterPlayerScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local invincible = false

-- GODMODE: Sağlığı sürekli full tut
RunService.Stepped:Connect(function()
	if invincible and humanoid then
		humanoid.Health = humanoid.MaxHealth
	end
end)

humanoid.HealthChanged:Connect(function()
	if invincible and humanoid.Health < humanoid.MaxHealth then
		humanoid.Health = humanoid.MaxHealth
	end
end)

-- GUI oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodModeGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Arkaplan Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2,0,0.08,0) -- ekran boyutuna göre
frame.Position = UDim2.new(0.02,0,0.02,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,12)
frameCorner.Parent = frame

-- Ön planda Buton
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0,5,0,5)
button.BackgroundColor3 = Color3.fromRGB(200,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Text = "GODMODE OFF"
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0,12)
buttonCorner.Parent = button

-- Buton tıklayınca aktif/pasif et
button.MouseButton1Click:Connect(function()
	invincible = not invincible
	if invincible then
		button.Text = "GODMODE ON"
		button.BackgroundColor3 = Color3.fromRGB(0,200,0)
	else
		button.Text = "GODMODE OFF"
		button.BackgroundColor3 = Color3.fromRGB(200,0,0)
	end
end)

-- Dragging mekanizması
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Ekran boyutu değişirse frame boyutunu koru
screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	frame.Size = UDim2.new(0.2,0,0.08,0)
end)
