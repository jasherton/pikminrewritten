function loadupmap()
timer.Simple( 2, function()
local map = string.Replace(game.GetMap(), " ", "")
if (file.Exists("lua/" .. map .. ".lua", "GAME")) then
print("map data found.")
				local file2 = file.Read("lua/" .. map .. ".lua", "GAME");
				local file3 = string.Explode(" ", file2);
				
timer.Simple( 2, function()
local onionr = ents.Create("pik_redonion")
onionr:SetPos(Vector(file3[2], file3[3], file3[4]))
onionr:Spawn()
local redpik0 = ents.Create("pik_pluckred")
redpik0:SetPos(Vector(file3[5], file3[6], file3[7]))
redpik0:Spawn()

local oniony = ents.Create("pik_yellowonion")
oniony:SetPos(Vector(file3[8], file3[9], file3[10]))
oniony:Spawn()
local ypik0 = ents.Create("pik_pluckyellow")
ypik0:SetPos(Vector(file3[11], file3[12], file3[13]))
ypik0:Spawn()

local onionb = ents.Create("pik_blueonion")
onionb:SetPos(Vector(file3[14], file3[15], file3[16]))
onionb:Spawn()
local bpik0 = ents.Create("pik_pluckblue")
bpik0:SetPos(Vector(file3[17], file3[18], file3[19]))
bpik0:Spawn()
end )

else
print("no map data")
end
end)

timer.Simple( 2, function()
local map = string.Replace(game.GetMap(), " ", "")
if (file.Exists("lua/" .. map .. "_pellet.lua", "GAME")) then
print("pellet data found.")
				local file4 = file.Read("lua/" .. map .. "_pellet.lua", "GAME");
				local file5 = string.Explode(" ", file4);
timer.Simple( 2, function()
local pellet = ents.Create("" .. string.Replace(file5[2], " ", "") .. "")
pellet:SetPos(Vector(file5[3], file5[4], file5[5]))
pellet:Spawn()
local pellet2 = ents.Create("" .. string.Replace(file5[6], " ", "") .. "")
pellet2:SetPos(Vector(file5[7], file5[8], file5[9]))
pellet2:Spawn()
local pellet3 = ents.Create("" .. string.Replace(file5[10], " ", "") .. "")
pellet3:SetPos(Vector(file5[11], file5[12], file5[13]))
pellet3:Spawn()
local pellet4 = ents.Create("" .. string.Replace(file5[14], " ", "") .. "")
pellet4:SetPos(Vector(file5[15], file5[16], file5[17]))
pellet4:Spawn()
local pellet5 = ents.Create("" .. string.Replace(file5[18], " ", "") .. "")
pellet5:SetPos(Vector(file5[19], file5[20], file5[21]))
pellet5:Spawn()
local pellet6 = ents.Create("" .. string.Replace(file5[22], " ", "") .. "")
pellet6:SetPos(Vector(file5[23], file5[24], file5[25]))
pellet6:Spawn()
end )

else
print("no pellet data")
end
end)
end

loadupmap()

function redhellpiki()
for k, pik in pairs(ents.FindByClass("pikmin_model")) do
pik:ManipulateBoneScale( 5, Vector(0, 0, 0 ))
pik:ManipulateBoneAngles( 5, Angle(0, 0, 90))
pik:ManipulateBoneAngles( 2, Angle(0, 185, 0))
pik:SetColor( Color(255, 0, 0)) 
end
end

CreateConVar( "pik_cantrip", 0, { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CHEAT }, "Enable pikmin to trip randomly." )

time = CurTime()

--timer.Simple(4, function()
--BroadcastLua("chat.AddText( Color( 255, 191, 0), 'Hurry Up! ', Color( 255, 255, 255 ), 'Gather your pikmin before the day ends.')")
--end)