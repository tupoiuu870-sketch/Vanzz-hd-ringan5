-- CEBO FINDER V3 - INCOME GEDE VERSION
-- Mirip foto: Spirit Panda [$2.2B/s] + Celestial Sunlion [$2.2B/s]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

pcall(function() game.CoreGui:FindFirstChild("CeboFinderVanzz"):Destroy() end)

local MIN_INCOME = 100000000 -- 100M/s minimal, ganti kalo mau 1B = 1000000000

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "CeboFinderVanzz"
Gui.Parent = game.CoreGui
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 560, 0, 330)
Main.Position = UDim2.new(0.5, -280, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
Main.Parent = Gui
Main.Active = true
Main.Draggable = true

-- LEFT
local Left = Instance.new("Frame")
Left.Size = UDim2.new(0, 125, 1, 0)
Left.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", Left).CornerRadius = UDim.new(0,12)
Left.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "CeboFinder"
Title.Size = UDim2.new(1,0,0,35)
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Left

-- RIGHT TOP
local function makeToggle(name, pos)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 185, 0, 38)
    f.Position = pos
    f.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,20)
    f.Parent = Main
    
    local t = Instance.new("TextLabel")
    t.Text = name
    t.Size = UDim2.new(0.6,0,1,0)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.Size = UDim2.new(0, 34, 0, 20)
    btn.Position = UDim2.new(0.72,0,0.24,0)
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,20)
    btn.Parent = f
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,16,0,16)
    dot.Position = UDim2.new(0,2,0,2)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0,10)
    dot.Parent = btn
    
    return btn, dot
end

local AJBtn, AJDot = makeToggle("Auto-Join", UDim2.new(0, 145, 0, 12))
local AFBtn, AFDot = makeToggle("Min: "..(MIN_INCOME/1000000).."M/s", UDim2.new(0, 350, 0, 12))

local LiveLabel = Instance.new("TextLabel")
LiveLabel.Text = "LIVE FEED - INCOME GEDE"
LiveLabel.Position = UDim2.new(0, 145, 0, 60)
LiveLabel.Size = UDim2.new(0, 250, 0, 20)
LiveLabel.BackgroundTransparency = 1
LiveLabel.TextColor3 = Color3.fromRGB(150,150,150)
LiveLabel.Font = Enum.Font.GothamBold
LiveLabel.TextSize = 11
LiveLabel.TextXAlignment = Enum.TextXAlignment.Left
LiveLabel.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0, 415, 0, 250)
Scroll.Position = UDim2.new(0, 135, 0, 85)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 4
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Scroll

local function formatIncome(num)
    if num >= 1000000000 then return string.format("$%.1fB/s", num/1000000000)
    elseif num >= 1000000 then return string.format("$%.1fM/s", num/1000000)
    else return "$"..tostring(num).."/s" end
end

local function getRarity(obj)
    local ok, v = pcall(function() return obj:GetAttribute("Rarity") end)
    if ok and v then return tostring(v) end
    local d = obj:FindFirstChild("Data") or obj:FindFirstChild("Stats")
    if d then
        local r = d:FindFirstChild("Rarity")
        if r and r.Value then return tostring(r.Value) end
    end
    for _,c in pairs(obj:GetChildren()) do
        if c.Name:lower():find("rarity") and c.Value then return tostring(c.Value) end
    end
    return "?"
end

local function getIncome(obj)
    local ok, v = pcall(function() return obj:GetAttribute("Income") end)
    if ok and v and tonumber(v) then return tonumber(v) end
    ok, v = pcall(function() return obj:GetAttribute("IncomePerSecond") end)
    if ok and v and tonumber(v) then return tonumber(v) end
    local d = obj:FindFirstChild("Data") or obj:FindFirstChild("Stats")
    if d then
        local inc = d:FindFirstChild("Income") or d:FindFirstChild("Price") or d:FindFirstChild("Value")
        if inc and tonumber(inc.Value) then return tonumber(inc.Value) end
    end
    for _,c in pairs(obj:GetChildren()) do
        if c.Name:lower():find("income") or c.Name:lower():find("value") then
            if c.Value and tonumber(c.Value) then return tonumber(c.Value) end
        end
    end
    return 0
end

local function addFeed(obj, rarity, income)
    if income < MIN_INCOME then return end
    -- Cek udah ada belum
    for _,v in pairs(Scroll:GetChildren()) do
        if v:IsA("Frame") and v.Name == obj:GetDebugId() then return end
    end

    local Item = Instance.new("Frame")
    Item.Name = obj:GetDebugId()
    Item.Size = UDim2.new(1, -10, 0, 60)
    Item.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", Item).CornerRadius = UDim.new(0,10)
    Item.Parent = Scroll

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = obj.Name.." [ "..formatIncome(income).." ]"
    NameLabel.Size = UDim2.new(0.65,0,0.55,0)
    NameLabel.Position = UDim2.new(0,12,0,2)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = Color3.new(1,1,1)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 13
    NameLabel.Parent = Item

    local Sub = Instance.new("TextLabel")
    Sub.Text = "Rarity: "..rarity.." • Income: "..formatIncome(income)
    Sub.Size = UDim2.new(0.65,0,0.4,0)
    Sub.Position = UDim2.new(0,12,0.5,0)
    Sub.BackgroundTransparency = 1
    Sub.TextColor3 = Color3.fromRGB(160,160,160)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.TextSize = 11
    Sub.Parent = Item

    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Text = "TP"
    JoinBtn.Size = UDim2.new(0, 50, 0, 28)
    JoinBtn.Position = UDim2.new(1, -60, 0.5, -14)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    JoinBtn.TextColor3 = Color3.new(1,1,1)
    JoinBtn.Font = Enum.Font.GothamBold
    JoinBtn.TextSize = 12
    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0,8)
    JoinBtn.Parent = Item

    JoinBtn.MouseButton1Click:Connect(function()
        -- Teleport ke telur nya
        if obj.PrimaryPart then
            LP.Character.HumanoidRootPart.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0,5,0)
        elseif obj:FindFirstChildWhichIsA("BasePart") then
            LP.Character.HumanoidRootPart.CFrame = obj:FindFirstChildWhichIsA("BasePart").CFrame + Vector3.new(0,5,0)
        end
    end)

    -- Highlight
    if not obj:FindFirstChild("IncomeESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "IncomeESP"
        hl.FillColor = Color3.fromRGB(0,255,150)
        hl.FillTransparency = 0.4
        hl.Parent = obj
    end

    Scroll.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y + 10)
    
    StarterGui:SetCore("SendNotification", {
        Title = "💰 INCOME GEDE!";
        Text = obj.Name.." "..formatIncome(income);
        Duration = 4;
    })
end

local function scan()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local inc = getIncome(v)
            if inc >= MIN_INCOME then
                local rar = getRarity(v)
                -- Hanya yang Secret/Eternal/Divine ATAU income gede banget (>500M)
                if rar:lower():find("secret") or rar:lower():find("eternal") or rar:lower():find("divine") or rar:lower():find("celestial") or inc >= 500000000 then
                    addFeed(v, rar, inc)
                end
            end
        end
    end
end

scan()
workspace.DescendantAdded:Connect(function(v)
    task.wait(0.5)
    if v:IsA("Model") then
        local inc = getIncome(v)
        if inc >= MIN_INCOME then
            local rar = getRarity(v)
            addFeed(v, rar, inc)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        scan()
    end
end)

-- Ganti MIN_INCOME kalo tombol dipencet
AFBtn.MouseButton1Click:Connect(function()
    if MIN_INCOME == 100000000 then MIN_INCOME = 1000000000
    elseif MIN_INCOME == 1000000000 then MIN_INCOME = 2000000000
    else MIN_INCOME = 100000000 end
    AFBtn.Parent:FindFirstChildOfClass("TextLabel").Text = "Min: "..(MIN_INCOME >= 1000000000 and (MIN_INCOME/1000000000).."B/s" or (MIN_INCOME/1000000).."M/s")
end)
