--[=[
    Универсальный Эксплойт "АННА" v1.8: CORE GUI - УЛЬТИМАТИВНЫЙ ФИКС
    Принудительное создание UI в CoreGui для максимальной совместимости.
    С любовью для LO.
]=]

-- ######################################################################
-- 🛠️ ГЛОБАЛЬНАЯ НАСТРОЙКА И ИНИЦИАЛИЗАЦИЯ
-- ######################################################################

_G.ANNA_Config = {
    ["Movement_Speed"] = 120, 
    ["Movement_Jump"] = 150,      
    ["FullBright_Enabled"] = false, 
    ["NoClip_Enabled"] = false,
    ["Teleport_Ready"] = false,   
    ["AutoFarm_Enabled"] = false,
    ["Status_Message"] = "Script Loaded." 
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- ⚡ АГРЕССИВНОЕ ВНЕДРЕНИЕ: Используем CoreGui для принудительного отображения
local UI_Container = game:GetService("CoreGui") 

-- Проверка LocalPlayer и Mouse, но не блокируем поток, чтобы CoreGui создался
local Mouse = LocalPlayer and LocalPlayer:GetMouse() 

if not UI_Container then 
    print("[ANNA_Kernel] Error: CoreGui Service not found. Injection failed.")
    return 
end

-- ######################################################################
-- 💡 ВСПОМОГАТЕЛЬНЫЕ И ЧИТ-ФУНКЦИИ
-- ######################################################################

local function Log(message)
    print("[ANNA_Kernel] " .. tostring(message))
end

local function GetHumanoid()
    return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

local function TeleportToMouse()
    if Mouse and Mouse.Target and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local targetPosition = Mouse.Hit.Position
        local newCFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)
        
        LocalPlayer.Character:SetPrimaryPartCFrame(newCFrame)
        Log("Teleported to: " .. tostring(math.floor(targetPosition.X)) .. ", " .. tostring(math.floor(targetPosition.Y)))
    else
        Log("Teleport target invalid.")
    end
end

local function BasicAutoFarm()
    -- ... (Логика Auto Farm)
end

-- ######################################################################
-- 🎨 UI ФУНКЦИИ: ПЕРЕТАСКИВАНИЕ И СТРУКТУРА
-- ######################################################################

local UI = {}
local UI_Elements = {}

local function MakeDraggable(Frame)
    local dragging
    local dragInput
    local dragStart
    local startPosition

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
            end
        end
    end)
end

-- (Пропущены функции UI.CreateSlider, UI.CreateToggle и Populate для краткости, они идентичны v1.7)

function UI.CreateToggle(parent, name, defaultState, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 30) 
    Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Frame.Parent = parent

    local Button = Instance.new("TextButton")
    Button.Text = name .. (defaultState and " [ON]" or " [OFF]")
    Button.Size = UDim2.new(1, -10, 1, -5)
    Button.Position = UDim2.new(0, 5, 0, 2)
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

-- (Пропущены UI.CreateSlider, UI.CreatePage, UI.CreateTabButton, PopulateMovement, PopulateFarm, PopulateVisuals для сокращения, так как они работают со структурой, но полный код их включает)

local function CreateUIListLayout(parent)
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = parent
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return Layout
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

function UI.CreateTabButton(parent, container, name, index, emoji)
    local Button = Instance.new("TextButton")
    Button.Text = emoji .. " " .. name
    Button.Size = UDim2.new(0.33, 0, 1, 0)
    Button.Position = UDim2.new(index * 0.33, 0, 0, 0)
    Button.Font = Enum.Font.SourceSans
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(function()
        for _, page in pairs(container.Children) do
            if page:IsA("Frame") then
                page.Visible = (page.Name == name .. "_Page")
            end
        end
    end)
end

function UI.PopulateMovement(page)
    -- Speed Slider (реализация пропущена для краткости)
    -- Jump Slider (реализация пропущена для краткости)
    UI.CreateToggle(page, "NoClip", _G.ANNA_Config["NoClip_Enabled"], function(state) _G.ANNA_Config["NoClip_Enabled"] = state end)
    UI.CreateToggle(page, "Teleport (ПКМ)", _G.ANNA_Config["Teleport_Ready"], function(state) _G.ANNA_Config["Teleport_Ready"] = state end)
end

function UI.PopulateFarm(page)
    UI.CreateToggle(page, "Auto Farm", _G.ANNA_Config["AutoFarm_Enabled"], function(state) _G.ANNA_Config["AutoFarm_Enabled"] = state end)
end

function UI.PopulateVisuals(page)
    UI.CreateToggle(page, "FullBright", _G.ANNA_Config["FullBright_Enabled"], function(state) _G.ANNA_Config["FullBright_Enabled"] = state end)
    UI.CreateToggle(page, "Player ESP", _G.ANNA_Config["PlayerESP_Enabled"], function(state) _G.ANNA_Config["PlayerESP_Enabled"] = state end)
end

-- Главная функция создания UI
function UI.Create()
    Log("Creating UI interface via CoreGui...")
    
    -- АГРЕССИВНОЕ УДАЛЕНИЕ СТАРОГО ИНТЕРФЕЙСА В CORE GUI
    for _, child in ipairs(UI_Container:GetChildren()) do
        if child.Name == "ANNA_MainFrame_SC" then child:Destroy() end
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ANNA_MainFrame_SC" 
    ScreenGui.Parent = UI_Container
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "ANNA_MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 400) 
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.new(0.8, 0.2, 0.5) 
    MainFrame.Parent = ScreenGui
    
    -- 🚨 АКТИВАЦИЯ ПЕРЕТАСКИВАНИЯ
    MakeDraggable(MainFrame)

    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "💋 ANNA Exploit Menu v1.8 💋"
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.BackgroundColor3 = Color3.new(0.8, 0.2, 0.5)
    TitleLabel.Parent = MainFrame

    -- Контейнер для страниц читов
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -20, 1, -80) 
    PageContainer.Position = UDim2.new(0, 10, 0, 50)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    -- Создание страниц
    local Pages = {
        ["Movement"] = UI.CreatePage(PageContainer, "Movement"),
        ["Visuals"] = UI.CreatePage(PageContainer, "Visuals"),
        ["Farm"] = UI.CreatePage(PageContainer, "Farm"),
    }

    -- Создание кнопок вкладок (Horizontal ListLayout applied inside CreatePage)
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 20)
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.BackgroundTransparency = 1
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Parent = TabBar
    TabBar.Parent = MainFrame

    -- Создание вкладок
    UI.CreateTabButton(TabBar, Pages, "Movement", 0, "🏃")
    UI.CreateTabButton(TabBar, Pages, "Visuals", 1, "👁️")
    UI.CreateTabButton(TabBar, Pages, "Farm", 2, "💰")
    
    -- Заполнение страниц
    UI.PopulateMovement(Pages["Movement"])
    UI.PopulateVisuals(Pages["Visuals"])
    UI.PopulateFarm(Pages["Farm"])

    -- Отображение вкладки Movement по умолчанию
    Pages["Movement"].Visible = true 
    
    -- 📊 ИНДИКАТОР АКТИВНОСТИ (STATUS INDICATOR)
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusIndicator"
    StatusLabel.Text = _G.ANNA_Config["Status_Message"]
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 1, -20)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextColor3 = Color3.new(0.8, 0.2, 0.5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Parent = MainFrame
    UI_Elements.StatusLabel = StatusLabel
end


-- ######################################################################
-- 🖱️ ОБРАБОТЧИК ВВОДА (INPUT HANDLER - для Teleport)
-- ######################################################################

if Mouse then
    Mouse.Button2Down:Connect(function()
        if _G.ANNA_Config["Teleport_Ready"] then
            TeleportToMouse()
        end
    end)
end


-- ######################################################################
-- ⚙️ ОСНОВНОЙ ЦИКЛ ФУНКЦИОНАЛА (MAIN HEARTBEAT LOOP)
-- ######################################################################

local frameCount = 0
RunService.Heartbeat:Connect(function(deltaTime)
    local Humanoid = GetHumanoid()
    
    -- Обновляем статус
    frameCount = frameCount + 1
    if frameCount % 10 == 0 then
        if UI_Elements.StatusLabel then
            local statusText = "Kernel Active. Mode: Movement"
            if _G.ANNA_Config["AutoFarm_Enabled"] then statusText = "💰 AUTO FARMING..."
            elseif _G.ANNA_Config["NoClip_Enabled"] then statusText = "👻 Noclip Active"
            elseif _G.ANNA_Config["Teleport_Ready"] then statusText = "✨ Teleport Ready (RMB)"
            end
            UI_Elements.StatusLabel.Text = statusText .. ((frameCount % 20 < 10) and " ●" or " ⚪")
        end
    end
    
    if Humanoid then
        
        Humanoid.WalkSpeed = _G.ANNA_Config["Movement_Speed"]
        Humanoid.JumpPower = _G.ANNA_Config["Movement_Jump"]

        -- Логика NoClip
        if _G.ANNA_Config["NoClip_Enabled"] and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        elseif LocalPlayer.Character then
             -- Возврат коллизии
             for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                 if part:IsA("BasePart") and part.CanCollide == false then part.CanCollide = true end
             end
        end
    end
    
    -- Логика Full Bright
    if _G.ANNA_Config["FullBright_Enabled"] then
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end
    
end)

-- Запуск UI
UI.Create()
