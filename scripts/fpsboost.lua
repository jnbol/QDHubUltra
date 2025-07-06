-- FPS Boost
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("Texture") or v:IsA("Decal") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Enabled = false
    elseif v:IsA("BasePart") and v.Material ~= Enum.Material.SmoothPlastic then
        v.Material = Enum.Material.SmoothPlastic
    end
end
sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility)
