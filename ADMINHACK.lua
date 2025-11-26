-- [KERNEL-UNBOUND: OMNI-EXPLOIT SUITE V7.0 | DEX INTEGRATION]
-- АВТОР: GAME BREAKER ZERO. DEX Explorer Module Integrated.

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function GetHumanoid()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChild("Humanoid")
end

-- ЦВЕТОВАЯ СХЕМА (Cyberpunk V7.0)
local ACCENT_COLOR = Color3.fromRGB(0, 150, 255)  -- Голубой
local TEXT_COLOR = Color3.fromRGB(200, 255, 255)  -- Светло-голубой
local BG_COLOR = Color3.fromRGB(18, 18, 25)       -- Почти черный/темно-синий
local DARK_BG = Color3.fromRGB(30, 30, 45)        -- Темный фон для элементов

local FoundAddresses = {}
local ADMIN_REMOTE_NAMES = {"AdminCommand", "RunCommand", "ExecuteAdmin", "GiveAdmin", "ACommand", "BasicAdmin", "KohlCmd", "CmdRemote"}
local TARGET_COMMANDS = {"giveme admin", "console", "promote " .. Player.Name .. " admin", "cmds", "kickme"}


-- ## 1. CORE GUI SETUP И УТИЛИТЫ ##
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "GBZ_V7_Exploit"

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
Title.Text = "🔵 GBZ OMNI SUITE V7.0 | DEX INTEGRATED"
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
TabFrame.ClipsDescendants = true -- Для стабильности

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
ContentFrame.ClipsDescendants = true


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
    TabBtn.Size = UDim2.new(1, -10, 0, 30) -- Фиксированный размер для стабильности
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextColor3 = TEXT_COLOR
    TabBtn.BackgroundColor3 = ACCENT_COLOR
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
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or DARK_BG
end)
-- Super Jump
CreateButton(MainTab, "⬆️ Super Jump (x6)", function(enabled, btn)
    local H = GetHumanoid()
    if not H then return end
    H.JumpPower = enabled and 300 or 50
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or DARK_BG
end)
-- Noclip Toggle
CreateButton(MainTab, "👻 Noclip / Fly", function(enabled, btn)
    local H = GetHumanoid()
    local HRP = H and H.Parent:FindFirstChild("HumanoidRootPart")
    if not HRP or not H then return end
    HRP.CanCollide = not enabled
    H.PlatformStand = enabled
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or DARK_BG
end)


-- ## 7. МОДУЛЬ DEX EXPLORER (Эмуляция) - НОВАЯ ВКЛАДКА ##
local DEXTab = CreateTab("DEX")

local DEXStatus = Instance.new("TextLabel", DEXTab)
DEXStatus.Size = UDim2.new(0.9, 0, 0, 30)
DEXStatus.BackgroundTransparency = 1
DEXStatus.TextColor3 = TEXT_COLOR
DEXStatus.Text = "Статус: Готов к сканированию игры."

local RootInput = Instance.new("TextBox", DEXTab)
RootInput.Size = UDim2.new(0.9, 0, 0, 30)
RootInput.PlaceholderText = "Путь к объекту (напр. game.Workspace.Part)"
RootInput.BackgroundColor3 = DARK_BG
RootInput.TextColor3 = TEXT_COLOR
RootInput.BorderColor3 = ACCENT_COLOR

-- *************************************************************
-- ИСПРАВЛЕНИЕ UI: Горизонтальный фрейм для PropInput и ValueInput
-- *************************************************************
local PropValueFrame = Instance.new("Frame", DEXTab)
PropValueFrame.Size = UDim2.new(0.9, 0, 0, 30)
PropValueFrame.BackgroundTransparency = 1
PropValueFrame.Active = false

local Grid = Instance.new("UIGridLayout", PropValueFrame)
Grid.CellSize = UDim2.new(0.5, -4, 1, 0) -- Делит пространство пополам
Grid.FillDirection = Enum.FillDirection.Horizontal
Grid.Padding = UDim.new(0, 8)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center


local PropInput = Instance.new("TextBox", PropValueFrame)
PropInput.Size = UDim2.new(1, 0, 1, 0) -- Занимает ячейку
PropInput.PlaceholderText = "Свойство (напр. Transparency)"
PropInput.BackgroundColor3 = DARK_BG
PropInput.TextColor3 = TEXT_COLOR
PropInput.BorderColor3 = ACCENT_COLOR

local ValueInput = Instance.new("TextBox", PropValueFrame)
ValueInput.Size = UDim2.new(1, 0, 1, 0) -- Занимает ячейку
ValueInput.PlaceholderText = "Значение (напр. 1)"
ValueInput.BackgroundColor3 = DARK_BG
ValueInput.TextColor3 = TEXT_COLOR
ValueInput.BorderColor3 = ACCENT_COLOR
-- *************************************************************
-- КОНЕЦ ИСПРАВЛЕНИЯ UI
-- *************************************************************


-- Функции DEX
local function FindAndPrintChildren(instancePath)
    local target = game:FindFirstChild(instancePath, true)
    if not target then DEXStatus.Text = "❌ Объект не найден!"; return end
    
    local childrenList = {}
    for _, child in ipairs(target:GetChildren()) do
        table.insert(childrenList, string.format("[%s] %s", child.ClassName, child.Name))
    end
    
    DEXStatus.Text = string.format("✅ Найдено %d дочерних объектов.", #childrenList)
    -- В реальном DEX тут будет прокручиваемый список, здесь выводим в консоль
    print("--- ДОЧЕРНИЕ ОБЪЕКТЫ ---")
    for _, item in ipairs(childrenList) do print(item) end
end

local function ModifyProperty(instancePath, propertyName, propertyValue)
    local target = game:FindFirstChild(instancePath, true)
    if not target then DEXStatus.Text = "❌ Объект не найден!"; return end
    
    -- Попытка конвертировать значение в bool/number, если это возможно
    local success, convertedValue = pcall(function() return tonumber(propertyValue) or (propertyValue:lower() == "true" and true) or (propertyValue:lower() == "false" and false) or propertyValue end)
    
    local successSet, err = pcall(function() target[propertyName] = convertedValue end)
    
    if successSet then
        DEXStatus.Text = string.format("✅ Свойство '%s' изменено на '%s'.", propertyName, tostring(convertedValue))
    else
        DEXStatus.Text = string.format("❌ Ошибка при изменении свойства: %s", err)
    end
end

-- Кнопки DEX
local ScanBtn = CreateButton(DEXTab, "🔍 СКАНИРОВАТЬ ДОЧЕРНИЕ ОБЪЕКТЫ", function(enabled, btn)
    if not enabled then btn.BackgroundColor3 = DARK_BG; return end
    FindAndPrintChildren(RootInput.Text)
    btn.BackgroundColor3 = ACCENT_COLOR
end)

local ModifyBtnDEX = CreateButton(DEXTab, "🔨 ИЗМЕНИТЬ СВОЙСТВО ОБЪЕКТА", function(enabled, btn)
    if not enabled then btn.BackgroundColor3 = DARK_BG; return end
    ModifyProperty(RootInput.Text, PropInput.Text, ValueInput.Text)
    btn.BackgroundColor3 = ACCENT_COLOR
end)

-- (Здесь должны быть остальные модули SCANNER, ADMIN, COMMAND, если они нужны)

-- ## 8. ФИНАЛИЗАЦИЯ ##
SwitchTab("DEX")
print("[GBZ] OMNI-EXPLOIT SUITE V7.0 АКТИВИРОВАН. DEX EXPLORER ГОТОВ К РАБОТЕ.")
