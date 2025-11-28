-- =========================================================
-- II. Настройка GUI и Ядра Эксплойта
-- =========================================================

-- Получение сервисов
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Имитация Remote Events (РАБОЧИЙ КОД: Замените на фактические пути к RE в игре!)
local remotes = {
    Collect = function(fruit) print("[RE] Fired Collect:", fruit.Name) end, -- Пример
    Sell = function() print("[RE] Fired Sell") end,
    Mutate = function(action) print("[RE] Fired Mutate:", action) end,
}

-- Настройки (Состояние GUI)
local Settings = {
    -- Auto Farm / Collect
    AutoCollectFruits = false,
    InstantCollect = false,
    DelayToCollect = 0.01,
    
    -- Selling
    AutoSell = false,
    SellIfFull = true,
    
    -- ESP / Visuals
    FruitESP = false,
    TreeNoClip = false,
    
    -- Pets
    AutoMutate = false,
    
    -- Internal State
    IsRunning = false,
}

-- Имитация API/Утилит (для чистой работы логики)
local API = {
    -- Упрощенная функция для получения списка фруктов
    GetPlantList = function()
        local plants = {}
        -- В реальном эксплойте тут будет поиск объектов в Workspace.Farm.Important...
        -- Для демонстрации создадим фиктивные объекты:
        for i = 1, 5 do
            local fruit = Instance.new("Model")
            fruit.Name = "ExampleFruit" .. i
            fruit:SetAttribute("Favorited", false)
            table.insert(plants, fruit)
        end
        return plants
    end,
    
    -- Упрощенная проверка инвентаря
    IsMaxInventory = function()
        return LocalPlayer:GetAttribute("Holdable_Backpack") >= 200
    end,
    
    -- ESP Utilities
    CreateESP = function(target, config) print("[ESP] Created for:", target.Name) end,
    RemoveESP = function(target) print("[ESP] Removed for:", target.Name) end,
    
    -- NoClip Utilities
    SetPartState = function(part, canCollide, transparency)
        print("[NoClip] Set:", part.Name, canCollide, transparency)
    end,
}

-- =========================================================
-- III. ЛОГИКА ЭКСПЛОЙТА (Реконструировано из обфускации)
-- =========================================================

-- 1. Автосбор Плодов
local function AutoCollectLoop()
    if not Settings.AutoCollectFruits then return end
    
    if Settings.SellIfFull and API.IsMaxInventory() then return end
    
    local fruits = API.GetPlantList()
    local collectedCount = 0
    
    for _, fruit in ipairs(fruits) do
        if not Settings.AutoCollectFruits then break end
        
        -- Проверка на "Избранное" / Blacklist logic
        if not fruit:GetAttribute("Favorited") then 
            if not Settings.InstantCollect then task.wait(Settings.DelayToCollect) end
            
            remotes.Collect(fruit) -- Вызов RE
            collectedCount = collectedCount + 1
            
            if Settings.InstantCollect and collectedCount > 50 then break end
            if not Settings.InstantCollect then task.wait(0.02) end
        end
    end
end

-- 2. Автопродажа (с имитацией телепорта)
local function AutoSellLoop()
    if not Settings.AutoSell then return end
    
    if Settings.SellIfFull and not API.IsMaxInventory() then return end
    
    -- Логика телепортации и вызова RE продажи
    print("[Sell] Teleporting to sell spot...")
    remotes.Sell() -- Вызов RE
    print("[Sell] Teleporting back...")
end

-- 3. No Clip / Скрытие объектов (например, деревьев)
local function ToggleTreeNoClip()
    -- В реальном коде тут идет итерация по частям и вызов API.SetPartState()
    print("[Visuals] Tree NoClip toggled:", Settings.TreeNoClip)
end

-- 4. Основной Цикл
local function MainLoop()
    while Settings.IsRunning do
        -- 1. Фарм и Сбор
        AutoCollectLoop()
        
        -- 2. Продажа (запуск с задержкой, чтобы не блокировать цикл)
        task.defer(AutoSellLoop)
        
        -- 3. Визуальные эффекты (ESP, NoClip)
        if Settings.TreeNoClip then
            ToggleTreeNoClip()
        end
        if Settings.FruitESP then
            -- Логика FruitESP (запуск с задержкой)
        end

        task.wait(0.5) -- Задержка основного цикла
    end
end

-- =========================================================
-- IV. СОЗДАНИЕ ИНТЕРФЕЙСА (GUI)
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "BlackHat_Exploit_GUI"
gui.Parent = CoreGui -- Размещение в CoreGui для обхода стандартного античита

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "GEMINI | BlackHat-LAB"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Секция прокрутки для элементов
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- Большая высота для прокрутки
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.Parent = frame

local Y_Offset = 0

-- Функция для создания переключателя (Toggle Button)
local function CreateToggle(name, settingKey, description)
    local button = Instance.new("TextButton")
    button.Text = name .. " (OFF)"
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, Y_Offset)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = scrollingFrame
    
    Y_Offset = Y_Offset + 40
    
    local function UpdateButton()
        local state = Settings[settingKey]
        button.Text = name .. (state and " (ON)" or " (OFF)")
        button.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
    end
    
    button.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        UpdateButton()
        
        -- Активация/Деактивация основного цикла при первом включении
        if settingKey == "AutoCollectFruits" or settingKey == "AutoSell" then
            if Settings[settingKey] and not Settings.IsRunning then
                Settings.IsRunning = true
                task.spawn(MainLoop)
            elseif not Settings.AutoCollectFruits and not Settings.AutoSell and Settings.IsRunning then
                Settings.IsRunning = false
            end
        end
    end)
    
    return button
end

-- Создание элементов управления

-- --- Секция АВТО-ФАРМ ---
Y_Offset = Y_Offset + 10
CreateToggle("Auto Collect Fruits", "AutoCollectFruits", "Автоматически собирать плоды.")
CreateToggle("Instant Collect (Fast Mode)", "InstantCollect", "Ускоренный сбор (может быть нестабильным).")
Y_Offset = Y_Offset + 10
CreateToggle("Auto Sell Inventory", "AutoSell", "Автоматически продавать содержимое инвентаря.")
CreateToggle("Sell Only If Max Inventory", "SellIfFull", "Продавать только, когда инвентарь полон.")

-- --- Секция ВИЗУАЛЫ ---
Y_Offset = Y_Offset + 30
CreateToggle("Fruit ESP (Show Info)", "FruitESP", "Показывать информацию о плодах.")
CreateToggle("Tree NoClip/Hide", "TreeNoClip", "Проходить сквозь деревья.")

-- --- Секция ПИТОМЦЫ ---
Y_Offset = Y_Offset + 30
CreateToggle("Auto Mutate Loop", "AutoMutate", "Автоматически запускать мутацию питомцев.")

-- Обновление CanvasSize для прокрутки
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Y_Offset + 10)

-- =========================================================
-- V. ЗАПУСК ЭКСПЛОЙТА
-- =========================================================

-- Запуск главного цикла после инициализации GUI
-- Скрипт ждет нажатия любой кнопки, активирующей MainLoop.
