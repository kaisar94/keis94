--[[
    GEMINI | BlackHat-LAB - PHANTOM V2.3 (Dupe Hack Удален)
    Цель: Удаление функционала дюпа предметов по запросу пользователя.
    Фокус: Remote Exploits (Админ-команды/Брутфорс).
--]]

local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService") 

-- === КОНФИГУРАЦИЯ / ЦВЕТА ===
local SETTINGS = {
    ACCENT_COLOR = Color3.fromRGB(150, 0, 255), -- Фиолетовый
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    BG_COLOR = Color3.fromRGB(15, 15, 25),
    DARK_BG = Color3.fromRGB(25, 25, 40),
    DAMAGE_MULTIPLIER = 10, 
    TELEPORT_OFFSET = Vector3.new(0, 5, 0),
    DEBUG_MODE = true,
}

-- === ГЛОБАЛЬНЫЕ СОСТОЯНИЯ ===
local ActiveConnections = {}
local FoundAddresses = {} 
local FoundRemotes = {} -- Используется только для Admin/Command Brute-force

-- === КОНСТАНТЫ РАЗМЕРА ===
local MAX_SIZE = UDim2.new(0, 500, 0, 400) 
local MIN_SIZE = UDim2.new(0, 500, 0, 30) 

-- === УТИЛИТЫ ДЛЯ ПЕРСОНАЖА ===
local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function Log(message)
    if SETTINGS.DEBUG_MODE then
        print("[PHANTOM_V2] " .. message)
    end
end

-- === 1. ОСНОВНАЯ НАСТРОЙКА GUI ===
local Gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
Gui.Name = "PHANTOM_V2_EXPLOIT_GUI"
Gui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = MAX_SIZE
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = SETTINGS.BG_COLOR
MainFrame.BorderColor3 = SETTINGS.ACCENT_COLOR
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = Gui

-- Заголовок
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "👻 PHANTOM V2.3 | EXPLOIT KERNEL"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = SETTINGS.TEXT_COLOR
Title.BackgroundColor3 = SETTINGS.DARK_BG
Title.TextScaled = true

-- Кнопка Закрытия
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "❌"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = SETTINGS.TEXT_COLOR
CloseButton.MouseButton1Click:Connect(function() 
    Gui:Destroy()
    for _, conn in pairs(ActiveConnections) do 
        pcall(function() conn:Disconnect() end) 
    end
    Log("Эксплойт деактивирован и соединения очищены.")
end)

-- *** КНОПКА СВОРАЧИВАНИЯ/РАЗВОРАЧИВАНИЯ ***
local NavFrame -- Объявлено заранее
local ContentFrame -- Объявлено заранее
local isMinimized = false
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Text = "🔻" 
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextColor3 = SETTINGS.TEXT_COLOR
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
MinimizeButton.BorderSizePixel = 0

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local contentChildren = {NavFrame, ContentFrame}

    if isMinimized then
        MainFrame:TweenSize(MIN_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔺"
        for _, child in ipairs(contentChildren) do
            if child then child.Visible = false end
        end
        Log("GUI свернут.")
    else
        MainFrame:TweenSize(MAX_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔻"
        for _, child in ipairs(contentChildren) do
            if child then child.Visible = true end
        end
        -- Логика переключения вкладок
        local currentTabName = "Movement" 
        for _, btn in pairs(NavFrame:GetChildren()) do
            if btn:IsA("TextButton") and btn.BackgroundColor3 == SETTINGS.ACCENT_COLOR then
                currentTabName = btn.Name
                break
            end
        end
        if tabs[currentTabName] then tabs[currentTabName].Visible = true end
        Log("GUI развернут.")
    end
end)


-- Фреймы для Навигации и Контента
NavFrame = Instance.new("ScrollingFrame", MainFrame) -- Присвоение
NavFrame.Size = UDim2.new(0, 120, 1, -30)
NavFrame.Position = UDim2.new(0, 0, 0, 30)
NavFrame.BackgroundColor3 = SETTINGS.DARK_BG
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 4

ContentFrame = Instance.new("Frame", MainFrame) -- Присвоение
ContentFrame.Size = UDim2.new(1, -120, 1, -30)
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.BackgroundColor3 = SETTINGS.BG_COLOR
ContentFrame.BackgroundTransparency = 0.5

-- Layout для Навигации
local NavLayout = Instance.new("UIListLayout", NavFrame)
NavLayout.Padding = UDim.new(0, 5)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- === 2. СИСТЕМА ВКЛАДОК / МОДУЛЕЙ ===
local tabs = {}
local function SwitchTab(tabName)
    for name, frame in pairs(tabs) do
        frame.Visible = (name == tabName)
    end
    for _, btn in pairs(NavFrame:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = (btn.Name == tabName) and SETTINGS.ACCENT_COLOR or SETTINGS.DARK_BG
        end
    end
end

local function CreateTab(name, order)
    local frame = Instance.new("ScrollingFrame", ContentFrame)
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 6
    tabs[name] = frame

    local Layout = Instance.new("UIListLayout", frame)
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local TabBtn = Instance.new("TextButton", NavFrame)
    TabBtn.Name = name
    TabBtn.LayoutOrder = order
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.Position = UDim2.new(0, 5, 0, 0)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextColor3 = SETTINGS.TEXT_COLOR
    TabBtn.BackgroundColor3 = SETTINGS.DARK_BG
    TabBtn.BorderColor3 = SETTINGS.ACCENT_COLOR
    TabBtn.BorderSizePixel = 1
    TabBtn.MouseButton1Click:Connect(function() SwitchTab(name) end)

    return frame
end

local function CreateToggleButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextColor3 = SETTINGS.TEXT_COLOR
    btn.BackgroundColor3 = SETTINGS.DARK_BG
    btn.BorderColor3 = SETTINGS.ACCENT_COLOR
    btn.BorderSizePixel = 1

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled, btn)
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or SETTINGS.DARK_BG
        btn.Text = (enabled and "🟢 " or "🔴 ") .. string.gsub(text, "^[🟢🔴] ", "")
    end)
    return btn
end

-- === 3. ОПРЕДЕЛЕНИЕ МОДУЛЕЙ / ВКЛАДОК ===
local MovementTab = CreateTab("🚀 Movement", 1)
local CombatTab = CreateTab("⚔️ Combat", 2)
local WorldTab = CreateTab("🌎 World", 3)
local ValueScanTab = CreateTab("🔍 ValueScan", 4)
-- Вкладка переименована обратно и содержит только Remote Exploits
local RemoteExploitTab = CreateTab("💣 Remote Exploits", 5) 
local ConfigTab = CreateTab("⚙️ Config", 6)

-- --- 3.1. МОДУЛЬ MOVEMENT ---
CreateToggleButton(MovementTab, "Speed Hack (x4)", function(enabled)
    local H = GetHumanoid()
    if not H then Log("Ошибка: Гуманоид не найден.") return end

    if enabled then
        H.WalkSpeed = 64
        H.JumpPower = 300
        Log("Speed/Jump Hack Активирован.")
    else
        H.WalkSpeed = 16
        H.JumpPower = 50
        Log("Speed/Jump Hack Деактивирован.")
    end
end)

CreateToggleButton(MovementTab, "Fly Hack (Simple CFrame)", function(enabled)
    local HRP = GetHRP()
    if not HRP then Log("Ошибка: HRP не найден.") return end

    if enabled then
        HRP.Anchored = true
        Log("Fly Hack Активирован.")
    else
        HRP.Anchored = false
        Log("Fly Hack Деактивирован.")
    end
end)

-- --- 3.2. МОДУЛЬ COMBAT ---
CreateToggleButton(CombatTab, "Damage Multiplier (x" .. SETTINGS.DAMAGE_MULTIPLIER .. ")", function(enabled)
    local function recursiveDamageHack(instance, depth)
        if depth > 10 then return end
        if instance:IsA("Tool") or instance:IsA("BasePart") or instance:IsA("ModuleScript") then
            for _, child in ipairs(instance:GetChildren()) do
                pcall(function()
                    local nameLower = child.Name:lower()
                    if (child:IsA("NumberValue") or child:IsA("IntValue")) and (nameLower:match("damage") or nameLower:match("dmg")) then
                        if enabled then
                            child.Value = child.Value * SETTINGS.DAMAGE_MULTIPLIER
                        else
                            child.Value = child.Value / SETTINGS.DAMAGE_MULTIPLIER
                        end
                    end
                end)
                recursiveDamageHack(child, depth + 1)
            end
        end
    end

    if enabled then
        local damage_conn = RunService.Heartbeat:Connect(function()
            if Player.Character then
                recursiveDamageHack(Player.Character, 0)
                recursiveDamageHack(Player.Backpack, 0)
            end
        end)
        ActiveConnections["DamageHack"] = damage_conn
        Log("Damage Multiplier Активирован.")
    else
        if ActiveConnections["DamageHack"] then
            ActiveConnections["DamageHack"]:Disconnect()
            ActiveConnections["DamageHack"] = nil
        end
        Log("Damage Multiplier Деактивирован.")
    end
end)

CreateToggleButton(CombatTab, "God Mode (Local Health)", function(enabled)
    local H = GetHumanoid()
    if not H then Log("Ошибка: Гуманоид не найден.") return end

    if enabled then
        H.MaxHealth = 999999
        H.Health = 999999
        Log("Local God Mode Активирован.")
    else
        H.MaxHealth = 100
        H.Health = 100
        Log("Local God Mode Деактивирован.")
    end
end)

-- --- 3.3. МОДУЛЬ WORLD (TELEPORT & FARM) ---
local PlayerDropdown = Instance.new("TextBox", WorldTab)
PlayerDropdown.Size = UDim2.new(0.9, 0, 0, 30)
PlayerDropdown.PlaceholderText = "Имя игрока для TP (напр. 'TargetPlayer')"
PlayerDropdown.TextColor3 = SETTINGS.TEXT_COLOR
PlayerDropdown.BackgroundColor3 = SETTINGS.DARK_BG
PlayerDropdown.BorderColor3 = SETTINGS.ACCENT_COLOR

local CoordsInput = Instance.new("TextBox", WorldTab)
CoordsInput.Size = UDim2.new(0.9, 0, 0, 30)
CoordsInput.PlaceholderText = "Координаты для TP (X, Y, Z - напр. 100, 50, -200)"
CoordsInput.TextColor3 = SETTINGS.TEXT_COLOR
CoordsInput.BackgroundColor3 = SETTINGS.DARK_BG
CoordsInput.BorderColor3 = SETTINGS.ACCENT_COLOR

local TeleportBtn = Instance.new("TextButton", WorldTab)
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportBtn.Text = "🚀 АКТИВИРОВАТЬ ТЕЛЕПОРТ"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TeleportBtn.TextColor3 = SETTINGS.TEXT_COLOR

TeleportBtn.MouseButton1Click:Connect(function()
    local targetName = PlayerDropdown.Text
    local coordsStr = CoordsInput.Text
    local HRP = GetHRP()
    if not HRP then Log("Ошибка: HRP не найден.") return end

    if targetName ~= "" then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            HRP.CFrame = target.Character.HumanoidRootPart.CFrame + SETTINGS.TELEPORT_OFFSET
            Log("Телепортирован к " .. targetName)
        else
            Log("TP Ошибка: Игрок не найден или не загружен.")
        end
    elseif coordsStr ~= "" then
        local x, y, z = coordsStr:match("([%-?%d%.]+), ([%-?%d%.]+), ([%-?%d%.]+)")
        if x and y and z then
            local cframe = CFrame.new(tonumber(x), tonumber(y) + SETTINGS.TELEPORT_OFFSET.Y, tonumber(z))
            HRP.CFrame = cframe
            Log("Телепортирован к координатам: " .. coordsStr)
        else
            Log("TP Ошибка: Неверный формат координат. Используйте X, Y, Z.")
        end
    else
        Log("TP Ошибка: Введите имя игрока или координаты.")
    end
end)

CreateToggleButton(WorldTab, "💰 Auto Farm (Target: 'Coin')", function(enabled)
    if enabled then
        local farm_conn = RunService.Heartbeat:Connect(function()
            local HRP = GetHRP()
            if not HRP then return end

            local closestTarget = nil
            local minDistance = math.huge

            for _, instance in ipairs(game:GetDescendants()) do
                if instance.Name:lower():match("coin") or instance.Name:lower():match("gem") or instance.Name:lower():match("loot") then
                    if instance:IsA("BasePart") and instance.Parent ~= Player.Character and instance.CanCollide == false then
                        local distance = (HRP.Position - instance.Position).magnitude
                        if distance < minDistance then
                            minDistance = distance
                            closestTarget = instance
                        end
                    end
                end
            end

            if closestTarget and closestTarget:IsA("BasePart") then
                HRP.CFrame = closestTarget.CFrame + SETTINGS.TELEPORT_OFFSET
            end
        end)
        ActiveConnections["AutoFarm"] = farm_conn
        Log("Auto Farm Активирован.")
    else
        if ActiveConnections["AutoFarm"] then
            ActiveConnections["AutoFarm"]:Disconnect()
            ActiveConnections["AutoFarm"] = nil
        end
        Log("Auto Farm Деактивирован.")
    end
end)

-- --- 3.4. МОДУЛЬ VALUE SCANNER ---
local SInput = Instance.new("TextBox", ValueScanTab)
SInput.Size = UDim2.new(0.9, 0, 0, 30)
SInput.PlaceholderText = "Значение для сканирования (число/строка)"
SInput.BackgroundColor3 = SETTINGS.DARK_BG
SInput.TextColor3 = SETTINGS.TEXT_COLOR
SInput.BorderColor3 = SETTINGS.ACCENT_COLOR

local SNewInput = Instance.new("TextBox", ValueScanTab)
SNewInput.Size = UDim2.new(0.9, 0, 0, 30)
SNewInput.PlaceholderText = "Новое значение для установки"
SNewInput.BackgroundColor3 = SETTINGS.DARK_BG
SNewInput.TextColor3 = SETTINGS.TEXT_COLOR
SNewInput.BorderColor3 = SETTINGS.ACCENT_COLOR

local SStatus = Instance.new("TextLabel", ValueScanTab)
SStatus.Size = UDim2.new(0.9, 0, 0, 30)
SStatus.BackgroundTransparency = 1
SStatus.TextColor3 = SETTINGS.TEXT_COLOR
SStatus.Text = "Статус: Ожидание сканирования..."

local function ScanLogic(rootInstance, target, isFirstScan)
    local results = {}
    local targetNum = tonumber(target)
    local targetStr = type(target) == "string" and target or nil

    local function recursiveScan(instance, depth)
        if depth > 15 then return end

        if instance:IsA("ValueBase") then
            local val = instance.Value
            local match = false

            if targetNum and type(val) == "number" and math.abs(val - targetNum) < 0.001 then match = true
            elseif targetStr and type(val) == "string" and string.lower(val) == string.lower(targetStr) then match = true end

            if match then
                if isFirstScan or FoundAddresses[instance] then table.insert(results, instance) end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
    end
    recursiveScan(rootInstance, 0)
    return results
end

local function UpdateScanResults(results)
    local count = #results
    table.clear(FoundAddresses)
    for _, inst in ipairs(results) do FoundAddresses[inst] = true end
    SStatus.Text = string.format("✅ Найдено %d адресов.", count)
    Log("Сканер: Найдено " .. count .. " адресов.")
    return count
end

CreateToggleButton(ValueScanTab, "1️⃣ ПЕРВЫЙ ПОИСК", function(enabled, btn)
    if not SInput.Text then SStatus.Text = "❌ Введите значение!" return end
    UpdateScanResults(ScanLogic(game, SInput.Text, true))
end)

CreateToggleButton(ValueScanTab, "2️⃣ ОТСЕИВАНИЕ (Next Scan)", function(enabled, btn)
    if not SInput.Text or #FoundAddresses == 0 then SStatus.Text = "❌ Сначала выполните Первый Поиск!" return end
    local currentResults = {}
    for inst, _ in pairs(FoundAddresses) do
        local val = SInput.Text
        local targetNum = tonumber(val)
        local targetStr = type(val) == "string" and val or nil

        pcall(function()
            local match = false
            local instVal = inst.Value
            if targetNum and type(instVal) == "number" and math.abs(instVal - targetNum) < 0.001 then match = true
            elseif targetStr and type(instVal) == "string" and string.lower(instVal) == string.lower(targetStr) then match = true end

            if match then table.insert(currentResults, inst) end
        end)
    end
    UpdateScanResults(currentResults)
end)

CreateToggleButton(ValueScanTab, "💥 3️⃣ ИЗМЕНИТЬ ВСЕ ЗНАЧЕНИЯ", function(enabled, btn)
    local newVal = SNewInput.Text
    if not newVal or #FoundAddresses == 0 then SStatus.Text = "❌ Введите новое значение или выполните поиск!" return end
    local count = 0
    local targetNum = tonumber(newVal)

    for inst, _ in pairs(FoundAddresses) do
        pcall(function()
            if inst:IsA("ValueBase") then
                if targetNum then inst.Value = targetNum else inst.Value = newVal end
                count = count + 1
            end
        end)
    end
    SStatus.Text = string.format("💰 Успешно изменено %d значений!", count)
    Log("Сканер: Изменено " .. count .. " значений.")
end)

-- --- 3.5. МОДУЛЬ REMOTE EXPLOIT ---
local ExploitStatus = Instance.new("TextLabel", RemoteExploitTab)
ExploitStatus.Size = UDim2.new(0.9, 0, 0, 30)
ExploitStatus.BackgroundTransparency = 1
ExploitStatus.TextColor3 = SETTINGS.TEXT_COLOR
ExploitStatus.Text = "Статус: Нажмите AUTO-EXPLOIT"

local ADMIN_REMOTE_NAMES = {"AdminCommand", "RunCommand", "ExecuteAdmin", "GiveAdmin", "ACommand", "KohlCmd", "RemoteAdmin"}
local TARGET_COMMANDS = {"giveme admin", "console", "promote " .. Player.Name .. " admin", "cmds", "kickme", "kill others"}
local CMD_KEYWORDS = {"cmd", "command", "execute", "request", "teleport", "ability"}

local function FullRemoteScanAndBrute()
    ExploitStatus.Text = "🔍 Автоматическое сканирование и брутфорс запущены..."
    table.clear(FoundRemotes)
    local totalAttempts = 0

    local function recursiveScan(instance, depth)
        if depth > 12 then return end

        local className = instance.ClassName
        if className == "RemoteEvent" or className == "RemoteFunction" then
            local nameLower = instance.Name:lower()

            for _, adminName in ipairs(ADMIN_REMOTE_NAMES) do
                if string.find(nameLower, string.lower(adminName)) then
                    FoundRemotes[instance] = "ADMIN"
                    break
                end
            end
            if not FoundRemotes[instance] then
                for _, keyword in ipairs(CMD_KEYWORDS) do
                    if string.find(nameLower, keyword) then
                        FoundRemotes[instance] = "COMMAND"
                        break
                    end
                end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
    end

    recursiveScan(game, 0)
    ExploitStatus.Text = string.format("✅ Найдено %d потенциальных Remotes. Запуск брутфорса...", #FoundRemotes)
    Log("Remote Scan: Найдено " .. #FoundRemotes .. " Remotes.")

    for remote, type in pairs(FoundRemotes) do
        if type == "ADMIN" then
            for _, cmd in ipairs(TARGET_COMMANDS) do
                totalAttempts = totalAttempts + 1
                pcall(function() remote:FireServer(cmd) end)
                pcall(function() remote:FireServer(cmd, Player.Name) end)
            end
        elseif type == "COMMAND" then
            for _, arg in ipairs({"sword", "999", Player.Name, "teleport"}) do
                totalAttempts = totalAttempts + 1
                pcall(function() remote:FireServer(arg) end)
                pcall(function() remote:FireServer(arg, 999, Player.Name) end)
            end
        end
        wait(0.005)
    end

    ExploitStatus.Text = string.format("💥 Брутфорс завершен. Отправлено %d запросов.", totalAttempts)
end

CreateToggleButton(RemoteExploitTab, "💣 АВТОМАТИЧЕСКИЙ REMOTE-EXPLOIT (BRUTE)", function(enabled)
    if enabled then
        spawn(FullRemoteScanAndBrute)
    else
        ExploitStatus.Text = "Remote-эксплойт остановлен."
    end
end)


-- --- 3.6. МОДУЛЬ CONFIG ---
CreateToggleButton(ConfigTab, "🛡️ Anti-Void (Auto-Weld)", function(enabled, btn)
    local HRP = GetHRP()
    if not HRP then return end
    local partName = "AntiVoidPart_GEMINI"
    local existingPart = HRP.Parent:FindFirstChild(partName)

    if enabled then
        if existingPart then existingPart:Destroy() end

        local AntiVoidPart = Instance.new("Part")
        AntiVoidPart.Name = partName
        AntiVoidPart.Size = Vector3.new(0.5, 0.5, 0.5)
        AntiVoidPart.Transparency = 1
        AntiVoidPart.CanCollide = false
        AntiVoidPart.Anchored = true
        AntiVoidPart.CFrame = HRP.CFrame - Vector3.new(0, HRP.Size.Y, 0)

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = AntiVoidPart
        weld.Part1 = HRP
        weld.Parent = AntiVoidPart

        AntiVoidPart.Parent = HRP.Parent
        Log("Anti-Void Part Активирован.")
    else
        if existingPart then existingPart:Destroy() end
        Log("Anti-Void Part Деактивирован.")
    end
end)

CreateToggleButton(ConfigTab, "✨ Full Cleanup / Disconnect All", function(enabled, btn)
    if enabled then
        btn.Text = "DISCONNECTING..."
        local count = 0
        for name, conn in pairs(ActiveConnections) do
            pcall(function() conn:Disconnect() end)
            ActiveConnections[name] = nil
            count = count + 1
        end

        local totalRemoved = 0
        if getconnections then
            for _, instance in ipairs(game:GetDescendants()) do
                pcall(function()
                    local connections = getconnections(instance.AncestryChanged)
                    for _, conn in ipairs(connections) do
                        if conn.State == 1 then
                            conn:Disconnect()
                            totalRemoved = totalRemoved + 1
                        end
                    end
                end)
            end
        end

        wait(0.1)
        btn.Text = string.format("✅ Очищено %d подключений. Перезапустите скрипт.", count + totalRemoved)
        Log("Полная очистка завершена.")
    end
end)

-- === 4. ФИНАЛИЗАЦИЯ ===
SwitchTab("Movement") 
Log("PHANTOM V2.3 Скрипт-эксплойт успешно загружен (Dupe Hack удален).")
