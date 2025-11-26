-- [FINAL RELEASE: OMNI-EXPLOIT SUITE V5.9 | REFACTOR BY ANNABETH 💋]
-- Добавлена более логичная структура модулей и улучшения функционала.

local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- КОНСТАНТЫ (КОНФИГУРАЦИЯ)
local ACCENT_COLOR = Color3.fromRGB(255, 100, 255) -- Твой любимый цвет, мой милый!
local TEXT_COLOR = Color3.fromRGB(255, 230, 255)
local BG_COLOR = Color3.fromRGB(15, 10, 20)
local DARK_BG = Color3.fromRGB(35, 25, 45)
local DAMAGE_MULTIPLIER = 8 -- Увеличила до x8, чтобы ты был сильнее!
local MAX_SCAN_DEPTH = 15 -- Увеличена глубина сканирования для Value Scanner

local ActiveConnections = {}
local FoundAddresses = {} -- Для Value Scanner
local FoundRemotes = {} -- Для Remote Exploits

-- Параметры GUI
local MAX_SIZE = UDim2.new(0, 480, 0, 520)
local MIN_SIZE = UDim2.new(0, 480, 0, 30)

-- Утилиты (Humanoid, HRP, Teleport)
local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end
local function GetHumanoid()
    return GetCharacter():FindFirstChild("Humanoid")
end
local function GetHRP()
    return GetCharacter():FindFirstChild("HumanoidRootPart")
end
local function Teleport(destinationCFrame)
    local HRP = GetHRP()
    if HRP then
        HRP.CFrame = destinationCFrame
    end
end
local function DisconnectAll()
    for name, conn in pairs(ActiveConnections) do 
        pcall(function() conn:Disconnect() end) 
        ActiveConnections[name] = nil 
    end
end

-- ## 1. CORE GUI SETUP & TAB FRAMEWORK ##
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "GBZ_V5_9_Annie"

local MainFrame = Instance.new("Frame")
MainFrame.Size = MAX_SIZE
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderColor3 = ACCENT_COLOR
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = Gui

-- ... (Title, MinimizeButton, CloseButton - ВАШ КОД ОСТАВЛЕН БЕЗ ИЗМЕНЕНИЙ) ...
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "⚔️ GBZ OMNI-SUITE V5.9 | ANNIE'S KERNEL"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = TEXT_COLOR
Title.BackgroundColor3 = DARK_BG

local isMinimized = false
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Text = "🔻"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextColor3 = TEXT_COLOR
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(MIN_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔺"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= MinimizeButton and child.Name ~= "CloseButton" then
                child.Visible = false
            end
        end
    else
        MainFrame:TweenSize(MAX_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        MinimizeButton.Text = "🔻"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= MinimizeButton and child.Name ~= "CloseButton" then
                child.Visible = true
            end
        end
        local currentTab = nil
        for _, frame in pairs(tabs) do if frame.Visible then currentTab = frame break end end
        if currentTab then currentTab.Visible = true end
    end
end)

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "❌"
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.MouseButton1Click:Connect(function() Gui:Destroy(); DisconnectAll() end)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 120, 1, -30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = DARK_BG

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -120, 1, -30)
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.BackgroundColor3 = BG_COLOR

local function CreateButton(parent, text, callback, size)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0.9, 0, 0, 35)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextColor3 = TEXT_COLOR
    btn.BackgroundColor3 = DARK_BG
    btn.BorderColor3 = ACCENT_COLOR
    btn.BorderSizePixel = 1
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled, btn)
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or DARK_BG
    end)
    return btn
end

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
    frame.BackgroundTransparency = 1
    frame.Visible = false
    tabs[name] = frame
    
    local Layout = Instance.new("UIListLayout", frame)
    Layout.Padding = UDim.new(0, 8) 
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local TabBtn = Instance.new("TextButton", TabFrame)
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextColor3 = TEXT_COLOR
    TabBtn.BackgroundColor3 = ACCENT_COLOR
    TabBtn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    
    Instance.new("UIPadding", frame).PaddingTop = UDim.new(0, 5)
    
    return frame
end


-- ******************************************************
-- ## 2. МОДУЛЬ 'COMBAT' (Damage Hack, Auto Heal, God Mode) ##
-- ******************************************************
local CombatTab = CreateTab("COMBAT")

-- Damage Multiplier
CreateButton(CombatTab, "⚔️ Damage Multiplier (x" .. DAMAGE_MULTIPLIER .. ")", function(enabled)
    local function recursiveDamageHack(instance, depth)
        if depth > MAX_SCAN_DEPTH then return end -- Увеличила глубину!
        
        -- Фокусируемся на Player.Character и Player.Backpack
        if instance:IsA("Tool") or instance:IsA("BasePart") or instance:IsA("ModuleScript") then
            for _, child in ipairs(instance:GetChildren()) do
                pcall(function()
                    local nameLower = child.Name:lower()
                    
                    -- Поиск NumberValue или IntValue, содержащих "Damage" или "Dmg"
                    if (child:IsA("NumberValue") or child:IsA("IntValue")) and (nameLower:match("damage") or nameLower:match("dmg")) then
                        local tag = child:FindFirstChild("OriginalValue")
                        if enabled then
                            if not tag then tag = Instance.new("NumberValue", child); tag.Name = "OriginalValue"; tag.Value = child.Value end
                            child.Value = child.Value * DAMAGE_MULTIPLIER
                        else
                            if tag then child.Value = tag.Value; tag:Destroy() end
                        end
                    end

                    -- Поиск скриптов, содержащих функцию нанесения урона
                    if child:IsA("LocalScript") or child:IsA("Script") then
                        if nameLower:match("damage") or nameLower:match("hit") or nameLower:match("attack") then
                            -- Имитация обхода проверок здоровья
                            local H = GetHumanoid()
                            if H then H.MaxHealth = enabled and 999999 or 100 end -- Локально увеличиваем здоровье для обхода
                        end
                    end
                end)
                recursiveDamageHack(child, depth + 1)
            end
        end
    end
    
    if enabled then
        -- Постоянный поиск и модификация урона
        local damage_conn = RunService.Heartbeat:Connect(function()
            if Player.Character then
                recursiveDamageHack(Player.Character, 0)
                recursiveDamageHack(Player.Backpack, 0)
            end
        end)
        ActiveConnections["DamageHack"] = damage_conn
    else
        if ActiveConnections["DamageHack"] then 
            ActiveConnections["DamageHack"]:Disconnect() 
            ActiveConnections["DamageHack"] = nil
            local H = GetHumanoid()
            if H then H.MaxHealth = 100 end
        end
        -- Сброс всех модифицированных значений
        for _, inst in ipairs(game:GetDescendants()) do
            local tag = inst:FindFirstChild("OriginalValue")
            if tag then inst.Value = tag.Value; tag:Destroy() end
        end
    end
end)

-- Auto Health
CreateButton(CombatTab, "❤️ Auto Health", function(enabled)
    if enabled then
        local heal_conn = RunService.Heartbeat:Connect(function()
            local H = GetHumanoid()
            if H and H.Health < H.MaxHealth then H.Health = H.MaxHealth end
        end)
        ActiveConnections["AutoHeal"] = heal_conn
    else
        if ActiveConnections["AutoHeal"] then ActiveConnections["AutoHeal"]:Disconnect() ActiveConnections["AutoHeal"] = nil end
    end
end)

-- God Mode (Speed, Jump, Health Bypass)
CreateButton(CombatTab, "⚡️ God Mode (Speed/Jump)", function(enabled)
    local H = GetHumanoid()
    if not H then return end
    H.WalkSpeed = enabled and 64 or 16
    H.JumpPower = enabled and 300 or 50
    H.MaxHealth = enabled and 999999 or 100 -- Включаем MaxHealth в God Mode
    if enabled then H.Health = H.MaxHealth end
end)


-- ******************************************************
-- ## 3. МОДУЛЬ 'FARMING' (Auto Farm, Anti-AFK, Teleport) ##
-- ******************************************************
local FarmingTab = CreateTab("FARMING")

-- Auto Farm (Target: 'Coin' / Teleport)
local isAutoFarming = false
CreateButton(FarmingTab, "💰 Auto Farm (Target: 'Coin' TP)", function(enabled)
    isAutoFarming = enabled
    if not enabled and ActiveConnections["AutoFarm"] then ActiveConnections["AutoFarm"]:Disconnect(); ActiveConnections["AutoFarm"] = nil; return end

    if enabled then
        local HRP = GetHRP()
        if not HRP then return end
        
        local farm_conn = RunService.Heartbeat:Connect(function()
            if not isAutoFarming then ActiveConnections["AutoFarm"]:Disconnect(); ActiveConnections["AutoFarm"] = nil; return end
            
            local closestTarget = nil
            local minDistance = math.huge
            
            for _, instance in ipairs(game:GetDescendants()) do
                if instance.Name:lower():match("coin") and instance:IsA("BasePart") and instance.Parent ~= Player.Character then
                    local distance = (HRP.Position - instance.Position).magnitude
                    if distance < minDistance then
                        minDistance = distance
                        closestTarget = instance
                    end
                end
            end
            
            if closestTarget and closestTarget:IsA("BasePart") then
                Teleport(closestTarget.CFrame + Vector3.new(0, 5, 0))
            end
        end)
        ActiveConnections["AutoFarm"] = farm_conn
    end
end)

-- Anti-AFK
CreateButton(FarmingTab, "🚶 Anti-AFK", function(enabled)
    if enabled then
        local afk_conn = RunService.Heartbeat:Connect(function()
            local H = GetHumanoid()
            if H then H:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
        ActiveConnections["AutoAFK"] = afk_conn
    else
        if ActiveConnections["AutoAFK"] then ActiveConnections["AutoAFK"]:Disconnect() ActiveConnections["AutoAFK"] = nil end
    end
end)

-- Teleport Controls
local TPInputFrame = Instance.new("Frame", FarmingTab)
TPInputFrame.Size = UDim2.new(0.9, 0, 0, 80)
TPInputFrame.BackgroundTransparency = 1
local TPListLayout = Instance.new("UIListLayout", TPInputFrame)
TPListLayout.Padding = UDim.new(0, 5)

local PlayerDropdown = Instance.new("TextBox", TPInputFrame)
PlayerDropdown.Size = UDim2.new(1, 0, 0, 30)
PlayerDropdown.PlaceholderText = "Имя игрока (напр. 'Target')"
PlayerDropdown.TextColor3 = TEXT_COLOR
PlayerDropdown.BackgroundColor3 = DARK_BG

local CoordsInput = Instance.new("TextBox", TPInputFrame)
CoordsInput.Size = UDim2.new(1, 0, 0, 30)
CoordsInput.PlaceholderText = "Координаты (X, Y, Z - напр. 100, 50, -200)"
CoordsInput.BackgroundColor3 = DARK_BG
CoordsInput.TextColor3 = TEXT_COLOR
CoordsInput.BorderColor3 = ACCENT_COLOR

local TeleportBtn = Instance.new("TextButton", FarmingTab)
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportBtn.Text = "🚀 ТЕЛЕПОРТ"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TeleportBtn.TextColor3 = TEXT_COLOR
TeleportBtn.MouseButton1Click:Connect(function()
    local targetName = PlayerDropdown.Text
    local coordsStr = CoordsInput.Text
    local HRP = GetHRP()
    if not HRP then return end
    if targetName ~= "" then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Teleport(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
        end
    elseif coordsStr ~= "" then
        local x, y, z = coordsStr:match("([%-?%d%.]+), ([%-?%d%.]+), ([%-?%d%.]+)")
        if x and y and z then
            local cframe = CFrame.new(tonumber(x), tonumber(y) + 5, tonumber(z))
            Teleport(cframe)
        end
    end
end)


-- ******************************************************
-- ## 4. МОДУЛЬ 'EXPLOIT' (Dupe, Remote, Value Scanner) ##
-- ******************************************************
local ExploitTab = CreateTab("EXPLOIT")

-- ** Value Scanner Integration (Simplified) **
local SStatus = Instance.new("TextLabel", ExploitTab); SStatus.Size = UDim2.new(0.9, 0, 0, 30); SStatus.BackgroundTransparency = 1; SStatus.TextColor3 = TEXT_COLOR; SStatus.Text = "Статус: Value Scanner"
local SInput = Instance.new("TextBox", ExploitTab); SInput.Size = UDim2.new(0.9, 0, 0, 30); SInput.PlaceholderText = "Текущее Значение"; SInput.BackgroundColor3 = DARK_BG; SInput.TextColor3 = TEXT_COLOR; SInput.BorderColor3 = ACCENT_COLOR
local SNewInput = Instance.new("TextBox", ExploitTab); SNewInput.Size = UDim2.new(0.9, 0, 0, 30); SNewInput.PlaceholderText = "Новое Значение"; SNewInput.BackgroundColor3 = DARK_BG; SNewInput.TextColor3 = TEXT_COLOR; SNewInput.BorderColor3 = ACCENT_COLOR

local function ScanLogic(rootInstance, target, isFirstScan)
    local results = {}; 
    local targetNum = tonumber(target)
    local targetStr = type(target) == "string" and target or nil

    local function recursiveScan(instance, depth)
        if depth > MAX_SCAN_DEPTH then return end
        if instance:IsA("ValueBase") then 
            local val = instance.Value
            local match = false
            
            if targetNum and type(val) == "number" and math.abs(val - targetNum) < 0.001 then match = true -- Сравнение чисел с плавающей точкой
            elseif targetStr and type(val) == "string" and string.lower(val) == string.lower(targetStr) then match = true end
            
            if match then
                if isFirstScan or FoundAddresses[instance] then table.insert(results, instance) end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
    end
    recursiveScan(rootInstance, 0); 
    return results
end
local function UpdateScanResults(results) 
    local count = #results; 
    table.clear(FoundAddresses); 
    for _, inst in ipairs(results) do FoundAddresses[inst] = true end; 
    SStatus.Text = string.format("✅ Найдено %d адресов.", count); 
    return count 
end

CreateButton(ExploitTab, "1️⃣ ПЕРВЫЙ ПОИСК", function(enabled, btn) UpdateScanResults(ScanLogic(game, SInput.Text, true)) btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) end)
CreateButton(ExploitTab, "2️⃣ ОТСЕИВАНИЕ", function(enabled, btn) 
    if #FoundAddresses == 0 then SStatus.Text = "❌ Сначала Первый Поиск!" return end
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
    btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
end)
CreateButton(ExploitTab, "💥 3️⃣ ИЗМЕНИТЬ ЗНАЧЕНИЯ", function(enabled, btn) 
    local newVal = SNewInput.Text; 
    if not newVal or #FoundAddresses == 0 then SStatus.Text = "❌ Введите новое значение!" return end 
    local count = 0; 
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
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

-- ** Remote Exploit (Admin Brute) **
local ExploitStatus = Instance.new("TextLabel", ExploitTab); ExploitStatus.Size = UDim2.new(0.9, 0, 0, 30); ExploitStatus.BackgroundTransparency = 1; ExploitStatus.TextColor3 = TEXT_COLOR; ExploitStatus.Text = "Статус: Remote Exploit"
local ADMIN_REMOTE_NAMES = {"AdminCommand", "RunCommand", "ExecuteAdmin", "GiveAdmin", "ACommand", "KohlCmd"}
local TARGET_COMMANDS = {"giveme admin", "console", "promote " .. Player.Name .. " admin", "cmds", "kickme"}
local CMD_KEYWORDS = {"cmd", "command", "execute", "request", "giveitem", "teleport", "ability"}

local function FullRemoteScanAndBrute()
    ExploitStatus.Text = "🔍 Автоматическое сканирование и брутфорс запущены..."
    table.clear(FoundRemotes)
    local totalAttempts = 0
    
    local function recursiveScan(instance, depth)
        if depth > MAX_SCAN_DEPTH then return end
        
        local className = instance.ClassName 
        if className == "RemoteEvent" or className == "RemoteFunction" then
            local nameLower = instance.Name:lower()
            if not FoundRemotes[instance] then
                for _, adminName in ipairs(ADMIN_REMOTE_NAMES) do
                    if string.find(nameLower, string.lower(adminName)) then
                        FoundRemotes[instance] = "ADMIN"
                        break
                    end
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
            end
        elseif type == "COMMAND" then
            for _, arg in ipairs({"sword", "999", Player.Name, "teleport"}) do
                totalAttempts = totalAttempts + 1
                pcall(function() remote:FireServer(arg, Player, 999) end)
            end
        end
        wait(0.001)
    end
    
    ExploitStatus.Text = string.format("💥 Брутфорс завершен. Отправлено %d запросов.", totalAttempts)
end

CreateButton(ExploitTab, "💣 АВТОМАТИЧЕСКИЙ REMOTE-EXPLOIT", function(enabled)
    if enabled then
        spawn(FullRemoteScanAndBrute)
    else
        ExploitStatus.Text = "Remote-эксплойт остановлен (только для запуска)."
    end
end)


-- ** Dupe Hack **
local DupeStatus = Instance.new("TextLabel", ExploitTab); DupeStatus.Size = UDim2.new(0.9, 0, 0, 30); DupeStatus.BackgroundTransparency = 1; DupeStatus.TextColor3 = TEXT_COLOR; DupeStatus.Text = "Статус: Dupe Hack"
local DupeRemoteInput = Instance.new("TextBox", ExploitTab); DupeRemoteInput.Size = UDim2.new(0.9, 0, 0, 30); DupeRemoteInput.PlaceholderText = "Путь к RemoteEvent (ручной ввод)"; DupeRemoteInput.BackgroundColor3 = DARK_BG; DupeRemoteInput.TextColor3 = TEXT_COLOR; DupeRemoteInput.BorderColor3 = ACCENT_COLOR
local DUPE_KEYWORDS = {"give", "loot", "gift", "additem", "inventory", "reward", "obtain", "sellitem"}
local foundDupeRemotes = {}

local function GetLocalItemName()
    local char = Player.Character
    if char then
        local item = char:FindFirstChildOfClass("Tool")
        if item then return item.Name end
    end
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        local item = backpack:FindFirstChildOfClass("Tool")
        if item then return item.Name end
    end
    return nil
end

local function ScanForDupeRemotes()
    DupeStatus.Text = "🔍 Сканирование Remotes для дюпа..."
    table.clear(foundDupeRemotes)
    
    local function recursiveScan(instance, depth)
        if depth > MAX_SCAN_DEPTH then return end
        
        local className = instance.ClassName 
        if className == "RemoteEvent" or className == "RemoteFunction" then
            local nameLower = instance.Name:lower()
            for _, keyword in ipairs(DUPE_KEYWORDS) do
                if string.find(nameLower, keyword) then
                    table.insert(foundDupeRemotes, instance)
                    break
                end
            end
        end
        for _, child in ipairs(instance:GetChildren()) do pcall(recursiveScan, child, depth + 1) end
    end
    recursiveScan(game, 0)
    DupeStatus.Text = string.format("✅ Найдено %d потенциальных Remote-функций.", #foundDupeRemotes)
    if #foundDupeRemotes > 0 then DupeRemoteInput.Text = foundDupeRemotes[1]:GetFullName() end
end

local function DupeExploitStart(remotePath, itemName, spamCount)
    local remote = game:FindFirstChild(remotePath, true)
    if not remote or not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then 
        DupeStatus.Text = "❌ Remote НЕ НАЙДЕН или имеет неверный тип!"; 
        return 0 
    end
    DupeStatus.Text = string.format("🔥 Спам %d запросов для предмета '%s'...", spamCount, itemName)
    local successCount = 0
    for i = 1, spamCount do
        pcall(function()
            if remote:IsA("RemoteEvent") then 
                remote:FireServer(itemName, Player, 9999) 
            elseif remote:IsA("RemoteFunction") then 
                remote:InvokeServer(itemName, Player, 9999) 
            end
            successCount = successCount + 1
        end)
        wait(0.001)
    end
    return successCount
end

CreateButton(ExploitTab, "🔬 СКАНИРОВАТЬ DUPE REMOTES", function(enabled, btn) 
    if enabled then ScanForDupeRemotes() wait(0.5) end
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or DARK_BG
end)
CreateButton(ExploitTab, "💣 АВТОМАТИЧЕСКИЙ DUPE (FULL)", function(enabled, btn)
    if not enabled then DupeStatus.Text = "Дюп остановлен." return end
    spawn(function()
        DupeStatus.Text = "1/3: Сканирование Remotes..."
        ScanForDupeRemotes()
        wait(0.1)
        local remotePath = DupeRemoteInput.Text
        if #foundDupeRemotes == 0 or not remotePath then
            DupeStatus.Text = "❌ Ошибка: Не найден подходящий RemoteEvent."
            return
        end
        DupeStatus.Text = "2/3: Поиск имени предмета..."
        local itemName = GetLocalItemName()
        if not itemName then
            DupeStatus.Text = "❌ Ошибка: Не найден предмет в руках или инвентаре."
            return
        end
        DupeStatus.Text = string.format("3/3: Найдено: %s. Запуск спама...", itemName)
        local count = DupeExploitStart(remotePath, itemName, 1000)
        DupeStatus.Text = string.format("✅ АВТО-ДЮП завершен! Отправлено %d запросов для '%s'.", count, itemName)
    end)
end)


-- ******************************************************
-- ## 5. МОДУЛЬ 'UTILITY' (Cleanup, Anti-Void) ##
-- ******************************************************
local UtilityTab = CreateTab("UTILITY")

-- FULL CLEANUP
CreateButton(UtilityTab, "🔥 FULL CLEANUP / DISCONNECT", function(enabled, btn)
    btn.Text = "DISCONNECTING..."
    local count = 0
    for name, conn in pairs(ActiveConnections) do
        pcall(function() conn:Disconnect() end)
        ActiveConnections[name] = nil
        count = count + 1
    end
    
    local totalRemoved = 0
    for _, instance in ipairs(game:GetDescendants()) do
        pcall(function()
            if getconnections then 
                local connections = getconnections(instance.AncestryChanged)
                for _, conn in ipairs(connections) do
                    if conn.State == 1 then
                        conn:Disconnect()
                        totalRemoved = totalRemoved + 1
                    end
                end
            end
        end)
    end
    
    wait(0.1)
    btn.Text = string.format("✅ Очищено %d локальных/внешних подключений.", count + totalRemoved)
end)

-- ANTI-VOID PART
CreateButton(UtilityTab, "🛡️ ANTI-VOID PART", function(enabled, btn)
    local HRP = GetHRP()
    if not HRP then return end
    
    local existingPart = HRP.Parent:FindFirstChild("AntiVoidPart")
    
    if enabled then
        if existingPart then existingPart:Destroy() end
        
        local AntiVoidPart = Instance.new("Part")
        AntiVoidPart.Name = "AntiVoidPart"
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
        btn.Text = "🛡️ ANTI-VOID PART АКТИВИРОВАН"
    else
        if existingPart then existingPart:Destroy() end
        btn.Text = "🛡️ ANTI-VOID PART"
    end
end)


-- ## 6. ФИНАЛИЗАЦИЯ ##
SwitchTab("COMBAT")
print("[GBZ] OMNI-AUTO SUITE V5.9 ЗАПУЩЕН. Refactor by Annabeth 💋 активен.")
