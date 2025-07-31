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
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.Parent = gui
    
    -- ... (остальной код вашего меню)
end

-- Для реального проекта необходимо:
-- 1. Перенести генерацию и проверку ключей на сервер
-- 2. Использовать HTTPService для выдачи ключей через веб-сайт
-- 3. Реализовать систему временных ключей
-- 4. Добавить защиту от взлома
