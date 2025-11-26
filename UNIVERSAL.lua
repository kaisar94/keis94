-- [KERNEL-UNBOUND: IN-GAME VALUE SCANNER/EDITOR]
-- Имитация Cheat Engine для Roblox, работающая с Instance.Value.

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local FoundInstances = {}

-- ## 1. Функции Сканирования ##
local function Scan(rootInstance, valueName, valueType)
    -- Рекурсивный поиск по всем объектам
    for _, instance in ipairs(rootInstance:GetChildren()) do
        
        -- Проверяем, является ли объект ValueInstance (NumberValue, IntValue, StringValue)
        local isValueInstance = instance:IsA("NumberValue") or instance:IsA("IntValue") or instance:IsA("StringValue")
        
        -- Если у объекта есть свойство 'Value' и он соответствует критериям
        if isValueInstance and instance.Name:lower() == valueName:lower() then
            
            -- Проверка типа данных, если указан
            if valueType then
                if valueType == "number" and (instance:IsA("NumberValue") or instance:IsA("IntValue")) then
                    table.insert(FoundInstances, instance)
                elseif valueType == "string" and instance:IsA("StringValue") then
                    table.insert(FoundInstances, instance)
                -- Игнорируем проверку типа, если 'valueType' не указан или не соответствует
                end
            else
                table.insert(FoundInstances, instance)
            end
        end

        -- Продолжаем рекурсивный поиск
        Scan(instance, valueName, valueType)
    end
end

-- ## 2. Функция Интерфейса и Управления ##
local function CreateScannerGUI()
    local Gui = Instance.new("ScreenGui", PlayerGui)
    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.new(0, 300, 0, 350)
    Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    Frame.Active = true
    Frame.Draggable = true
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "🔵 GBZ: IN-GAME SCANNER"
    Title.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
    
    local NameInput = Instance.new("TextBox", Frame)
    NameInput.Size = UDim2.new(0.9, 0, 0, 30)
    NameInput.Position = UDim2.new(0.05, 0, 0, 40)
    NameInput.PlaceholderText = "Имя Value (напр. 'Cash' или 'Gems')"

    local TypeInput = Instance.new("TextBox", Frame)
    TypeInput.Size = UDim2.new(0.9, 0, 0, 30)
    TypeInput.Position = UDim2.new(0.05, 0, 0, 80)
    TypeInput.PlaceholderText = "Тип (number/string) - Опционально"
    
    local NewValueInput = Instance.new("TextBox", Frame)
    NewValueInput.Size = UDim2.new(0.9, 0, 0, 30)
    NewValueInput.Position = UDim2.new(0.05, 0, 0, 120)
    NewValueInput.PlaceholderText = "Новое значение (напр. 99999)"
    
    local ScanBtn = Instance.new("TextButton", Frame)
    ScanBtn.Size = UDim2.new(0.9, 0, 0, 40)
    ScanBtn.Position = UDim2.new(0.05, 0, 0, 160)
    ScanBtn.Text = "🔎 ШАГ 1: СКАНИРОВАТЬ"
    ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    
    local Status = Instance.new("TextLabel", Frame)
    Status.Size = UDim2.new(0.9, 0, 0, 30)
    Status.Position = UDim2.new(0.05, 0, 0, 210)
    Status.Text = "Статус: Ожидание..."
    Status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local ModifyBtn = Instance.new("TextButton", Frame)
    ModifyBtn.Size = UDim2.new(0.9, 0, 0, 40)
    ModifyBtn.Position = UDim2.new(0.05, 0, 0, 250)
    ModifyBtn.Text = "💥 ШАГ 2: ИЗМЕНИТЬ ВСЕ НАЙДЕННЫЕ ЗНАЧЕНИЯ"
    ModifyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ModifyBtn.Visible = false -- Скрыт до сканирования

    -- Логика кнопки СКАНИРОВАТЬ
    ScanBtn.MouseButton1Click:Connect(function()
        table.clear(FoundInstances) -- Очищаем предыдущие результаты
        local name = NameInput.Text
        local vType = TypeInput.Text
        
        if name == "" then
            Status.Text = "❌ Введите Имя Value!"
            return
        end
        
        Status.Text = "Сканирование Workspace и Player..."
        
        -- Сканирование
        Scan(Workspace, name, vType)
        Scan(Player, name, vType)

        if #FoundInstances > 0 then
            Status.Text = "✅ Найдено " .. #FoundInstances .. " экземпляров '" .. name .. "'!"
            ModifyBtn.Visible = true
        else
            Status.Text = "⛔ Не найдено! Попробуйте другое имя."
            ModifyBtn.Visible = false
        end
    end)

    -- Логика кнопки ИЗМЕНИТЬ
    ModifyBtn.MouseButton1Click:Connect(function()
        local newValueStr = NewValueInput.Text
        
        if #FoundInstances == 0 or newValueStr == "" then
            Status.Text = "❌ Сначала просканируйте и введите значение!"
            return
        end
        
        local successCount = 0
        local newValueNum = tonumber(newValueStr)
        
        for _, instance in ipairs(FoundInstances) do
            pcall(function()
                if instance:IsA("NumberValue") or instance:IsA("IntValue") then
                    -- Если это числовое значение, пытаемся записать число
                    if newValueNum then
                        instance.Value = newValueNum
                        successCount = successCount + 1
                    end
                elseif instance:IsA("StringValue") then
                    -- Если это строковое значение, записываем строку
                    instance.Value = newValueStr
                    successCount = successCount + 1
                end
            end)
        end
        
        Status.Text = "🔥 Успешно изменено: " .. successCount .. " значений!"
        ModifyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(2)
        ModifyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end)
end

-- Запуск GUI
CreateScannerGUI()
print("[GBZ] IN-GAME SCANNER Активирован. Готов к поиску локальных переменных.")
