-- VANZZ SCRIPTER V6 - OFFICIAL
local LP = game.Players.LocalPlayer
pcall(function() game.CoreGui:FindFirstChild("VanzzScripter"):Destroy() end)

local MIN = 2000000000 -- MIN 2B/s
local SG = Instance.new("ScreenGui", game.CoreGui); SG.Name="VanzzScripter"
local Main = Instance.new("Frame", SG); Main.Size=UDim2.new(0,420,0,380); Main.Position=UDim2.new(0.5,-210,0.5,-190); Main.BackgroundColor3=Color3.fromRGB(10,10,10); Main.BorderSizePixel=0; Instance.new("UICorner",Main).CornerRadius=UDim.new(0,14); Main.Active=true; Main.Draggable=true
local Stroke = Instance.new("UIStroke",Main); Stroke.Color=Color3.fromRGB(0,255,120); Stroke.Thickness=2; Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

local Title = Instance.new("TextLabel", Main); Title.Size=UDim2.new(1,0,0,45); Title.BackgroundTransparency=1; Title.Text="⚡ VANZZ SCRIPTER - LIVE 2B/s+ ⚡"; Title.TextColor3=Color3.fromRGB(0,255,120); Title.Font=Enum.Font.GothamBlack; Title.TextSize=14
local Sub = Instance.new("TextLabel", Main); Sub.Size=UDim2.new(1,0,0,20); Sub.Position=UDim2.new(0,0,0,35); Sub.BackgroundTransparency=1; Sub.Text="by Vanzz | Steal an Egg"; Sub.TextColor3=Color3.fromRGB(150,150,150); Sub.Font=Enum.Font.Gotham; Sub.TextSize=10

local Feed = Instance.new("ScrollingFrame", Main); Feed.Size=UDim2.new(0,390,0,300); Feed.Position=UDim2.new(0,15,0,65); Feed.BackgroundTransparency=1; Feed.CanvasSize=UDim2.new(0,0,0,0); Feed.ScrollBarThickness=2; Feed.ScrollBarImageColor3=Color3.fromRGB(0,255,120)
local List = Instance.new("UIListLayout", Feed); List.Padding=UDim.new(0,8)

local function parseMoney(text)
    if not text then return 0 end
    local s = text:lower():gsub("%$",""):gsub("/s",""):gsub(" ",""):gsub(",","")
    local mult = 1
    if s:find("t") then mult=1e12; s=s:gsub("t","") elseif s:find("b") then mult=1e9; s=s:gsub("b","") elseif s:find("m") then mult=1e6; s=s:gsub("m","") elseif s:find("k") then mult=1e3; s=s:gsub("k","") end
    return (tonumber(s) or 0) * mult
end

local function getIncome(model)
    for _,v in pairs(model:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:find("%$") then
            local inc = parseMoney(v.Text)
            if inc > 0 then return inc, v.Text end
        end
    end
    return 0,""
end

local function addLive(model, inc, txt)
    local id = model:GetDebugId()
    if Feed:FindFirstChild(id) then return end
    if inc < MIN then return end

    local Item = Instance.new("Frame", Feed); Item.Name=id; Item.Size=UDim2.new(1,-10,0,55); Item.BackgroundColor3=Color3.fromRGB(25,25,25); Instance.new("UICorner",Item).CornerRadius=UDim.new(0,10)
    local Label = Instance.new("TextLabel", Item); Label.Size=UDim2.new(0.6,0,1,0); Label.Position=UDim2.new(0,12,0,0); Label.BackgroundTransparency=1; Label.Text=model.Name.."\n"..txt; Label.TextColor3=Color3.fromRGB(0,255,120); Label.TextXAlignment=Enum.TextXAlignment.Left; Label.Font=Enum.Font.GothamBold; Label.TextSize=12; Label.TextWrapped=true
    local TP = Instance.new("TextButton", Item); TP.Size=UDim2.new(0,65,0,32); TP.Position=UDim2.new(1,-75,0.5,-16); TP.Text="TP [VANZZ]"; TP.BackgroundColor3=Color3.fromRGB(0,255,120); TP.TextColor3=Color3.fromRGB(0,0,0); TP.Font=Enum.Font.GothamBold; TP.TextSize=11; Instance.new("UICorner",TP).CornerRadius=UDim.new(0,8)
    TP.MouseButton1Click:Connect(function()
        local p = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if p then LP
