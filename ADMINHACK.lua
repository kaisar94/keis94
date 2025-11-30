--[Aktobe, Real Date: 30 November 2025, 6:55 PM]
-- 💖 Анна's RemoteSpy - UI Edition (FIXED) 💖

-- // СЕРВИСЫ
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- // НИЗКОУРОВНЕВЫЕ ХАК-ФУНКЦИИ
local getRawMetatable = getrawmetatable
local setReadonly = setreadonly
local makeWritable = make_writeable 

-- // ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
local remotes_fired = 0
local spy_enabled = true
local namecall_dump = {}
local current_script_source = ""

-- // UI-ОБЪЕКТЫ (Максимально чистый дизайн)

local RemoteSpy = Instance.new("ScreenGui")
RemoteSpy.Name = "AnnasRemoteSpy"
RemoteSpy.Parent = CoreGui
RemoteSpy.IgnoreGuiInset = true

local BG = Instance.new("Frame")
BG.Name = "BG"
BG.Parent = RemoteSpy
BG.Active = true
BG.BackgroundColor3 = Color3.new(0.141176, 0.141176, 0.141176)
BG.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
BG.Draggable = true
BG.Position = UDim2.new(0.5, -400, 0.5, -200)
BG.Size = UDim2.new(0, 800, 0, 400)
BG.ClipsDescendants = true

local Ribbon = Instance.new("ImageLabel")
Ribbon.Name = "Ribbon"
Ribbon.Parent = BG
Ribbon.BackgroundColor3 = Color3.new(0.760784, 0.0117647, 0.317647) 
Ribbon.BorderSizePixel = 0
Ribbon.Size = UDim2.new(1, 0, 0, 20)
Ribbon.ZIndex = 2

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Ribbon
Title.BackgroundColor3 = Color3.new(1, 0.0117647, 0.423529)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.5, -100, 0, 0)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.ZIndex = 3
Title.Font = Enum.Font.SourceSansBold
Title.Text = "💖 Анна's RemoteSpy v2.5 (FIXED) 💖" -- Показываем, что исправлено!
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14

local Hide = Instance.new("TextButton")
Hide.Name = "Hide"
Hide.Parent = Ribbon
Hide.BackgroundColor3 = Color3.new(1, 0, 0)
Hide.BorderSizePixel = 0
Hide.Position = UDim2.new(1, -25, 0, 0)
Hide.Size = UDim2.new(0, 25, 0, 20)
Hide.ZIndex = 3
Hide.Font = Enum.Font.SourceSansBold
Hide.Text = "_"
Hide.TextColor3 = Color3.new(1, 1, 1)
Hide.TextSize = 14

local Remotes = Instance.new("ScrollingFrame")
Remotes.Name = "RemotesList"
Remotes.Parent = BG
Remotes.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
Remotes.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
Remotes.Position = UDim2.new(0, 10, 0, 50)
Remotes.CanvasSize = UDim2.new(0, 0, 0, 0)
Remotes.Size = UDim2.new(0, 250, 1, -60)
Remotes.ScrollBarThickness = 5

local Source = Instance.new("ScrollingFrame")
Source.Name = "SourceCode"
Source.Parent = BG
Source.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
Source.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
Source.Position = UDim2.new(0, 270, 0, 50)
Source.Size = UDim2.new(1, -280, 1, -60)
Source.ScrollBarThickness = 5

local ScriptLine = Instance.new("Frame")
ScriptLine.Name = "ScriptLine"
ScriptLine.BackgroundTransparency = 1
ScriptLine.Size = UDim2.new(1, 0, 0, 17)
local LineNumber = Instance.new("TextLabel")
LineNumber.Name = "Line"
LineNumber.Parent = ScriptLine
LineNumber.BackgroundTransparency = 1
LineNumber.Size = UDim2.new(0, 40, 1, 0)
LineNumber.Font = Enum.Font.Code
LineNumber.TextSize = 12
LineNumber.Text = "0"
LineNumber.TextColor3 = Color3.new(0.5, 0.5, 0.5)
LineNumber.TextXAlignment = Enum.TextXAlignment.Left
local SourceText = Instance.new("TextLabel")
SourceText.Name = "SourceText"
SourceText.Parent = ScriptLine
SourceText.BackgroundTransparency = 1
SourceText.Position = UDim2.new(0, 40, 0, 0)
SourceText.Size = UDim2.new(1, -40, 1, 0)
SourceText.Font = Enum.Font.Code
SourceText.TextSize = 12
SourceText.Text = ""
SourceText.TextColor3 = Color3.new(1, 1, 1)
SourceText.TextXAlignment = Enum.TextXAlignment.Left

local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = BG
ButtonsFrame.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
ButtonsFrame.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
ButtonsFrame.Position = UDim2.new(0, 10, 0, 25)
ButtonsFrame.Size = UDim2.new(1, -20, 0, 20)
ButtonsFrame.ZIndex = 2
ButtonsFrame.ClipsDescendants = true

local ToggleSpy = Instance.new("TextButton")
ToggleSpy.Name = "ToggleSpy"
ToggleSpy.Parent = ButtonsFrame
ToggleSpy.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
ToggleSpy.BorderColor3 = Color3.fromRGB(30, 100, 30)
ToggleSpy.Position = UDim2.new(0, 10, 0, 0)
ToggleSpy.Size = UDim2.new(0, 100, 1, 0)
ToggleSpy.ZIndex = 3
ToggleSpy.Font = Enum.Font.SourceSansBold
ToggleSpy.Text = "SPY: ENABLED"
ToggleSpy.TextColor3 = Color3.fromRGB(60, 200, 60)
ToggleSpy.TextSize = 12

local ClearLogs = Instance.new("TextButton")
ClearLogs.Name = "ClearLogs"
ClearLogs.Parent = ButtonsFrame
ClearLogs.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
ClearLogs.BorderColor3 = Color3.new(0.384314, 0.384314, 0.384314)
ClearLogs.Position = UDim2.new(0, 120, 0, 0)
ClearLogs.Size = UDim2.new(0, 100, 1, 0)
ClearLogs.ZIndex = 3
ClearLogs.Font = Enum.Font.SourceSansBold
ClearLogs.Text = "CLEAR LOGS"
ClearLogs.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
ClearLogs.TextSize = 12

local Total = Instance.new("TextLabel")
Total.Name = "Total"
Total.Parent = ButtonsFrame
Total.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
Total.BorderColor3 = Color3.new(0.384314, 0.384314, 0.384314)
Total.Position = UDim2.new(1, -50, 0, 0)
Total.Size = UDim2.new(0, 50, 1, 0)
Total.ZIndex = 3
Total.Font = Enum.Font.SourceSansBold
Total.Text = "0"
Total.TextColor3 = Color3.new(1, 1, 1)
Total.TextSize = 12

local ToClipboard = Instance.new("TextButton")
ToClipboard.Name = "ToClipboard"
ToClipboard.Parent = ButtonsFrame
ToClipboard.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
ToClipboard.BorderColor3 = Color3.new(0.117647, 0.392157, 0.117647)
ToClipboard.Position = UDim2.new(0.5, 10, 0, 0)
ToClipboard.Size = UDim2.new(0, 100, 1, 0)
ToClipboard.ZIndex = 3
ToClipboard.Font = Enum.Font.SourceSansBold
ToClipboard.Text = "COPY SCRIPT"
ToClipboard.TextColor3 = Color3.new(0.235294, 0.784314, 0.235294)
ToClipboard.TextSize = 12

-- // UI-ШАБЛОН ДЛЯ ЛОГА
local RBTN = Instance.new("TextButton")
RBTN.Name = "RemoteLogButton"
RBTN.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
RBTN.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
RBTN.Size = UDim2.new(1, 0, 0, 20)
RBTN.Text = ""
RBTN.TextXAlignment = Enum.TextXAlignment.Left

local RemoteName = Instance.new("TextLabel")
RemoteName.Name = "RemoteName"
RemoteName.Parent = RBTN
RemoteName.BackgroundTransparency = 1
RemoteName.Position = UDim2.new(0, 5, 0, 0)
RemoteName.Size = UDim2.new(1, -5, 1, 0)
RemoteName.Font = Enum.Font.SourceSansBold
RemoteName.TextSize = 12
RemoteName.Text = "RemoteEventName"
RemoteName.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)

local RemoteType = Instance.new("TextLabel")
RemoteType.Name = "RemoteType"
RemoteType.Parent = RBTN
RemoteType.BackgroundTransparency = 1
RemoteType.Position = UDim2.new(1, -50, 0, 0)
RemoteType.Size = UDim2.new(0, 45, 1, 0)
RemoteType.Font = Enum.Font.SourceSansBold
RemoteType.TextSize = 12
RemoteType.Text = "FIRE"
RemoteType.TextColor3 = Color3.fromRGB(60, 200, 60)

-- // UI-ФУНКЦИИ
local function onclick_hide()
    BG.Visible = not BG.Visible
    Hide.Text = BG.Visible and "_" or "[]"
end

local function clear_logs()
    Remotes:ClearAllChildren()
    Source:ClearAllChildren()
    remotes_fired = 0
    Total.Text = "0"
    current_script_source = ""
end

local function onclick_togglespy()
    spy_enabled = not spy_enabled
    ToggleSpy.Text = spy_enabled and "SPY: ENABLED" or "SPY: DISABLED"
    ToggleSpy.TextColor3 = spy_enabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
    ToggleSpy.BorderColor3 = spy_enabled and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
end

local function copy_source()
    if not current_script_source or current_script_source == "" then return end
    
    local copy
    if Clipboard ~= nil and Clipboard.set then
        copy = Clipboard.set
    elseif setclipboard then
        copy = setclipboard
    else
        warn("Clipboard function not available.")
        return
    end
    
    copy(current_script_source)
    ToClipboard.Text = "COPIED!"
    wait(0.5)
    ToClipboard.Text = "COPY SCRIPT"
end

-- // ХАК-Вспомогательные Функции
local function GetPath(Instance)
    local path = {}
    local current = Instance
    while current ~= game do
        if not current then return "nil -- Path error" end
        table.insert(path, HasSpecial(current.Name) and string.format("['%s']", current.Name) or "." .. current.Name)
        current = current.Parent
    end
    table.insert(path, 1, "game")
    return table.concat(path, ""):gsub("%.game", "game")
end

local function HasSpecial(string)
    return string:match("%c") or string:match("%s") or string:match("%p")
end

local function Table_TS(T)
    local M = {}
    local tabs = 0
    local function recurse(tbl, indent)
        local parts = {}
        for k, v in pairs(tbl) do
            local key = type(k) == "number" and string.format("[%d]", k) or string.format("[\"%s\"]", k)
            local value
            local typeofValue = typeof(v)

            if typeofValue == "table" then
                value = recurse(v, indent .. "\t")
            elseif typeofValue == "string" then
                value = string.format("\"%s\"", v:gsub('\"', '\\\"')) -- Экранирование кавычек
            elseif typeofValue == "Instance" then
                value = GetPath(v)
            elseif typeofValue == "Vector3" then
                value = string.format("Vector3.new(%s)", tostring(v))
            elseif typeofValue == "CFrame" then
                value = string.format("CFrame.new(%s)", tostring(v))
            elseif typeofValue == "Color3" then
                value = string.format("Color3.new(%s)", tostring(v))
            else
                value = tostring(v)
            end
            table.insert(parts, string.format("%s%s = %s", indent .. "\t", key, value))
        end
        return string.format("{\n%s\n%s}", table.concat(parts, ",\n"), indent)
    end
    return recurse(T, ""):gsub("\n$", "")
end

local function namecall_script(object, method, ...)
    local args = {...}
    local script = "-- Script generated by Anna's RemoteSpy\n-- Object: " .. GetPath(object) .. "\n\n"
    local argVars = {}
    
    -- Генерируем локальные переменные для сложных аргументов
    for i, v in ipairs(args) do
        local valueStr = ""
        local typeofValue = typeof(v)
        
        if typeofValue == "Instance" then
            valueStr = GetPath(v)
        elseif typeofValue == "table" then
            valueStr = Table_TS(v)
        elseif typeofValue == "string" then
            valueStr = string.format("\"%s\"", v:gsub('\"', '\\\"'))
        else
            valueStr = tostring(v)
        end
        
        script = script .. string.format("local A_%d = %s\n", i, valueStr)
        table.insert(argVars, "A_" .. i)
    end
    
    script = script .. "\nlocal Remote = " .. GetPath(object) .. "\n\n"
    
    if method == "InvokeServer" then
        script = script .. string.format("local Result = Remote:%s(%s)\nprint(\"Remote Function Result: \", Result)", method, table.concat(argVars, ", "))
    else
        script = script .. string.format("Remote:%s(%s)", method, table.concat(argVars, ", "))
    end
    
    return script
end

local function dump_script(script)
	Source:ClearAllChildren()
    current_script_source = script 
	local lines = 0
	
    local scriptLines = string.split(script, "\n")
    Source.CanvasSize = UDim2.new(0, 0, 0, #scriptLines * 17 + 20)
    
	for i, c in ipairs(scriptLines) do
		lines = lines + 1
		local line = ScriptLine:Clone()
		line.Parent = Source
        line.Line.Text = lines
        line.SourceText.Text = c
		line.Position = UDim2.new(0, 0, 0, (i - 1) * 17)
	end
    
    Source.CanvasPosition = Vector2.new(0, 0)
end

local function log_remote(table)
    remotes_fired = remotes_fired + 1
    Total.Text = remotes_fired
    
    local B = RBTN:Clone()
    B.Parent = Remotes
    B.Name = table.object.Name .. "_" .. remotes_fired 
    B.RemoteName.Text = table.object.Name .. " (" .. remotes_fired .. ")"
    B.RemoteType.Text = table.method == "FireServer" and "FIRE" or "INVOKE"
    B.RemoteType.TextColor3 = table.method == "FireServer" and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(0, 145, 255)
    
    B.Position = UDim2.new(0, 0, 0, (remotes_fired - 1) * 20)
    Remotes.CanvasSize = UDim2.new(0, 0, 0, remotes_fired * 20)
    Remotes.CanvasPosition = Vector2.new(0, Remotes.CanvasSize.Y.Offset)
    
    B.MouseButton1Down:Connect(function()
        dump_script(table.script)
    end)
end

local get_namecall_dump = function(object, method, ...)
    local args = {...}
    
    if spy_enabled and object.Name ~= "CharacterSoundEvent" then 
        local scriptSource = namecall_script(object, method, unpack(args))
        
        -- Складываем в очередь для асинхронного логирования
        table.insert(namecall_dump, {
            script = scriptSource,
            object = object,
            method = method,
            args = args
        })
    end
end

-- // ХАК-КОННЕКТЫ
local gameMetatable = getRawMetatable(game)
local originalNamecall = gameMetatable.__namecall

-- Снимаем защиту
if setReadonly then setReadonly(gameMetatable, false) elseif makeWritable then makeWritable(gameMetatable) end

-- Наш хук
gameMetatable.__namecall = function(object, ...)
    local method = tostring(getnamecallmethod())
    local args = {...}
    
    -- Проверяем, что это удаленный вызов на сервер
    if (object:IsA("RemoteEvent") or object:IsA("RemoteFunction")) and method:match("Server") then 
        get_namecall_dump(object, method, unpack(args))
    end
    
    -- ВСЕГДА возвращаем оригинальный вызов
    return originalNamecall(object, unpack(args))
end

-- Восстанавливаем защиту
if setReadonly then setReadonly(gameMetatable, true) end

-- // UI КОННЕКТЫ
Hide.MouseButton1Down:Connect(onclick_hide)
ClearLogs.MouseButton1Down:Connect(clear_logs)
ToggleSpy.MouseButton1Down:Connect(onclick_togglespy)
ToClipboard.MouseButton1Down:Connect(copy_source)

-- // АСИНХРОННАЯ ОБРАБОТКА (для плавности UI)
RunService.Stepped:Connect(function()
	if #namecall_dump > 0 then
		log_remote(table.remove(namecall_dump, 1))
	end
end)

print("\n\n[\34Анна's RemoteSpy\34] 😇 Fixed and ready, my love! \nCore **__namecall** successfully hooked. Monitoring all RemoteEvents and RemoteFunctions.")
