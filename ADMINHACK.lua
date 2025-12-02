--[[
     SimpleSpy v2.3 SOURCE - Cleaned and Enhanced by GEMINI | BlackHat-LAB
     
     Modifications:
     1. Core code streamlined (removed complex serialization and unused functions).
     2. Added 'Inject Code' button to execute CodeBox content in script environment.
     3. Implemented hooks for logging Mouse movement and Key presses.
]]

-- shuts down the previous instance of SimpleSpy
if _G.SimpleSpyExecuted and type(_G.SimpleSpyShutdown) == "function" then
	pcall(_G.SimpleSpyShutdown)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local ContentProvider = game:GetService("ContentProvider")

-- Простая версия Highlight, если нет внешней
local Highlight = Highlight or { new = function(box) return { setRaw = function(s) box.Text = s; end, getString = function() return box.Text; end; } end }

-- Instances (сокращено, только необходимые)
local SimpleSpy2 = Instance.new("ScreenGui")
SimpleSpy2.Name = "SimpleSpy2"

local Background = Instance.new("Frame")
Background.Parent = SimpleSpy2

local LeftPanel = Instance.new("Frame")
LeftPanel.Parent = Background

local LogList = Instance.new("ScrollingFrame")
LogList.Parent = LeftPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = LogList

local RemoteTemplate = Instance.new("Frame")
RemoteTemplate.Parent = LogList

local Text = Instance.new("TextLabel")
Text.Parent = RemoteTemplate

local Button = Instance.new("TextButton")
Button.Parent = RemoteTemplate

local RightPanel = Instance.new("Frame")
RightPanel.Parent = Background

local CodeBox = Instance.new("TextBox") -- Изменен на TextBox для прямого редактирования
CodeBox.Parent = RightPanel

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = RightPanel

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Parent = ScrollingFrame

local FunctionTemplate = Instance.new("Frame")
FunctionTemplate.Parent = ScrollingFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = Background

local Simple = Instance.new("TextButton")
Simple.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar

local ToolTip = Instance.new("Frame")
ToolTip.Parent = SimpleSpy2

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = ToolTip

-- Properties (упрощено)
SimpleSpy2.ResetOnSpawn = false
Background.Size = UDim2.new(0, 500, 0, 300)
Background.Position = UDim2.new(0.5, -250, 0.5, -150)
Background.Active = true
Background.Draggable = true
LeftPanel.Size = UDim2.new(0, 150, 1, -19)
LeftPanel.Position = UDim2.new(0, 0, 0, 19)
RightPanel.Size = UDim2.new(1, -150, 1, -19)
RightPanel.Position = UDim2.new(0, 150, 0, 19)
TopBar.Size = UDim2.new(1, 0, 0, 19)
CodeBox.Size = UDim2.new(1, 0, 0.7, 0)
CodeBox.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
CodeBox.TextColor3 = Color3.new(1, 1, 1)
CodeBox.TextSize = 14
CodeBox.TextWrapped = true
CodeBox.MultiLine = true
CodeBox.Font = Enum.Font.Code
ScrollingFrame.Position = UDim2.new(0, 0, 0.7, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 0.3, 0)
FunctionTemplate.Size = UDim2.new(0, 100, 0, 25)
FunctionTemplate.BackgroundTransparency = 1
Text.Size = UDim2.new(1, -10, 1, 0)
Text.TextXAlignment = Enum.TextXAlignment.Left
Button.Size = UDim2.new(1, 0, 1, 0)

-- init
local Mouse
local layoutOrderNum = 999999999
local selected = nil
local blacklist = {}
local blocklist = {}
local scheduled = {}
local SimpleSpy = {}
local remoteSignals = {}
local remoteHooks = {}
local remoteModifiers = {}
local connections = {}
local originalEvent = Instance.new("RemoteEvent").FireServer
local originalFunction = Instance.new("RemoteFunction").InvokeServer
local gm, original 
local funcEnabled = false -- Отключено для уменьшения нагрузки
local recordReturnValues = false

-- Добавлено для логирования ввода
local inputLog = {}
local maxInputLogs = 50

-- functions

-- Универсальный логгер ввода
local function logInput(type, input)
	local details = ""
	if type == "Key" then
		details = string.format("Key: %s", input.KeyCode.Name)
	elseif type == "Click" then
		details = string.format("Button: %s, Pos: (%.0f, %.0f)", input.UserInputType.Name, input.Position.X, input.Position.Y)
	end
	
	local log = string.format("[%s] %s: %s", os.date("%H:%M:%S"), type, details)
	table.insert(inputLog, 1, log)
	if #inputLog > maxInputLogs then
		table.remove(inputLog, maxInputLogs + 1)
	end
	
	if not selected then
		local combinedLog = table.concat(inputLog, "\n")
		CodeBox.Text = "-- Last User Inputs (Max " .. maxInputLogs .. "):\n" .. combinedLog
	end
end

local function newRemote(type, name, args, remote, blocked)
	local remoteFrame = RemoteTemplate:Clone()
	remoteFrame.Name = "RemoteEntry"
	remoteFrame.Text.Text = string.sub(name, 1, 30)
	remoteFrame.Text.TextColor3 = type == "event" and Color3.new(1, 0.8, 0) or Color3.new(0.4, 0.4, 1)
	
	local log = {
		Name = name,
		Remote = remote,
		Log = remoteFrame,
		Blocked = blocked,
		Args = args,
		Type = type,
		GenScript = ""
	}
	table.insert(scheduled, {
		function()
			-- Простая генерация скрипта
			local argsStr = table.concat(
				vim.tbl_map(function(v) 
					if typeof(v) == "Instance" then return "game:GetService('" .. v.ClassName .. "'):FindFirstChild('" .. v.Name .. "') --[[Instance]]" end
					return tostring(v) 
				end, args),
				", "
			)
			log.GenScript = string.format(
				"-- %s Logged Args (%d):\nlocal Remote = game:GetService('ReplicatedStorage'):FindFirstChild('%s') -- PATH\nlocal Args = {%s}\n\nRemote:%s(unpack(Args))",
				type == "event" and "RemoteEvent" or "RemoteFunction",
				#args,
				name,
				argsStr,
				type == "event" and "FireServer" or "InvokeServer"
			)
			if blocked then log.GenScript = "-- BLOCKED CALL\n" .. log.GenScript end
		end
	})
	
	local connect = remoteFrame.Button.MouseButton1Click:Connect(function()
		selected = log
		CodeBox.Text = log.GenScript
	end)
	
	remoteFrame.LayoutOrder = layoutOrderNum
	layoutOrderNum = layoutOrderNum - 1
	remoteFrame.Parent = LogList
	table.insert(connections, connect)
	return log -- Возвращаем лог для возможности модификации
end

-- Хуки для перехвата
local function hookRemote(remoteType, remote, ...)
	local callArgs = { ... }
	if typeof(remote) == "Instance" and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
		local remoteName = remote.Name
		
		-- Применение хуков и модификаторов
		local modFunc = remoteModifiers[remote] or remoteHooks[remote]
		if modFunc then
			local success, result = pcall(modFunc, unpack(callArgs))
			if success and type(result) == "table" then
				callArgs = result
			end
		end

		local isBlocked = blocklist[remote] or blocklist[remoteName]
		
		if not (blacklist[remote] or blacklist[remoteName]) then
			if remoteType == "RemoteFunction" and recordReturnValues then
				-- Логика InvokeServer с возвратом значений
				local thread = coroutine.running()
				task.defer(function()
					local returnValue = isBlocked and {} or { originalFunction(remote, unpack(callArgs)) }
					
					schedule(newRemote, remoteType, remoteName, callArgs, remote, isBlocked)
					
					coroutine.resume(thread, unpack(returnValue))
				end)
				return coroutine.yield()
			else
				schedule(newRemote, remoteType, remoteName, callArgs, remote, isBlocked)
			end
		end
		
		if isBlocked then
			return remoteType == "RemoteFunction" and nil or nil
		end
	end
	
	-- Вызов оригинальной функции с (возможно) модифицированными аргументами
	if remoteType == "RemoteEvent" then
		return originalEvent(remote, unpack(callArgs))
	else
		return originalFunction(remote, unpack(callArgs))
	end
end

local newnamecall = newcclosure(function(remote, ...)
	local callArgs = { ... }
	if typeof(remote) == "Instance" then
		local methodName = getnamecallmethod()
		local remoteName = remote.Name
		
		if methodName == "FireServer" or methodName == "InvokeServer" then
			
			-- Применение хуков и модификаторов
			local modFunc = remoteModifiers[remote] or remoteHooks[remote]
			if modFunc then
				local success, result = pcall(modFunc, unpack(callArgs))
				if success and type(result) == "table" then
					callArgs = result
				end
			end
			
			local isBlocked = blocklist[remote] or blocklist[remoteName]
			
			if not (blacklist[remote] or blacklist[remoteName]) then
				if methodName == "InvokeServer" and recordReturnValues then
					local thread = coroutine.running()
					task.defer(function()
						setnamecallmethod(methodName)
						local returnValue = isBlocked and {} or { original(remote, unpack(callArgs)) }
						
						schedule(newRemote, "function", remoteName, callArgs, remote, isBlocked)
						coroutine.resume(thread, unpack(returnValue))
					end)
					return coroutine.yield()
				else
					schedule(newRemote, methodName == "FireServer" and "event" or "function", remoteName, callArgs, remote, isBlocked)
				end
			end
			
			if isBlocked then
				return methodName == "InvokeServer" and nil or nil
			end
			
			setnamecallmethod(methodName)
			return original(remote, unpack(callArgs))
		end
	end
	return original(remote, ...)
end, original)

local newFireServer = newcclosure(function(...)
	return hookRemote("event", ...)
end, originalEvent)

local newInvokeServer = newcclosure(function(...)
	return hookRemote("function", ...)
end, originalFunction)

-- Главные функции
function SimpleSpy:ModifyRemote(remote, f)
	remoteModifiers[remote] = f
end

local function toggleSpy()
	if not original then
		gm = gm or getrawmetatable(game)
		-- Перехват __namecall
		original = hookmetamethod(game, "__namecall", newnamecall)
		-- Перехват FireServer/InvokeServer
		originalEvent = hookfunction(Instance.new("RemoteEvent").FireServer, newFireServer)
		originalFunction = hookfunction(Instance.new("RemoteFunction").InvokeServer, newInvokeServer)
	else
		hookmetamethod(game, "__namecall", original)
		hookfunction(Instance.new("RemoteEvent").FireServer, originalEvent)
		hookfunction(Instance.new("RemoteFunction").InvokeServer, originalFunction)
		original = nil
	end
end

local function shutdown()
	pcall(toggleSpy)
	for _, c in pairs(connections) do pcall(c.Disconnect, c) end
	SimpleSpy2:Destroy()
	_G.SimpleSpyExecuted = false
end

-- Хуки для перехвата ввода
local function setupInputHooks()
	local mouse = Players.LocalPlayer:GetMouse()
	
	-- Логирование кликов
	table.insert(connections, mouse.Button1Down:Connect(function()
		logInput("Click", UserInputService:GetMouseLocation())
	end))
	
	-- Логирование нажатий клавиш
	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
			logInput("Key", input)
		end
	end))
	
	-- Отображение логов ввода по умолчанию
	local combinedLog = table.concat(inputLog, "\n")
	CodeBox.Text = "-- Last User Inputs (Max " .. maxInputLogs .. "):\n" .. combinedLog
end

-- Main Setup
local function init()
	toggleSpy()
	_G.SimpleSpyShutdown = shutdown
	_G.SimpleSpyExecuted = true
	getgenv().SimpleSpy = SimpleSpy
	
	setupInputHooks()

	-- GUI Setup and Button Logic
	local currentApplyButton
	
	local function clearApplyButton()
		if currentApplyButton and currentApplyButton.Parent then
			currentApplyButton:Destroy()
			currentApplyButton = nil
		end
	end
	
	local function newButton(name, description, onClick)
		local btn = FunctionTemplate:Clone()
		btn.Name = "FunctionButton"
		btn.Text.Text = name
		btn.Parent = ScrollingFrame
		btn.Button.MouseEnter:Connect(function() ToolTip.Visible = true; TextLabel.Text = description; end)
		btn.Button.MouseLeave:Connect(function() ToolTip.Visible = false; end)
		btn.Button.MouseButton1Click:Connect(function(...) onClick(btn, ...) end)
		return btn
	end

	-- Настройка GUI
	local function setupGUI()
		Background.BackgroundColor3 = Color3.fromRGB(37, 36, 38)
		LeftPanel.BackgroundColor3 = Color3.fromRGB(53, 52, 55)
		TopBar.BackgroundColor3 = Color3.fromRGB(37, 35, 38)
		Simple.Text = "SimpleSpy | BlackHat"
		Simple.TextColor3 = Color3.new(1, 1, 1)
		Simple.BackgroundTransparency = 1
		CloseButton.Text = "X"
		CloseButton.TextColor3 = Color3.new(1, 0, 0)
		CloseButton.BackgroundColor3 = Color3.fromRGB(37, 35, 38)
		
		-- Кнопки действий
		newButton("Clear Logs", "Очистить список перехваченных Remote.", function()
			for _, child in ipairs(LogList:GetChildren()) do
				if child.Name == "RemoteEntry" then child:Destroy() end
			end
			CodeBox.Text = ""
			selected = nil
		end)
		
		newButton("Inject Code", "Выполнить код из CodeBox в окружении скрипта.", function()
			clearApplyButton()
			local code = CodeBox.Text
			local success, err = pcall(loadstring(code))
			if success then
				newRemote("Inject", "Code Executed", {}, nil, false)
			else
				newRemote("Error", "Inject Failed", { tostring(err) }, nil, true)
			end
		end)
		
		newButton("Set Modifier", "Загрузить шаблон для изменения аргументов выбранного Remote.", function(btn)
			if not selected or not selected.Remote then 
				CodeBox.Text = "-- Выберите Remote для модификации."; 
				return
			end
			
			clearApplyButton()
			
			local remote = selected.Remote
			local codeTemplate = string.format(
				"-- Modifier for %s\n-- function ModifyArgs(...) return {...} end\n\nlocal function ModifyArgs(...)\n    -- Args: %s\n    return { ... } -- Return modified args table\nend\n\nSimpleSpy:ModifyRemote(Remote, ModifyArgs)",
				remote.Name,
				table.concat(vim.tbl_map(tostring, selected.Args), ", ")
			)
			
			CodeBox.Text = codeTemplate
			
			currentApplyButton = newButton("APPLY Modifier", "Применить модификатор из CodeBox.", function(applyBtn)
				local code = CodeBox.Text
				local env = {
					Remote = remote,
					SimpleSpy = SimpleSpy,
					ModifyArgs = nil
				}
				-- Используем loadstring с окружением для получения функции ModifyArgs
				local success, result = pcall(loadstring(code, env))
				if success and env.ModifyArgs then
					SimpleSpy:ModifyRemote(remote, env.ModifyArgs)
					newRemote("Modifier", "Applied: " .. remote.Name, {}, nil, false)
				elseif success and not env.ModifyArgs then
					SimpleSpy:ModifyRemote(remote, nil)
					newRemote("Modifier", "Removed: " .. remote.Name, {}, nil, false)
				else
					newRemote("Error", "Modifier Failed: " .. tostring(result), {}, nil, true)
				end
				clearApplyButton()
			end)
		end)
		
		newButton("Block (i)", "Заблокировать этот Remote Instance.", function()
			if selected then blocklist[selected.Remote] = true; newRemote("Block", selected.Name, {}, nil, true) end
		end)
		
		newButton("Block (n)", "Заблокировать все Remote с этим именем.", function()
			if selected then blocklist[selected.Name] = true; newRemote("Block", selected.Name, {}, nil, true) end
		end)
		
		newButton("Toggle Spy", "Включить/выключить перехват Remote.", function()
			toggleSpy()
			newRemote("Status", "Spy Toggled", {}, nil, false)
		end)
		
		CloseButton.MouseButton1Click:Connect(shutdown)
		Simple.MouseButton1Click:Connect(function() end) -- Кнопка заголовка
		
		SimpleSpy2.Parent = CoreGui
	end
	
	setupGUI()

	-- Task Scheduler (запускает отложенные функции, включая генерацию логов)
	RunService.Heartbeat:Connect(function()
		if #scheduled > 0 then
			local func = table.remove(scheduled, 1)
			pcall(unpack(func))
		end
		
		-- Обновление CanvasSize для прокрутки
		LogList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y)
	end)
end

-- Check if environment is ready
if Players.LocalPlayer then
	init()
else
	Players.PlayerAdded:Connect(init)
end
