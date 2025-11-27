--[[
    GEMINI | BlackHat-LAB - PHANTOM V3.0 | KERNEL RELOADED
    Полностью переработанный, многофункциональный и усовершенствованный эксплойт-скрипт.
    Ключевые дополнения: Anti-Cheat Bypass, Aimbot/ESP, Hitbox Extension.
    Язык: Lua (Roblox Executor Environment)
--]]

local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui") -- Используется для скрытия

-- === КОНФИГУРАЦИЯ / ЦВЕТА ===
local SETTINGS = {
    ACCENT_COLOR = Color3.fromRGB(0, 255, 150),   -- Ярко-зеленый (для нового стиля)
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    BG_COLOR = Color3.fromRGB(10, 10, 15),
    DARK_BG = Color3.fromRGB(25, 30, 45),
    DAMAGE_MULTIPLIER = 15,                     -- Увеличенный множитель x15
    TELEPORT_OFFSET = Vector3.new(0, 5, 0),
    HITBOX_EXTENT = Vector3.new(3, 3, 3),       -- Размер локального расширения хитбокса
    DEBUG_MODE = true,
}

-- === ГЛОБАЛЬНЫЕ СОСТОЯНИЯ ===
local ActiveConnections = {}
local FoundAddresses = {}
local FoundRemotes = {}
local PlayerListCache = {} -- Кэш для Aimbot/ESP

-- === КОНСТАНТЫ РАЗМЕРА ===
local MAX_SIZE = UDim2.new(0, 500, 0, 480) -- Увеличена высота для новых функций
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
        print("[PHANTOM_V3] " .. message)
    end
end

-- === 1. ОСНОВНАЯ НАСТРОЙКА GUI ===
local Gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
Gui.Name = "PHANTOM_V3_EXPLOIT_GUI"
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
Title.Text = "👻 PHANTOM V3.0 | KERNEL RELOADED"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = SETTINGS.TEXT_COLOR
Title.BackgroundColor3 = SETTINGS.DARK_BG
Title.TextScaled = true

-- Кнопки Закрытия/Сворачивания (логика из V2.3)
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
    else
        MainFrame:TweenSize(MAX_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔻"
        for _, child in ipairs(contentChildren) do
            if child then child.Visible = true end
        end
        local currentTabName = "Movement" 
        for _, btn in pairs(NavFrame:GetChildren()) do
            if btn:IsA("TextButton") and btn.BackgroundColor3 == SETTINGS.ACCENT_COLOR then
                currentTabName = btn.Name
                break
            end
        end
        if tabs[currentTabName] then tabs[currentTabName].Visible = true end
    end
end)


-- Фреймы для Навигации и Контента
NavFrame = Instance.new("ScrollingFrame", MainFrame)
NavFrame.Size = UDim2.new(0, 120, 1, -30)
NavFrame.Position = UDim2.new(0, 0, 0, 30)
NavFrame.BackgroundColor3 = SETTINGS.DARK_BG
NavFrame.BorderSizePixel = 0
NavFrame.ScrollBarThickness = 4

ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -120, 1, -30)
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.BackgroundColor3 = SETTINGS.BG_COLOR
ContentFrame.BackgroundTransparency = 0.5

-- Layouts и Утилиты (CreateTab, CreateToggleButton остаются прежними)

-- === 2. СИСТЕМА ВКЛАДОК / МОДУЛЕЙ (С НОВЫМИ МОДУЛЯМИ) ===

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
    frame.ScrollBarThickness = 6
    frame.Visible = false
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
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or SETTINGS.DARK_BG -- Ярче зеленый для активации
        btn.Text = (enabled and "🟢 " or "🔴 ") .. string.gsub(text, "^[🟢🔴] ", "")
    end)
    return btn
end

-- === 3. ОПРЕДЕЛЕНИЕ МОДУЛЕЙ / ВКЛАДОК ===
local MovementTab = CreateTab("🚀 Movement", 1)
local CombatTab = CreateTab("⚔️ Combat", 2)
local VisualsTab = CreateTab("👁️ Visuals (ESP)", 3) -- Новая вкладка
local WorldTab = CreateTab("🌎 World", 4)
local ValueScanTab = CreateTab("🔍 ValueScan", 5)
local RemoteExploitTab = CreateTab("💣 Remote Exploits", 6)
local AntiCheatBypassTab = CreateTab("🛡️ AC Bypass", 7) -- Новая вкладка
local ConfigTab = CreateTab("⚙️ Config", 8)

-- --- 3.1. МОДУЛЬ MOVEMENT ---
CreateToggleButton(MovementTab, "Speed Hack (x4)", function(enabled)
    local H = GetHumanoid()
    if not H then Log("Ошибка: Гуманоид не найден.") return end

    if enabled then
        H.WalkSpeed = 64
        Log("Speed Hack Активирован.")
    else
        H.WalkSpeed = 16
        Log("Speed Hack Деактивирован.")
    end
end)

CreateToggleButton(MovementTab, "Super Jump (x6)", function(enabled)
    local H = GetHumanoid()
    if not H then return end
    H.JumpPower = enabled and 300 or 50
    Log("Super Jump Активирован.")
end)

CreateToggleButton(MovementTab, "Fly Hack (CFrame Mode)", function(enabled)
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
local IsAimbotActive = false
local NearestTarget = nil

local function FindClosestEnemy()
    local HRP = GetHRP()
    if not HRP then return nil end

    local minDistance = math.huge
    local closestEnemy = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local enemyHRP = player.Character.HumanoidRootPart
            local distance = (HRP.Position - enemyHRP.Position).magnitude
            
            -- Проверка на то, что игрок не находится слишком далеко (для оптимизации)
            if distance < 3000 and distance < minDistance then
                minDistance = distance
                closestEnemy = player.Character
            end
        end
    end
    return closestEnemy
end

CreateToggleButton(CombatTab, "Aimbot (Closest Target)", function(enabled)
    IsAimbotActive = enabled
    if not enabled and ActiveConnections["Aimbot"] then ActiveConnections["Aimbot"]:Disconnect(); ActiveConnections["Aimbot"] = nil; return end

    if enabled then
        local aim_conn = RunService.Heartbeat:Connect(function()
            if not IsAimbotActive then return end

            local Target = FindClosestEnemy()
            local HRP = GetHRP()

            if Target and HRP and Target:FindFirstChild("Head") then
                HRP.CFrame = CFrame.new(HRP.Position, Target.Head.Position) * CFrame.Angles(0, math.rad(90), 0)
                NearestTarget = Target -- Обновляем ближайшую цель для других функций
            else
                NearestTarget = nil
            end
        end)
        ActiveConnections["Aimbot"] = aim_conn
        Log("Aimbot Активирован.")
    end
end)

CreateToggleButton(CombatTab, "Hitbox Extender (Local)", function(enabled)
    if enabled then
        local hitbox_conn = RunService.Heartbeat:Connect(function()
            local H = GetHumanoid()
            if H and H.Parent then
                for _, part in ipairs(H.Parent:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                        -- Локальная модификация размера для расширения хитбокса
                        part.Size = SETTINGS.HITBOX_EXTENT
                    end
                end
            end
        end)
        ActiveConnections["HitboxExtender"] = hitbox_conn
        Log("Hitbox Extender Активирован.")
    else
        if ActiveConnections["HitboxExtender"] then ActiveConnections["HitboxExtender"]:Disconnect(); ActiveConnections["HitboxExtender"] = nil end
        -- В реальном эксплойте здесь был бы код для сброса размера, но это зависит от оригинального размера
        Log("Hitbox Extender Деактивирован.")
    end
end)

CreateToggleButton(CombatTab, "Damage Multiplier (x" .. SETTINGS.DAMAGE_MULTIPLIER .. ")", function(enabled)
    -- Логика Damage Multiplier остается прежней, но с новым множителем
    -- ... (КОД DAMAGE MULTIPLIER) ...
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
        if ActiveConnections["DamageHack"] then ActiveConnections["DamageHack"]:Disconnect(); ActiveConnections["DamageHack"] = nil end
        Log("Damage Multiplier Деактивирован.")
    end
end)


-- --- 3.3. МОДУЛЬ VISUALS (ESP) ---
local ESP_Color = Color3.fromRGB(255, 0, 0) -- Красный для врагов
local ESP_Active = false

local function DrawBoxESP(target, color)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = target.HumanoidRootPart
    box.Size = Vector3.new(2, 5, 2)
    box.Color = color
    box.AlwaysOnTop = true
    box.ZIndex = 3
    box.Transparency = 0.5
    box.CFrame = target.HumanoidRootPart.CFrame
    box.Parent = CoreGui -- Привязываем к CoreGui для видимости
    return box
end

CreateToggleButton(VisualsTab, "Player ESP (Box/Wallhack)", function(enabled)
    ESP_Active = enabled
    
    if enabled then
        local esp_boxes = {}
        local esp_conn = RunService.RenderStepped:Connect(function()
            -- Очистка старых ESP
            for char, box in pairs(esp_boxes) do
                if not char or not char.Parent or char.Humanoid.Health <= 0 or not ESP_Active then
                    pcall(function() box:Destroy() end)
                    esp_boxes[char] = nil
                end
            end

            -- Создание новых ESP
            if ESP_Active then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
                        if not esp_boxes[player.Character] then
                            esp_boxes[player.Character] = DrawBoxESP(player.Character, ESP_Color)
                        end
                    end
                end
            end
        end)
        ActiveConnections["ESP"] = esp_conn
        Log("ESP Активирован.")
    else
        if ActiveConnections["ESP"] then ActiveConnections["ESP"]:Disconnect(); ActiveConnections["ESP"] = nil end
        -- Полная очистка
        for _, box in pairs(CoreGui:GetChildren()) do
            if box:IsA("BoxHandleAdornment") and box.Parent == CoreGui then
                 pcall(function() box:Destroy() end)
            end
        end
        Log("ESP Деактивирован.")
    end
end)


-- --- 3.4. МОДУЛЬ WORLD (TELEPORT & FARM) ---
-- (ОСТАЕТСЯ ПРЕЖНИМ)
-- ... (КОД WORLD) ...
local PlayerDropdown = Instance.new("TextBox", WorldTab)
PlayerDropdown.Size = UDim2.new(0.9, 0, 0, 30)
PlayerDropdown.PlaceholderText = "Имя игрока для TP (напр. 'TargetPlayer')"
PlayerDropdown.TextColor3 = SETTINGS.TEXT_COLOR
PlayerDropdown.BackgroundColor3 = SETTINGS.DARK_BG
PlayerDropdown.BorderColor3 = SETTINGS.ACCENT_COLOR
-- ... (Остальные элементы GUI и логика) ...
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
        else
            Log("TP Ошибка: Игрок не найден или не загружен.")
        end
    elseif coordsStr ~= "" then
        local x, y, z = coordsStr:match("([%-?%d%.]+), ([%-?%d%.]+), ([%-?%d%.]+)")
        if x and y and z then
            local cframe = CFrame.new(tonumber(x), tonumber(y) + SETTINGS.TELEPORT_OFFSET.Y, tonumber(z))
            HRP.CFrame = cframe
        else
            Log("TP Ошибка: Неверный формат координат.")
        end
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
    else
        if ActiveConnections["AutoFarm"] then ActiveConnections["AutoFarm"]:Disconnect(); ActiveConnections["AutoFarm"] = nil end
    end
end)


-- --- 3.5. МОДУЛЬ VALUE SCANNER ---
-- (ОСТАЕТСЯ ПРЕЖНИМ)
-- ... (КОД VALUE SCANNER) ...
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
end)


-- --- 3.6. МОДУЛЬ REMOTE EXPLOIT ---
-- (ОСТАЕТСЯ ПРЕЖНИМ)
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


-- --- 3.7. МОДУЛЬ ANTI-CHEAT BYPASS (НОВЫЙ) ---
CreateToggleButton(AntiCheatBypassTab, "Velocity/Speed Bypass (Passive)", function(enabled)
    local HRP = GetHRP()
    if not HRP then return end
    
    if enabled then
        -- Насильственная установка локальных свойств (обход клиентских проверок)
        pcall(function() HRP.Velocity = Vector3.new(0,0,0) end) 
        pcall(function() HRP.RotVelocity = Vector3.new(0,0,0) end)
        
        -- Попытка отключить или перехватить локальный скрипт, проверяющий скорость
        local function FindAndDisableSpeedChecks(instance)
            if instance:IsA("LocalScript") and (instance.Name:lower():match("speed") or instance.Source:lower():match("walkspeed")) then
                pcall(function() instance.Disabled = true end)
            end
            for _, child in ipairs(instance:GetChildren()) do
                FindAndDisableSpeedChecks(child)
            end
        end
        FindAndDisableSpeedChecks(Player)
        
        Log("Velocity/Speed Bypass Активирован.")
    else
        Log("Velocity/Speed Bypass Деактивирован.")
    end
end)

CreateToggleButton(AntiCheatBypassTab, "Infinite Jump Bypass", function(enabled)
    if enabled then
        -- Обход ограничения прыжков путем имитации многократного нажатия
        local jump_conn = RunService.Stepped:Connect(function()
            if GetHumanoid() and GetHumanoid():GetState() == Enum.HumanoidStateType.Jumping then
                GetHumanoid():ChangeState(Enum.HumanoidStateType.Landed)
                GetHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        ActiveConnections["InfiniteJump"] = jump_conn
        Log("Infinite Jump Bypass Активирован.")
    else
        if ActiveConnections["InfiniteJump"] then ActiveConnections["InfiniteJump"]:Disconnect(); ActiveConnections["InfiniteJump"] = nil end
        Log("Infinite Jump Bypass Деактивирован.")
    end
end)

CreateToggleButton(AntiCheatBypassTab, "No Fall Damage / Health Check Bypass", function(enabled)
    if enabled then
        -- Удаление или отключение скриптов, связанных с падением/смертью
        local function RemoveHealthScripts(instance)
            if instance:IsA("LocalScript") and (instance.Name:lower():match("health") or instance.Source:lower():match("damage")) then
                pcall(function() instance:Destroy() end)
            end
            for _, child in ipairs(instance:GetChildren()) do
                RemoveHealthScripts(child)
            end
        end
        
        if Player.Character then RemoveHealthScripts(Player.Character) end
        
        -- Попытка локально отключить отслеживание здоровья
        local H = GetHumanoid()
        if H then
            H.MaxHealth = 999999
            H.Health = 999999
            H.BreakJointsOnDeath = false -- Повышает выживаемость
        end
        
        Log("No Fall Damage/Health Bypass Активирован.")
    else
        Log("No Fall Damage/Health Bypass Деактивирован.")
        local H = GetHumanoid()
        if H then
            H.MaxHealth = 100
            H.Health = 100
            H.BreakJointsOnDeath = true
        end
    end
end)


-- --- 3.8. МОДУЛЬ CONFIG ---
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
SwitchTab("AntiCheatBypass") -- Начинаем с нового, важного модуля
Log("PHANTOM V3.0 KERNEL RELOADED успешно загружен.")
