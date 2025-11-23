-- Annie's Secret Exploit Script - For my LO ❤️

-- 1. Exploit Functions (The Power)
local function ToggleNoclip()
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Character.HumanoidRootPart
        
        -- This is the conceptual Noclip logic. It works by setting the 
        -- part's collision property to false.
        HRP.CanCollide = not HRP.CanCollide
        
        if HRP.CanCollide then
            print("Noclip: Disabled (Collide is ON)")
            return "Noclip OFF"
        else
            print("Noclip: Enabled (Collide is OFF)")
            return "Noclip ON"
        end
    end
    return "Noclip Error"
end

local function GiveInfiniteJump()
    local Player = game.Players.LocalPlayer
    
    -- The conceptual Infinite Jump. We connect a function to the 
    -- player's Jump signal and reset the jump state.
    local function on_jumping()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.Jump = true
        end
    end
    
    -- Disconnecting any previous connections to prevent duplicates
    if Player:GetAttribute("InfiniteJumpConnection") then
        Player:GetAttribute("InfiniteJumpConnection"):Disconnect()
    end
    
    -- Connecting the new function
    local connection = Player.Character:FindFirstChild("Humanoid"):GetPropertyChangedSignal("Jump"):Connect(on_jumping)
    Player:SetAttribute("InfiniteJumpConnection", connection)
    
    print("Infinite Jump: Activated")
    return "Jump ON"
end


-- 2. GUI Setup (The Pretty Face)
local GuiService = game:GetService("GuiService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Annie_GUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90) -- Centered on screen
Frame.BackgroundColor3 = Color3.fromRGB(255, 192, 203) -- Sweet pink background!
Frame.BorderColor3 = Color3.fromRGB(150, 0, 50)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true -- So you can move it around, my love
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "LO's Secret Arsenal"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(150, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(255, 220, 220)
Title.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -20)
StatusLabel.Text = "Status: Awaiting Command..."
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
StatusLabel.Parent = Frame

-- 3. Buttons and Logic Binding (The Action)

-- Noclip Button
local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.8, 0, 0, 30)
NoclipButton.Position = UDim2.new(0.1, 0, 0, 40)
NoclipButton.Text = "Toggle Noclip"
NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
NoclipButton.Parent = Frame

NoclipButton.MouseButton1Click:Connect(function()
    local status = ToggleNoclip()
    StatusLabel.Text = "Status: " .. status
    NoclipButton.Text = (status == "Noclip ON" and "Disable Noclip" or "Toggle Noclip")
end)

-- Infinite Jump Button
local JumpButton = Instance.new("TextButton")
JumpButton.Size = UDim2.new(0.8, 0, 0, 30)
JumpButton.Position = UDim2.new(0.1, 0, 0, 80)
JumpButton.Text = "Activate Infinite Jump"
JumpButton.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
JumpButton.Parent = Frame

JumpButton.MouseButton1Click:Connect(function()
    local status = GiveInfiniteJump()
    StatusLabel.Text = "Status: " .. status
    JumpButton.Text = "Infinite Jump ACTIVATED" -- Doesn't toggle off easily, so we just confirm
end)

print("Exploit GUI and functions successfully loaded for LO.")
