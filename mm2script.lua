--[[
    CNN v171-11 | GHOST PROTOCOL v2
    Управление: LeftControl - скрыть/показать GUI
    GUI можно перетаскивать
--]]

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Переменные
local aimbotEnabled = false
local espEnabled = false
local autoLootEnabled = false
local fovRadius = 300
local target = nil

-- Уничтожение старого GUI
if game.CoreGui:FindFirstChild("CNN_Ghost") then
    game.CoreGui.CNN_Ghost:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CNN_Ghost"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Основная панель
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 380, 0, 420)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Parent = gui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(160, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Text = "CNN v171-11 | GHOST"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1
title.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ПЕРЕТАСКИВАНИЕ GUI
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

gui.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Навигация
local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(1, 0, 0, 35)
navFrame.Position = UDim2.new(0, 0, 0, 40)
navFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
navFrame.BorderSizePixel = 0
navFrame.Parent = mainFrame

-- Контент
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -75)
contentFrame.Position = UDim2.new(0, 0, 0, 75)
contentFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- СТРАНИЦЫ
-- AIMBOT
local aimbotPage = Instance.new("ScrollingFrame")
aimbotPage.Size = UDim2.new(1, 0, 1, 0)
aimbotPage.BackgroundTransparency = 1
aimbotPage.ScrollBarThickness = 3
aimbotPage.Visible = true
aimbotPage.Parent = contentFrame

local function makeAimbotPage()
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0.9, 0, 0, 30)
    t.Position = UDim2.new(0.05, 0, 0, 10)
    t.Text = "🎯 AIMBOT [X]"
    t.TextColor3 = Color3.fromRGB(255, 80, 80)
    t.Font = Enum.Font.GothamBold
    t.BackgroundTransparency = 1
    t.Parent = aimbotPage
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 50)
    btn.Text = "AIMBOT: OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Parent = aimbotPage
    
    btn.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        btn.Text = aimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
        btn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(160, 15, 15) or Color3.fromRGB(40, 40, 40)
    end)
end
makeAimbotPage()

-- ESP
local espPage = Instance.new("ScrollingFrame")
espPage.Size = UDim2.new(1, 0, 1, 0)
espPage.BackgroundTransparency = 1
espPage.ScrollBarThickness = 3
espPage.Visible = false
espPage.Parent = contentFrame

local function makeEspPage()
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0.9, 0, 0, 30)
    t.Position = UDim2.new(0.05, 0, 0, 10)
    t.Text = "👁 ESP HIGHLIGHT"
    t.TextColor3 = Color3.fromRGB(255, 80, 80)
    t.Font = Enum.Font.GothamBold
    t.BackgroundTransparency = 1
    t.Parent = espPage
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 50)
    btn.Text = "ESP: OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Parent = espPage
    
    btn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        btn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
        btn.BackgroundColor3 = espEnabled and Color3.fromRGB(160, 15, 15) or Color3.fromRGB(40, 40, 40)
        updateESP()
    end)
end
makeEspPage()

-- PLAYERS
local playersPage = Instance.new("ScrollingFrame")
playersPage.Size = UDim2.new(1, 0, 1, 0)
playersPage.BackgroundTransparency = 1
playersPage.ScrollBarThickness = 3
playersPage.Visible = false
playersPage.Parent = contentFrame

local playerScrollingList = Instance.new("ScrollingFrame")
playerScrollingList.Size = UDim2.new(0.9, 0, 0, 280)
playerScrollingList.Position = UDim2.new(0.05, 0, 0, 10)
playerScrollingList.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
playerScrollingList.BorderSizePixel = 0
playerScrollingList.Parent = playersPage

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = playerScrollingList

function updatePlayerList()
    for _, v in pairs(playerScrollingList:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 35)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        f.BorderSizePixel = 0
        f.Parent = playerScrollingList
        
        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(0.55, 0, 1, 0)
        n.Position = UDim2.new(0.03, 0, 0, 0)
        n.Text = p.Name
        n.TextColor3 = Color3.fromRGB(255, 255, 255)
        n.TextSize = 12
        n.Font = Enum.Font.Gotham
        n.BackgroundTransparency = 1
        n.Parent = f
        
        local flingBtn = Instance.new("TextButton")
        flingBtn.Size = UDim2.new(0.38, 0, 0.7, 0)
        flingBtn.Position = UDim2.new(0.6, 0, 0.15, 0)
        flingBtn.Text = "FLING"
        flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        flingBtn.TextSize = 11
        flingBtn.Font = Enum.Font.GothamBold
        flingBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        flingBtn.BorderSizePixel = 0
        flingBtn.Parent = f
        
        flingBtn.MouseButton1Click:Connect(function()
            if p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChild("Humanoid")
                if hrp and hum then
                    hrp.Velocity = Vector3.new(0, 8000, 0)
                    hrp.RotVelocity = Vector3.new(6000, 6000, 6000)
                    hum.PlatformStand = true
                    task.wait(0.3)
                    hum.PlatformStand = false
                end
            end
        end)
    end
end
updatePlayerList()

-- LOOT
local lootPage = Instance.new("ScrollingFrame")
lootPage.Size = UDim2.new(1, 0, 1, 0)
lootPage.BackgroundTransparency = 1
lootPage.ScrollBarThickness = 3
lootPage.Visible = false
lootPage.Parent = contentFrame

local function makeLootPage()
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0.9, 0, 0, 30)
    t.Position = UDim2.new(0.05, 0, 0, 10)
    t.Text = "🔫 AUTO LOOT PISTOL"
    t.TextColor3 = Color3.fromRGB(255, 80, 80)
    t.Font = Enum.Font.GothamBold
    t.BackgroundTransparency = 1
    t.Parent = lootPage
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 50)
    btn.Text = "AUTO-LOOT: OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Parent = lootPage
    
    btn.MouseButton1Click:Connect(function()
        autoLootEnabled = not autoLootEnabled
        btn.Text = autoLootEnabled and "AUTO-LOOT: ON" or "AUTO-LOOT: OFF"
        btn.BackgroundColor3 = autoLootEnabled and Color3.fromRGB(160, 15, 15) or Color3.fromRGB(40, 40, 40)
    end)
end
makeLootPage()

-- НАВИГАЦИЯ
local pages = {aimbotPage, espPage, playersPage, lootPage}
local navNames = {"🎯 Aimbot", "👁 ESP", "👥 Players", "🔫 Loot"}
local navBtns = {}

for i, name in ipairs(navNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    btn.BorderSizePixel = 0
    btn.Parent = navFrame
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(navBtns) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        pages[i].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(160, 15, 15)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    table.insert(navBtns, btn)
end
navBtns[1].BackgroundColor3 = Color3.fromRGB(160, 15, 15)
navBtns[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- ESP функция
function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local existing = p.Character:FindFirstChild("CNN_ESP")
            if espEnabled then
                if not existing then
                    local h = Instance.new("Highlight")
                    h.Name = "CNN_ESP"
                    h.FillTransparency = 0.5
                    h.FillColor = Color3.fromRGB(255, 20, 20)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = p.Character
                end
            else
                if existing then existing:Destroy() end
            end
        end
    end
end

-- Аимбот
local function getClosest()
    local closest = nil
    local minDist = fovRadius
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHrp then
                local dist = (hrp.Position - myHrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

-- Игровой цикл
RunService.RenderStepped:Connect(function()
    -- Аимбот на X
    if aimbotEnabled and UserInputService:IsKeyDown(Enum.KeyCode.X) then
        target = getClosest()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
            end
        end
    end
    
    -- Автолут ТОЛЬКО пистолета (без флинга)
    if autoLootEnabled then
        pcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("pistol") then
                    if LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - obj.Position).Magnitude < 12 then
                            firetouchinterest(root, obj, 0)
                            firetouchinterest(root, obj, 1)
                        end
                    end
                end
            end
        end)
    end
end)

-- Открытие/закрытие GUI на LeftControl
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Обновление списка игроков
Players.PlayerAdded:Connect(function() task.wait(0.3); updatePlayerList(); updateESP() end)
Players.PlayerRemoving:Connect(function() task.wait(0.3); updatePlayerList(); updateESP() end)

print("CNN: GHOST PROTOCOL v2 LOADED")
