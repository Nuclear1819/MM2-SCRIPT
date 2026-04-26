local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local isLocking = false
local espEnabled = false
local killAuraEnabled = true 
local uiVisible = true
local isAction = false

----------------------------------------------------------------
-- 1. สร้างโครงสร้าง UI
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FarHub_V30_FullWarning"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.AutomaticSize = Enum.AutomaticSize.Y
mainFrame.Size = UDim2.new(0, 200, 0, 0)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Visible = true
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

-- [[ ปุ่มเปิด/ปิดหลัก ]]
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
-- 2. ฟังก์ชันช่วย
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
local lockButton = createBlueButton("Aimbot: OFF")
local espButton = createBlueButton("ESP: OFF")

local grabButton = createBlueButton("Grab Gun")
createWarning("⚠️ นายอำเภอตายแล้วปืนตกพื้น ค่อยกดปุ่ม Grab Gun", Color3.fromRGB(255, 200, 0))

local killAllButton = createBlueButton("Kill All (Warp)")
-- รวมข้อความตามที่คุณสั่ง
createWarning("⚠️ คุณต้องเป็นฆาตกรก่อน ถึงจะสามารถใช้ปุ่ม Kill All ได้", Color3.fromRGB(255, 80, 80))

local rejoinButton = createBlueButton("Rejoin Server")

hideButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    mainFrame.Visible = uiVisible
end)

lockButton.MouseButton1Click:Connect(function()
    isLocking = not isLocking
    lockButton.Text = isLocking and "Aimbot: ON" or "Aimbot: OFF"
    lockButton.BackgroundColor3 = isLocking and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 120, 200)
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 120, 200)
    if not espEnabled then
        for _, op in pairs(Players:GetPlayers()) do
            if op.Character then
                local hl = op.Character:FindFirstChild("FarHubESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

grabButton.MouseButton1Click:Connect(function()
    if isAction then return end
    local gun = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Handle", true)
    if gun and gun:IsA("BasePart") and not gun:IsDescendantOf(player.Character) then
        isAction = true
        local root = player.Character.HumanoidRootPart
        local oldPos = root.CFrame
        root.CFrame = gun.CFrame
        task.wait(0.4)
        root.CFrame = oldPos
        isAction = false
    else
        grabButton.Text = "❌ ไม่พบปืน"
        task.wait(1)
        grabButton.Text = "Grab Gun"
    end
end)

killAllButton.MouseButton1Click:Connect(function()
    if isAction then return end
    local knife = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
    
    if not knife then
        local oldText = killAllButton.Text
        killAllButton.Text = "❌ คุณไม่ใช่ฆาตกร!"
        task.wait(1.5)
        killAllButton.Text = oldText
        return
    end

    isAction = true
    local char = player.Character
    local root = char.HumanoidRootPart
    local oldPos = root.CFrame
    for _, victim in pairs(Players:GetPlayers()) do
        if victim ~= player and victim.Character and victim.Character:FindFirstChild("Humanoid") and victim.Character.Humanoid.Health > 0 then
            knife.Parent = char
            root.CFrame = victim.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
            task.wait(0.25)
        end
    end
    root.CFrame = oldPos
    isAction = false
end)

rejoinButton.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, player) end)

----------------------------------------------------------------
-- 4. ระบบการทำงานอัตโนมัติ (Aura / ESP / Lock)
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    local char = player.Character
    local knife = char and char:FindFirstChild("Knife")
    if knife and killAuraEnabled then
        for _, op in pairs(Players:GetPlayers()) do
            if op ~= player and op.Character and op.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - op.Character.HumanoidRootPart.Position).Magnitude
                if dist < 15 then
                    knife:Activate()
                    firetouchinterest(op.Character.HumanoidRootPart, knife.Handle, 0)
                    firetouchinterest(op.Character.HumanoidRootPart, knife.Handle, 1)
                end
            end
        end
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
    end
    
    if isLocking then
        local target = nil
        local dist = 200
        for _, op in pairs(Players:GetPlayers()) do
            if op ~= player and checkInventory(op, "Knife") then
                local head = op.Character and op.Character:FindFirstChild("Head")
                if head and (player.Character.HumanoidRootPart.Position - head.Position).Magnitude < dist then 
                    target = head dist = (player.Character.HumanoidRootPart.Position - head.Position).Magnitude 
                end
            end
        end
        if target then camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, target.Position), 0.15) end
    end
end)

