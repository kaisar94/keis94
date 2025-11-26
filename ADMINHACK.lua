-- [KERNEL-UNBOUND: ADMIN PANEL EXPLOIT & BRUTE-FORCE]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local TargetPlayerName = Player.Name -- Изначально нацеливаемся на себя, чтобы получить права

-- Список общих имен RemoteEvents, используемых для админ-команд
local ADMIN_REMOTE_NAMES = {
    "AdminCommand",
    "RunCommand",
    "ExecuteAdmin",
    "GiveAdmin",
    "ACommand",
    "AdminEvent",
    "KohlCmd", -- Часто используется в модулях
    "BasicAdmin",
    "CmdRemote"
}

-- Список команд, которые мы хотим запустить
local TARGET_COMMANDS = {
    "giveme admin",
    "console",
    "get player " .. Player.Name .. " admin",
    "promote " .. Player.Name,
    "give " .. Player.Name .. " admin",
    "kickme", -- для проверки работы команды (если пройдет, мы ее нашли)
    "cmds"
}

-- ## Функция Брутфорса ##
local function BruteForceAdminRemotes()
    local attempts = 0
    local foundSuccess = false
    
    print("==============================================")
    print("[GBZ ADMIN EXPLOIT] НАЧАЛО БРУТФОРСА АДМИН-КОМАНД")
    
    for _, remoteName in ipairs(ADMIN_REMOTE_NAMES) do
        local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
        
        if not remote then
            -- Поиск в Workspace тоже, на всякий случай
            remote = game.Workspace:FindFirstChild(remoteName, true)
        end
        
        if remote and remote:IsA("RemoteEvent") then
            print(string.format(">> [FOUND] Потенциальный Admin Remote: %s", remote:GetFullName()))
            
            for _, cmd in ipairs(TARGET_COMMANDS) do
                attempts = attempts + 1
                
                -- Попытка запустить команду, имитируя, что мы - админ
                pcall(function()
                    remote:FireServer(cmd)
                end)
                
                if attempts % 50 == 0 then
                    wait(0.01) -- Небольшая задержка, чтобы избежать мгновенного FloodCheck
                end
            end
            
            foundSuccess = true
            print(string.format(">> [ATTEMPTED] Отправлено %d команд через %s.", #TARGET_COMMANDS, remoteName))
        end
    end
    
    print("==============================================")
    print(string.format("[GBZ ADMIN EXPLOIT] БРУТФОРС ЗАВЕРШЕН. Отправлено всего %d команд.", attempts))
    if foundSuccess then
        print(">> Проверьте, появились ли у вас новые команды или консоль.")
    else
        print(">> Стандартные Admin Remotes не найдены. Требуется DEX DUMP для точного имени.")
    end
end

-- ## 2. Вызов ##
-- BruteForceAdminRemotes() -- Для немедленного запуска

-- ## 3. Интеграция с GUI (Кнопка) ##

local function CreateAdminExploitGUI()
    local Gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 0, 0) -- Красный для опасных действий
    Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Frame.Active = true
    Frame.Draggable = true
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "🚨 ADMIN PANEL EXPLOIT"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    
    local ExploitBtn = Instance.new("TextButton", Frame)
    ExploitBtn.Size = UDim2.new(0.9, 0, 0, 50)
    ExploitBtn.Position = UDim2.new(0.05, 0, 0, 50)
    ExploitBtn.Text = "💥 ЗАПУСТИТЬ BRUTE-FORCE ADMIN"
    ExploitBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ExploitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local Status = Instance.new("TextLabel", Frame)
    Status.Size = UDim2.new(0.9, 0, 0, 30)
    Status.Position = UDim2.new(0.05, 0, 0, 110)
    Status.Text = "Статус: Готов к атаке."
    Status.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)

    ExploitBtn.MouseButton1Click:Connect(function()
        ExploitBtn.Text = "ЗАПУЩЕНО... (Проверьте консоль)"
        ExploitBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        Status.Text = "Атака активна. Ожидайте результатов..."
        
        BruteForceAdminRemotes()
        
        ExploitBtn.Text = "✅ АТАКА ЗАВЕРШЕНА"
        ExploitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        Status.Text = "Поиск завершен. Если права не получены, используйте DEX DUMP."
    end)
end

-- Запуск GUI
CreateAdminExploitGUI()
print("[GBZ] Admin Exploit GUI Активирован.")
