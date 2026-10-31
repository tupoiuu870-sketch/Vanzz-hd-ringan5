-- FPS BOOSTER V2 ULTRA 80+ LINES - ANTI LAG
-- Aman 100%, no bypass, no cheat

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local StarterGui = game:GetService("StarterGui")

-- Setting awal
local function applyLowSettings()
    -- 1. Lighting Settings
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1000000
    Lighting.FogStart = 0
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ShadowDensity = 0
    Lighting.ExposureCompensation = 0

    -- 2. Matikan semua efek
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("SunRays") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRays") then
            effect.Enabled = false
        end
    end

    -- 3. Terrain Optimization
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
        Terrain.Decoration = false
    end

    -- 4. Rendering Quality
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.EditQualityLevel = Enum.QualityLevel.Level01

    -- 5. Hilangkan shadows di part
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.Transparency = obj.Transparency -- keep original
            -- hapus texture berat
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") then
                    child:Destroy()
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
            obj.Lifetime = NumberRange.new(0)
        elseif obj:IsA("MeshPart") then
            obj.RenderFidelity = Enum.RenderFidelity.Performance
            obj.CastShadow = false
        elseif obj:IsA("SpecialMesh") then
            obj.CastShadow = false
        end
    end

    -- 6. Matikan animasi berat
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if humanoid and obj ~= Players.LocalPlayer.Character then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end
    end

    -- 7. Low material di semua
    for i = 1, 10 do
        task
