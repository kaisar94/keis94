--[[
    GEMINI | BlackHat-LAB - PHANTOM V5.6 | SHADOW CORE (ULTRA-STEALTH DUPE)
    Ультимативная версия: Максимально скрытный дюп, ручная активация AC Bypass и полная модульность.
    Язык: Lua (Roblox Executor Environment)
--]]

local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Mouse = Player:GetMouse()
local HttpService = game:GetService("HttpService")

-- === КОНФИГУРАЦИЯ / ЦВЕТА ===
local SETTINGS = {
    ACCENT_COLOR = Color3.fromRGB(0, 180, 255),   -- Скрытый Голубой
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    BG_COLOR = Color3.fromRGB(5, 5, 15),
    DARK_BG = Color3.fromRGB(25, 25, 40),
    DAMAGE_MULTIPLIER = 25,
    TELEPORT_OFFSET = Vector3.new(0, 5, 0),
    DUPE_KEYWORDS = {"give", "item", "inventory", "reward", "purchase", "loot", "add"},
    DEBUG_MODE = true,
}

-- === ГЛОБАЛЬНЫЕ СОСТОЯНИЯ ===
local ActiveConnections = {}
local FoundAddresses = {} 
local FoundRemotes = {}   
local DupeRemotesCache = {}
local IsSilentAimActive = false

-- === КОНСТАНТЫ РАЗМЕРА ===
local MAX_SIZE = UDim2.new(0, 500, 0, 550) 
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

local function GetEquippedTool()
    local char = GetCharacter()
    if char then
        local equippedTool = char:FindFirstChildOfClass("Tool")
        if equippedTool and equippedTool.Parent == char then
            return equippedTool
        end
    end
    return nil
end

local function Log(message)
    if SETTINGS.DEBUG_MODE then
        print("[PHANTOM_V5] " .. message)
    end
end

local function FindClosestEnemy()
    local HRP = GetHRP()
    if not HRP then return nil end

    local minDistance = math.huge
    local closestEnemy = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local enemyHRP = player.Character.HumanoidRootPart
            local distance = (HRP.Position - enemyHRP.Position).magnitude
            
            if distance < 3000 and distance < minDistance then
                minDistance = distance
                closestEnemy = player.Character
            end
        end
    end
    return closestEnemy
end

-- === 0. СИСТЕМА СКРЫТНОСТИ (Evasion Environment Setup) ===
local StealthContainer = Instance.new("Folder")
StealthContainer.Name = "SystemCache_" .. HttpService:GenerateGUID(false) 
StealthContainer.Parent = nil 

-- === 1. ОСНОВНАЯ НАСТРОЙКА GUI ===
local Gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
Gui.Name = "SystemUI_" .. HttpService:GenerateGUID(false) 

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
Title.Text = "👻 PHANTOM V5.6 | SHADOW CORE (ULTRA-STEALTH DUPE)"
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
    for _, conn in pairs(ActiveConnections) do pcall(function() conn:Disconnect() end) end
end)

local NavFrame 
local ContentFrame 
local isMinimized = false
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Text = "🔻" 
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextColor3 = SETTINGS.TEXT_COLOR
MinimizeButton.BackgroundColor3 = SETTINGS.ACCENT_COLOR
MinimizeButton.BorderSizePixel = 0

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local contentChildren = {NavFrame, ContentFrame}

    if isMinimized then
        MainFrame:TweenSize(MIN_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔺"
        for _, child in ipairs(contentChildren) do if child then child.Visible = false end end
    else
        MainFrame:TweenSize(MAX_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔻"
        for _, child in ipairs(contentChildren) do if child then child.Visible = true end end
        local currentTabName = "Movement" 
        for _, btn in pairs(NavFrame:GetChildren()) do
            if btn:IsA("TextButton") and btn.BackgroundColor3 == SETTINGS.ACCENT_COLOR then currentTabName = btn.Name; break end
        end
        if tabs[currentTabName] then tabs[currentTabName].Visible = true end
    end
end)

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

local NavLayout = Instance.new("UIListLayout", NavFrame)
NavLayout.Padding = UDim.new(0, 5)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- === 2. СИСТЕМА ВКЛАДОК / МОДУЛЕЙ ===
local tabs = {}
local function SwitchTab(tabName)
    for name, frame in pairs(tabs) do frame.Visible = (name == tabName) end
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
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or SETTINGS.DARK_BG 
        btn.Text = (enabled and "🟢 " or "🔴 ") .. string.gsub(text, "^[🟢🔴] ", "")
    end)
    return btn
end

-- === 3. ОПРЕДЕЛЕНИЕ МОДУЛЕЙ / ВКЛАДОК ===
local MovementTab = CreateTab("🚀 Movement", 1)
local CombatTab = CreateTab("⚔️ Combat", 2)
local VisualsTab = CreateTab("👁️ Visuals (ESP)", 3)
local WorldTab = CreateTab("🌎 World", 4)
local DupeHackTab = CreateTab("💰 Stealth Dupe", 5) 
local DataSpyTab = CreateTab("📡 DataSpy", 6)
local ValueScanTab = CreateTab("🔍 ValueScan", 7)
local RemoteExploitTab = CreateTab("💣 Remote Exploits", 8)
local AntiCheatBypassTab = CreateTab("🛡️ AC Bypass", 9)
local ConfigTab = CreateTab("⚙️ Config", 10)

-- --- 3.1. МОДУЛЬ MOVEMENT ---
CreateToggleButton(MovementTab, "Speed Hack (x4)", function(enabled)
    local H = GetHumanoid()
    if not H then return end
    H.WalkSpeed = enabled and 64 or 16
end)

CreateToggleButton(MovementTab, "Super Jump (x6)", function(enabled)
    local H = GetHumanoid()
    if not H then return end
    H.JumpPower = enabled and 300 or 50
end)

CreateToggleButton(MovementTab, "Fly Hack (CFrame Mode)", function(enabled)
    local HRP = GetHRP()
    if not HRP then return end
    HRP.Anchored = enabled
end)

CreateToggleButton(MovementTab, "Noclip (Collision Bypass)", function(enabled)
    local char = GetCharacter()
    if not char then return end

    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end)

-- --- 3.2. МОДУЛЬ COMBAT ---
local IsAimbotActive = false
local IsSilentAimActive = false

CreateToggleButton(CombatTab, "Aimbot (HRP Lock)", function(enabled)
    IsAimbotActive = enabled
    if not enabled and ActiveConnections["Aimbot"] then ActiveConnections["Aimbot"]:Disconnect(); ActiveConnections["Aimbot"] = nil; return end

    if enabled then
        local aim_conn = RunService.Stepped:Connect(function()
            if not IsAimbotActive then return end
            local Target = FindClosestEnemy()
            local HRP = GetHRP()
            if Target and HRP and Target:FindFirstChild("Head") then
                HRP.CFrame = CFrame.new(HRP.Position, Target.Head.Position) * CFrame.Angles(0, math.rad(90), 0)
            end
        end)
        ActiveConnections["Aimbot"] = aim_conn
    end
end)

CreateToggleButton(CombatTab, "Silent Aim (On Click)", function(enabled)
    IsSilentAimActive = enabled
    if not enabled and ActiveConnections["SilentAim"] then ActiveConnections["SilentAim"]:Disconnect(); ActiveConnections["SilentAim"] = nil; return end
    
    if enabled then
        local silent_conn = Mouse.Button1Down:Connect(function()
            if not IsSilentAimActive then return end
            local Target = FindClosestEnemy()
            local HRP = GetHRP()
            
            if Target and HRP and Target:FindFirstChild("Head") then
                local originalCFrame = HRP.CFrame
                HRP.CFrame = CFrame.new(HRP.Position, Target.Head.Position) * CFrame.Angles(0, math.rad(90), 0)
                RunService.Stepped:Wait() 
                HRP.CFrame = originalCFrame
            end
        end)
        ActiveConnections["SilentAim"] = silent_conn
    end
end)

CreateToggleButton(CombatTab, "Hitbox Extender (Local)", function(enabled)
    if enabled then
        local hitbox_conn = RunService.Stepped:Connect(function()
            local H = GetHumanoid()
            if H and H.Parent then
                for _, part in ipairs(H.Parent:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide and part.Name ~= "HumanoidRootPart" then
                        part.Size = SETTINGS.HITBOX_EXTENT
                    end
                end
            end
        end)
        ActiveConnections["HitboxExtender"] = hitbox_conn
    else
        if ActiveConnections["HitboxExtender"] then ActiveConnections["HitboxExtender"]:Disconnect(); ActiveConnections["HitboxExtender"] = nil end
    end
end)

CreateToggleButton(CombatTab, "Damage Multiplier (x" .. SETTINGS.DAMAGE_MULTIPLIER .. ")", function(enabled)
    local function recursiveDamageHack(instance, depth)
        if depth > 10 then return end
        if instance:IsA("Tool") or instance:IsA("BasePart") or instance:IsA("ModuleScript") then
            for _, child in ipairs(instance:GetChildren()) do
                pcall(function()
                    local nameLower = child.Name:lower()
                    if (child:IsA("NumberValue") or child:IsA("IntValue")) and (nameLower:match("damage") or nameLower:match("dmg")) then
                        if enabled then child.Value = child.Value * SETTINGS.DAMAGE_MULTIPLIER
                        else child.Value = child.Value / SETTINGS.DAMAGE_MULTIPLIER end
                    end
                end)
                recursiveDamageHack(child, depth + 1)
            end
        end
    end

    if enabled then
        local damage_conn = RunService.Stepped:Connect(function() 
            if Player.Character then recursiveDamageHack(Player.Character, 0); recursiveDamageHack(Player.Backpack, 0) end
        end)
        ActiveConnections["DamageHack"] = damage_conn
    else
        if ActiveConnections["DamageHack"] then ActiveConnections["DamageHack"]:Disconnect(); ActiveConnections["DamageHack"] = nil end
    end
end)


-- --- 3.3. МОДУЛЬ VISUALS (ESP) ---
local ESP_Color = Color3.fromRGB(255, 0, 0) 
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
    box.Parent = CoreGui 
    return box
end

CreateToggleButton(VisualsTab, "Player ESP (Box/Wallhack)", function(enabled)
    ESP_Active = enabled
    if enabled then
        local esp_boxes = {}
        local esp_conn = RunService.RenderStepped:Connect(function()
            for char, box in pairs(esp_boxes) do
                if not char or not char.Parent or char.Humanoid.Health <= 0 or not ESP_Active then
                    pcall(function() box:Destroy() end)
                    esp_boxes[char] = nil
                end
            end
            if ESP_Active then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
                        if not esp_boxes[player.Character] then
                            esp_boxes[player.Character] = DrawBoxESP(player.Character, ESP_Color)
                        else
                            esp_boxes[player.Character].CFrame = player.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end
        end)
        ActiveConnections["ESP"] = esp_conn
    else
        if ActiveConnections["ESP"] then ActiveConnections["ESP"]:Disconnect(); ActiveConnections["ESP"] = nil end
        for _, box in pairs(CoreGui:GetChildren()) do
            if box:IsA("BoxHandleAdornment") and box.Parent == CoreGui then pcall(function() box:Destroy() end) end
        end
    end
end)


-- --- 3.4. МОДУЛЬ WORLD (TELEPORT & FARM) ---
local PlayerDropdown = Instance.new("TextBox", WorldTab)
PlayerDropdown.Size = UDim2.new(0.9, 0, 0, 30)
PlayerDropdown.PlaceholderText = "Имя игрока для TP"
PlayerDropdown.TextColor3 = SETTINGS.TEXT_COLOR
PlayerDropdown.BackgroundColor3 = SETTINGS.DARK_BG
PlayerDropdown.BorderColor3 = SETTINGS.ACCENT_COLOR

local CoordsInput = Instance.new("TextBox", WorldTab)
CoordsInput.Size = UDim2.new(0.9, 0, 0, 30)
CoordsInput.PlaceholderText = "Координаты для TP (X, Y, Z)"
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
    if not HRP then return end
    if targetName ~= "" then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            HRP.CFrame = target.Character.HumanoidRootPart.CFrame + SETTINGS.TELEPORT_OFFSET
        end
    elseif coordsStr ~= "" then
        local x, y, z = coordsStr:match("([%-?%d%.]+), ([%-?%d%.]+), ([%-?%d%.]+)")
        if x and y and z then
            local cframe = CFrame.new(tonumber(x), tonumber(y) + SETTINGS.TELEPORT_OFFSET.Y, tonumber(z))
            HRP.CFrame = cframe
        end
    end
end)

CreateToggleButton(WorldTab, "💰 Auto Farm (Target: 'Coin')", function(enabled)
    if enabled then
        local farm_conn = RunService.Stepped:Connect(function() 
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


-- --- 3.5. МОДУЛЬ STEALTH AUTO DUPE ---
local DupeStatus = Instance.new("TextLabel", DupeHackTab)
DupeStatus.Size = UDim2.new(0.9, 0, 0, 30)
DupeStatus.BackgroundTransparency = 1
DupeStatus.TextColor3 = SETTINGS.TEXT_COLOR
DupeStatus.Text = "Статус: Ожидание сканирования..."

local DupeRemoteInput = Instance.new("TextBox", DupeHackTab)
DupeRemoteInput.Size = UDim2.new(0.9, 0, 0, 30)
DupeRemoteInput.PlaceholderText = "Путь к RemoteEvent (заполнится автоматически)"
DupeRemoteInput.BackgroundColor3 = SETTINGS.DARK_BG
DupeRemoteInput.TextColor3 = SETTINGS.TEXT_COLOR
DupeRemoteInput.BorderColor3 = SETTINGS.ACCENT_COLOR

local function ScanForDupeRemotes()
    local foundRemotes = {}
    local function recursiveScan(instance, depth)
        if depth > 12 then return end
        
        local className = instance.ClassName
        if className == "RemoteEvent" or className == "RemoteFunction" then
            local nameLower = instance.Name:lower()
            
            for _, keyword in ipairs(SETTINGS.DUPE_KEYWORDS) do
                if string.find(nameLower, keyword) then
                    table.insert(foundRemotes, instance)
                    break
                end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
    end
    
    recursiveScan(game, 0)
    DupeRemotesCache = foundRemotes
    return foundRemotes
end

local function StealthDupeStart(remote, toolName, spamCount)
    if not remote or not toolName then return 0 end
    
    local successCount = 0
    local RANDOM_ARGS = {
        nil, Player, 9999, toolName, CFrame.new(), Vector3.new(0, 5, 0), math.random(10, 100), HttpService:GenerateGUID(false)
    }
    
    for i = 1, spamCount do
        pcall(function()
            local arg1 = RANDOM_ARGS[math.random(1, #RANDOM_ARGS)]
            local arg2 = RANDOM_ARGS[math.random(1, #RANDOM_ARGS)]
            local arg3 = toolName 
            
            if remote:IsA("RemoteEvent") then
                if math.random(1, 2) == 1 then
                    remote:FireServer(arg3, arg1, arg2)
                else
                    remote:FireServer(arg1, arg3, arg2)
                end
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(arg3, arg1)
            end
            successCount = successCount + 1
        end)
        wait(0.05 + math.random() * 0.05) -- Увеличенная и рандомизированная задержка
    end
    
    return successCount
end

CreateToggleButton(DupeHackTab, "🔍 СКАНИРОВАТЬ DUPE REMOTES", function(enabled, btn)
    if enabled then
        DupeStatus.Text = "🔍 Сканирование Remotes для дюпа..."
        local foundRemotes = ScanForDupeRemotes()
        
        if #foundRemotes > 0 then
            local remotePath = foundRemotes[1]:GetFullName()
            DupeRemoteInput.Text = remotePath
            DupeStatus.Text = string.format("✅ Найдено %d потенциальных Remote-функций.", #foundRemotes)
        else
            DupeStatus.Text = "❌ Remote-функции для дюпа не найдены."
        end
        wait(0.5)
    end
end)

CreateToggleButton(DupeHackTab, "💣 АВТОМАТИЧЕСКИЙ STEALTH DUPE (ЭКИПИРОВАННОЕ)", function(enabled, btn)
    if not enabled then DupeStatus.Text = "Дюп остановлен." return end

    spawn(function()
        DupeStatus.Text = "1/3: Поиск ЭКИПИРОВАННОГО предмета..."
        local equippedTool = GetEquippedTool()
        
        if not equippedTool then
            DupeStatus.Text = "❌ Ошибка: Предмет не экипирован (должен быть в руке)."
            return
        end
        
        DupeStatus.Text = "2/3: Поиск RemoteEvent..."
        local remotePath = DupeRemoteInput.Text
        if remotePath == "" then
             DupeStatus.Text = "⚠️ Сначала выполните СКАНИРОВАНИЕ DUPE REMOTES!"
             return
        end
        local remote = game:FindFirstChild(remotePath, true)
        
        if not remote or not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            DupeStatus.Text = "❌ Ошибка: Remote НЕ НАЙДЕН или неверный путь: " .. remotePath
            return
        end
        
        DupeStatus.Text = string.format("3/3: Найдено: '%s'. Запуск ULTRA-STEALTH спама...", equippedTool.Name)
        
        local count = StealthDupeStart(remote, equippedTool.Name, 50)
        
        DupeStatus.Text = string.format("✅ ДЮП завершен! Отправлено %d запросов для '%s'.", count, equippedTool.Name)
        
    end)
end)


-- --- 3.6. МОДУЛЬ DATASPY ---
local SpyLog = Instance.new("TextLabel", DataSpyTab)
SpyLog.Size = UDim2.new(0.9, 0, 1, -40)
SpyLog.Position = UDim2.new(0.05, 0, 0, 5)
SpyLog.BackgroundTransparency = 0.8
SpyLog.BackgroundColor3 = SETTINGS.DARK_BG
SpyLog.TextColor3 = SETTINGS.TEXT_COLOR
SpyLog.TextXAlignment = Enum.TextXAlignment.Left
SpyLog.TextYAlignment = Enum.TextYAlignment.Top
SpyLog.Text = "Ожидание активности Remote..."
SpyLog.Font = Enum.Font.SourceSans
SpyLog.TextSize = 10
SpyLog.TextWrapped = true

local logBuffer = {}
local function updateSpyLog(message)
    table.insert(logBuffer, 1, message)
    if #logBuffer > 15 then table.remove(logBuffer, #logBuffer) end
    SpyLog.Text = table.concat(logBuffer, "\n")
end

CreateToggleButton(DataSpyTab, "📡 Remote Event Listener (Inbound)", function(enabled)
    if not getconnections then updateSpyLog("❌ getconnections не поддерживается вашим эксплойтом."); return end

    if enabled then
        table.clear(logBuffer)
        updateSpyLog("🟢 Прослушивание Remote Event запущено...")
        local remotes = {}
        
        for _, inst in ipairs(game:GetDescendants()) do
            if inst:IsA("RemoteEvent") then table.insert(remotes, inst) end
        end

        local totalCount = 0
        local spy_connections = {}
        for _, remote in ipairs(remotes) do
            local connections = pcall(function() return getconnections(remote.OnClientEvent) end)
            if connections and connections[1] then
                for _, conn in ipairs(connections[1]) do
                    if conn.State == 1 then
                        local originalFunc = conn.Function
                        conn.Function = function(...)
                            totalCount = totalCount + 1
                            local args = {...}
                            local msg = string.format("[%d] 📜 %s (Args: %d)", totalCount, remote.Name, #args)
                            updateSpyLog(msg)
                            return originalFunc(...)
                        end
                        table.insert(spy_connections, conn)
                    end
                end
            end
        end
        ActiveConnections["DataSpy"] = spy_connections
        updateSpyLog(string.format("🟢 Найдено %d Remotes для прослушивания. Ждем данных...", #remotes))
    else
        if ActiveConnections["DataSpy"] then
            for _, conn in ipairs(ActiveConnections["DataSpy"]) do
                pcall(function() conn:Disconnect() end)
            end
            ActiveConnections["DataSpy"] = nil
        end
        updateSpyLog("🔴 Прослушивание Remote Event остановлено.")
    end
end)


-- --- 3.7. МОДУЛЬ VALUE SCANNER ---
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

local function CheckValueMatch(instance, targetValue)
    local val = instance.Value
    local targetNum = tonumber(targetValue)
    local targetStr = type(targetValue) == "string" and targetValue or nil

    if instance:IsA("ValueBase") then
        if targetNum and type(val) == "number" then
            return math.abs(val - targetNum) < 0.001
        elseif targetStr and type(val) == "string" then
            return string.lower(val) == string.lower(targetStr)
        end
    end
    return false
end

local function InitialScanLogic(rootInstance, targetValue)
    local results = {}
    local targetType = tonumber(targetValue) and "number" or "string"

    local function recursiveScan(instance, depth)
        if depth > 20 then return end

        if instance:IsA("ValueBase") then
            if targetType == "number" and (instance:IsA("NumberValue") or instance:IsA("IntValue")) then
                 if CheckValueMatch(instance, targetValue) then
                    results[instance] = instance.Value
                end
            elseif targetType == "string" and instance:IsA("StringValue") then
                if CheckValueMatch(instance, targetValue) then
                    results[instance] = instance.Value
                end
            end
        end
        
        if not instance:IsA("LocalScript") and not instance:IsA("Script") and not instance:IsA("ModuleScript") then
             for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
        end
    end
    recursiveScan(rootInstance, 0)
    return results
end

local function RefineScanLogic(targetValue)
    local refinedResults = {}
    
    for instance, _ in pairs(FoundAddresses) do
        if instance.Parent and CheckValueMatch(instance, targetValue) then
            refinedResults[instance] = instance.Value
        end
    end
    return refinedResults
end

local function UpdateScanResults(results)
    table.clear(FoundAddresses)
    for inst, val in pairs(results) do
        FoundAddresses[inst] = val
    end
    local count = 0
    for _, _ in pairs(FoundAddresses) do count = count + 1 end
    SStatus.Text = string.format("✅ Найдено %d адресов.", count)
    return count
end


CreateToggleButton(ValueScanTab, "1️⃣ ПЕРВЫЙ ПОИСК", function(enabled, btn)
    if not SInput.Text or SInput.Text == "" then SStatus.Text = "❌ Введите значение!" return end
    
    spawn(function()
        SStatus.Text = "🔍 Поиск по всему дереву объектов..."
        local results = InitialScanLogic(game, SInput.Text)
        UpdateScanResults(results)
    end)
end)

CreateToggleButton(ValueScanTab, "2️⃣ ОТСЕИВАНИЕ (Next Scan)", function(enabled, btn)
    if not SInput.Text or SInput.Text == "" or #FoundAddresses == 0 then SStatus.Text = "❌ Сначала выполните Первый Поиск!" return end
    
    spawn(function()
        SStatus.Text = "🔎 Фильтрация существующих адресов..."
        local results = RefineScanLogic(SInput.Text)
        UpdateScanResults(results)
    end)
end)

CreateToggleButton(ValueScanTab, "💥 3️⃣ ИЗМЕНИТЬ ВСЕ ЗНАЧЕНИЯ", function(enabled, btn)
    local newVal = SNewInput.Text
    if not newVal or #FoundAddresses == 0 then SStatus.Text = "❌ Введите новое значение или выполните поиск!" return end
    local count = 0
    local targetNum = tonumber(newVal)

    for inst, _ in pairs(FoundAddresses) do
        pcall(function()
            if inst.Parent and inst:IsA("ValueBase") then
                if targetNum then inst.Value = targetNum else inst.Value = newVal end
                count = count + 1
            else
                FoundAddresses[inst] = nil 
            end
        end)
    end
    SStatus.Text = string.format("💰 Успешно изменено %d значений!", count)
end)


-- --- 3.8. МОДУЛЬ REMOTE EXPLOIT ---
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


-- --- 3.9. МОДУЛЬ ANTI-CHEAT BYPASS (MANUAL-ON LOGIC) ---

-- Функции для ручной активации/деактивации
local function ToggleVelocityBypass(enabled)
    local HRP = GetHRP()
    if not HRP then return end
    
    if enabled then
        pcall(function() HRP.Velocity = Vector3.new(0,0,0) end) 
        pcall(function() HRP.RotVelocity = Vector3.new(0,0,0) end)
        
        local function FindAndDisableSpeedChecks(instance)
            if instance:IsA("LocalScript") and (instance.Name:lower():match("speed") or instance.Source:lower():match("walkspeed")) then
                pcall(function() instance.Disabled = true end)
            end
            for _, child in ipairs(instance:GetChildren()) do FindAndDisableSpeedChecks(child) end
        end
        FindAndDisableSpeedChecks(Player)
    end
end

local function ToggleInfiniteJump(enabled)
    if enabled then
        local jump_conn = RunService.Stepped:Connect(function()
            local H = GetHumanoid()
            if H and H:GetState() == Enum.HumanoidStateType.Jumping then
                H:ChangeState(Enum.HumanoidStateType.Landed)
                H:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        ActiveConnections["InfiniteJump"] = jump_conn
    else
        if ActiveConnections["InfiniteJump"] then ActiveConnections["InfiniteJump"]:Disconnect(); ActiveConnections["InfiniteJump"] = nil end
    end
end)

local function ToggleGravityBypass(enabled)
    local H = GetHumanoid()
    if not H then return end
    
    if enabled then
        local gravity_conn = RunService.Stepped:Connect(function()
            H.PlatformStand = true
            local HRP = GetHRP()
            if HRP then HRP.CFrame = HRP.CFrame + Vector3.new(0, 0.001, 0) end
        end)
        ActiveConnections["GravityBypass"] = gravity_conn
    else
        if ActiveConnections["GravityBypass"] then ActiveConnections["GravityBypass"]:Disconnect(); ActiveConnections["GravityBypass"] = nil end
        H.PlatformStand = false
    end
end)

local function ToggleHeartbeatSpoof(enabled)
    if not getconnections then return end

    if enabled then
        local spoof_conn = Instance.new("LocalScript", StealthContainer).AncestryChanged:Connect(function()
            local function checkAndDisconnect(connections)
                for _, conn in ipairs(connections) do
                    if conn.State == 1 and conn.Function then
                        local funcInfo = tostring(conn.Function)
                        if funcInfo:match("getVelocity") or funcInfo:match("checkSpeed") then
                            pcall(function() conn:Disconnect() end)
                        end
                    end
                end
            end

            pcall(function() checkAndDisconnect(getconnections(RunService.Heartbeat)) end)
            pcall(function() checkAndDisconnect(getconnections(RunService.RenderStepped)) end)
        end)
        ActiveConnections["HeartbeatSpoof"] = spoof_conn
    else
        if ActiveConnections["HeartbeatSpoof"] then ActiveConnections["HeartbeatSpoof"]:Disconnect(); ActiveConnections["HeartbeatSpoof"] = nil end
    end
end)


CreateToggleButton(AntiCheatBypassTab, "Velocity/Speed Bypass (Manual)", ToggleVelocityBypass)
CreateToggleButton(AntiCheatBypassTab, "Infinite Jump Bypass (Manual)", ToggleInfiniteJump)
CreateToggleButton(AntiCheatBypassTab, "Gravity Bypass (Manual)", ToggleGravityBypass)
CreateToggleButton(AntiCheatBypassTab, "Heartbeat Check Spoof (Manual)", ToggleHeartbeatSpoof)


-- --- 3.10. МОДУЛЬ CONFIG ---
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
    else
        if existingPart then existingPart:Destroy() end
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
    end
end)

-- === 4. ФИНАЛИЗАЦИЯ ===
SwitchTab("DupeHackTab") 
Log("PHANTOM V5.6 SHADOW CORE успешно загружен. Фокус: Ultra-Stealth Dupe.")
