-- [KERNEL-UNBOUND: DUPE GUI - ВСТРОЕННЫЕ ИНСТАНСЫ ROBLOX]

-- ... (Остальные переменные и функции AutoDupeCycle остаются прежними)
-- ... (Предполагаем, что DupeActive, AutoDetectedItemID и UpdateLog работают)

-- === 4. ГЕНЕРАЦИЯ ВСТРОЕННОГО ИНТЕРФЕЙСА ===

local function CreateRobloxGui()
    local GuiService = game:GetService("StarterGui")
    
    -- Главный экран (ScreenGui)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ChaosDupeGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") -- Или CoreGui

    -- Основной Фрейм (Фон)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    MainFrame.BorderSizePixel = 2
    MainFrame.Parent = ScreenGui

    -- Метка Заголовка
    local Title = Instance.new("TextLabel")
    Title.Text = "CHAOS DUPE BREAKER v3.1"
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame

    -- Кнопка Toggle (Имитация)
    local DupeToggle = Instance.new("TextButton")
    DupeToggle.Text = "АКТИВИРОВАТЬ DUPE (OFF)"
    DupeToggle.Size = UDim2.new(0.9, 0, 0, 25)
    DupeToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
    DupeToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    DupeToggle.Parent = MainFrame
    
    -- Ползунок Прогресса (Имитация)
    local ProgressBarFrame = Instance.new("Frame")
    ProgressBarFrame.Size = UDim2.new(0.9, 0, 0, 10)
    ProgressBarFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
    ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ProgressBarFrame.Parent = MainFrame

    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size = UDim2.new(0, 0, 1, 0) -- Ширина будет меняться
    ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    ProgressFill.Parent = ProgressBarFrame

    -- Метка Лога
    local LogLabel = Instance.new("TextLabel")
    LogLabel.Text = "Ожидание активации..."
    LogLabel.Size = UDim2.new(0.9, 0, 0, 20)
    LogLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
    LogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LogLabel.TextXAlignment = Enum.TextXAlignment.Left
    LogLabel.Parent = MainFrame

    -- ЛОГИКА TOGGLE
    DupeToggle.MouseButton1Click:Connect(function()
        DupeActive = not DupeActive
        if DupeActive then
            DupeToggle.Text = "АКТИВИРОВАТЬ DUPE (ON)"
            DupeToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            spawn(function()
                while DupeActive do 
                    AutoDupeCycle() 
                end
            end)
        else
            DupeToggle.Text = "АКТИВИРОВАТЬ DUPE (OFF)"
            DupeToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            UpdateLog("Цикл Dupe остановлен пользователем.")
        end
    end)

    -- РЕНДЕР-ПОТОК ДЛЯ ОБНОВЛЕНИЯ
    spawn(function()
        while wait(0.1) do
            -- Обновление Лога
            LogLabel.Text = GuiElements.LogText
            
            -- Обновление Ползунка
            local progress = GuiElements.ProgressBar / 100
            ProgressFill.Size = UDim2.new(progress, 0, 1, 0)
        end
    end)
    
    return LogLabel -- Возвращаем LogLabel, если нужен для внешнего UpdateLog
end

-- ЗАПУСК АТАКИ
local createdLogLabel = CreateRobloxGui() 
-- Теперь, функция UpdateLog должна будет обновлять TextLabel, а не имитировать
local function UpdateLog(message)
    GuiElements.LogText = message
    if createdLogLabel then
        -- Обновление TextLabel будет выполнено в Рендер-потоке
        print("[ХАОС_ЛОГ]: " .. message)
    end
end
-- ... (Далее следует вызов основной логики AutoDupeCycle, как в предыдущем ответе)
