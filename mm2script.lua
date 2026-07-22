--[[
    CNN v171-11 | AMBER FARM PROTOCOL - Jurassic Blocky
    Управление: LeftControl - скрыть/показать GUI
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local autoFarmEnabled = false
local teleportEnabled = false

-- Уничтожение старого GUI
if game.CoreGui:FindFirstChild("CNN_AmberFarm") then
    game.CoreGui.CNN_AmberFarm:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CNN_AmberFarm"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 10)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Parent = gui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(180, 120, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Text = "ЯНТАРНЫЙ ФАРМ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Перетаскивание
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
gui.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Кнопка автофарма
local farmToggle = Instance.new("TextButton")
farmToggle.Size = UDim2.new(0.8, 0, 0, 40)
farmToggle.Position = UDim2.new(0.1, 0, 0, 50)
farmToggle.Text = "АВТОСБОР ЯНТАРЯ: ВЫКЛ"
farmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
farmToggle.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
farmToggle.BorderSizePixel = 0
farmToggle.Font = Enum.Font.GothamBold
farmToggle.Parent = mainFrame
farmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    farmToggle.Text = autoFarmEnabled and "АВТОСБОР ЯНТАРЯ: ВКЛ" or "АВТОСБОР ЯНТАРЯ: ВЫКЛ"
    farmToggle.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(200, 140, 20) or Color3.fromRGB(60, 40, 20)
end)

-- Кнопка телепорта к янтарю
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.8, 0, 0, 40)
teleportBtn.Position = UDim2.new(0.1, 0, 0, 100)
teleportBtn.Text = "ТЕЛЕПОРТ К ЯНТАРЮ"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
teleportBtn.BorderSizePixel = 0
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.Parent = mainFrame
teleportBtn.MouseButton1Click:Connect(function()
    -- Ищем ближайший янтарь
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local nearest = nil
    local minDist = 500
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("amber") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
        end
    end
    if nearest then
        -- Телепорт с анимацией
        local targetPos = nearest.Position + Vector3.new(0, 3, 0) -- чуть выше
        local tween = TweenService:Create(root, TweenInfo.new(0.3), {CFrame = CFrame.new(targetPos)})
        tween:Play()
    end
end)

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
statusLabel.Position = UDim2.new(0.1, 0, 0, 155)
statusLabel.Text = "Статус: ожидание"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Автосбор янтаря
RunService.RenderStepped:Connect(function()
    if autoFarmEnabled then
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local collected = 0
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("amber") then
                    if (obj.Position - root.Position).Magnitude < 10 then
                        firetouchinterest(root, obj, 0)
                        firetouchinterest(root, obj, 1)
                        collected = collected + 1
                    end
                end
            end
            if collected > 0 then
                statusLabel.Text = "Статус: собрано " .. collected .. " янт."
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                statusLabel.Text = "Статус: ищу янтарь..."
                statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end)
    else
        statusLabel.Text = "Статус: ожидание"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Скрытие/показ на LeftControl
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("CNN: Amber Farm Protocol Active")
