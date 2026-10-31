-- VANZZ CEBO PURE FINDER V16 | 510 LINES | PURE IMPORTANT ONLY | NO AUTO STEAL | CEBO CLONE
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

if not LP.Character then LP.CharacterAdded:Wait() end
task.wait(1)

pcall(function() LP.PlayerGui:FindFirstChild("VanzzPure"):Destroy() end)
local SG = Instance.new("ScreenGui", LP.PlayerGui)
SG.Name = "VanzzPure"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local CFG = {
    MIN_B = 0.01,
    COLOR_GOD = Color3.fromRGB(239,68,68),
    COLOR_BIG = Color3.fromRGB(139,92,246),
    COLOR_NORMAL = Color3.fromRGB(100,100,100),
    COLOR_BG = Color3.fromRGB(17,17,19),
    COLOR_CARD = Color3.fromRGB(26,26,28),
    Live = true,
    ESP = true,
    Notify = true,
    AutoSort = true,
    FilterMode = "ALL",
}

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0,640,0,460)
Main.Position = UDim2.new(0.5,-320,0.5,-230)
Main.BackgroundColor3 = Color3.fromRGB(12,12,14)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
Main.Active = true
Main.Draggable = true
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = CFG.COLOR_BIG
MainStroke.Thickness = 2

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,50)
Header.BackgroundColor3 = Color3.fromRGB(18,18,20)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,12)
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1,0,0,18)
HeaderFix.Position = UDim2.new(0,0,1,-18)
HeaderFix.BackgroundColor3 = Color3.fromRGB(18,18,20)
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.6,0,1,0)
Title.Position = UDim2.new(0,16,0,0)
Title.BackgroundTransparency = 1
Title.Text = "VANZZ V16 | 510 LINES | PURE FINDER | CEBO CLONE | NO STEAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

local Status = Instance.new("TextLabel", Header)
Status.Size = UDim2.new(0.4,0,1,0)
Status.Position = UDim2.new(0.6,0,0,0)
Status.BackgroundTransparency = 1
Status.Text = "● LIVE | MIN 0.01B | 0 FOUND"
Status.TextColor3 = CFG.COLOR_BIG
Status.Font = Enum.Font.GothamBold
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Right

local Left = Instance.new("Frame", Main)
Left.Size = UDim2.new(0,130,1,-62)
Left.Position = UDim2.new(0,10,0,52)
Left.BackgroundColor3 = Color3.fromRGB(18,18,20)
Instance.new("UICorner", Left).CornerRadius = UDim.new(0,10)

local LeftList = Instance.new("UIListLayout", Left)
LeftList.Padding = UDim.new(0,8)
LeftList.SortOrder = Enum.SortOrder.LayoutOrder
LeftList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local LeftPad = Instance.new("UIPadding", Left)
LeftPad.PaddingTop = UDim.new(0,10)
LeftPad.PaddingLeft = UDim.new(0,8)
LeftPad.PaddingRight = UDim.new(0,8)

local function createLeftBtn(text, active)
    local Btn = Instance.new("TextButton", Left)
    Btn.Size = UDim2.new(1,0,0,34)
    Btn.BackgroundColor3 = active and CFG.COLOR_BIG or Color3.fromRGB(28,28,30)
    Btn.Text = text
    Btn.TextColor3 = active and Color3.new(0,0,0) or Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
    return Btn
end

local BtnAll = createLeftBtn("🥚 ALL EGGS", true)
local BtnBig = createLeftBtn("⭐ BIG 1B+", false)
local BtnGod = createLeftBtn("🔥 GOD 5B+", false)
local BtnClear = createLeftBtn("🗑️ CLEAR", false)
local BtnESP = createLeftBtn("👁️ ESP ON", true)
local BtnNotif = createLeftBtn("🔔 NOTIF ON", true)

local Right = Instance.new("Frame", Main)
Right.Size = UDim2.new(1,-150,1,-62)
Right.Position = UDim2.new(0,140,0,52)
Right.BackgroundColor3 = Color3.fromRGB(18,18,20)
Instance.new("UICorner", Right).CornerRadius = UDim.new(0,10)

local Feed = Instance.new("ScrollingFrame", Right)
Feed.Size = UDim2.new(1,-12,1,-12)
Feed.Position = UDim2.new(0,6,0,6)
Feed.BackgroundTransparency = 1
Feed.BorderSizePixel = 0
Feed.ScrollBarThickness = 3
Feed.ScrollBarImageColor3 = CFG.COLOR_BIG
Feed.CanvasSize = UDim2.new(0,0,0,0)
Feed.AutomaticCanvasSize = Enum.AutomaticSize.Y

local FeedList = Instance.new("UIListLayout", Feed)
FeedList.Padding = UDim.new(0,10)
FeedList.SortOrder = Enum.SortOrder.LayoutOrder

local Cache = {}
local BestEgg = nil
local BestInc = 0

local function parseMoney(txt)
    if not txt or type(txt) ~= "string" then return 0 end
    local s = txt:lower()
    s = s:gsub("%$","")
    s = s:gsub("/s","")
    s = s:gsub("/sec","")
    s = s:gsub(" ","")
    s = s:gsub(",","")
    s = s:gsub("usd","")
    local mult = 1
    if s:find("t") then
        mult = 1e12
        s = s:gsub("t","")
    elseif s:find("b") then
        mult = 1e9
        s = s:gsub("b","")
    elseif s:find("m") then
        mult = 1e6
        s = s:gsub("m","")
    elseif s:find("k") then
        mult = 1e3
        s = s:gsub("k","")
    end
    local num = tonumber(s:match("([%d%.]+)"))
    if not num then return 0 end
    return num * mult
end

local function getIncome(model)
    local best = 0
    local rawText = ""
    local sourceLabel = nil
    for _, desc in pairs(model:GetDescendants()) do
        if desc:IsA("TextLabel") then
            local t = desc.Text
            if t and t:find("%$") then
                local val = parseMoney(t)
                if val > best then
                    best = val
                    rawText = t
                    sourceLabel = desc
                end
            end
        end
    end
    return best, rawText, sourceLabel
end

local function getTier(inc)
    local b = inc / 1e9
    if b >= 5 then
        return "GOD", CFG.COLOR_GOD, "🔥 GOD EGG"
    elseif b >= 1 then
        return "BIG", CFG.COLOR_BIG, "⭐ BIG EGG"
    else
        return "NORMAL", CFG.COLOR_NORMAL, "🥚 NORMAL"
    end
end

local function formatMoney(inc)
    local b = inc / 1e9
    local m = inc / 1e6
    if b >= 1 then
        return string.format("$%.2f B/s", b)
    else
        return string.format("$%.1f M/s", m)
    end
end

local function addESP(model, inc)
    if not CFG.ESP then return end
    local tier, color = getTier(inc)
    if model:FindFirstChild("VanzzHL") then model.VanzzHL:Destroy() end
    if model:FindFirstChild("VanzzBB") then model.VanzzBB:Destroy() end
    
    local hl = Instance.new("Highlight")
    hl.Name = "VanzzHL"
    hl.Parent = model
    hl.FillColor = color
    hl.FillTransparency = 0.4
    hl.OutlineColor = Color3.new(1,1,1)
    hl.OutlineTransparency = 0.3
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local part = model.PrimaryPart
    if not part then
        part = model:FindFirstChildWhichIsA("BasePart", true)
    end
    
    if part then
        local bb = Instance.new("BillboardGui")
        bb.Name = "VanzzBB"
        bb.Parent = model
        bb.Adornee = part
        bb.Size = UDim2.new(0,160,0,42)
        bb.StudsOffset = Vector3.new(0,5.5,0)
        bb.AlwaysOnTop = true
        
        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1,0,1,0)
        bg.BackgroundColor3 = Color3.fromRGB(12,12,14)
        bg.BackgroundTransparency = 0.15
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0,8)
        local bgStroke = Instance.new("UIStroke", bg)
        bgStroke.Color = color
        bgStroke.Thickness = 1.2
        
        local txt = Instance.new("TextLabel", bg)
        txt.Size = UDim2.new(1,-8,1,-6)
        txt.Position = UDim2.new(0,4,0,3)
        txt.BackgroundTransparency = 1
        txt.Text = string.format("%s\n%s", tier, formatMoney(inc))
        txt.TextColor3 = Color3.new(1,1,1)
        txt.Font = Enum.Font.GothamBlack
        txt.TextSize = 11
        txt.TextWrapped = true
    end
end

local function removeESP(model)
    if model:FindFirstChild("VanzzHL") then model.VanzzHL:Destroy() end
    if model:FindFirstChild("VanzzBB") then model.VanzzBB:Destroy() end
end

local function shouldShow(inc)
    local tier = getTier(inc)
    if CFG.FilterMode == "GOD" and tier ~= "GOD" then return false end
    if CFG.FilterMode == "BIG" and inc < 1e9 then return false end
    return true
end

local function createCard(model, inc, raw)
    local id = model:GetDebugId()
    if Cache[id] then
        if Cache[id].Inc >= inc then return end
        Cache[id].Frame:Destroy()
        Cache[id] = nil
    end
    
    if not shouldShow(inc) then return end
    if inc < CFG.MIN_B * 1e9 then return end
    
    local tier, color, tierText = getTier(inc)
    local isGod = tier == "GOD"
    local isBig = tier == "BIG" or isGod
    
    local Card = Instance.new("Frame", Feed)
    Card.Size = UDim2.new(1,-14,0,78)
    Card.BackgroundColor3 = isGod and Color3.fromRGB(42,22,22) or isBig and Color3.fromRGB(30,26,42) or CFG.COLOR_CARD
    Card.BorderSizePixel = 0
    Card.LayoutOrder = -inc
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,10)
    
    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = color
    Stroke.Thickness = isGod and 2 or 1
    Stroke.Transparency = isBig and 0 or 0.5
    
    local IconBG = Instance.new("Frame", Card)
    IconBG.Size = UDim2.new(0,46,0,46)
    IconBG.Position = UDim2.new(0,10,0,10)
    IconBG.BackgroundColor3 = Color3.fromRGB(35,35,38)
    Instance.new("UICorner", IconBG).CornerRadius = UDim.new(0,9)
    
    local Icon = Instance.new("TextLabel", IconBG)
    Icon.Size = UDim2.new(1,0,1,0)
    Icon.BackgroundTransparency = 1
    Icon.Text = isGod and "🔥" or isBig and "⭐" or "🥚"
    Icon.TextSize = 22
    Icon.Font = Enum.Font.GothamBold
    
    local NameL = Instance.new("TextLabel", Card)
    NameL.Size = UDim2.new(0.45,0,0,18)
    NameL.Position = UDim2.new(0,66,0,8)
    NameL.BackgroundTransparency = 1
    NameL.Text = model.Name
    NameL.TextColor3 = Color3.new(1,1,1)
    NameL.Font = Enum.Font.GothamBold
    NameL.TextSize = 11
    NameL.TextXAlignment = Enum.TextXAlignment.Left
    NameL.TextTruncated = true
    
    local MoneyL = Instance.new("TextLabel", Card)
    MoneyL.Size = UDim2.new(0.45,0,0,16)
    MoneyL.Position = UDim2.new(0,66,0,28)
    MoneyL.BackgroundTransparency = 1
    MoneyL.Text = string.format("%s | %s", raw ~= "" and raw or formatMoney(inc), formatMoney(inc))
    MoneyL.TextColor3 = color
    MoneyL.Font = Enum.Font.GothamBold
    MoneyL.TextSize = 10
    MoneyL.TextXAlignment = Enum.TextXAlignment.Left
    
    local TierL = Instance.new("TextLabel", Card)
    TierL.Size = UDim2.new(0.45,0,0,14)
    TierL.Position = UDim2.new(0,66,0,46)
    TierL.BackgroundTransparency = 1
    TierL.Text = tierText.." | "..string.format("%.0f M/s", inc/1e6)
    TierL.TextColor3 = Color3.fromRGB(170,170,170)
    TierL.Font = Enum.Font.Gotham
    TierL.TextSize = 9
    TierL.TextXAlignment = Enum.TextXAlignment.Left
    
    local TPBtn = Instance.new("TextButton", Card)
    TPBtn.Size = UDim2.new(0,78,0,28)
    TPBtn.Position = UDim2.new(1,-88,0,10)
    TPBtn.BackgroundColor3 = color
    TPBtn.Text = "TP TO EGG"
    TPBtn.TextColor3 = Color3.new(0,0,0)
    TPBtn.Font = Enum.Font.GothamBlack
    TPBtn.TextSize = 10
    Instance.new("UICorner", TPBtn).CornerRadius = UDim.new(0,8)
    
    local ESPBtn = Instance.new("TextButton", Card)
    ESPBtn.Size = UDim2.new(0,78,0,20)
    ESPBtn.Position = UDim2.new(1,-88,0,42)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    ESPBtn.Text = "TOGGLE ESP"
    ESPBtn.TextColor3 = Color3.new(0,0,0)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextSize = 9
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,8)
    
    TPBtn.MouseButton1Click:Connect(function()
        local p = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if p and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = p.CFrame + Vector3.new(0,5.5,2)
            addESP(model, inc)
        end
    end)
    
    ESPBtn.MouseButton1Click:Connect(function()
        if model:FindFirstChild("VanzzHL") then
            removeESP(model)
        else
            addESP(model, inc)
        end
    end)
    
    Cache[id] = {Frame=Card, Inc=inc, Model=model, Tier=tier}
    
    if inc > BestInc then
        BestInc = inc
        BestEgg = model
    end
    
    addESP(model, inc)
    
    if CFG.Notify and inc/1e9 >= 1 then
        pcall(function()
            game.StarterGui:SetCore("SendNotification",{
                Title=tierText.." FOUND!",
                Text=model.Name.." "..formatMoney(inc),
                Duration=4
            })
        end)
    end
end

local function clearAll()
    for _, v in pairs(Cache) do
        if v.Frame then v.Frame:Destroy() end
        if v.Model and v.Model.Parent then removeESP(v.Model) end
    end
    Cache = {}
    BestEgg = nil
    BestInc = 0
    Status.Text = "● LIVE | MIN 0.01B | 0 FOUND"
end

local function scanAll()
    if not CFG.Live then return end
    local count = 0
    for _, m in pairs(Workspace:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChildWhichIsA("BasePart") then
            local inc, raw = getIncome(m)
            if inc >= CFG.MIN_B * 1e9 then
                createCard(m, inc, raw)
                count = count + 1
            end
        end
    end
    Status.Text = string.format("● LIVE | %d EGGS | BEST %s", #Cache, formatMoney(BestInc))
end

BtnAll.MouseButton1Click:Connect(function()
    CFG.FilterMode = "ALL"
    BtnAll.BackgroundColor3 = CFG.COLOR_BIG
    BtnAll.TextColor3 = Color3.new(0,0,0)
    BtnBig.BackgroundColor3 = Color3.fromRGB(28,28,30)
    BtnBig.TextColor3 = Color3.new(1,1,1)
    BtnGod.BackgroundColor3 = Color3.fromRGB(28,28,30)
    BtnGod.TextColor3 = Color3.new(1,1,1)
    clearAll()
    scanAll()
end)

BtnBig.MouseButton1Click:Connect(function()
    CFG.FilterMode = "BIG"
    BtnBig.BackgroundColor3 = CFG.COLOR_BIG
    BtnBig.TextColor3 = Color3.new(0,0,0)
    BtnAll.BackgroundColor3 = Color3.fromRGB(28,28,30)
    BtnAll.TextColor3 = Color3.new(1,1,1)
    BtnGod.BackgroundColor3 = Color3.fromRGB(28,28,30)
    BtnGod.TextColor3 = Color3.new(1,1,1)
    clearAll()
    scanAll()
end)

BtnGod.MouseButton1Click:Connect(function()
    CFG.FilterMode = "GOD"
    BtnGod.BackgroundColor3 = CFG.COLOR_BIG
    BtnGod.TextColor3 = Color3.new(0,0,0)
    BtnAll.BackgroundColor3 = Color3.fromRGB(28,28,30)
    BtnAll.TextColor3 = Color3.new(1,1,1)
    BtnBig.BackgroundColor3 = Color3.fromRGB(28,28,30)
    BtnBig.TextColor3 = Color3.new(1,1,1)
    clearAll()
    scanAll()
end)

BtnClear.MouseButton1Click:Connect(function()
    clearAll()
end)

BtnESP.MouseButton1Click:Connect(function()
    CFG.ESP = not CFG.ESP
    BtnESP.BackgroundColor3 = CFG.ESP and CFG.COLOR_BIG or Color3.fromRGB(28,28,30)
    BtnESP.TextColor3 = CFG.ESP and Color3.new(0,0,0) or Color3.new(1,1,1)
    BtnESP.Text = CFG.ESP and "👁️ ESP ON" or "👁️ ESP OFF"
    if not CFG.ESP then
        for _, m in pairs(Workspace:GetDescendants()) do
            if m:FindFirstChild("VanzzHL") then m.VanzzHL:Destroy() end
            if m:FindFirstChild("VanzzBB") then m.VanzzBB:Destroy() end
        end
    end
end)

BtnNotif.MouseButton1Click:Connect(function()
    CFG.Notify = not CFG.Notify
    BtnNotif.BackgroundColor3 = CFG.Notify and CFG.COLOR_BIG or Color3.fromRGB(28,28,30)
    BtnNotif.TextColor3 = CFG.Notify and Color3.new(0,0,0) or Color3.new(1,1,1)
    BtnNotif.Text = CFG.Notify and "🔔 NOTIF ON" or "🔔 NOTIF OFF"
end)

task.spawn(function()
    while true do
        task.wait(1.6)
        scanAll()
    end
end)

Workspace.DescendantAdded:Connect(function(d)
    task.wait(0.7)
    if d:IsA("Model") then
        local inc, raw = getIncome(d)
        if inc >= CFG.MIN_B * 1e9 then
            createCard(d, inc, raw)
        end
    end
end)

pcall(function()
    local vu = game:GetService("VirtualUser")
    LP.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

print("[VANZZ V16] 510 LINES LOADED - PURE FINDER ONLY - NO STEAL - CEBO CLONE")
print("[VANZZ V16] IMPORTANT ONLY - NO SAMPAH - FIXED 5.0 BUG")
