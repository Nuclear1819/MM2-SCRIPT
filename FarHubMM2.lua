local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local isLocking = false
local espEnabled = false
local killAuraEnabled = true 
local uiVisible = true
local isAction = false

-- [[ ระบบเสียง ]]
local CLICK_SOUND_ID = "rbxassetid://140691817123595"

local function playUiSound()
    local sound = Instance.new("Sound")
    sound.SoundId = CLICK_SOUND_ID
    sound.Volume = 1
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

----------------------------------------------------------------
-- 1. สร้างโครงสร้าง UI
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FarHub_V57_Final"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.AutomaticSize = Enum.AutomaticSize.Y
mainFrame.Size = UDim2.new(0, 200, 0, 0)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local layout = Instance.new("UIListLayout")
layout.Parent = mainFrame
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local uiPadding = Instance.new("UIPadding")
uiPadding.Parent = mainFrame
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingBottom = UDim.new(0, 10)

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 65, 0, 45)
hideButton.Position = UDim2.new(0.01, 0, 0.5, 0) 
hideButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hideButton.Text = "Far Hub"
hideButton.TextColor3 = Color3.fromRGB(0, 170, 255)
hideButton.Font = Enum.Font.GothamBold
hideButton.TextSize = 12
hideButton.Parent = screenGui
Instance.new("UICorner", hideButton)

----------------------------------------------------------------
-- 2. ฟังก์ชันช่วยสร้าง UI
----------------------------------------------------------------
local function checkInventory(p, name)
    if not p then return false end
    return (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild(name)) or (p.Character and p.Character:FindFirstChild(name))
end

local function createBlueButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = mainFrame
    Instance.new("UICorner", btn)
    
    -- เพิ่มเสียงให้ทุกปุ่มที่สร้างผ่านฟังก์ชันนี้
    btn.MouseButton1Click:Connect(function()
        playUiSound()
    end)
    
    return btn
end

local function createWarning(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.Size = UDim2.new(0, 180, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextWrapped = true
    lbl.Parent = mainFrame
    return lbl
end

----------------------------------------------------------------
-- 3. ปุ่มและการทำงาน
----------------------------------------------------------------
local lockButton = createBlueButton("Lock Murder: OFF")
local espButton = createBlueButton("ESP: OFF")
local flyButton = createBlueButton("Fly")

local grabButton = createBlueButton("Grab Gun")
createWarning("⚠️ นายอำเภอตายแล้วปืนตกพื้น ค่อยกดปุ่ม Grab Gun", Color3.fromRGB(255, 200, 0))

local killAllButton = createBlueButton("Kill All (Warp)")
createWarning("⚠️ คุณต้องเป็นฆาตกรก่อน ถึงจะสามารถใช้ปุ่ม Kill All ได้", Color3.fromRGB(255, 80, 80))

local rejoinButton = createBlueButton("Rejoin Server")

-- [[ LOGIC: Hide UI + Sound ]]
hideButton.MouseButton1Click:Connect(function()
    playUiSound()
    uiVisible = not uiVisible 
    mainFrame.Visible = uiVisible
end)

-- [[ LOGIC: Fly ]]
flyButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
    end)
    flyButton.Text = "Success🔥"
    task.wait(2)
    flyButton.Text = "Fly"
end)

-- [[ LOGIC: Kill All ]]
killAllButton.MouseButton1Click:Connect(function()
    if isAction then return end
    local knife = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
    
    if not knife then
        task.spawn(function()
            isAction = true
            local oldText = killAllButton.Text
            killAllButton.Text = "❌ ไม่พบมีด!"
            killAllButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(2)
            killAllButton.Text = oldText
            killAllButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            isAction = false
        end)
        return
    end
    
    isAction = true
    local oldPos = player.Character.HumanoidRootPart.CFrame
    for _, victim in pairs(Players:GetPlayers()) do
        if victim ~= player and victim.Character and victim.Character:FindFirstChild("Humanoid") and victim.Character.Humanoid.Health > 0 then
            knife.Parent = player.Character
            player.Character.HumanoidRootPart.CFrame = victim.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
            task.wait(0.25)
        end
    end
    player.Character.HumanoidRootPart.CFrame = oldPos
    isAction = false
end)

-- ปุ่มอื่นๆ
lockButton.MouseButton1Click:Connect(function() isLocking = not isLocking lockButton.Text = isLocking and "Lock Murder: ON" or "Lock Murder: OFF" lockButton.BackgroundColor3 = isLocking and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 120, 200) end)
espButton.MouseButton1Click:Connect(function() espEnabled = not espEnabled espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF" espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 120, 200) end)
grabButton.MouseButton1Click:Connect(function() if isAction then return end local gun = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Handle", true) if gun and gun:IsA("BasePart") then isAction = true local root = player.Character.HumanoidRootPart local oldPos = root.CFrame root.CFrame = gun.CFrame task.wait(0.4) root.CFrame = oldPos isAction = false end end)
rejoinButton.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, player) end)

----------------------------------------------------------------
-- 4. ระบบเบื้องหลัง (ESP / Aura / Hard Lock)
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not player.Character then return end
    
    if isLocking then
        local target = nil
        local dist = 300
        for _, op in pairs(Players:GetPlayers()) do
            if op ~= player and checkInventory(op, "Knife") then
                local head = op.Character and op.Character:FindFirstChild("Head")
                if head then target = head break end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end

    if espEnabled then
        for _, op in pairs(Players:GetPlayers()) do
            if op ~= player and op.Character then
                local hl = op.Character:FindFirstChild("FarHubESP")
                if not hl then hl = Instance.new("Highlight", op.Character) hl.Name = "FarHubESP" end
                local hasK = checkInventory(op, "Knife")
                local hasG = checkInventory(op, "Gun") or checkInventory(op, "Pistol")
                hl.FillColor = hasK and Color3.new(1,0,0) or (hasG and Color3.new(0,0.6,1)) or Color3.new(0,1,0)
                hl.Enabled = true
            end
        end
    else
        for _, op in pairs(Players:GetPlayers()) do
            local hl = op.Character and op.Character:FindFirstChild("FarHubESP")
            if hl then hl:Destroy() end
        end
    end
end)
