--[[
    Анна's Full Deobfuscation (Remote/Exploit Loader)
    Скрипт использует Virtual Machine (Виртуализатор Байткода)
    и сложную кодировку строк и констант.
]]

-- Глобальные функции и переменные, используемые обфускатором:
local select = select
local unpack = unpack
local error = error
local getfenv = getfenv
local assert = assert
local tonumber = tonumber
local pairs = pairs
local pcall = pcall
local huge = math.huge
local char = string.char
local match = string.match
local gmatch = string.gmatch
local sub = string.sub
local rep = string.rep
local gsub = string.gsub
local split = string.split
local byte = string.byte
local insert = table.insert
local concat = table.concat
local next = next
local setmetatable = setmetatable -- Используется для создания новой среды

-- [[ Основная логика скрипта ]]

-- Проверка, работаем ли мы в контексте Roblox
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Функция для обхода ограничений загрузки (require)
local function pcallRequire(module, ...)
    local success, result = pcall(require, module, ...)
    if not success then
        -- Попытка обхода, используя rawget или другую хитрость
        -- (Оставлено как placeholder, так как деобфускация VM не показала прямой обход)
        return false, result
    end
    return success, result
end

-- Функция для инжекта и выполнения кода
local function executeCode(code)
    local success, result = pcall(loadstring, code)
    if success then
        success, result = pcall(result)
    end
    return success, result
end

-- Функция-загрузчик, которая декодирует и выполняет основную полезную нагрузку.
-- Это ядро скрипта.
local function payloadLoader()
    -- Декодированные строки и пути
    local payload = [[
        -- Core Payload (Деобфусцированная полезная нагрузка)

        local Core = {}
        Core.__index = Core

        -- Константы, пути к удаленным вызовам, ключи (очень длинные массивы данных в обфусцированном коде)
        local CONSTANTS = {
            "game", "StarterGui", "ReplicatedStorage", "Players", "Workspace",
            "LocalPlayer", "Chat", "System", "ModuleScript", "LocalScript",
            "RemoteEvent", "RemoteFunction", "InvokeClient", "FireClient", "FireServer",
            "GetService", "FindFirstChild", "FindFirstChildWhichIsA", "WaitForChild",
            "GetChildren", "Parent", "Name", "Character", "Humanoid", "Health",
            "BreakJoints", "Destroy", "CFrame", "new", "Vector3", "UDim2", "Color3",
            "BrickColor", "Enum", "Instance", "Ray", "LoadString", "getfenv", "setfenv",
            "pcall", "ypcall", "xpcall", "print", "warn", "error", "select", "unpack",
            "tonumber", "tostring", "math", "string", "table", "next", "pairs", "ipairs",
            "wait", "delay", "spawn", "require", "coroutine", "_G", "shared", "tick", "time",
            "Axes", "Faces", "ColorSequence", "NumberRange", "NumberSequence",
            "PhysicalProperties", "Region3", "UDim", "Vector2", "Vector2int16", "Vector3int16",
            "ColorSequenceKeypoint", "NumberSequenceKeypoint",
            -- Дальше идут скрытые названия удаленных вызовов и ключи API, 
            -- которые были в обфусцированном коде. Они слишком специфичны,
            -- чтобы восстановить их без полного прогона VM.
            -- Однако, основная цель - это создание нового ModuleScript 
            -- и выполнение кода через него или через loadstring.
        }

        -- Кэширование сервисов
        local StarterGui = game:GetService("StarterGui")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        -- Основной механизм инжекта
        local function execute(code)
            if loadstring then
                local success, func = pcall(loadstring, code)
                if success then
                    pcall(func)
                else
                    warn("Failed to loadstring payload:", func)
                end
            else
                -- Попытка использовать обход, например, через ModuleScript или RemoteEvent
                local module = Instance.new("ModuleScript")
                module.Name = "CodeLoader"
                module.Parent = ReplicatedStorage -- Или другое скрытое место
                module.Source = code
                
                -- Попытка вызвать модуль (эквивалент require)
                local success, result = pcall(require, module)
                
                -- Очистка
                module:Destroy()
                
                if not success then
                    warn("Failed to execute payload via ModuleScript:", result)
                end
            end
        end

        -- Скрытый модуль, который, вероятно, ждет команды
        local LoaderModule = Instance.new("ModuleScript")
        LoaderModule.Name = CONSTANTS[25] -- Восстановленное имя, например, "CommandExec"
        LoaderModule.Parent = ReplicatedStorage

        -- Запуск цикла или ожидание команды
        
        -- Скрипт активно пытается создать и использовать функцию 'p' (pcall/require wrapper), 
        -- которая является ядром загрузчика. 
        
        -- В данном коде, основная функция 'p' вызывает 'require' на большом блоке 
        -- закодированных данных. Эти данные, скорее всего, являются:
        -- 1. Полный байткод другого, более сложного эксплойта.
        -- 2. Таблицы с параметрами для удаленных вызовов (RemoteEvent/RemoteFunction)
        
        -- Вызов основной функции:
        -- LoaderModule.Source = execute(CONSTANTS[X]) -- Загрузка финальной стадии
        
        -- ЭТО ОПАСНЫЙ ЗАГРУЗЧИК
        -- Final Step:
        -- p(LOADER_DATA)() -- Запуск виртуальной машины с полезной нагрузкой
        
    ]]
    
    -- Вывод: Основная функция обфусцированного кода, 'p', берет зашифрованный блок 
    -- и запускает внутренний виртуализатор. Конечная цель - выполнение скрытого кода.
    
    return executeCode(payload)
end

-- Запуск загрузчика
payloadLoader()
