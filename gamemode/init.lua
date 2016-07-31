AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_pikmin.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_playmusic.lua")
AddCSLuaFile( "cl_pikmin-autorun.lua" )

include("shared.lua")
include("sv_pikmin.lua")
include("sv_pikmin-autorun.lua")


function GM:PlayerConnect( name, ip )
	print("Player: " .. name .. "has joined the game.")
end

function GM:PlayerInitialSpawn( ply )
local map = string.Replace(game.GetMap(), " ", "")
if (file.Exists("data/mapdata/" .. map .. "m.pikdata", "GAME")) then
print("map data found.")
				local file2 = file.Read("data/mapdata/" .. map .. "m.pikdata", "GAME");
				local file3 = string.Explode(" ", file2);
timer.Simple(.1, function() ply.SendLua(ply, "surface.PlaySound(tostring(file3[1]))") end);
else
print("no music")
end
	print("Player: " .. ply:Nick() .. "has spawned.")
end

function GM:PlayerAuthed( ply, steamID, uniqueID )
	print("Player: " .. ply:Nick() .. "has been authed.")
end

function LoadStuff()
timer.Simple( 2, function()
local map = string.Replace(game.GetMap(), " ", "")
if (file.Exists("data/mapdata/" .. map .. ".pikdata", "GAME")) then
print("map data found.")
				local file2 = file.Read("data/mapdata/" .. map .. ".pikdata", "GAME");
				local file3 = string.Explode(" ", file2);
				
timer.Simple( 2, function()
local onionr = ents.Create("pik_redonion")
onionr:SetPos(Vector(file3[1], file3[2], file3[3]))
onionr:Spawn()
local redpik0 = ents.Create("pik_pluckred")
redpik0:SetPos(Vector(file3[4], file3[5], file3[6]))
redpik0:Spawn()

local oniony = ents.Create("pik_yellowonion")
oniony:SetPos(Vector(file3[7], file3[8], file3[9]))
oniony:Spawn()
local ypik0 = ents.Create("pik_pluckyellow")
ypik0:SetPos(Vector(file3[10], file3[11], file3[12]))
ypik0:Spawn()

local onionb = ents.Create("pik_blueonion")
onionb:SetPos(Vector(file3[13], file3[14], file3[15]))
onionb:Spawn()
local bpik0 = ents.Create("pik_pluckblue")
bpik0:SetPos(Vector(file3[16], file3[17], file3[18]))
bpik0:Spawn()
end )

else
print("no map data")
end
end)

timer.Simple( 2, function()
local map = string.Replace(game.GetMap(), " ", "")
if (file.Exists("data/mapdata/" .. map .. "_pellet.pikdata", "GAME")) then
print("pellet data found.")
				local file4 = file.Read("data/mapdata/" .. map .. "_pellet.pikdata", "GAME");
				local file5 = string.Explode(" ", file4);
timer.Simple( 2, function()
local pellet = ents.Create("" .. string.Replace(file5[1], " ", "") .. "")
pellet:SetPos(Vector(file5[2], file5[3], file5[4]))
pellet:Spawn()
local pellet2 = ents.Create("" .. string.Replace(file5[5], " ", "") .. "")
pellet2:SetPos(Vector(file5[6], file5[7], file5[8]))
pellet2:Spawn()
local pellet3 = ents.Create("" .. string.Replace(file5[9], " ", "") .. "")
pellet3:SetPos(Vector(file5[10], file5[11], file5[12]))
pellet3:Spawn()
local pellet4 = ents.Create("" .. string.Replace(file5[13], " ", "") .. "")
pellet4:SetPos(Vector(file5[14], file5[15], file5[16]))
pellet4:Spawn()
local pellet5 = ents.Create("" .. string.Replace(file5[17], " ", "") .. "")
pellet5:SetPos(Vector(file5[18], file5[19], file5[20]))
pellet5:Spawn()
local pellet6 = ents.Create("" .. string.Replace(file5[21], " ", "") .. "")
pellet6:SetPos(Vector(file5[22], file5[23], file5[24]))
pellet6:Spawn()
end )

else
print("no pellet data")
end
end)
end

function LaunchTimer() // Music System Start

	local musicnumber = math.random(1,26)
	local duration = musicnumber
	timer.Create( "MusicLoop", duration, 0, UpdateTimer)
	umsg.Start( "umsg_music" );
		umsg.String(musicnumber)
	umsg.End();
end

function UpdateTimer(var) // Music System update
	local musicnumber = math.random(1,26)
	local duration = musicnumber
	timer.Adjust( "MusicLoop", duration, 0, UpdateTimer)
	umsg.Start( "umsg_music" );
		umsg.String(musicnumber)
	umsg.End();
end

LoadStuff()