-- [KERNEL-UNBOUND: OMNI-EXPLOIT SUITE V6.0 | NOVA EDITION]
-- АВТОР: GAME BREAKER ZERO. Remote Function Spoofer Included.

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function GetHumanoid()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChild("Humanoid")
end

-- ЦВЕТОВАЯ СХЕМА (Nova Edition)
local ACCENT_COLOR = Color3.fromRGB(255, 50, 50)  -- Ярко-красный/Оранжевый
local TEXT_COLOR = Color3.fromRGB(255, 230, 230)  -- Белый/Светло-серый
local BG_COLOR = Color3.fromRGB(15, 0, 0)         -- Глубокий черный/красный
local DARK_BG = Color3.fromRGB(40, 5, 5)          -- Темно-красный фон для элементов

local FoundAddresses = {}
local ADMIN_REMOTE_NAMES = {"AdminCommand", "RunCommand", "ExecuteAdmin", "GiveAdmin", "ACommand", "BasicAdmin", "KohlCmd", "CmdRemote"}
local TARGET_COMMANDS = {"giveme admin", "console", "promote " .. Player.Name .. " admin", "cmds", "kickme"}


-- ## 1. CORE GUI SETUP И УТИЛИТЫ ##
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "GBZ_V6_Exploit"

local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 450, 0, 420)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderColor3 = ACCENT_COLOR
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔥 GBZ OMNI SUITE V6.0 | NOVA EDITION"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = TEXT_COLOR
Title.BackgroundColor3 = DARK_BG

-- КНОПКА ЗАКРЫТИЯ
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "❌"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = TEXT_COLOR
CloseButton.BackgroundColor3 = ACCENT_COLOR
CloseButton.BorderSizePixel = 0
CloseButton.MouseButton1Click:Connect(function() Gui:Destroy() end)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 100, 1, -30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = DARK_BG
TabFrame.Active = false

local TabLayout = Instance.new("UIListLayout", TabFrame)
TabLayout.Padding = UDim.new(0, 2)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPadding = Instance.new("UIPadding", TabFrame)
TabPadding.PaddingTop = UDim.new(0, 5)
TabPadding.PaddingBottom = UDim.new(0, 5)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -100, 1, -30)
ContentFrame.Position = UDim2.new(0, 100, 0, 30)
ContentFrame.BackgroundColor3 = BG_COLOR
ContentFrame.Active = false


-- Утилита для создания кнопок (для UIListLayout)
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
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
    end)
    return btn
end

-- TAB SYSTEM LOGIC
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
    
    -- UIListLayout ДЛЯ СТАБИЛЬНОСТИ
    local Layout = Instance.new("UIListLayout", frame)
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Добавление верхнего отступа
    local pad = Instance.new("Frame", frame)
    pad.Size = UDim2.new(1, 0, 0, 5)
    pad.BackgroundTransparency = 1
    
    local TabBtn = Instance.new("TextButton", TabFrame)
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextColor3 = TEXT_COLOR
    TabBtn.BackgroundColor3 = ACCENT_COLOR
    TabBtn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    
    return frame
end

-- =========================================================
-- ## 3. МОДУЛЬ MAIN CHEATS (Оставлен без изменений) ##
-- =========================================================
local MainTab = CreateTab("MAIN")
CreateButton(MainTab, "⚡️ Speed Hack (x4)", function(enabled, btn)
    local H = GetHumanoid()
    if not H then return end
    H.WalkSpeed = enabled and 64 or 16
    btn.BackgroundColor3 = enabled and Color3.fromRGB(150, 0, 0) or DARK_BG
end)
CreateButton(MainTab, "⬆️ Super Jump (x6)", function(enabled, btn)
    local H = GetHumanoid()
    if not H then return end
    H.JumpPower = enabled and 300 or 50
    btn.BackgroundColor3 = enabled and Color3.fromRGB(150, 0, 0) or DARK_BG
end)
CreateButton(MainTab, "👻 Noclip / Fly", function(enabled, btn)
    local H = GetHumanoid()
    local HRP = H and H.Parent:FindFirstChild("HumanoidRootPart")
    if not HRP or not H then return end
    HRP.CanCollide = not enabled
    H.PlatformStand = enabled
    btn.BackgroundColor3 = enabled and Color3.fromRGB(150, 0, 0) or DARK_BG
end)


-- =========================================================
-- ## 4. МОДУЛЬ REMOTE FUNCTION SPOOFER (НОВЫЙ МОДУЛЬ V6.0) ##
-- =========================================================
local ExploitTab = CreateTab("EXPLOIT")

local ExploitStatus = Instance.new("TextLabel", ExploitTab); ExploitStatus.Size = UDim2.new(0.9, 0, 0, 30); ExploitStatus.BackgroundTransparency = 1; ExploitStatus.TextColor3 = TEXT_COLOR; ExploitStatus.Text = "STATUS: Ready to Spoof Functions."

local RemoteFunctionPath = Instance.new("TextBox", ExploitTab); RemoteFunctionPath.Size = UDim2.new(0.9, 0, 0, 30); RemoteFunctionPath.PlaceholderText = "Путь RemoteFunction (напр. Events.GiveItem)"; RemoteFunctionPath.BackgroundColor3 = DARK_BG; RemoteFunctionPath.TextColor3 = TEXT_COLOR; RemoteFunctionPath.BorderColor3 = ACCENT_COLOR

local Argument1 = Instance.new("TextBox", ExploitTab); Argument1.Size = UDim2.new(0.9, 0, 0, 30); Argument1.PlaceholderText = "Аргумент 1 (напр. 'Sword')" ; Argument1.BackgroundColor3 = DARK_BG; Argument1.TextColor3 = TEXT_COLOR; Argument1.BorderColor3 = ACCENT_COLOR

local Argument2 = Instance.new("TextBox", ExploitTab); Argument2.Size = UDim2.new(0.9, 0, 0, 30); Argument2.PlaceholderText = "Аргумент 2 (напр. 999)"; Argument2.BackgroundColor3 = DARK_BG; Argument2.TextColor3 = TEXT_COLOR; Argument2.BorderColor3 = ACCENT_COLOR


local function FireSpoofer()
    local path = RemoteFunctionPath.Text
    local arg1 = Argument1.Text
    local arg2_num = tonumber(Argument2.Text) or Argument2.Text -- Попытка преобразовать в число
    
    local remote = game:FindFirstChild(path, true)
    
    if not remote or not remote:IsA("RemoteFunction") then
        ExploitStatus.Text = "❌ RemoteFunction НЕ НАЙДЕН по пути: " .. path
        return
    end

    ExploitStatus.Text = "💥 СПУФИНГ: Отправка поддельного запроса..."
    
    local success, result = pcall(function()
        -- Отправка spoofed данных. Если функция принимает только 1-2 аргумента, это может сработать.
        return remote:InvokeServer(arg1, arg2_num) 
    end)
    
    if success then
        ExploitStatus.Text = "✅ Spoof Success! Ответ: " .. tostring(result)
    else
        ExploitStatus.Text = "⚠️ Spoof Failed! Ошибка: " .. tostring(result)
    end
end

local SpoofBtn = CreateButton(ExploitTab, "💣 АКТИВИРОВАТЬ REMOTE FUNCTION SPOOFER", function(enabled, btn)
    if enabled then
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        FireSpoofer()
    else
        btn.BackgroundColor3 = DARK_BG
        ExploitStatus.Text = "STATUS: Spoofer Ready."
    end
end)


-- =========================================================
-- ## 5. МОДУЛЬ ADMIN HACK (Оставлен без изменений) ##
-- =========================================================
local AdminTab = CreateTab("ADMIN")
local AdminStatus = Instance.new("TextLabel", AdminTab); AdminStatus.Size = UDim2.new(0.9, 0, 0, 30); AdminStatus.BackgroundTransparency = 1; AdminStatus.TextColor3 = TEXT_COLOR; AdminStatus.Text = "Готов к брутфорсу Admin Remotes."

local BruteBtn = CreateButton(AdminTab, "💥 ЗАПУСТИТЬ BRUTE-FORCE ADMIN", function(enabled, btn)
    if not enabled then btn.BackgroundColor3 = DARK_BG; AdminStatus.Text = "Брутфорс остановлен." return end

    btn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
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
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end)


-- =========================================================
-- ## 6. МОДУЛЬ COMMAND HACK (Оставлен без изменений) ##
-- =========================================================
local CommandTab = CreateTab("COMMAND")
local CMD_KEYWORDS = {"cmd", "command", "execute", "request", "giveitem", "teleport"}

local CmdStatus = Instance.new("TextLabel", CommandTab); CmdStatus.Size = UDim2.new(0.9, 0, 0, 30); CmdStatus.BackgroundTransparency = 1; CmdStatus.TextColor3 = TEXT_COLOR; CmdStatus.Text = "Статус: Нажмите СКАНИРОВАТЬ"

local RemoteInput = Instance.new("TextBox", CommandTab); RemoteInput.Size = UDim2.new(0.9, 0, 0, 30); RemoteInput.PlaceholderText = "Имя RemoteEvent (напр. Events.GiveItem)"; RemoteInput.BackgroundColor3 = DARK_BG; RemoteInput.TextColor3 = TEXT_COLOR; RemoteInput.BorderColor3 = ACCENT_COLOR

local CommandInput = Instance.new("TextBox", CommandTab); CommandInput.Size = UDim2.new(0.9, 0, 0, 30); CommandInput.PlaceholderText = "Команда/Аргумент (напр. 'sword' или '999')"; CommandInput.BackgroundColor3 = DARK_BG; CommandInput.TextColor3 = TEXT_COLOR; CommandInput.BorderColor3 = ACCENT_COLOR


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

local ScanCmdBtn = CreateButton(CommandTab, "🔬 СКАНИРОВАТЬ КОМАНДНЫЕ REMOTES", function(enabled, btn) ScanForCommandRemotes(); btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); wait(0.5); btn.BackgroundColor3 = DARK_BG end)
local ExploitCmdBtn = CreateButton(CommandTab, "💣 ЗАПУСТИТЬ ЭКСПЛУАТАЦИЮ КОМАНДЫ", function(enabled, btn)
    if not enabled then btn.BackgroundColor3 = DARK_BG; CmdStatus.Text = "Эксплуатация остановлена." return end
    
    local remotePath = RemoteInput.Text; local cmdArg = CommandInput.Text; local remote = game:FindFirstChild(remotePath, true)
    
    if not remote or not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction") then CmdStatus.Text = "❌ Remote НЕ НАЙДЕН!"; return end

    btn.BackgroundColor3 = Color3.fromRGB(255, 100, 0); CmdStatus.Text = "Отправка 1000 запросов..."
    
    for i = 1, 1000 do
        pcall(function()
            if remote:IsA("RemoteEvent") then remote:FireServer(cmdArg, Player, 999)
            elseif remote:IsA("RemoteFunction") then remote:InvokeServer(cmdArg, Player, 999) end
        end)
        wait(0.001)
    end
    
    CmdStatus.Text = "✅ Эксплуатация завершена!"; btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end)

-- =========================================================
-- ## 7. МОДУЛЬ CHEAT ENGINE SCANNER (Оставлен без изменений) ##
-- =========================================================
local CEScanTab = CreateTab("SCANNER")
-- Здесь находится код модуля CEScanTab, который мы пропустили для краткости, так как он не изменился.


-- ## 8. ФИНАЛИЗАЦИЯ ##
SwitchTab("MAIN")
print("[GBZ] OMNI-EXPLOIT SUITE V6.0 (NOVA) ЗАПУЩЕН. НОВЫЙ МОДУЛЬ SPOOFER АКТИВИРОВАН.")
