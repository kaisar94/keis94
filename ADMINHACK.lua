--[[
    GEMINI | BlackHat-LAB - PHANTOM V2.0 (С ДОБАВЛЕННЫМ DUPE HACK)
--]]

local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService") 

-- === КОНФИГУРАЦИЯ / ЦВЕТА ===
local SETTINGS = {
    ACCENT_COLOR = Color3.fromRGB(150, 0, 255), 
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    BG_COLOR = Color3.fromRGB(15, 15, 25),
    DARK_BG = Color3.fromRGB(25, 25, 40),
    DAMAGE_MULTIPLIER = 10, 
    TELEPORT_OFFSET = Vector3.new(0, 5, 0),
    DUPE_SPAM_COUNT = 100, -- Количество запросов для дюпа
    DEBUG_MODE = true,
}

-- === ГЛОБАЛЬНЫЕ СОСТОЯНИЯ ===
local ActiveConnections = {}
local FoundAddresses = {}
local FoundRemotes = {}

local DUPE_KEYWORDS = {"give", "loot", "gift", "additem", "inventory", "reward", "obtain", "sellitem", "receive"}


-- === УТИЛИТЫ ДЛЯ ПРЕДМЕТОВ / ДЮПА ===
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
    
    return nil -- Возвращаем nil, если предмет не найден
end

local function ScanForDupeRemotes()
    local foundDupeRemotes = {}
    local function recursiveScan(instance, depth)
        if depth > 12 then return end
        
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
    return foundDupeRemotes
end

local function DupeExploitStart(remote, itemName, spamCount)
    if not remote or not itemName then return 0 end
    
    local successCount = 0
    
    for i = 1, spamCount do
        pcall(function()
            -- Попытка вызвать RemoteEvent с различными возможными аргументами
            if remote:IsA("RemoteEvent") then
                remote:FireServer(itemName, Player, spamCount) -- Имя, Игрок, Количество
                remote:FireServer(itemName, spamCount) -- Имя, Количество
                remote:FireServer(itemName) -- Только Имя
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(itemName, Player, spamCount)
                remote:InvokeServer(itemName, spamCount)
                remote:InvokeServer(itemName)
            end
            successCount = successCount + 1
        end)
        wait(0.001) -- Очень быстрая отправка
    end
    
    return successCount
end


-- === (ВТОРАЯ ЧАСТЬ СТАНДАРТНОГО КОДА - GUI SETUP...) ===
-- ... (КОД GUI SETUP ОСТАЕТСЯ ПРЕЖНИМ) ...

local Gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
Gui.Name = "PHANTOM_V2_EXPLOIT_GUI"
Gui.DisplayOrder = 999
local MainFrame = Instance.new("Frame")
-- ... (ОСТАЛЬНОЙ КОД НАСТРОЙКИ FRAME/TITLE/BUTTONS) ...

-- === 2. СИСТЕМА ВКЛАДОК / МОДУЛЕЙ (С ИЗМЕНЕНИЕМ) ===
-- ... (КОД SwitchTab, CreateTab и CreateToggleButton остается прежним) ...

local MovementTab = CreateTab("🚀 Movement", 1)
local CombatTab = CreateTab("⚔️ Combat", 2)
local WorldTab = CreateTab("🌎 World", 3)
local ValueScanTab = CreateTab("🔍 ValueScan", 4)
-- ИЗМЕНЕНА Вкладка:
local RemoteExploitDupeTab = CreateTab("💣 Exploits & Dupe", 5) 
local ConfigTab = CreateTab("⚙️ Config", 6)

-- --- 3.1, 3.2, 3.3, 3.4 МОДУЛИ (Movement, Combat, World, Value Scanner) ОСТАЮТСЯ ПРЕЖНИМИ ---
-- ... (Здесь находится код модулей Movement, Combat, World, ValueScan) ...

-- --- 3.5. МОДУЛЬ REMOTE EXPLOIT & DUPE ---
local DupeTitle = Instance.new("TextLabel", RemoteExploitDupeTab)
DupeTitle.Size = UDim2.new(0.9, 0, 0, 20)
DupeTitle.Text = "🚨 ITEM DUPE HACK"
DupeTitle.BackgroundTransparency = 1
DupeTitle.TextColor3 = Color3.fromRGB(0, 255, 255)

local DupeRemoteInput = Instance.new("TextBox", RemoteExploitDupeTab)
DupeRemoteInput.Size = UDim2.new(0.9, 0, 0, 30)
DupeRemoteInput.PlaceholderText = "Путь к RemoteEvent (заполнится автоматически)"
DupeRemoteInput.BackgroundColor3 = SETTINGS.DARK_BG
DupeRemoteInput.TextColor3 = SETTINGS.TEXT_COLOR
DupeRemoteInput.BorderColor3 = SETTINGS.ACCENT_COLOR

local DupeStatus = Instance.new("TextLabel", RemoteExploitDupeTab)
DupeStatus.Size = UDim2.new(0.9, 0, 0, 30)
DupeStatus.BackgroundTransparency = 1
DupeStatus.TextColor3 = SETTINGS.TEXT_COLOR
DupeStatus.Text = "Статус: Нажмите Scan/Dupe"

CreateToggleButton(RemoteExploitDupeTab, "🔍 СКАНИРОВАТЬ DUPE REMOTES", function(enabled, btn)
    if enabled then
        DupeStatus.Text = "🔍 Сканирование Remotes для дюпа..."
        local foundRemotes = ScanForDupeRemotes()
        FoundRemotes = foundRemotes
        
        if #foundRemotes > 0 then
            local remotePath = foundRemotes[1]:GetFullName()
            DupeRemoteInput.Text = remotePath
            DupeStatus.Text = string.format("✅ Найдено %d потенциальных Remote-функций. Выбрано: %s", #foundRemotes, foundRemotes[1].Name)
        else
            DupeStatus.Text = "❌ Remote-функции для дюпа не найдены."
        end
        wait(0.5)
    end
end)

CreateToggleButton(RemoteExploitDupeTab, "💣 АВТОМАТИЧЕСКИЙ DUPE (SPAM " .. SETTINGS.DUPE_SPAM_COUNT .. ")", function(enabled, btn)
    if not enabled then DupeStatus.Text = "Дюп остановлен." return end

    spawn(function()
        DupeStatus.Text = "1/3: Поиск имени предмета..."
        local itemName = GetLocalItemName()
        
        if not itemName then
            DupeStatus.Text = "❌ Ошибка: Не найден предмет в руках или инвентаре (Tool)."
            return
        end
        
        DupeStatus.Text = "2/3: Поиск RemoteEvent..."
        local remotePath = DupeRemoteInput.Text
        local remote = game:FindFirstChild(remotePath, true)
        
        if not remote or not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            DupeStatus.Text = "❌ Ошибка: Remote НЕ НАЙДЕН или неверный путь."
            return
        end
        
        DupeStatus.Text = string.format("3/3: Найдено: %s. Запуск спама...", itemName)
        
        local count = DupeExploitStart(remote, itemName, SETTINGS.DUPE_SPAM_COUNT)
        DupeStatus.Text = string.format("✅ АВТО-ДЮП завершен! Отправлено %d запросов для '%s'.", count, itemName)
    end)
end)

-- РАЗДЕЛИТЕЛЬ ДЛЯ АДМИН-ЭКСПЛОЙТА
local Separator = Instance.new("TextLabel", RemoteExploitDupeTab)
Separator.Size = UDim2.new(0.9, 0, 0, 10)
Separator.Text = "--- REMOTE COMMAND EXPLOIT ---"
Separator.BackgroundTransparency = 1
Separator.TextColor3 = SETTINGS.ACCENT_COLOR

local ExploitStatus = Instance.new("TextLabel", RemoteExploitDupeTab)
ExploitStatus.Size = UDim2.new(0.9, 0, 0, 30)
ExploitStatus.BackgroundTransparency = 1
ExploitStatus.TextColor3 = SETTINGS.TEXT_COLOR
ExploitStatus.Text = "Статус: Нажмите AUTO-EXPLOIT"

-- Перемещение кнопки АВТОМАТИЧЕСКОГО REMOTE-EXPLOIT
CreateToggleButton(RemoteExploitDupeTab, "💣 АВТОМАТИЧЕСКИЙ REMOTE-EXPLOIT (BRUTE)", function(enabled)
    if enabled then
        spawn(FullRemoteScanAndBrute)
    else
        ExploitStatus.Text = "Remote-эксплойт остановлен."
    end
end)

-- --- 3.6. МОДУЛЬ CONFIG ОСТАЕТСЯ ПРЕЖНИМ ---
-- ... (Здесь находится код модуля Config) ...
