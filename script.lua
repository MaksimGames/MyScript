local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "CustomGui"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Меню"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

local button1 = Instance.new("TextButton")
button1.Name = "R6Button"
button1.Text = "Сделать R6"
button1.Size = UDim2.new(0.8, 0, 0, 30)
button1.Position = UDim2.new(0.1, 0, 0.25, 0)
button1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.Font = Enum.Font.SourceSans
button1.TextSize = 16
button1.Parent = frame

local button1Corner = Instance.new("UICorner")
button1Corner.CornerRadius = UDim.new(0, 6)
button1Corner.Parent = button1

local button2 = Instance.new("TextButton")
button2.Name = "KillButton"
button2.Text = "Убить себя"
button2.Size = UDim2.new(0.8, 0, 0, 30)
button2.Position = UDim2.new(0.1, 0, 0.5, 0)
button2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.Font = Enum.Font.SourceSans
button2.TextSize = 16
button2.Parent = frame

local button2Corner = Instance.new("UICorner")
button2Corner.CornerRadius = UDim.new(0, 6)
button2Corner.Parent = button2

local button3 = Instance.new("TextButton")
button3.Name = "RejoinButton"
button3.Text = "Перезайти"
button3.Size = UDim2.new(0.8, 0, 0, 30)
button3.Position = UDim2.new(0.1, 0, 0.75, 0)
button3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button3.TextColor3 = Color3.fromRGB(255, 255, 255)
button3.Font = Enum.Font.SourceSans
button3.TextSize = 16
button3.Parent = frame

local button3Corner = Instance.new("UICorner")
button3Corner.CornerRadius = UDim.new(0, 6)
button3Corner.Parent = button3

button1.MouseButton1Click:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.RigType = Enum.HumanoidRigType.R6
    end
end)

button2.MouseButton1Click:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end)

button3.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)