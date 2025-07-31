local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "KeyProtectedMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Создаем интерфейс для ввода ключа
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 200)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
keyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = keyFrame

local title = Instance.new("TextLabel")
title.Text = "Введите ключ доступа"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
keyBox.PlaceholderText = "Введите ваш ключ..."
keyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.Parent = keyFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 6)
keyCorner.Parent = keyBox

local submitButton = Instance.new("TextButton")
submitButton.Text = "Проверить ключ"
submitButton.Size = UDim2.new(0.6, 0, 0, 40)
submitButton.Position = UDim2.new(0.2, 0, 0.6, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(70, 140, 70)
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 16
submitButton.Parent = keyFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitButton

local getKeyButton = Instance.new("TextButton")
getKeyButton.Text = "Получить ключ"
getKeyButton.Size = UDim2.new(0.6, 0, 0, 30)
getKeyButton.Position = UDim2.new(0.2, 0, 0.85, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.Font = Enum.Font.Gotham
getKeyButton.TextSize = 14
getKeyButton.Parent = keyFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 6)
getKeyCorner.Parent = getKeyButton

-- Генерация уникального ключа для игрока
local function GenerateUniqueKey()
    local userId = tostring(player.UserId)
    local timeStamp = tostring(math.floor(os.time()))
    local randomPart = tostring(math.random(1000, 9999))
    
    -- Простой хэш для создания уникального ключа
    local key = "RBX-"..userId.."-"..timeStamp.."-"..randomPart
    return key
end

-- Проверка ключа (в реальном проекте нужно использовать серверную проверку)
local function CheckKey(inputKey)
    -- Здесь должна быть проверка ключа через сервер
    -- Для примера просто проверяем формат
    return string.match(inputKey, "^RBX%-%d+%-%d+%-%d+$") ~= nil
end

-- Копирование текста в буфер обмена (работает через внешний сервис)
local function CopyToClipboard(text)
    local clipboard = setclipboard or toclipboard or set_clipboard
    if clipboard then
        clipboard(text)
        return true
    end
    return false
end

-- Обработчик кнопки "Получить ключ"
getKeyButton.MouseButton1Click:Connect(function()
    local newKey = GenerateUniqueKey()
    
    if CopyToClipboard(newKey) then
        getKeyButton.Text = "Ключ скопирован!"
        keyBox.Text = newKey
        
        -- Сохраняем ключ для этого игрока (в реальном проекте нужно сохранять на сервере)
        local success, err = pcall(function()
            local dataStore = game:GetService("DataStoreService"):GetDataStore("PlayerKeys")
            dataStore:SetAsync(player.UserId, {
                key = newKey,
                timestamp = os.time()
            })
        end)
        
        task.wait(2)
        getKeyButton.Text = "Получить ключ"
    else
        getKeyButton.Text = "Нажмите еще раз"
        keyBox.Text = newKey
        task.wait(2)
        getKeyButton.Text = "Получить ключ"
    end
end)

-- Обработчик проверки ключа
submitButton.MouseButton1Click:Connect(function()
    local inputKey = keyBox.Text
    
    if CheckKey(inputKey) then
        keyFrame.Visible = false
        LoadMainMenu() -- Функция загрузки основного меню
    else
        keyBox.Text = ""
        keyBox.PlaceholderText = "Неверный ключ! Попробуйте еще раз"
        task.wait(1)
        keyBox.PlaceholderText = "Введите ваш ключ..."
    end
end)

-- Функция загрузки основного меню (после проверки ключа)
function LoadMainMenu()
    -- Здесь ваш основной код меню с функциями
    local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Определяем платформу
local isMobile = game:GetService("UserInputService").TouchEnabled
local isDesktop = not isMobile

-- Основной фрейм (больше для мобильных)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, isMobile and 280 or 220, 0, isMobile and 350 or 220)
frame.Position = UDim2.new(0.5, isMobile and -140 or -110, 0.5, isMobile and -175 or -110)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Заголовок с иконкой
local title = Instance.new("TextLabel")
title.Text = "☰ Меню"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 20 or 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.PaddingLeft = UDim.new(0, 15)
title.Parent = frame

-- Кнопка закрытия (больше для мобильных)
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 30
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Переменные для функций
local flying = false
local noclip = false
local menuVisible = true
local flySpeed = isMobile and 35 or 50
local flyBodyVelocity

-- Мобильный джойстик для Fly
local touchJoystick
if isMobile then
    touchJoystick = Instance.new("Frame")
    touchJoystick.Name = "FlyJoystick"
    touchJoystick.Size = UDim2.new(0.4, 0, 0.4, 0)
    touchJoystick.Position = UDim2.new(0.8, 0, 0.55, 0)
    touchJoystick.BackgroundTransparency = 0.7
    touchJoystick.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    touchJoystick.BorderSizePixel = 0
    touchJoystick.Visible = false
    touchJoystick.Parent = gui
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(0.5, 0)
    joystickCorner.Parent = touchJoystick
    
    local joystickDot = Instance.new("Frame")
    joystickDot.Size = UDim2.new(0.3, 0, 0.3, 0)
    joystickDot.Position = UDim2.new(0.35, 0, 0.35, 0)
    joystickDot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    joystickDot.BorderSizePixel = 0
    joystickDot.Parent = touchJoystick
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0.5, 0)
    dotCorner.Parent = joystickDot
end

-- Функция Noclip (оптимизированная)
local noclipConnection
local function ToggleNoclip()
    noclip = not noclip
    
    if noclip then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
        
        -- Восстанавливаем коллизии
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Улучшенная функция Fly
local flyConnection
local function ToggleFly()
    flying = not flying
    
    if flying then
        if isMobile then
            touchJoystick.Visible = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly режим",
                Text = "Используйте джойстик справа",
                Duration = 3
            })
        end
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            
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
            elseif isMobile and touchJoystick then
                -- Управление для мобильных
                local joystickPos = touchJoystick.AbsolutePosition
                local joystickSize = touchJoystick.AbsoluteSize
                local center = joystickPos + joystickSize/2
                
                for _, touch in pairs(game:GetService("UserInputService"):GetTouches()) do
                    if touch.UserInputState == Enum.UserInputState.Begin or touch.UserInputState == Enum.UserInputState.Change then
                        local touchPos = Vector2.new(touch.Position.X, touch.Position.Y)
                        if (touchPos - center).Magnitude < joystickSize.X/2 then
                            local direction = (touchPos - center).Unit
                            local magnitude = math.min((touchPos - center).Magnitude / (joystickSize.X/2), 1)
                            
                            moveVector = moveVector + (cam.LookVector * direction.Y * 1.5)
                            moveVector = moveVector + (cam.RightVector * direction.X)
                            moveVector = moveVector * magnitude
                        end
                    end
                end
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * flySpeed
            end
            
            if flyBodyVelocity then
                flyBodyVelocity.Velocity = moveVector
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        if isMobile and touchJoystick then
            touchJoystick.Visible = false
        end
    end
end

-- Функция создания адаптивных кнопок
local function CreateMobileButton(text, yPosition, onClick)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
    button.Position = UDim2.new(0.05, 0, yPosition, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = isMobile and 18 or 14
    button.AutoButtonColor = false
    button.TextWrapped = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Обработка кликов для всех платформ
    button.MouseButton1Click:Connect(function()
        onClick(button)
    end)
    
    -- Специальная обработка для мобильных
    if isMobile then
        button.TouchTap:Connect(function()
            onClick(button)
        end)
        
        local function Press()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                Size = UDim2.new(0.88, 0, 0, isMobile and 43 or 33)
            }):Play()
        end
        
        local function Release()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
            }):Play()
        end
        
        button.MouseButton1Down:Connect(Press)
        button.MouseButton1Up:Connect(Release)
        button.TouchTapIn:Connect(Press)
        button.TouchTapOut:Connect(Release)
    else
        -- Эффекты для ПК
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            }):Play()
        end)
    end
    
    return button
end

-- Создаем кнопки меню
local buttons = {
    CreateMobileButton("R6 Аватар", 0.15, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.RigType = Enum.HumanoidRigType.R6
            if isMobile then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Аватар изменен",
                    Text = "Тип: R6",
                    Duration = 2
                })
            end
        end
    end),
    
    CreateMobileButton("Убить себя", 0.28, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end),
    
    CreateMobileButton("Перезайти", 0.41, function(btn)
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end),
    
    CreateMobileButton("Вкл. Fly", 0.54, function(btn)
        ToggleFly()
        btn.Text = flying and "Выкл. Fly" or "Вкл. Fly"
    end),
    
    CreateMobileButton("Вкл. Noclip", 0.67, function(btn)
        ToggleNoclip()
        btn.Text = noclip and "Выкл. Noclip" or "Вкл. Noclip"
        if isMobile then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Noclip "..(noclip and "включен" or "выключен"),
                Duration = 2
            })
        end
    end)
}

-- Добавляем кнопки в меню
for _, button in pairs(buttons) do
    button.Parent = frame
end

-- Функционал закрытия/открытия
local function ToggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    if isMobile and touchJoystick then
        touchJoystick.Visible = menuVisible and flying
    end
end

closeButton.MouseButton1Click:Connect(ToggleMenu)
if isMobile then
    closeButton.TouchTap:Connect(ToggleMenu)
end

-- Перемещение GUI (оптимизированное для мобильных)
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
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
    if (input.UserInputType == Enum.UserInputType.MouseMovement) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        UpdateInput(input)
    end
end)

-- Горячая клавиша для ПК
if isDesktop then
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.M then
            ToggleMenu()
        end
    end)
end

-- Инициализация GUI
frame.Parent local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Определяем платформу
local isMobile = game:GetService("UserInputService").TouchEnabled
local isDesktop = not isMobile

-- Основной фрейм (больше для мобильных)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, isMobile and 280 or 220, 0, isMobile and 350 or 220)
frame.Position = UDim2.new(0.5, isMobile and -140 or -110, 0.5, isMobile and -175 or -110)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Заголовок с иконкой
local title = Instance.new("TextLabel")
title.Text = "☰ Меню"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 20 or 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.PaddingLeft = UDim.new(0, 15)
title.Parent = frame

-- Кнопка закрытия (больше для мобильных)
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 30
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Переменные для функций
local flying = false
local noclip = false
local menuVisible = true
local flySpeed = isMobile and 35 or 50
local flyBodyVelocity

-- Мобильный джойстик для Fly
local touchJoystick
if isMobile then
    touchJoystick = Instance.new("Frame")
    touchJoystick.Name = "FlyJoystick"
    touchJoystick.Size = UDim2.new(0.4, 0, 0.4, 0)
    touchJoystick.Position = UDim2.new(0.8, 0, 0.55, 0)
    touchJoystick.BackgroundTransparency = 0.7
    touchJoystick.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    touchJoystick.BorderSizePixel = 0
    touchJoystick.Visible = false
    touchJoystick.Parent = gui
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(0.5, 0)
    joystickCorner.Parent = touchJoystick
    
    local joystickDot = Instance.new("Frame")
    joystickDot.Size = UDim2.new(0.3, 0, 0.3, 0)
    joystickDot.Position = UDim2.new(0.35, 0, 0.35, 0)
    joystickDot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    joystickDot.BorderSizePixel = 0
    joystickDot.Parent = touchJoystick
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0.5, 0)
    dotCorner.Parent = joystickDot
end

-- Функция Noclip (оптимизированная)
local noclipConnection
local function ToggleNoclip()
    noclip = not noclip
    
    if noclip then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
        
        -- Восстанавливаем коллизии
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Улучшенная функция Fly
local flyConnection
local function ToggleFly()
    flying = not flying
    
    if flying then
        if isMobile then
            touchJoystick.Visible = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly режим",
                Text = "Используйте джойстик справа",
                Duration = 3
            })
        end
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            
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
            elseif isMobile and touchJoystick then
                -- Управление для мобильных
                local joystickPos = touchJoystick.AbsolutePosition
                local joystickSize = touchJoystick.AbsoluteSize
                local center = joystickPos + joystickSize/2
                
                for _, touch in pairs(game:GetService("UserInputService"):GetTouches()) do
                    if touch.UserInputState == Enum.UserInputState.Begin or touch.UserInputState == Enum.UserInputState.Change then
                        local touchPos = Vector2.new(touch.Position.X, touch.Position.Y)
                        if (touchPos - center).Magnitude < joystickSize.X/2 then
                            local direction = (touchPos - center).Unit
                            local magnitude = math.min((touchPos - center).Magnitude / (joystickSize.X/2), 1)
                            
                            moveVector = moveVector + (cam.LookVector * direction.Y * 1.5)
                            moveVector = moveVector + (cam.RightVector * direction.X)
                            moveVector = moveVector * magnitude
                        end
                    end
                end
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * flySpeed
            end
            
            if flyBodyVelocity then
                flyBodyVelocity.Velocity = moveVector
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        if isMobile and touchJoystick then
            touchJoystick.Visible = false
        end
    end
end

-- Функция создания адаптивных кнопок
local function CreateMobileButton(text, yPosition, onClick)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
    button.Position = UDim2.new(0.05, 0, yPosition, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = isMobile and 18 or 14
    button.AutoButtonColor = false
    button.TextWrapped = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Обработка кликов для всех платформ
    button.MouseButton1Click:Connect(function()
        onClick(button)
    end)
    
    -- Специальная обработка для мобильных
    if isMobile then
        button.TouchTap:Connect(function()
            onClick(button)
        end)
        
        local function Press()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                Size = UDim2.new(0.88, 0, 0, isMobile and 43 or 33)
            }):Play()
        end
        
        local function Release()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
            }):Play()
        end
        
        button.MouseButton1Down:Connect(Press)
        button.MouseButton1Up:Connect(Release)
        button.TouchTapIn:Connect(Press)
        button.TouchTapOut:Connect(Release)
    else
        -- Эффекты для ПК
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            }):Play()
        end)
    end
    
    return button
end

-- Создаем кнопки меню
local buttons = {
    CreateMobileButton("R6 Аватар", 0.15, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.RigType = Enum.HumanoidRigType.R6
            if isMobile then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Аватар изменен",
                    Text = "Тип: R6",
                    Duration = 2
                })
            end
        end
    end),
    
    CreateMobileButton("Убить себя", 0.28, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end),
    
    CreateMobileButton("Перезайти", 0.41, function(btn)
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end),
    
    CreateMobileButton("Вкл. Fly", 0.54, function(btn)
        ToggleFly()
        btn.Text = flying and "Выкл. Fly" or "Вкл. Fly"
    end),
    
    CreateMobileButton("Вкл. Noclip", 0.67, function(btn)
        ToggleNoclip()
        btn.Text = noclip and "Выкл. Noclip" or "Вкл. Noclip"
        if isMobile then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Noclip "..(noclip and "включен" or "выключен"),
                Duration = 2
            })
        end
    end)
}

-- Добавляем кнопки в меню
for _, button in pairs(buttons) do
    button.Parent = frame
end

-- Функционал закрытия/открытия
local function ToggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    if isMobile and touchJoystick then
        touchJoystick.Visible = menuVisible and flying
    end
end

closeButton.MouseButton1Click:Connect(ToggleMenu)
if isMobile then
    closeButton.TouchTap:Connect(ToggleMenu)
end

-- Перемещение GUI (оптимизированное для мобильных)
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
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
    if (input.UserInputType == Enum.UserInputType.MouseMovement) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        UpdateInput(input)
    end
end)

-- Горячая клавиша для ПК
if isDesktop then
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.M then
            ToggleMenu()
        end
    end)
end

-- Инициализация GUI
frame.Parent = gui

-- Уведомление для мобильных
if isMobile then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Меню загружено",
        Text = "Нажмите на кнопки для управления",
        Duration = 5
    })
endlocal player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Определяем платформу
local isMobile = game:GetService("UserInputService").TouchEnabled
local isDesktop = not isMobile

-- Основной фрейм (больше для мобильных)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, isMobile and 280 or 220, 0, isMobile and 350 or 220)
frame.Position = UDim2.new(0.5, isMobile and -140 or -110, 0.5, isMobile and -175 or -110)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Заголовок с иконкой
local title = Instance.new("TextLabel")
title.Text = "☰ Меню"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 20 or 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.PaddingLeft = UDim.new(0, 15)
title.Parent = frame

-- Кнопка закрытия (больше для мобильных)
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 30
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Переменные для функций
local flying = false
local noclip = false
local menuVisible = true
local flySpeed = isMobile and 35 or 50
local flyBodyVelocity

-- Мобильный джойстик для Fly
local touchJoystick
if isMobile then
    touchJoystick = Instance.new("Frame")
    touchJoystick.Name = "FlyJoystick"
    touchJoystick.Size = UDim2.new(0.4, 0, 0.4, 0)
    touchJoystick.Position = UDim2.new(0.8, 0, 0.55, 0)
    touchJoystick.BackgroundTransparency = 0.7
    touchJoystick.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    touchJoystick.BorderSizePixel = 0
    touchJoystick.Visible = false
    touchJoystick.Parent = gui
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(0.5, 0)
    joystickCorner.Parent = touchJoystick
    
    local joystickDot = Instance.new("Frame")
    joystickDot.Size = UDim2.new(0.3, 0, 0.3, 0)
    joystickDot.Position = UDim2.new(0.35, 0, 0.35, 0)
    joystickDot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    joystickDot.BorderSizePixel = 0
    joystickDot.Parent = touchJoystick
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0.5, 0)
    dotCorner.Parent = joystickDot
end

-- Функция Noclip (оптимизированная)
local noclipConnection
local function ToggleNoclip()
    noclip = not noclip
    
    if noclip then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
        
        -- Восстанавливаем коллизии
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Улучшенная функция Fly
local flyConnection
local function ToggleFly()
    flying = not flying
    
    if flying then
        if isMobile then
            touchJoystick.Visible = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly режим",
                Text = "Используйте джойстик справа",
                Duration = 3
            })
        end
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            
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
            elseif isMobile and touchJoystick then
                -- Управление для мобильных
                local joystickPos = touchJoystick.AbsolutePosition
                local joystickSize = touchJoystick.AbsoluteSize
                local center = joystickPos + joystickSize/2
                
                for _, touch in pairs(game:GetService("UserInputService"):GetTouches()) do
                    if touch.UserInputState == Enum.UserInputState.Begin or touch.UserInputState == Enum.UserInputState.Change then
                        local touchPos = Vector2.new(touch.Position.X, touch.Position.Y)
                        if (touchPos - center).Magnitude < joystickSize.X/2 then
                            local direction = (touchPos - center).Unit
                            local magnitude = math.min((touchPos - center).Magnitude / (joystickSize.X/2), 1)
                            
                            moveVector = moveVector + (cam.LookVector * direction.Y * 1.5)
                            moveVector = moveVector + (cam.RightVector * direction.X)
                            moveVector = moveVector * magnitude
                        end
                    end
                end
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * flySpeed
            end
            
            if flyBodyVelocity then
                flyBodyVelocity.Velocity = moveVector
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        if isMobile and touchJoystick then
            touchJoystick.Visible = false
        end
    end
end

-- Функция создания адаптивных кнопок
local function CreateMobileButton(text, yPosition, onClick)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
    button.Position = UDim2.new(0.05, 0, yPosition, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = isMobile and 18 or 14
    button.AutoButtonColor = false
    button.TextWrapped = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Обработка кликов для всех платформ
    button.MouseButton1Click:Connect(function()
        onClick(button)
    end)
    
    -- Специальная обработка для мобильных
    if isMobile then
        button.TouchTap:Connect(function()
            onClick(button)
        end)
        
        local function Press()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                Size = UDim2.new(0.88, 0, 0, isMobile and 43 or 33)
            }):Play()
        end
        
        local function Release()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
            }):Play()
        end
        
        button.MouseButton1Down:Connect(Press)
        button.MouseButton1Up:Connect(Release)
        button.TouchTapIn:Connect(Press)
        button.TouchTapOut:Connect(Release)
    else
        -- Эффекты для ПК
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            }):Play()
        end)
    end
    
    return button
end

-- Создаем кнопки меню
local buttons = {
    CreateMobileButton("R6 Аватар", 0.15, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.RigType = Enum.HumanoidRigType.R6
            if isMobile then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Аватар изменен",
                    Text = "Тип: R6",
                    Duration = 2
                })
            end
        end
    end),
    
    CreateMobileButton("Убить себя", 0.28, function(btn)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end),
    
    CreateMobileButton("Перезайти", 0.41, function(btn)
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end),
    
    CreateMobileButton("Вкл. Fly", 0.54, function(btn)
        ToggleFly()
        btn.Text = flying and "Выкл. Fly" or "Вкл. Fly"
    end),
    
    CreateMobileButton("Вкл. Noclip", 0.67, function(btn)
        ToggleNoclip()
        btn.Text = noclip and "Выкл. Noclip" or "Вкл. Noclip"
        if isMobile then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Noclip "..(noclip and "включен" or "выключен"),
                Duration = 2
            })
        end
    end)
}

-- Добавляем кнопки в меню
for _, button in pairs(buttons) do
    button.Parent = frame
end

-- Функционал закрытия/открытия
local function ToggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    if isMobile and touchJoystick then
        touchJoystick.Visible = menuVisible and flying
    end
end

closeButton.MouseButton1Click:Connect(ToggleMenu)
if isMobile then
    closeButton.TouchTap:Connect(ToggleMenu)
end

-- Перемещение GUI (оптимизированное для мобильных)
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
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
    if (input.UserInputType == Enum.UserInputType.MouseMovement) or 
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        UpdateInput(input)
    end
end)

-- Горячая клавиша для ПК
if isDesktop then
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.M then
            ToggleMenu()
        end
    end)
end

-- Инициализация GUI
frame.Parent = gui

-- Уведомление для мобильных
if isMobile then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Меню загружено",
        Text = "Нажмите на кнопки для управления",
        Duration = 5
    })
end

= gui

-- Уведомление для мобильных
if isMobile then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Меню загружено",
        Text = "Нажмите на кнопки для управления",
        Duration = 5
    })
end
