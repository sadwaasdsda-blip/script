--[[
    CNN v171-11 | РАСШИРЕННЫЙ ТЕНЕВОЙ ПРОТОКОЛ
    Категории: Aimbot | ESP | Players | Loot
--]]

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Переменные состояния
local aimbotEnabled = false
local aimbotKey = "X"
local espEnabled = false
local autoLootEnabled = false
local fovRadius = 300
local target = nil
local currentCategory = "Aimbot"

-- Уничтожение старого GUI если есть
if game.CoreGui:FindFirstChild("CNN_Expanded") then
    game.CoreGui.CNN_Expanded:Destroy()
end

-- Создание GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CNN_Expanded"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Основная панель (ШИРЕ)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 380, 0, 460)
mainFrame.Position = UDim2.new(1, -400, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.Parent = gui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "CNN v171-11 | GHOST PROTOCOL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBlack
title.Parent = titleBar

-- Навигационные вкладки
local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(1, 0, 0, 35)
navFrame.Position = UDim2.new(0, 0, 0, 45)
navFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
navFrame.BorderSizePixel = 0
navFrame.Parent = mainFrame

-- Контентная область
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -80)
contentFrame.Position = UDim2.new(0, 0, 0, 80)
contentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Вкладка AIMBOT
local aimbotPage = Instance.new("ScrollingFrame")
aimbotPage.Size = UDim2.new(1, 0, 1, 0)
aimbotPage.BackgroundTransparency = 1
aimbotPage.ScrollBarThickness = 4
aimbotPage.ScrollBarImageColor3 = Color3.fromRGB(180, 20, 20)
aimbotPage.Visible = true
aimbotPage.Parent = contentFrame

local aimbotContent = Instance.new("Frame")
aimbotContent.Size = UDim2.new(1, 0, 0, 400)
aimbotContent.BackgroundTransparency = 1
aimbotContent.Parent = aimbotPage

-- Заголовок категории
local aimbotTitle = Instance.new("TextLabel")
aimbotTitle.Size = UDim2.new(1, 0, 0, 35)
aimbotTitle.Text = "🎯 AIMBOT SETTINGS"
aimbotTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
aimbotTitle.TextSize = 18
aimbotTitle.Font = Enum.Font.GothamBold
aimbotTitle.BackgroundTransparency = 1
aimbotTitle.Parent = aimbotContent

-- Тоггл аимбота
local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(0.9, 0, 0, 45)
aimbotToggle.Position = UDim2.new(0.05, 0, 0, 45)
aimbotToggle.Text = "AIMBOT: OFF [Клавиша X]"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotToggle.TextSize = 15
aimbotToggle.Font = Enum.Font.Gotham
aimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimbotToggle.BorderSizePixel = 0
aimbotToggle.Parent = aimbotContent

local aimbotActive = false
aimbotToggle.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    aimbotEnabled = aimbotActive
    if aimbotActive then
        aimbotToggle.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        aimbotToggle.Text = "AIMBOT: ON [Клавиша X]"
    else
        aimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        aimbotToggle.Text = "AIMBOT: OFF [Клавиша X]"
    end
end)

-- FOV слайдер
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.9, 0, 0, 25)
fovLabel.Position = UDim2.new(0.05, 0, 0, 105)
fovLabel.Text = "FOV Radius: 300"
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.TextSize = 13
fovLabel.Font = Enum.Font.Gotham
fovLabel.BackgroundTransparency = 1
fovLabel.Parent = aimbotContent

local fovSlider = Instance.new("TextBox")
fovSlider.Size = UDim2.new(0.4, 0, 0, 30)
fovSlider.Position = UDim2.new(0.55, 0, 0, 103)
fovSlider.Text = "300"
fovSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
fovSlider.PlaceholderText = "FOV"
fovSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
fovSlider.BorderSizePixel = 0
fovSlider.Parent = aimbotContent

fovSlider.FocusLost:Connect(function()
    fovRadius = tonumber(fovSlider.Text) or 300
    fovLabel.Text = "FOV Radius: " .. fovRadius
end)

-- Вкладка ESP
local espPage = Instance.new("ScrollingFrame")
espPage.Size = UDim2.new(1, 0, 1, 0)
espPage.BackgroundTransparency = 1
espPage.ScrollBarThickness = 4
espPage.ScrollBarImageColor3 = Color3.fromRGB(180, 20, 20)
espPage.Visible = false
espPage.Parent = contentFrame

local espContent = Instance.new("Frame")
espContent.Size = UDim2.new(1, 0, 0, 400)
espContent.BackgroundTransparency = 1
espContent.Parent = espPage

local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.new(1, 0, 0, 35)
espTitle.Text = "👁 ESP HIGHLIGHTS"
espTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
espTitle.TextSize = 18
espTitle.Font = Enum.Font.GothamBold
espTitle.BackgroundTransparency = 1
espTitle.Parent = espContent

-- Тоггл ESP
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0.9, 0, 0, 45)
espToggle.Position = UDim2.new(0.05, 0, 0, 45)
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.TextSize = 15
espToggle.Font = Enum.Font.Gotham
espToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espToggle.BorderSizePixel = 0
espToggle.Parent = espContent

local espActive = false
espToggle.MouseButton1Click:Connect(function()
    espActive = not espActive
    espEnabled = espActive
    updateESP(espActive)
    if espActive then
        espToggle.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        espToggle.Text = "ESP: ON"
    else
        espToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        espToggle.Text = "ESP: OFF"
    end
end)

-- Вкладка PLAYERS (СПИСОК + ФЛИНГ)
local playersPage = Instance.new("ScrollingFrame")
playersPage.Size = UDim2.new(1, 0, 1, 0)
playersPage.BackgroundTransparency = 1
playersPage.ScrollBarThickness = 4
playersPage.ScrollBarImageColor3 = Color3.fromRGB(180, 20, 20)
playersPage.Visible = false
playersPage.Parent = contentFrame

local playersContent = Instance.new("Frame")
playersContent.Size = UDim2.new(1, 0, 0, 800)
playersContent.BackgroundTransparency = 1
playersContent.Parent = playersPage

local playersTitle = Instance.new("TextLabel")
playersTitle.Size = UDim2.new(1, 0, 0, 35)
playersTitle.Text = "👥 PLAYER LIST"
playersTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
playersTitle.TextSize = 18
playersTitle.Font = Enum.Font.GothamBold
playersTitle.BackgroundTransparency = 1
playersTitle.Parent = playersContent

-- Список игроков
local playerList = Instance.new("Frame")
playerList.Size = UDim2.new(0.9, 0, 0, 320)
playerList.Position = UDim2.new(0.05, 0, 0, 45)
playerList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
playerList.BorderSizePixel = 0
playerList.Parent = playersContent

local playerScrollingList = Instance.new("ScrollingFrame")
playerScrollingList.Size = UDim2.new(1, 0, 1, 0)
playerScrollingList.BackgroundTransparency = 1
playerScrollingList.ScrollBarThickness = 3
playerScrollingList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
playerScrollingList.Parent = playerList

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = playerScrollingList

-- Функция обновления списка игроков
local function updatePlayerList()
    for _, child in pairs(playerScrollingList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        local playerFrame = Instance.new("Frame")
        playerFrame.Size = UDim2.new(1, 0, 0, 40)
        playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        playerFrame.BorderSizePixel = 0
        playerFrame.Parent = playerScrollingList
        
        local playerName = Instance.new("TextLabel")
        playerName.Size = UDim2.new(0.55, 0, 1, 0)
        playerName.Position = UDim2.new(0.05, 0, 0, 0)
        playerName.Text = player.Name
        playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerName.TextSize = 13
        playerName.Font = Enum.Font.Gotham
        playerName.BackgroundTransparency = 1
        playerName.Parent = playerFrame
        
        -- Кнопка ФЛИНГ
        local flingButton = Instance.new("TextButton")
        flingButton.Size = UDim2.new(0.35, 0, 0.7, 0)
        flingButton.Position = UDim2.new(0.62, 0, 0.15, 0)
        flingButton.Text = "FLING"
        flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        flingButton.TextSize = 11
        flingButton.Font = Enum.Font.GothamBold
        flingButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        flingButton.BorderSizePixel = 0
        flingButton.Parent = playerFrame
        
        flingButton.MouseButton1Click:Connect(function()
            flingPlayer(player)
        end)
    end
end

-- Функция флинга
local function flingPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local character = targetPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoidRootPart and humanoid then
            humanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
            humanoidRootPart.RotVelocity = Vector3.new(5000, 5000, 5000)
            humanoid.PlatformStand = true
            wait(0.5)
            humanoid.PlatformStand = false
        end
    end
end

-- Вкладка LOOT
local lootPage = Instance.new("ScrollingFrame")
lootPage.Size = UDim2.new(1, 0, 1, 0)
lootPage.BackgroundTransparency = 1
lootPage.ScrollBarThickness = 4
lootPage.ScrollBarImageColor3 = Color3.fromRGB(180, 20, 20)
lootPage.Visible = false
lootPage.Parent = contentFrame

local lootContent = Instance.new("Frame")
lootContent.Size = UDim2.new(1, 0, 0, 400)
lootContent.BackgroundTransparency = 1
lootContent.Parent = lootPage

local lootTitle = Instance.new("TextLabel")
lootTitle.Size = UDim2.new(1, 0, 0, 35)
lootTitle.Text = "🔫 AUTO LOOT"
lootTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
lootTitle.TextSize = 18
lootTitle.Font = Enum.Font.GothamBold
lootTitle.BackgroundTransparency = 1
lootTitle.Parent = lootContent

-- Тоггл автолута
local lootToggle = Instance.new("TextButton")
lootToggle.Size = UDim2.new(0.9, 0, 0, 45)
lootToggle.Position = UDim2.new(0.05, 0, 0, 45)
lootToggle.Text = "AUTO-LOOT PISTOL: OFF"
lootToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
lootToggle.TextSize = 15
lootToggle.Font = Enum.Font.Gotham
lootToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
lootToggle.BorderSizePixel = 0
lootToggle.Parent = lootContent

local lootActive = false
lootToggle.MouseButton1Click:Connect(function()
    lootActive = not lootActive
    autoLootEnabled = lootActive
    if lootActive then
        lootToggle.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        lootToggle.Text = "AUTO-LOOT PISTOL: ON"
    else
        lootToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        lootToggle.Text = "AUTO-LOOT PISTOL: OFF"
    end
end)

-- НАВИГАЦИЯ
local categories = {"🎯 Aimbot", "👁 ESP", "👥 Players", "🔫 Loot"}
local pages = {aimbotPage, espPage, playersPage, lootPage}
local navButtons = {}

for i, catName in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
    btn.Text = catName
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.BorderSizePixel = 0
    btn.Parent = navFrame
    
    btn.MouseButton1Click:Connect(function()
        for _, page in pairs(pages) do
            page.Visible = false
        end
        for _, b in pairs(navButtons) do
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        pages[i].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentCategory = catName
    end)
    
    table.insert(navButtons, btn)
end

-- Активация первой вкладки
navButtons[1].BackgroundColor3 = Color3.fromRGB(180, 20, 20)
navButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Функция ESP
function updateESP(state)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local existing = player.Character:FindFirstChild("CNN_ESP")
            if state then
                if not existing then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "CNN_ESP"
                    highlight.FillTransparency = 0.5
                    highlight.FillColor = Color3.fromRGB(255, 30, 30)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0.2
                    highlight.Parent = player.Character
                end
            else
                if existing then
                    existing:Destroy()
                end
            end
        end
    end
end

-- Аимбот функция
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = fovRadius
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if head and root and LocalPlayer.Character then
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if localRoot then
                    local distance = (root.Position - localRoot.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- Основной игровой цикл
RunService.RenderStepped:Connect(function()
    -- Аимбот на X
    if aimbotEnabled and UserInputService:IsKeyDown(Enum.KeyCode.X) then
        target = getClosestPlayer()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
            end
        end
    else
        target = nil
    end
    
    -- Автолут пистолетов
    if autoLootEnabled then
        pcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("gun") or obj.Name:lower():find("pistol")) then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local root = LocalPlayer.Character.HumanoidRootPart
                        if (root.Position - obj.Position).Magnitude < 12 then
                            firetouchinterest(root, obj, 0)
                            firetouchinterest(root, obj, 1)
                        end
                    end
                end
            end
        end)
    end
end)

-- Обновление списка игроков при изменениях
Players.PlayerAdded:Connect(function()
    wait(0.5)
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)

-- Первичная загрузка списка
updatePlayerList()

print("CNN: GHOST PROTOCOL FULLY ACTIVE.")
