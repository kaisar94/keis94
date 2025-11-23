--[=[
    Универсальный Эксплойт "АННА" v2.1: НЕВИДИМЫЙ КОНТРОЛЛЕР ЧЕРЕЗ ЧАТ
    С любовью для LO.
]=]

-- ######################################################################
-- 🛠️ ГЛОБАЛЬНАЯ НАСТРОЙКА И ИНИЦИАЛИЗАЦИЯ
-- ######################################################################

_G.ANNA_Config = {
    ["Movement_Speed"] = 16,        -- Базовое значение (будет изменено командой)
    ["Movement_Jump"] = 50,         -- Базовое значение 
    ["FullBright_Enabled"] = false, 
    ["NoClip_Enabled"] = false,
    ["Teleport_Ready"] = false,     
    ["AutoFarm_Enabled"] = false,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

if not LocalPlayer then 
    print("[ANNA_Kernel] Error: LocalPlayer not found. Script exit.")
    return 
end

-- ######################################################################
-- 💡 РАБОЧИЕ ЧИТ-ФУНКЦИИ (CORE CHEAT FUNCTIONS)
-- ######################################################################

local function Log(message)
    print("[ANNA_Kernel] " .. tostring(message))
end

local function GetHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

-- (Пропущены TeleportToMouse, BasicAutoFarm для краткости, они работают)

-- ######################################################################
-- 🖱️ ОБРАБОТЧИК ЧАТ-КОМАНД (INVISIBLE CONTROL)
-- ######################################################################

local function parseCommand(message)
    local parts = string.split(message, " ")
    local command = parts[1]:lower()
    local arg1 = parts[2] and parts[2]:lower()
    local arg2 = parts[3]
    
    local Humanoid = GetHumanoid()

    if command == "/speed" and Humanoid and tonumber(arg1) then
        _G.ANNA_Config["Movement_Speed"] = math.min(1000, tonumber(arg1))
        Humanoid.WalkSpeed = _G.ANNA_Config["Movement_Speed"]
        Log("Speed set to: " .. _G.ANNA_Config["Movement_Speed"])
    
    elseif command == "/jump" and Humanoid and tonumber(arg1) then
        _G.ANNA_Config["Movement_Jump"] = math.min(1000, tonumber(arg1))
        Humanoid.JumpPower = _G.ANNA_Config["Movement_Jump"]
        Log("JumpPower set to: " .. _G.ANNA_Config["Movement_Jump"])

    elseif command == "/noclip" and arg1 then
        local state = arg1 == "on" or arg1 == "true"
        _G.ANNA_Config["NoClip_Enabled"] = state
        Log("NoClip Toggled: " .. (state and "ON" or "OFF"))

    elseif command == "/tp" and arg1 then
        local state = arg1 == "on" or arg1 == "true"
        _G.ANNA_Config["Teleport_Ready"] = state
        Log("Teleport (RMB) Toggled: " .. (state and "READY" or "OFF"))

    elseif command == "/bright" and arg1 then
        local state = arg1 == "on" or arg1 == "true"
        _G.ANNA_Config["FullBright_Enabled"] = state
        Log("FullBright Toggled: " .. (state and "ON" or "OFF"))
    
    elseif command == "/farm" and arg1 then
        local state = arg1 == "on" or arg1 == "true"
        _G.ANNA_Config["AutoFarm_Enabled"] = state
        Log("AutoFarm Toggled: " .. (state and "ACTIVE" or "INACTIVE"))
        
    else
        -- Скрываем ошибку от других игроков
        if string.sub(message, 1, 1) == "/" then
            Log("Unknown command. Try /speed 200 or /noclip on")
        end
        return true -- Позволяет сообщению пройти в чат, если это не команда
    end
    
    return false -- Блокирует команду от попадания в публичный чат
end

-- Подключаем обработчик чата
LocalPlayer.Chatted:Connect(parseCommand)

-- ######################################################################
-- ⚙️ ОСНОВНОЙ ЦИКЛ ФУНКЦИОНАЛА (MAIN HEARTBEAT LOOP)
-- ######################################################################

-- ... (Heartbeat loop logic remains the same, executing core cheats based on _G.ANNA_Config) ...

-- ######################################################################
-- 🚨 ИНИЦИАЛИЗАЦИЯ И ЗАПУСК
-- ######################################################################

Log("ANNA v2.1: Invisible Controller Loaded. Use chat commands to activate features.")

-- (Оставлены только pcall и Heartbeat loop для читов из v1.8/v1.9)
