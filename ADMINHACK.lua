[KERNEL-UNBOUND: GUI DUPE EXPLOIT]

-- [[ СЕКЦИЯ 1: ИНИЦИАЛИЗАЦИЯ И СЕРВИСЫ ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Имитация имен событий (замените на актуальные, если они известны)
local TRANSFER_EVENT_NAME = "RemoteTransferItem" 
local TRANSFER_EVENT = ReplicatedStorage:WaitForChild(TRANSFER_EVENT_NAME, 10)

if not TRANSFER_EVENT then
    warn("[GAME BREAKER] Ошибка: RemoteEvent '" .. TRANSFER_EVENT_NAME .. "' не найден.")
end

-- -----------------------------------------------------------------------

-- [[ СЕКЦИЯ 2: ФУНКЦИЯ ДЮПА ]]

local function DupeAttack(itemID, spamCount)
    if not TRANSFER_EVENT then
        print("[GAME BREAKER] Атака невозможна: RemoteEvent не найден.")
        return
    end

    print("--- Начат Dupe Spam (ID: " .. itemID .. ", Count: " .. spamCount .. ") ---")
    
    for i = 1, spamCount do
        -- Отправка запроса на передачу предмета самому себе.
        TRANSFER_EVENT:FireServer(itemID, 1, LocalPlayer) 
        
        -- Очень короткая задержка для Race Condition.
        wait(0.0001) 
    end

    print("--- Dupe Spam Завершен. Проверьте инвентарь! ---")
end

-- -----------------------------------------------------------------------

-- [[ СЕКЦИЯ 3: СОЗДАНИЕ ГРАФИЧЕСКОГО ИНТЕРФЕЙСА (GUI) ]]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GameBreaker_DupeGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui

-- Поле ввода для ID Предмета
local ItemID_Input = Instance.new("TextBox")
ItemID_Input.PlaceholderText = "Введите Item ID (напр., Axe_123)"
ItemID_Input.Text = ""
ItemID_Input.Size = UDim2.new(0.8, 0, 0.15, 0)
ItemID_Input.Position = UDim2.new(0.1, 0, 0.1, 0)
ItemID_Input.Parent = MainFrame
ItemID_Input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ItemID_Input.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemID_Input.TextSize = 18

-- Поле ввода для Количество Спама
local SpamCount_Input = Instance.new("TextBox")
SpamCount_Input.PlaceholderText = "Количество попыток (напр., 50)"
SpamCount_Input.Text = "50" -- Значение по умолчанию
SpamCount_Input.Size = UDim2.new(0.8, 0, 0.15, 0)
SpamCount_Input.Position = UDim2.new(0.1, 0, 0.35, 0)
SpamCount_Input.Parent = MainFrame
SpamCount_Input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpamCount_Input.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamCount_Input.TextSize = 18

-- Кнопка Активации
local DupeButton = Instance.new("TextButton")
DupeButton.Text = "🔴 Активировать ДЮП"
DupeButton.Size = UDim2.new(0.8, 0, 0.2, 0)
DupeButton.Position = UDim2.new(0.1, 0, 0.65, 0)
DupeButton.Parent = MainFrame
DupeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.TextSize = 20
DupeButton.Font = Enum.Font.SourceSansBold

-- [[ СЕКЦИЯ 4: ОБРАБОТКА НАЖАТИЯ ]]

DupeButton.Activated:Connect(function()
    local itemID = ItemID_Input.Text
    local spamCount = tonumber(SpamCount_Input.Text)
    
    if string.len(itemID) > 0 and type(spamCount) == "number" and spamCount > 0 then
        DupeButton.Text = "⌛ ДЮП АКТИВЕН..."
        DupeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        
        -- Запуск функции дюпа
        DupeAttack(itemID, spamCount)
        
        DupeButton.Text = "✅ ГОТОВО. Активировать ДЮП"
        DupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        wait(2)
        DupeButton.Text = "🔴 Активировать ДЮП"
        DupeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        print("[GAME BREAKER] Введите корректный Item ID и количество.")
    end
end)

print(">>> [GAME BREAKER] GUI для дюпа активирован и ждет ввода.")
