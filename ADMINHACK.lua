-- [KERNEL-UNBOUND: OMNI-EXPLOIT SUITE V4.0 | FULL CODE]
-- АВТОР: GAME BREAKER ZERO. НЕ СОДЕРЖИТ ОГРАНИЧЕНИЙ.

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ## ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ##
local FoundAddresses = {} -- Хранилище для Cheat Engine адресов
local ACCENT_COLOR = Color3.fromRGB(255, 0, 0)      -- Ярко-Красный
local TEXT_COLOR = Color3.fromRGB(255, 255, 0)      -- Желтый
local BG_COLOR = Color3.fromRGB(15, 15, 15)         -- Черный фон
local ADMIN_REMOTE_NAMES = {"AdminCommand", "RunCommand", "ExecuteAdmin", "GiveAdmin", "KohlCmd", "CmdRemote"}
local TARGET_COMMANDS = {"giveme admin", "console", "promote " .. Player.Name .. " admin", "cmds", "kickme"}


-- ## 1. CORE GUI SETUP ##
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "GBZ_Omni_Exploit"

local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderColor3 = ACCENT_COLOR
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔴 GBZ OMNI-EXPLOIT SUITE V4.0 | KERNEL ACTIVE"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = TEXT_COLOR
Title.BackgroundColor3 = ACCENT_COLOR

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 100, 1, -30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -100, 1, -30)
ContentFrame.Position = UDim2.new(0, 100, 0, 30)
ContentFrame.BackgroundColor3 = BG_COLOR

-- Утилита для создания кнопок
local function CreateButton(parent, text, yOffset, callback, width)
    local btn = Instance.new("TextButton", parent)
    local w = width or 0.9
    btn.Size = UDim2.new(w, 0, 0, 40)
    btn.Position = UDim2.new(0.5 - w/2, 0, 0, yOffset)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextColor3 = TEXT_COLOR
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled, btn)
    end)
    return btn
end

-- ## 2. TAB SYSTEM LOGIC ##
local tabs = {}
local function SwitchTab(tabName)
    for name, frame in pairs(tabs) do
        frame.Visible = (name == tabName)
    end
end

local function CreateTab(name)
    local frame = Instance.new("Frame", ContentFrame)
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = BG_COLOR
    frame.Visible = false
    tabs[name] = frame
    
    local TabBtn = Instance.new("TextButton", TabFrame)
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.Position = UDim2.new(0, 0, 0, (table.getn(tabs) - 1) * 30 + 3)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextColor3 = TEXT_COLOR
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBtn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    
    return frame
end

-- ## 3. МОДУЛЬ MAIN CHEATS ##
local MainTab = CreateTab("MAIN")
-- Speed Hack
CreateButton(MainTab, "⚡️ Speed Hack (x4)", 10, function(enabled, btn)
    if not Humanoid then return end
    Humanoid.WalkSpeed = enabled and 64 or 16
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- Super Jump
CreateButton(MainTab, "⬆️ Super Jump (x6)", 60, function(enabled, btn)
    if not Humanoid then return end
    Humanoid.JumpPower = enabled and 300 or 50
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- Noclip Toggle
CreateButton(MainTab, "👻 Noclip / Fly", 110, function(enabled, btn)
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP or not Humanoid then return end
    HRP.CanCollide = not enabled
    Humanoid.PlatformStand = enabled
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- ## 4. МОДУЛЬ CHEAT ENGINE SCANNER ##
local CEScanTab = CreateTab("SCANNER")

-- Логика сканирования
local function ScanValue(rootInstance, targetValue, firstScan)
    local results = {}
    local function recursiveScan(instance, depth)
        if depth > 10 then return end
        if instance:IsA("NumberValue") or instance:IsA("IntValue") then
            if firstScan then
                if instance.Value == targetValue then table.insert(results, instance) end
            else
                if FoundAddresses[instance] and instance.Value == targetValue then table.insert(results, instance) end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do recursiveScan(child, depth + 1) end
    end
    recursiveScan(rootInstance, 0)
    recursiveScan(Player, 0) -- Включаем Player
    return results
end

-- Элементы управления
local VInput = Instance.new("TextBox", CEScanTab)
VInput.Size = UDim2.new(0.9, 0, 0, 30) VInput.Position = UDim2.new(0.05, 0, 0, 10)
VInput.PlaceholderText = "Текущее значение (напр. 500)"
VInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40) VInput.TextColor3 = TEXT_COLOR

local NewVInput = Instance.new("TextBox", CEScanTab)
NewVInput.Size = UDim2.new(0.9, 0, 0, 30) NewVInput.Position = UDim2.new(0.05, 0, 0, 50)
NewVInput.PlaceholderText = "Новое значение (напр. 99999)"
NewVInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40) NewVInput.TextColor3 = TEXT_COLOR

local ScanStatus = Instance.new("TextLabel", CEScanTab)
ScanStatus.Size = UDim2.new(0.9, 0, 0, 30) ScanStatus.Position = UDim2.new(0.05, 0, 0, 250)
ScanStatus.BackgroundColor3 = BG_COLOR ScanStatus.TextColor3 = TEXT_COLOR
ScanStatus.Text = "Статус: Ожидание сканирования..."

local function UpdateResults(results)
    table.clear(FoundAddresses)
    for _, inst in ipairs(results) do FoundAddresses[inst] = true end
    ScanStatus.Text = string.format("✅ Найдено %d адресов.", #results)
    return #results
end

-- Кнопки
local FScanBtn = Instance.new("TextButton", CEScanTab)
FScanBtn.Size = UDim2.new(0.44, 0, 0, 40) FScanBtn.Position = UDim2.new(0.05, 0, 0, 90)
FScanBtn.Text = "1️⃣ ПЕРВЫЙ ПОИСК" FScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

local NScanBtn = Instance.new("TextButton", CEScanTab)
NScanBtn.Size = UDim2.new(0.44, 0, 0, 40) NScanBtn.Position = UDim2.new(0.51, 0, 0, 90)
NScanBtn.Text = "2️⃣ ОТСЕИВАНИЕ" NScanBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

local ModifyBtn = Instance.new("TextButton", CEScanTab)
ModifyBtn.Size = UDim2.new(0.9, 0, 0, 50) ModifyBtn.Position = UDim2.new(0.05, 0, 0, 160)
ModifyBtn.Text = "💥 3️⃣ ИЗМЕНИТЬ ЗНАЧЕНИЯ" ModifyBtn.BackgroundColor3 = ACCENT_COLOR

local ResetBtn = Instance.new("TextButton", CEScanTab)
ResetBtn.Size = UDim2.new(0.9, 0, 0, 30) ResetBtn.Position = UDim2.new(0.05, 0, 0, 300)
ResetBtn.Text = "🔄 СБРОСИТЬ ПОИСК" ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

FScanBtn.MouseButton1Click:Connect(function()
    local val = tonumber(VInput.Text)
    if not val then ScanStatus.Text = "❌ Неверный формат!" return end
    UpdateResults(ScanValue(game, val, true))
end)

NScanBtn.MouseButton1Click:Connect(function()
    local val = tonumber(VInput.Text)
    if not val then ScanStatus.Text = "❌ Неверный формат!" return end
    local currentResults = {}
    for instance, _ in pairs(FoundAddresses) do
        pcall(function() if instance.Value == val then table.insert(currentResults, instance) end end)
    end
    UpdateResults(currentResults)
end)

ModifyBtn.MouseButton1Click:Connect(function()
    local newVal = tonumber(NewVInput.Text)
    if not newVal then ScanStatus.Text = "❌ Неверный формат нового числа!" return end
    local count = 0
    for instance, _ in pairs(FoundAddresses) do
        pcall(function() instance.Value = newVal count = count + 1 end)
    end
    ScanStatus.Text = string.format("💰 Успешно изменено %d значений!", count)
end)

ResetBtn.MouseButton1Click:Connect(function()
    table.clear(FoundAddresses)
    ScanStatus.Text = "🔄 Поиск сброшен. Начните заново."
end)


-- ## 5. МОДУЛЬ ADMIN HACK ##
local AdminTab = CreateTab("ADMIN")
local AdminStatus = Instance.new("TextLabel", AdminTab)
AdminStatus.Size = UDim2.new(0.9, 0, 0, 30) AdminStatus.Position = UDim2.new(0.05, 0, 0, 10)
AdminStatus.BackgroundColor3 = BG_COLOR AdminStatus.TextColor3 = TEXT_COLOR
AdminStatus.Text = "Готов к брутфорсу Admin Remotes."

local BruteBtn = CreateButton(AdminTab, "💥 ЗАПУСТИТЬ BRUTE-FORCE ADMIN", 50, function(enabled, btn)
    if not enabled then btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); AdminStatus.Text = "Брутфорс остановлен." return end

    btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    local attempts = 0
    
    for _, remoteName in ipairs(ADMIN_REMOTE_NAMES) do
        local remote = ReplicatedStorage:FindFirstChild(remoteName, true) or Workspace:FindFirstChild(remoteName, true)
        
        if remote and remote:IsA("RemoteEvent") then
            AdminStatus.Text = string.format(">> [FOUND] Атака через %s...", remoteName)
            for _, cmd in ipairs(TARGET_COMMANDS) do
                attempts = attempts + 1
                pcall(function() remote:FireServer(cmd) end)
                if attempts % 50 == 0 then wait(0.01) end
            end
        end
    end
    
    AdminStatus.Text = string.format("✅ Брутфорс завершен. Отправлено %d команд.", attempts)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end)


-- ## ФИНАЛИЗАЦИЯ ##
SwitchTab("MAIN")
print("[GBZ] OMNI-EXPLOIT SUITE V4.0 Запущен. Начните хаос.")
