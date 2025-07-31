local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFriendlyMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Определяем платформу
local isMobile = game:GetService("UserInputService").TouchEnabled
local isDesktop = not isMobile

-- Основной фрейм
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, isMobile and 250 or 220, 0, isMobile and 300 or 220)
frame.Position = UDim2.new(0.5, isMobile and -125 or -110, 0.5, isMobile and -150 or -110)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Заголовок (для перемещения)
local title = Instance.new("TextLabel")
title.Text = isMobile and "Меню (удерживайте)" or "Меню (перетаскивайте)"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 16 or 14
title.Parent = frame

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Переменные для функций
local flying = false
local noclip = false
local menuVisible = true
local flySpeed = isMobile and 30 or 50
local flyBodyVelocity

-- Мобильный джойстик для Fly
local touchControls = {}
if isMobile then
    local touchFrame = Instance.new("Frame")
    touchFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
    touchFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
    touchFrame.BackgroundTransparency = 0.8
    touchFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    touchFrame.BorderSizePixel = 0
    touchFrame.Visible = false
    touchFrame.Parent = gui
    
    local touchCorner = Instance.new("UICorner")
    touchCorner.CornerRadius = UDim.new(0.5, 0)
    touchCorner.Parent = touchFrame
    
    touchControls.frame = touchFrame
    touchControls.active = false
    touchControls.startPos = Vector2.new()
    touchControls.currentPos = Vector2.new()
end

-- Функция Noclip
local function NoclipLoop()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Функция Fly (общая для мобильных и ПК)
local function Fly()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        if not flyBodyVelocity or flyBodyVelocity.Parent ~= root then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBodyVelocity.P = 1000
            flyBodyVelocity.Parent = root
        end
        
        local moveVector = Vector3.new()
        local cam = workspace.CurrentCamera.CFrame
        
        if isDesktop then
            -- Управление для ПК
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + cam.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - cam.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + cam.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - cam.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
        elseif isMobile and touchControls.active then
            -- Управление для мобильных
            local delta = (touchControls.currentPos - touchControls.startPos)
            local direction = Vector2.new(delta.X, delta.Y)
            local magnitude = math.min(direction.Magnitude, 100) / 100
            
            if magnitude > 0.1 then
                direction = direction.Unit
                moveVector = moveVector + (cam.LookVector * direction.Y * 1.5)
                moveVector = moveVector + (cam.RightVector * direction.X)
                moveVector = moveVector * magnitude
            end
        end
        
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * flySpeed
        end
        
        flyBodyVelocity.Velocity = moveVector
    elseif flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
end

-- Функция создания кнопок (адаптированная для мобильных)
local function createButton(text, yPosition, onClick)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, isMobile and 40 or 30)
    button.Position = UDim2.new(0.05, 0, yPosition, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = isMobile and 18 or 14
    button.AutoButtonColor = not isMobile
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        onClick(button)
    end)
    
    -- Эффекты при нажатии (для мобильных)
    if isMobile then
        button.TouchTap:Connect(function()
            onClick(button)
        end)
        
        button.MouseButton1Down:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
    else
        -- Эффекты при наведении (для ПК)
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
    end
    
    return button
end

-- Создаем кнопки
local buttons = {
    createButton("R6 Аватар", 0.15, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.RigType = Enum.HumanoidRigType.R6
            if isMobile then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Успех",
                    Text = "Аватар изменен на R6",
                    Duration = 2
                })
            end
        end
    end),
    
    createButton("Убить себя", 0.28, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end),
    
    createButton("Перезайти", 0.41, function(btn)
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end),
    
    createButton("Вкл. Fly", 0.54, function(btn)
        flying = not flying
        btn.Text = flying and "Выкл. Fly" or "Вкл. Fly"
        
        if isMobile then
            touchControls.frame.Visible = flying
            if flying then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fly режим",
                    Text = "Используйте джойстик справа",
                    Duration = 3
                })
            end
        end
    end),
    
    createButton("Вкл. Noclip", 0.67, function(btn)
        noclip = not noclip
        btn.Text = noclip and "Выкл. Noclip" or "Вкл. Noclip"
        
        if isMobile then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Noclip",
                Text = noclip and "Включен" or "Выключен",
                Duration = 2
            })
        end
    end)
}

-- Добавляем кнопки во фрейм
for _, button in pairs(buttons) do
    button.Parent = frame
end

-- Обработка сенсорного ввода для мобильных
if isMobile then
    local touchInput = game:GetService("UserInputService")
    
    touchInput.TouchStarted:Connect(function(touch, processed)
        if not processed and flying and touchControls.frame then
            local touchPos = Vector2.new(touch.Position.X, touch.Position.Y)
            local framePos = touchControls.frame.AbsolutePosition
            local frameSize = touchControls.frame.AbsoluteSize
            
            -- Проверяем, было ли касание в области джойстика
            if touchPos.X >= framePos.X and touchPos.X <= framePos.X + frameSize.X and
               touchPos.Y >= framePos.Y and touchPos.Y <= framePos.Y + frameSize.Y then
                touchControls.active = true
                touchControls.startPos = Vector2.new(framePos.X + frameSize.X/2, framePos.Y + frameSize.Y/2)
                touchControls.currentPos = touchPos
            end
        end
    end)
    
    touchInput.TouchMoved:Connect(function(touch, processed)
        if not processed and flying and touchControls.active then
            touchControls.currentPos = Vector2.new(touch.Position.X, touch.Position.Y)
        end
    end)
    
    touchInput.TouchEnded:Connect(function(touch, processed)
        if not processed and flying and touchControls.active then
            touchControls.active = false
            touchControls.currentPos = touchControls.startPos
        end
    end)
end

-- Функционал закрытия/открытия
closeButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    if isMobile and touchControls.frame then
        touchControls.frame.Visible = menuVisible and flying
    end
end)

if isMobile then
    closeButton.TouchTap:Connect(function()
        menuVisible = not menuVisible
        frame.Visible = menuVisible
        touchControls.frame.Visible = menuVisible and flying
    end)
end

-- Перемещение GUI (работает и на мобильных)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta
    if isMobile and input.UserInputType == Enum.UserInputType.Touch then
        delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
    else
        delta = input.Position - dragStart
    end
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch and input.Position.Y < frame.AbsolutePosition.Y + 40) then
        dragging = true
        dragStart = isMobile and Vector2.new(input.Position.X, input.Position.Y) or input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Добавляем фрейм в GUI
frame.Parent = gui

-- Горячая клавиша для показа/скрытия (только для ПК)
if isDesktop then
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.F5 then
            menuVisible = not menuVisible
            frame.Visible = menuVisible
        end
    end)
end

-- Постоянные проверки для Fly и Noclip
game:GetService("RunService").Stepped:Connect(function()
    if player.Character then
        if flying then
            Fly()
        end
        if noclip then
            NoclipLoop()
        end
    end
end)

-- Уведомление для мобильных пользователей
if isMobile then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Меню загружено",
        Text = "Нажмите на кнопки для управления",
        Duration = 5
    })
end
