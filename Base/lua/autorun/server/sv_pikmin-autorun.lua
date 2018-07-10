include("sv_pikmin.lua");
include("pik_loadmap.lua")

local pik_load = GetConVar("sv_pikmin_mapload")

if IsValid(pik_load) then
print("test")
if pik_load:GetInt() == 1 then
LoadMapData()
end
end