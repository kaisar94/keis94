-- [KERNEL-UNBOUND: CHEAT ENGINE SCANNER V3.0 CORE]
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local FoundAddresses = {} -- Хранилище для найденных объектов (для отсеивания)

-- ## Функции Сканирования ##

local function ScanValue(rootInstance, targetValue, firstScan)
    local results = {}
    
    local function recursiveScan(instance, depth)
        if depth > 10 then return end -- Ограничение глубины
        
        -- Проверка, является ли объект числовым Value
        if instance:IsA("NumberValue") or instance:IsA("IntValue") then
            if firstScan then
                -- ПЕРВЫЙ ПОИСК: Ищем Value, равное targetValue
                if instance.Value == targetValue then
                    table.insert(results, instance)
                end
            else
                -- ОТСЕИВАНИЕ (NEXT SCAN): Проверяем, есть ли объект в списке FoundAddresses
                -- и равен ли он targetValue.
                if FoundAddresses[instance] and instance.Value == targetValue then
                    table.insert(results, instance)
                end
            end
        end

        -- Рекурсия
        for _, child in ipairs(instance:GetChildren()) do
            recursiveScan(child, depth + 1)
        end
    end

    -- Начинаем сканирование с Workspace и Player
    recursiveScan(Workspace, 0)
    recursiveScan(Player, 0)
    
    return results
end

-- ## 2. GUI и Логика ##

local function CreateCheatEngineGUI()
    local Gui = Instance.new("ScreenGui", PlayerGui)
    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.new(0, 350, 0, 380)
    Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Темный фон
    Frame.BorderColor3 = Color3.fromRGB(255, 255, 0) -- Желтая рамка
    Frame.BorderSizePixel = 2
    Frame.Active = true
    Frame.Draggable = true
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "🟡 GBZ CHEAT ENGINE SCANNER"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 0) -- Ярко-желтый текст
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    -- Поле для поиска
    local ValueInput = Instance.new("TextBox", Frame)
    ValueInput.Size = UDim2.new(0.9, 0, 0, 30)
    ValueInput.Position = UDim2.new(0.05, 0, 0, 40)
    ValueInput.PlaceholderText = "Введите текущее значение (напр. 500)"
    ValueInput.Text = "0"
    ValueInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Поле для нового значения
    local NewValueInput = Instance.new("TextBox", Frame)
    NewValueInput.Size = UDim2.new(0.9, 0, 0, 30)
    NewValueInput.Position = UDim2.new(0.05, 0, 0, 80)
    NewValueInput.PlaceholderText = "Введите НОВОЕ значение (напр. 99999)"
    NewValueInput.Text = "99999"
    NewValueInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    NewValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Кнопка ПЕРВЫЙ ПОИСК
    local FirstScanBtn = Instance.new("TextButton", Frame)
    FirstScanBtn.Size = UDim2.new(0.44, 0, 0, 40)
    FirstScanBtn.Position = UDim2.new(0.05, 0, 0, 120)
    FirstScanBtn.Text = "1️⃣ ПЕРВЫЙ ПОИСК"
    FirstScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Зеленый
    FirstScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Кнопка ОТСЕИВАНИЕ (Next Scan)
    local NextScanBtn = Instance.new("TextButton", Frame)
    NextScanBtn.Size = UDim2.new(0.44, 0, 0, 40)
    NextScanBtn.Position = UDim2.new(0.51, 0, 0, 120)
    NextScanBtn.Text = "2️⃣ ОТСЕИВАНИЕ"
    NextScanBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый
    NextScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    NextScanBtn.Visible = false -- Скрыт до первого поиска
    
    -- Кнопка ИЗМЕНИТЬ
    local ModifyBtn = Instance.new("TextButton", Frame)
    ModifyBtn.Size = UDim2.new(0.9, 0, 0, 50)
    ModifyBtn.Position = UDim2.new(0.05, 0, 0, 200)
    ModifyBtn.Text = "💥 3️⃣ ИЗМЕНИТЬ ВСЕ ЗНАЧЕНИЯ"
    ModifyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Красный
    ModifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ModifyBtn.Visible = false
    
    local Status = Instance.new("TextLabel", Frame)
    Status.Size = UDim2.new(0.9, 0, 0, 30)
    Status.Position = UDim2.new(0.05, 0, 0, 260)
    Status.Text = "Статус: Ожидание первого поиска..."
    Status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local ResetBtn = Instance.new("TextButton", Frame)
    ResetBtn.Size = UDim2.new(0.9, 0, 0, 30)
    ResetBtn.Position = UDim2.new(0.05, 0, 0, 300)
    ResetBtn.Text = "🔄 СБРОСИТЬ ПОИСК"
    ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Хелпер-функция для обработки результатов
    local function UpdateResults(results, isFirstScan)
        table.clear(FoundAddresses)
        for _, inst in ipairs(results) do
            FoundAddresses[inst] = true
        end
        
        local count = #results
        Status.Text = string.format("✅ Найдено %d адресов. Текущее значение: %s", count, ValueInput.Text)
        
        if count > 0 then
            NextScanBtn.Visible = true
            ModifyBtn.Visible = true
        else
            NextScanBtn.Visible = false
            ModifyBtn.Visible = false
        end
        
        if count == 1 then
             Status.Text = "🔥 Найден 1 адрес! Готов к изменению."
             NextScanBtn.Visible = false
        end
    end

    -- Логика кнопки ПЕРВЫЙ ПОИСК
    FirstScanBtn.MouseButton1Click:Connect(function()
        local value = tonumber(ValueInput.Text)
        if not value then Status.Text = "❌ Неверный формат числа!" return end
        
        Status.Text = "Выполняется Первый Поиск..."
        UpdateResults(ScanValue(game, value, true), true)
    end)

    -- Логика кнопки ОТСЕИВАНИЕ
    NextScanBtn.MouseButton1Click:Connect(function()
        local value = tonumber(ValueInput.Text)
        if not value then Status.Text = "❌ Неверный формат числа!" return end
        
        Status.Text = "Выполняется Отсеивание..."
        -- Отсеивание работает только с уже найденными адресами
        
        local currentResults = {}
        for instance, _ in pairs(FoundAddresses) do
             pcall(function()
                if instance.Value == value then
                    table.insert(currentResults, instance)
                end
             end)
        end
        
        UpdateResults(currentResults, false)
    end)

    -- Логика кнопки ИЗМЕНИТЬ
    ModifyBtn.MouseButton1Click:Connect(function()
        local newValue = tonumber(NewValueInput.Text)
        if not newValue then Status.Text = "❌ Неверный формат нового числа!" return end
        
        local count = 0
        for instance, _ in pairs(FoundAddresses) do
             pcall(function()
                instance.Value = newValue
                count = count + 1
             end)
        end
        
        Status.Text = string.format("💰 Успешно изменено %d значений на %d!", count, newValue)
    end)
    
    -- Логика кнопки СБРОСИТЬ
    ResetBtn.MouseButton1Click:Connect(function()
        table.clear(FoundAddresses)
        Status.Text = "🔄 Поиск сброшен. Начните заново."
        NextScanBtn.Visible = false
        ModifyBtn.Visible = false
        ValueInput.Text = "0"
        NewValueInput.Text = "99999"
    end)

end

-- Запуск GUI
CreateCheatEngineGUI()
print("[GBZ] Cheat Engine Scanner V3.0 Активирован. Начинайте поиск.")
