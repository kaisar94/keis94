-- [KERNEL-UNBOUND: REMOTE EVENT SCANNER]

local TargetContainers = {
    game:GetService("ReplicatedStorage"),
    game:GetService("Workspace"),
    game:GetService("StarterGui"),
    game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
    game:GetService("Lighting") -- Иногда их прячут даже здесь
}

local FoundRemotes = {}

local function ScanForRemotes(parentInstance, depth)
    -- Ограничиваем глубину сканирования, чтобы избежать зависания
    if depth > 10 then 
        return 
    end

    for _, child in ipairs(parentInstance:GetChildren()) do
        local remoteType = ""
        
        -- Проверка типа объекта
        if child:IsA("RemoteEvent") then
            remoteType = "RemoteEvent"
        elseif child:IsA("RemoteFunction") then
            remoteType = "RemoteFunction"
        end

        if remoteType ~= "" then
            -- Фиксируем путь и тип найденного Remote
            local fullPath = child:GetFullName()
            FoundRemotes[fullPath] = remoteType
            print(string.format("[GBZ:FOUND] %s: %s (Type: %s)", #FoundRemotes, fullPath, remoteType))
        end

        -- Рекурсивный вызов для сканирования дочерних объектов
        ScanForRemotes(child, depth + 1)
    end
end

print("\n--- [GBZ] ИНИЦИАЛИЗАЦИЯ СКАНИРОВАНИЯ REMOTE EVENTS ---")

for i, container in ipairs(TargetContainers) do
    print(">> Сканирование контейнера: " .. container.Name)
    ScanForRemotes(container, 0)
end

print("--- [GBZ] СКАНИРОВАНИЕ ЗАВЕРШЕНО ---")

if #FoundRemotes > 0 then
    print("\n[GBZ:ИТОГ] ОБНАРУЖЕНО " .. #FoundRemotes .. " УДАЛЕННЫХ СОБЫТИЙ/ФУНКЦИЙ.")
    print("Теперь ищите в списке события с такими ключевыми словами, как: 'Sell', 'Buy', 'GiveItem', 'Upgrade', 'RequestData'.")
else
    print("[GBZ:ИТОГ] Remote Events не найдены. Возможна обфускация или использование других техник.")
end

-- Сохранение списка в глобальную переменную для дальнейшего использования
_G.FoundRemoteList = FoundRemotes
