local L=game:GetService("Lighting") L.GlobalShadows=true L.Brightness=2 L.ShadowDensity=0.3 L.EnvironmentDiffuseScale=0.5 L.EnvironmentSpecularScale=0.5 L.FogEnd=2000
local cc=Instance.new("ColorCorrectionEffect") cc.Saturation=0.15 cc.Contrast=0.05 cc.Parent=L
local b=Instance.new("BloomEffect") b.Intensity=0.15 b.Size=10 b.Threshold=2 b.Parent=L
print("HD RINGAN ON - Vanzz")
