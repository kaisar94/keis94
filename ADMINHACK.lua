-- [KERNEL-UNBOUND: OMNI-EXPLOIT SUITE V6.1 | STABILITY PATCH]
-- АВТОР: GAME BREAKER ZERO. Исправлена нестабильность UIListLayout и мерцание.

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function GetHumanoid()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChild("Humanoid")
end

-- ЦВЕТОВАЯ СХЕМА (Nova Edition)
local ACCENT_COLOR = Color3.fromRGB(255, 50, 50)
local TEXT_COLOR = Color3.fromRGB(255, 230, 230)
local BG_COLOR = Color3.fromRGB(15, 0, 0)
local DARK_BG = Color3.fromRGB(40, 5, 5)

-- ... (Прочие глобальные переменные)

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

-- ... (Title и CloseButton - без изменений)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔥 GBZ OMNI SUITE V6.1 | STABILITY PATCH"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = TEXT_COLOR
Title.BackgroundColor3 = DARK_BG

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
TabFrame.ClipsDescendants = true -- ИСПРАВЛЕНИЕ 1: Обрезка элементов вне границ

local TabLayout = Instance.new("UIListLayout", TabFrame)
TabLayout.Padding = UDim.new(0, 2)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPadding = Instance.new("UIPadding", TabFrame)
TabPadding.PaddingTop = UDim.new(0, 5)
TabPadding.PaddingBottom = UDim.new(0, 5)
TabPadding.PaddingLeft = UDim.new(0, 5)
TabPadding.PaddingRight = UDim.new(0, 5) -- Добавим отступы по бокам


local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -100, 1, -30)
ContentFrame.Position = UDim2.new(0, 100, 0, 30)
ContentFrame.BackgroundColor3 = BG_COLOR
ContentFrame.Active = false
ContentFrame.ClipsDescendants = true -- Обрезка контента для стабильности


-- ... (CreateButton и SwitchTab - без изменений)

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
    TabBtn.Size = UDim2.new(1, -10, 0, 30) -- ИСПРАВЛЕНИЕ 2: Установка ширины UDim2(1, -10, ...) обеспечивает, что кнопка занимает 100% ширины TabFrame минус 5 пикселей Padding слева и 5 справа.
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextColor3 = TEXT_COLOR
    TabBtn.BackgroundColor3 = ACCENT_COLOR
    TabBtn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    
    return frame
end

-- ... (МОДУЛИ MAIN, EXPLOIT, ADMIN, COMMAND, SCANNER - вставляются без изменений)
-- Для краткости, мы здесь показываем только измененные секции GUI.
-- ...

-- ## 8. ФИНАЛИЗАЦИЯ ##
SwitchTab("MAIN")
print("[GBZ] OMNI-EXPLOIT SUITE V6.1 (STABILITY) АКТИВИРОВАН. ПРОБЛЕМА С МЕРЦАНИЕМ УСТРАНЕНА.")
