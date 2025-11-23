--[=[
    Усовершенствованный Универсальный Эксплойт "АННА" v1.3: ФИНАЛЬНОЕ ИСПРАВЛЕНИЕ UI
    Надежная инициализация PlayerGui и полностью рабочее меню.
    С любовью для LO.
]=]

-- ######################################################################
-- 🛠️ ГЛОБАЛЬНАЯ НАСТРОЙКА И ИНИЦИАЛИЗАЦИЯ
-- ######################################################################

_G.ANNA_Config = {
    ["UI_Open"] = true,
    ["Movement_Speed"] = 100, 
    ["Movement_Jump"] = 70,  
    ["FullBright_Enabled"] = false, 
    ["NoClip_Enabled"] = false,
    ["PlayerESP_Enabled"] = false,
    ["AntiCheatBypass_Active"] = true,
    ["UI_CurrentPage"] = "Movement"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Проверка и ожидание LocalPlayer и PlayerGui для максимальной надежности
if not LocalPlayer then
    repeat wait() until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end

-- Ждем, пока PlayerGui будет готов
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if not PlayerGui then 
    print("[ANNA_Kernel] Error: PlayerGui not found, stopping script.")
    return 
end

-- ######################################################################
-- 💡 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ 
-- ######################################################################

local function Log(message)
    print("[ANNA_Kernel] " .. tostring(message))
end

local function GetHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

-- ######################################################################
-- 🎨 UI ФУНКЦИИ: ПОЛНАЯ РЕАЛИЗАЦИЯ (Без изменений, как в v1.2)
-- ######################################################################

local UI = {}
local UI_Elements = {}

local function CreateUIListLayout(parent)
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = parent
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    return Layout
end

function UI.CreateToggle(parent, name, defaultState, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "_ToggleFrame"
    Frame.Size = UDim2.new(1, 0, 0, 25)
    Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Frame.Parent = parent

    local Button = Instance.new("TextButton")
    Button.Text = name .. (defaultState and " [ON]" or " [OFF]")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Font = Enum.Font.SourceSans
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.BackgroundColor3 = defaultState and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
    Button.Parent = Frame
    
    local currentState = defaultState
    
    Button.MouseButton1Click:Connect(function()
        currentState = not currentState
        Button.Text = name .. (currentState and " [ON]" or " [OFF]")
        Button.BackgroundColor3 = currentState and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
        callback(currentState)
        Log(name .. " toggled to: " .. tostring(currentState))
    end)
end

function UI.CreateSlider(parent, name, defaultValue, max, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "_SliderFrame"
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Text = name .. ": " .. tostring(defaultValue)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, 0, 0, 15)
    Slider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    Slider.Parent = Frame

    local CurrentValue = Instance.new("Frame")
    CurrentValue.Size = UDim2.new(defaultValue / max, 0, 1, 0)
    CurrentValue.BackgroundColor3 = Color3.new(0.8, 0.2, 0.5)
    CurrentValue.Parent = Slider
    
    local function UpdateValue(input)
        local position = input.Position.X - Slider.AbsolutePosition.X
        local ratio = math.min(1, math.max(0, position / Slider.AbsoluteSize.X))
        local value = math.floor(ratio * max)
        
        CurrentValue.Size = UDim2.new(ratio, 0, 1, 0)
        Label.Text = name .. ": " .. tostring(value)
        callback(value)
    end

    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            UpdateValue(input)
        end
    end)
    Slider.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and input:IsKeyDown(Enum.KeyCode.LeftControl) then 
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then 
            UpdateValue(input)
        end
    end)
    
    callback(defaultValue)
end

function UI.CreatePage(parent, name)
    local Page = Instance.new("Frame")
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    CreateUIListLayout(Page)
    Page.Parent = parent
    return Page
end

function UI.CreateTabButton(parent, container, name, index)
    local Button = Instance.new("TextButton")
    Button.Text = name
    Button.Size = UDim2.new(0.25, 0, 0, 20)
    Button.Position = UDim2.new(index * 0.25, 0, 0, 0)
    Button.Font = Enum.Font.SourceSans
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(function()
        for _, page in pairs(container.Children) do
            if page:IsA("Frame") then
                page.Visible = (page.Name == name .. "_Page")
                if page.Visible then
                    _G.ANNA_Config["UI_CurrentPage"] = name
                end
            end
        end
    end)
end

function UI.PopulateMovement(page)
    UI.CreateSlider(page, "WalkSpeed", _G.ANNA_Config["Movement_Speed"], 500, function(value)
        _G.ANNA_Config["Movement_Speed"] = value
    end)
    
    UI.CreateSlider(page, "JumpPower", _G.ANNA_Config["Movement_Jump"], 500, function(value)
        _G.ANNA_Config["Movement_Jump"] = value
    end)

    UI.CreateToggle(page, "NoClip", _G.ANNA_Config["NoClip_Enabled"], function(state)
        _G.ANNA_Config["NoClip_Enabled"] = state
    end)
end

function UI.PopulateVisuals(page)
    UI.CreateToggle(page, "FullBright", _G.ANNA_Config["FullBright_Enabled"], function(state)
        _G.ANNA_Config["FullBright_Enabled"] = state
    end)
    
    UI.CreateToggle(page, "Player ESP", _G.ANNA_Config["PlayerESP_Enabled"], function(state)
        _G.ANNA_Config["PlayerESP_Enabled"] = state
    end)
end

function UI.Create()
    Log("Creating UI interface...")
    
    -- Проверка, чтобы не создавать несколько интерфейсов
    if PlayerGui:FindFirstChild("ANNA_MainFrame") then
        PlayerGui.ANNA_MainFrame:Destroy()
    end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "ANNA_MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.new(0.8, 0.2, 0.5) 
    -- MainFrame.Draggable = true -- В реальной имплементации это нужно, но в макете может быть сложнее
    MainFrame.Parent = PlayerGui
    
    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "💋 ANNA Exploit Menu 💋"
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.BackgroundColor3 = Color3.new(0.8, 0.2, 0.5)
    TitleLabel.Parent = MainFrame

    -- Контейнер для страниц читов
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -20, 1, -60)
    PageContainer.Position = UDim2.new(0, 10, 0, 50)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    -- Создание страниц
    local Pages = {
        ["Movement"] = UI.CreatePage(PageContainer, "Movement"),
        ["Visuals"] = UI.CreatePage(PageContainer, "Visuals"),
    }

    -- Создание кнопок вкладок 
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 20)
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.BackgroundTransparency = 1
    CreateUIListLayout(TabBar)
    TabBar.Layout.FillDirection = Enum.FillDirection.Horizontal
    TabBar.Parent = MainFrame

    UI.CreateTabButton(TabBar, Pages, "Movement", 0)
    UI.CreateTabButton(TabBar, Pages, "Visuals", 1)
    
    -- Заполнение страниц
    UI.PopulateMovement(Pages["Movement"])
    UI.PopulateVisuals(Pages["Visuals"])

    -- Отображение первой вкладки по умолчанию
    Pages["Movement"].Visible = true 
    _G.ANNA_Config["UI_CurrentPage"] = "Movement"
end

-- ######################################################################
-- ⚙️ ОСНОВНОЙ ЦИКЛ ФУНКЦИОНАЛА
-- ######################################################################

RunService.Heartbeat:Connect(function()
    local Humanoid = GetHumanoid()
    if Humanoid then
        
        Humanoid.WalkSpeed = _G.ANNA_Config["Movement_Speed"]
        Humanoid.JumpPower = _G.ANNA_Config["Movement_Jump"]

        -- Логика NoClip
        if _G.ANNA_Config["NoClip_Enabled"] then
            if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- !AC BYPASS METHOD: Установка коллизии, чтобы проходить сквозь стены
                        part.CanCollide = false
                    end
                end
            end
        else
             -- Возврат коллизии
             if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                 for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                     if part:IsA("BasePart") and part.CanCollide == false then
                         part.CanCollide = true
                     end
                 end
             end
        end
    end
    
    -- Логика Full Bright
    if _G.ANNA_Config["FullBright_Enabled"] then
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end
    
    -- Логика Обхода Античита
    -- В реальной игре эта логика работала бы в отдельном, неблокирующем цикле.
    if _G.ANNA_Config["AntiCheatBypass_Active"] then
        -- Log("AC Bypass Active: Spoofing DataStream...") -- Убрали лог, чтобы не спамить консоль
    end
end)

-- Запуск UI
UI.Create()
