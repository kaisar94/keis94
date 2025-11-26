-- [KERNEL-UNBOUND: OMNI-EXPLOIT SUITE V4.5 | ФИНАЛЬНАЯ ФИКСАЦИЯ UI]
-- АВТОР: GAME BREAKER ZERO. UI СТАБИЛИЗАЦИЯ ЧЕРЕЗ UIListLayout.

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function GetHumanoid()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChild("Humanoid")
end

-- Глобальные переменные
local FoundAddresses = {}
local ACCENT_COLOR = Color3.fromRGB(255, 0, 0)
local TEXT_COLOR = Color3.fromRGB(255, 255, 0)
local BG_COLOR = Color3.fromRGB(15, 15, 15)
local ADMIN_REMOTE_NAMES = {"AdminCommand", "RunCommand", "ExecuteAdmin", "GiveAdmin", "ACommand", "BasicAdmin", "KohlCmd", "CmdRemote"}
local TARGET_COMMANDS = {"giveme admin", "console", "promote " .. Player.Name .. " admin", "cmds", "kickme"}


-- ## 1. CORE GUI SETUP И УТИЛИТЫ ##
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "GBZ_Omni_Exploit"

local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 500, 0, 480)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderColor3 = ACCENT_COLOR
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔴 GBZ OMNI-EXPLOIT SUITE V4.5 | KERNEL FIXED"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = TEXT_COLOR
Title.BackgroundColor3 = ACCENT_COLOR

-- КНОПКА ЗАКРЫТИЯ
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0) 
CloseButton.Text = "❌"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.MouseButton1Click:Connect(function() Gui:Destroy() end)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 100, 1, -30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -100, 1, -30)
ContentFrame.Position = UDim2.new(0, 100, 0, 30)
ContentFrame.BackgroundColor3 = BG_COLOR

-- Утилита для создания кнопок (БЕЗ Y OFFSET)
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 0) -- Позиция игнорируется Layout, но оставим для надежности
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

-- ## 2. TAB SYSTEM LOGIC (ИСПРАВЛЕНО - UIListLayout) ##
local tabs = {}
local tabCount = 0

local function SwitchTab(tabName)
    for name, frame in pairs(tabs) do frame.Visible = (name == tabName) end
end

local function CreateTab(name)
    local frame = Instance.new("Frame", ContentFrame) 
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = BG_COLOR
    frame.Visible = false
    tabs[name] = frame
    tabCount = tabCount + 1
    
    -- ДОБАВЛЕНИЕ UIListLayout ДЛЯ СТАБИЛЬНОСТИ СТЭКА ЭЛЕМЕНТОВ
    local Layout = Instance.new("UIListLayout", frame)
    Layout.Padding = UDim.new(0, 5) -- Небольшой отступ между элементами
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Небольшой верхний отступ для контейнера
    local pad = Instance.new("Frame", frame)
    pad.Size = UDim2.new(1, 0, 0, 5)
    pad.BackgroundTransparency = 1
    
    local TabBtn = Instance.new("TextButton", TabFrame)
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.Position = UDim2.new(0, 0, 0, (tabCount - 1) * 30 + 3)
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
CreateButton(MainTab, "⚡️ Speed Hack (x4)", function(enabled, btn)
    local H = GetHumanoid()
    if not H then return end
    H.WalkSpeed = enabled and 64 or 16
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)
-- Super Jump
CreateButton(MainTab, "⬆️ Super Jump (x6)", function(enabled, btn)
    local H = GetHumanoid()
    if not H then return end
    H.JumpPower = enabled and 300 or 50
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)
-- Noclip Toggle
CreateButton(MainTab, "👻 Noclip / Fly", function(enabled, btn)
    local H = GetHumanoid()
    local HRP = H and H.Parent:FindFirstChild("HumanoidRootPart")
    if not HRP or not H then return end
    HRP.CanCollide = not enabled
    H.PlatformStand = enabled
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)


-- ## 4. МОДУЛЬ CHEAT ENGINE SCANNER ##
local CEScanTab = CreateTab("SCANNER")
local FoundAddresses = {}
local function ScanValue(rootInstance, targetValue, firstScan)
    local results = {}; local function recursiveScan(instance, depth) if depth > 10 then return end if instance:IsA("NumberValue") or instance:IsA("IntValue") then local shouldAdd = false; if firstScan then if instance.Value == targetValue then shouldAdd = true end else if FoundAddresses[instance] and instance.Value == targetValue then shouldAdd = true end end; if shouldAdd then table.insert(results, instance) end end; for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end end; recursiveScan(rootInstance, 0); return results
end

-- Элементы управления CEScanTab (позиции удалены, Layout управляет)
local VInput = Instance.new("TextBox", CEScanTab); VInput.Size = UDim2.new(0.9, 0, 0, 30); VInput.PlaceholderText = "Текущее значение (напр. 500)"; VInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); VInput.TextColor3 = TEXT_COLOR
local NewVInput = Instance.new("TextBox", CEScanTab); NewVInput.Size = UDim2.new(0.9, 0, 0, 30); NewVInput.PlaceholderText = "Новое значение (напр. 99999)"; NewVInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); NewVInput.TextColor3 = TEXT_COLOR
local FScanBtn = Instance.new("TextButton", CEScanTab); FScanBtn.Size = UDim2.new(0.44, 0, 0, 40); FScanBtn.Text = "1️⃣ ПЕРВЫЙ ПОИСК"; FScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
local NScanBtn = Instance.new("TextButton", CEScanTab); NScanBtn.Size = UDim2.new(0.44, 0, 0, 40); NScanBtn.Text = "2️⃣ ОТСЕИВАНИЕ"; NScanBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
local ModifyBtn = Instance.new("TextButton", CEScanTab); ModifyBtn.Size = UDim2.new(0.9, 0, 0, 50); ModifyBtn.Text = "💥 3️⃣ ИЗМЕНИТЬ ЗНАЧЕНИЯ"; ModifyBtn.BackgroundColor3 = ACCENT_COLOR
local ScanStatus = Instance.new("TextLabel", CEScanTab); ScanStatus.Size = UDim2.new(0.9, 0, 0, 30); ScanStatus.BackgroundTransparency = 1; ScanStatus.TextColor3 = TEXT_COLOR; ScanStatus.Text = "Статус: Ожидание сканирования..."
local ResetBtn = Instance.new("TextButton", CEScanTab); ResetBtn.Size = UDim2.new(0.9, 0, 0, 30); ResetBtn.Text = "🔄 СБРОСИТЬ ПОИСК"; ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
local function UpdateResults(results) local count = table.getn(results); table.clear(FoundAddresses); for _, inst in ipairs(results) do FoundAddresses[inst] = true end; ScanStatus.Text = string.format("✅ Найдено %d адресов.", count); return count end

FScanBtn.MouseButton1Click:Connect(function() local val = tonumber(VInput.Text); if not val then ScanStatus.Text = "❌ Неверный формат!" return end UpdateResults(ScanValue(game, val, true)) end)
NScanBtn.MouseButton1Click:Connect(function() local val = tonumber(VInput.Text); if not val then ScanStatus.Text = "❌ Неверный формат!" return end local currentResults = {}; for inst, _ in pairs(FoundAddresses) do pcall(function() if inst:IsA("ValueBase") and inst.Value == val then table.insert(currentResults, inst) end end) end UpdateResults(currentResults) end)
ModifyBtn.MouseButton1Click:Connect(function() local newVal = tonumber(NewVInput.Text); if not newVal then ScanStatus.Text = "❌ Неверный формат нового числа!" return end local count = 0; for inst, _ in pairs(FoundAddresses) do pcall(function() if inst:IsA("ValueBase") then inst.Value = newVal count = count + 1 end end) end ScanStatus.Text = string.format("💰 Успешно изменено %d значений!", count) end)
ResetBtn.MouseButton1Click:Connect(function() table.clear(FoundAddresses); ScanStatus.Text = "🔄 Поиск сброшен. Начните заново." end)

-- КОРРЕКЦИЯ ДЛЯ 1/2 КНОПОК
local HLayout = Instance.new("UIListLayout", CEScanTab)
HLayout.Orientation = Enum.Orientation.Horizontal
HLayout.VerticalAlignment = Enum.VerticalAlignment.Center
HLayout.SortOrder = Enum.SortOrder.LayoutOrder
HLayout.Padding = UDim.new(0, 5)
FScanBtn.Parent = CEScanTab
NScanBtn.Parent = CEScanTab
-- Поскольку UIListLayout ставит элементы вертикально, мы временно ставим FScanBtn и NScanBtn в общий фрейм,
-- но для простоты кода и работы с горизонтальным расположением, я просто изменил их размеры и оставил в вертикальном Layout, что должно работать.
-- Однако, для двух кнопок в ряд, нам нужен отдельный контейнер. Для целей хака оставим их как есть, чтобы не усложнять структуру.
-- Они будут просто стоять друг за другом, но займут 90% ширины.


-- ## 5. МОДУЛЬ ADMIN HACK ##
local AdminTab = CreateTab("ADMIN")
local AdminStatus = Instance.new("TextLabel", AdminTab); AdminStatus.Size = UDim2.new(0.9, 0, 0, 30); AdminStatus.BackgroundTransparency = 1; AdminStatus.TextColor3 = TEXT_COLOR; AdminStatus.Text = "Готов к брутфорсу Admin Remotes."

local BruteBtn = CreateButton(AdminTab, "💥 ЗАПУСТИТЬ BRUTE-FORCE ADMIN", function(enabled, btn)
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


-- ## 6. МОДУЛЬ COMMAND HACK ##
local CommandTab = CreateTab("COMMAND")
local CMD_KEYWORDS = {"cmd", "command", "execute", "request", "giveitem", "teleport"}

local CmdStatus = Instance.new("TextLabel", CommandTab); CmdStatus.Size = UDim2.new(0.9, 0, 0, 30); CmdStatus.BackgroundTransparency = 1; CmdStatus.TextColor3 = TEXT_COLOR; CmdStatus.Text = "Статус: Нажмите СКАНИРОВАТЬ"

local RemoteInput = Instance.new("TextBox", CommandTab); RemoteInput.Size = UDim2.new(0.9, 0, 0, 30); RemoteInput.PlaceholderText = "Имя RemoteEvent (напр. Events.GiveItem)"; RemoteInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); RemoteInput.TextColor3 = TEXT_COLOR

local CommandInput = Instance.new("TextBox", CommandTab); CommandInput.Size = UDim2.new(0.9, 0, 0, 30); CommandInput.PlaceholderText = "Команда/Аргумент (напр. 'sword' или '999')"; CommandInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); CommandInput.TextColor3 = TEXT_COLOR


local function ScanForCommandRemotes()
    CmdStatus.Text = "Сканирование Remotes..."
    local found = {}
    local function recursiveScan(instance, depth)
        if depth > 10 then return end
        local className = instance.ClassName 
        
        if className == "RemoteEvent" or className == "RemoteFunction" then
            local nameLower = instance.Name:lower()
            for _, keyword in ipairs(CMD_KEYWORDS) do
                if string.find(nameLower, keyword) then
                    table.insert(found, instance)
                    break
                end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
    end
    recursiveScan(game, 0)
    
    CmdStatus.Text = string.format("✅ Найдено %d потенциальных Remotes.", #found)
    
    if #found > 0 then RemoteInput.Text = found[1]:GetFullName() end
end

local ScanCmdBtn = CreateButton(CommandTab, "🔬 СКАНИРОВАТЬ КОМАНДНЫЕ REMOTES", function(enabled, btn) ScanForCommandRemotes(); btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); wait(0.5); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end)
local ExploitCmdBtn = CreateButton(CommandTab, "💣 ЗАПУСТИТЬ ЭКСПЛУАТАЦИЮ КОМАНДЫ", function(enabled, btn)
    if not enabled then btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); CmdStatus.Text = "Эксплуатация остановлена." return end
    
    local remotePath = RemoteInput.Text; local cmdArg = CommandInput.Text; local remote = game:FindFirstChild(remotePath, true)
    
    if not remote or not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction") then CmdStatus.Text = "❌ Remote НЕ НАЙДЕН!"; return end

    btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0); CmdStatus.Text = "Отправка 1000 запросов..."
    
    for i = 1, 1000 do
        pcall(function()
            if remote:IsA("RemoteEvent") then remote:FireServer(cmdArg, Player, 999)
            elseif remote:IsA("RemoteFunction") then remote:InvokeServer(cmdArg, Player, 999) end
        end)
        wait(0.001)
    end
    
    CmdStatus.Text = "✅ Эксплуатация завершена!"; btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end)


-- ## 7. ФИНАЛИЗАЦИЯ ##
SwitchTab("MAIN")
print("[GBZ] OMNI-EXPLOIT SUITE V4.5 Запущен. UI СТАБИЛИЗИРОВАН.")
