-- VANZZ SCRIPTER V8 | 120+ LINES | WORK 100%
-- OFFICIAL BY VANZZ - NOT CEBO
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- CONFIG
local CONFIG = { MIN = 500000000, REFRESH = 1.5, COLOR = Color3.fromRGB(0,255,135) }

-- CLEAN OLD
pcall(function() game.CoreGui:FindFirstChild("VanzzScripter"):Destroy() end)
local GuiRoot = LP:WaitForChild("PlayerGui")
local ok, hui = pcall(function() return gethui() end)
if ok and hui then GuiRoot = hui end

local SG = Instance.new("ScreenGui", GuiRoot)
SG.Name = "VanzzScripter"
SG.ResetOnSpawn = false

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0,430,0,420)
Main.Position = UDim2.new(0.5,-215,0.5,-210)
Main.BackgroundColor3 = Color3.fromRGB(12,12,12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = CONFIG.COLOR
Stroke.Thickness = 2

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1,0,0,50)
Top.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1,-20,0,25)
Title.Position = UDim2.new(0,10,0,5)
Title.BackgroundTransparency = 1
Title.Text = "VANZZ SCRIPTER V8"
Title.TextColor3 = CONFIG.COLOR
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
local Sub = Instance.new("TextLabel", Top)
Sub.Size = UDim2.new(1,-20,0,20)
Sub.Position = UDim2.new(0,10,0,28)
Sub.BackgroundTransparency = 1
Sub.Text = "LIVE SCAN | MIN: "..CONFIG.MIN/1e9.."B/s | BY VANZZ"
Sub.TextColor3 = Color3.fromRGB(180,180,180)
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 11
Sub.TextXAlignment = Enum.TextXAlignment.Left

local Feed = Instance.new("ScrollingFrame", Main)
Feed.Size = UDim2.new(1,-20,1,-70)
Feed.Position = UDim2.new(0,10,0,55)
Feed.BackgroundColor3 = Color3.fromRGB(18,18,18)
Feed.BorderSizePixel = 0
Feed.CanvasSize = UDim2.new(0,0,0,0)
Feed.ScrollBarThickness = 3
Feed.ScrollBarImageColor3 = CONFIG.COLOR
Instance.new("UICorner", Feed).CornerRadius = UDim.new(0,10)
local Layout = Instance.new("UIListLayout", Feed)
Layout.Padding = UDim.new(0,8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- CORE LOGIC (ORI VANZZ)
local function parseMoney(txt)
    if not txt then return 0 end
    txt = txt:lower():gsub("%$",""):gsub("/s",""):gsub(" ",""):gsub(",","")
    local m = 1
    if txt:find("t") then m=1e12; txt=txt:gsub("t","") elseif txt:find("b") then m=1e9; txt=txt:gsub("b","") elseif txt:find("m") then m=1e6; txt=txt:gsub("m","") elseif txt:find("k") then m=1e3; txt=txt:gsub("k","") end
    local n = tonumber(txt:match("([%d%.]+)"))
    return (n or 0)*m
end

local function getIncome(model)
    for _,d in pairs(model:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:find("%$") and d.Text:find("/") then
            local val = parseMoney(d.Text)
            if val >= 1000 then return val, d.Text end
        end
        if d:IsA("BillboardGui") then
            for _,t in pairs(d:GetDescendants()) do
                if t:IsA("TextLabel") and t.Text:find("%$") then
                    local val = parseMoney(t.Text)
                    if val >= 1000 then return val, t.Text end
                end
            end
        end
    end
    return 0, ""
end

local Found = {}
local function addItem(model, inc, rawText)
    if Found[model] then return end
    if inc < CONFIG.MIN then return end
    Found[model] = true
    
    local Card = Instance.new("Frame", Feed)
    Card.Size = UDim2.new(1,-10,0,62)
    Card.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Card.BorderSizePixel = 0
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,10)
    Card.LayoutOrder = -inc
    
    local Name = Instance.new("TextLabel", Card)
    Name.Size = UDim2.new(0.55,0,0,32)
    Name.Position = UDim2.new(0,12,0,5)
    Name.BackgroundTransparency = 1
    Name.Text = model.Name
    Name.TextColor3 = Color3.new(1,1,1)
    Name.Font = Enum.Font.GothamBold
    Name.TextSize = 13
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.TextTruncated = true
    
    local IncLabel = Instance.new("TextLabel", Card)
    IncLabel.Size = UDim2.new(0.55,0,0,18)
    IncLabel.Position = UDim2.new(0,12,0,32)
    IncLabel.BackgroundTransparency = 1
    IncLabel.Text = rawText.." | "..string.format("%.2f B/s", inc/1e9)
    IncLabel.TextColor3 = CONFIG.COLOR
    IncLabel.Font = Enum.Font.GothamBold
    IncLabel.TextSize = 12
    IncLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TPBtn = Instance.new("TextButton", Card)
    TPBtn.Size = UDim2.new(0,75,0,34)
    TPBtn.Position = UDim2.new(1,-85,0.5,-17)
    TPBtn.BackgroundColor3 = CONFIG.COLOR
    TPBtn.Text = "TELEPORT"
    TPBtn.TextColor3 = Color3.fromRGB(0,0,0)
    TPBtn.Font = Enum.Font.GothamBlack
    TPBtn.TextSize = 10
    Instance.new("UICorner", TPBtn).CornerRadius = UDim.new(0,8)
    TPBtn.MouseButton1Click:Connect(function()
        local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if part then LP.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,5,0) end
    end)
    
    local HL = Instance.new("Highlight", model)
    HL.FillColor = CONFIG.COLOR
    HL.OutlineColor = Color3.new(1,1,1)
    
    Feed.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y + 10)
end

local function SCAN_ALL()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") then
            if obj.Name:len() > 2 then
                local inc, txt = getIncome(obj)
                if inc >= CONFIG.MIN then addItem(obj, inc, txt) end
            end
        end
    end
end

-- LIVE
SCAN_ALL()
Workspace.DescendantAdded:Connect(function(d) task.wait(0.7) if d:IsA("Model") then local i,t=getIncome(d) if i>=CONFIG.MIN then addItem(d,i,t) end end end)
task.spawn(function() while true do task.wait(CONFIG.REFRESH) SCAN_ALL() end end)
print("[VANZZ SCRIPTER V8] LOADED - MIN "..CONFIG.MIN)
