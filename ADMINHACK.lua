-- ================================================================= --
--                             НАСТРОЙКА
-- ================================================================= --

-- 1. Сюда вставьте ВЕСЬ очищенный код модуля, полученный в предыдущем ответе.
--    (Я использую заглушки для демонстрации структуры)
local OBFUSCATED_MODULE_CODE = [==[
    -- [ВАШ ПОЛНОСТЬЮ ОЧИЩЕННЫЙ КОД МОДУЛЯ ЗДЕСЬ]
    return {
        -- Заглушки для демонстрации
        AutoHideTrees = function(T) return function() print("AutoHideTrees Running!") end end,
        FavoritePetsThreshold = function(T) return function() print("FavoritePetsThreshold Running!") end end,
        CollectFruitsBlacklist = function(T) return function() print("CollectFruitsBlacklist Running!") end end,
        AutoWaterFruits = function(T) return function() print("AutoWaterFruits Running!") end end,
        EggESP_Loop = function(T) return function() print("EggESP_Loop Running!") end end,
        FruitsESP_Loop = function(T) return function() print("FruitsESP_Loop Running!") end end,
        AutoSell = function(T) return function() print("AutoSell Running!") end end,
        -- ... и остальные функции ...
        Client_Library_Init = function(T) 
            local settings = T[0]
            local player = T[1]
            local utils = {
                StartLoop = function(name, func) task.spawn(function() while true do if settings[name] then func() end task.wait() end end) end,
                Connections = function(event, func) return {Disconnect = function() end} end
            }
            return {
                API = {Data = {Pets = {}, Fruits = {}}, Variant = {}},
                Utils = utils,
                ToolFunction = {
                    IsMaxInventory = function() return false end,
                    GetMagnitude = function() return 0 end,
                    GetTo = function() end
                },
                -- Вернуть заглушки API для работы основного скрипта
                Crops = {Collect = {FireServer = function() end}},
                Sell_Item = {FireServer = function() end},
                PetMutationMachineService_RE = {FireServer = function() end},
                PetsService = {FireServer = function() end},
                DataStream = {OnClientEvent = {Connect = function(f) return {Disconnect=function()end} end}},
                EggReadyToHatch_RE = {OnClientEvent = {Connect = function(f) return {Disconnect=function()end} end}},
                PetCooldownsUpdated = {OnClientEvent = {Connect = function(f) return {Disconnect=function()end} end}}
            }
        end
    }
] ==]

-- ВАЖНО: Настройте ссылки на объекты игры!
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- ================================================================= --
-- 2. ГЛОБАЛЬНАЯ НАСТРОЙКА (Settings)
-- ================================================================= --

local Settings = {}
local RawCode = loadstring(OBFUSCATED_MODULE_CODE)()

-- Создание заглушек для служб (RPC)
local RemoteServices = {
    Crops = {Collect = {FireServer = function() end}},
    Sell_Item = {FireServer = function() end},
    PetMutationMachineService_RE = {FireServer = function() end},
    PetsService = {FireServer = function() end},
    DataStream = {OnClientEvent = {Connect = function() end}},
    EggReadyToHatch_RE = {OnClientEvent = {Connect = function() end}},
    PetCooldownsUpdated = {OnClientEvent = {Connect = function() end}},
}

-- Попытка получить реальные ссылки на RemoteFunctions/Events
for name, service in pairs(RemoteServices) do
    if RawCode.API and RawCode.API[name] then -- Проверка, если модуль API настроен
        RemoteServices[name] = RawCode.API[name]
    end
end

-- ================================================================= --
-- 3. ИНИЦИАЛИЗАЦИЯ И ЗАПУСК МОДУЛЯ
-- ================================================================= --

local Client_API = RawCode.Z({
    LocalPlayer, 
    RemoteServices, 
    Settings, 
    HttpService,
    -- ... прочие необходимые зависимости из T
})

local MainFunctions = {
    -- Функции Авто-Фарма
    ["Auto Collect Blacklist"] = Client_API.CollectFruitsBlacklist({Settings, Client_API, nil, Client_API.ToolFunction, Client_API.Crops}),
    ["Auto Collect Whitelist"] = Client_API.CollectFruitsWhitelist({Settings, Client_API.ToolFunction, nil, Client_API, Client_API.Crops}),
    ["Auto Collect Mut. Whitelist"] = Client_API.CollectFruitsWhitelistMutation({Settings, Client_API.ToolFunction, nil, Client_API, Client_API.Crops}),
    ["Auto Sell"] = Client_API.AutoSell({Client_API.SellFunction, Client_API.ToolFunction, Settings}),
    ["Auto Feed Pets"] = Client_API.AutoFeedPets({Client_API.ActivePetService, Client_API.PetAPI, Settings, LocalPlayer, Client_API}),
    ["Auto Water Fruits"] = Client_API.AutoWaterFruits({Settings, LocalPlayer, Client_API.Water_RE, Client_API}),
    
    -- Функции ESP
    ["Fruits ESP"] = Client_API.FruitsESP_Loop({Settings, Client_API.PetAPI, Client_API.ESP, Client_API.Collection, Client_API.Calculator, Client_API.Utils}),
    ["Pets ESP"] = Client_API.PetsESP_Loop({Settings, Client_API.ESP, Client_API.PetAPI, LocalPlayer}),
    ["Egg ESP"] = Client_API.EggESP_Loop({Settings, Client_API.ESP, LocalPlayer, Client_API.Calculator, Client_API.CustomDelay}),
    
    -- ... другие функции, такие как BuyEggs, Gifting, CrateOpening и т.д.
}

-- ================================================================= --
-- 4. ПОСТРОЕНИЕ ИНТЕРФЕЙСА (БАЗОВЫЙ ПРИМЕР)
-- ================================================================= --

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHubX_GUI"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "✨ SpeedHub X (Deobfuscated)"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Title.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800) -- Настройте по необходимости
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollingFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Layout.Parent = ScrollingFrame

local function CreateToggle(name, default_value, parent)
    -- Инициализация настройки
    Settings[name] = default_value 
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -10, 0, 25)
    ToggleButton.Position = UDim2.new(0, 5, 0, 0)
    ToggleButton.Text = name .. ": [OFF]"
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    ToggleButton.Parent = parent

    local function update_button_state()
        if Settings[name] then
            ToggleButton.Text = name .. ": [ON]"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        else
            ToggleButton.Text = name .. ": [OFF]"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        end
    end
    
    update_button_state()
    
    ToggleButton.MouseButton1Click:Connect(function()
        Settings[name] = not Settings[name]
        update_button_state()
    end)

    return ToggleButton
end

-- ================================================================= --
-- 5. ЗАПУСК ФУНКЦИЙ ИНТЕРФЕЙСА
-- ================================================================= --

local function RunAllLoops()
    for name, func_factory in pairs(MainFunctions) do
        -- Получаем функцию цикла, которую нужно запустить
        local loop_func = func_factory
        
        -- Используем вспомогательную функцию для запуска в цикле (на основе Utils.StartLoop)
        Client_API.Utils.StartLoop(name, loop_func)
    end
end

-- Создание кнопок-переключателей
for name, func_factory in pairs(MainFunctions) do
    CreateToggle(name, false, ScrollingFrame)
end

-- Запуск всех циклов
RunAllLoops()

print("Script Loaded and Initialized. GUI is ready to use. ")
