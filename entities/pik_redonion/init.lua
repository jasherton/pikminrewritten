//Template for code block comments
//Template for code block comments
/*****************************************

******************************************/


AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include('shared.lua');
AddCSLuaFile();


/*****************************************
Initialize and spawn functions
Gotta have these, or we have no SEnt!
******************************************/

function ENT:Initialize()
	self:SetModel("models/pikmin/onion.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self.ent2 = ents.Create("prop_physics")
	if (file.Exists("oniondata/redonionleaf.txt", "DATA")) then
	local file2 = file.Read("oniondata/redonionleaf.txt", "DATA");
				local file3 = string.Explode(" ", file2);
				self.piknumberleaf = tonumber(file3[1])
				else
				self.piknumberleaf = 0
				--nothing
				end
	if (file.Exists("oniondata/redonionbud.txt", "DATA")) then
				local file02 = file.Read("oniondata/redonionbud.txt", "DATA");
				local file03 = string.Explode(" ", file02);
				self.piknumberbud = tonumber(file03[1])
				else
				self.piknumberbud = 0
				--nothing
				end
	if (file.Exists("oniondata/redonionflower.txt", "DATA")) then
				local file002 = file.Read("oniondata/redonionflower.txt", "DATA");
				local file003 = string.Explode(" ", file002);
				self.piknumberflower = tonumber(file003[1])
				else
				self.piknumberflower = 0
				--nothing
				end
				self.piknumber = self.piknumberleaf + self.piknumberbud + self.piknumberflower
	self.CallOutPikis = true
	self.absorbing = false
	self.check = true
	self.bootup = false
	--self:SetMaterial("models/shiny");
	--local rnd = math.random(0, 2);
	self:SetSkin(2)
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	end
	self.AutomaticFrameAdvance = true
	time = CurTime()
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 16));
	local ent = ents.Create("pik_redonion");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("red Onion");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:GetPikAmountLeaf()
	if (self.piknumberleaf) then
		return tonumber(self.piknumberleaf);
	end
	return nil;
end

function ENT:GetPikAmountBud()
	if (self.piknumberbud) then
		return tonumber(self.piknumberbud);
	end
	return nil;
end

function ENT:GetPikAmountFlw()
	if (self.piknumberflower) then
		return tonumber(self.piknumberflower);
	end
	return nil;
end

function ENT:SetPikAmountLeaf(amount)
	if (self.piknumberleaf) then
		self.piknumberleaf = amount
	end
	return nil;
end

function ENT:SetPikAmountBud(amount)
	if (self.piknumberbud) then
		self.piknumberbud = amount
	end
	return nil;
end

function ENT:SetPikAmountFlw(amount)
	if (self.piknumberflower) then
		self.piknumberflower = amount
	end
	return nil;
end

function ENT:CanCall()
	if (self.CallOutPikis) then
		return tobool(self.CallOutPikis);
	end
	return nil;
end

function ENT:OnRemove()
if (IsValid( self.ent2 )) then
self.ent2:Remove()
else
-- non-existant
end
end

function ENT:flyoff()
if (IsValid( self.ent2 )) then
self.ent2:Remove()
else
-- non-existant
end
self:SetPlaybackRate( -0.5 )
self:ResetSequence( 2 )
if (CurTime() - time >= 1) then

if (file.IsDir( "oniondata", "DATA" )) then
file.Write( "oniondata/redonionleaf.txt", tostring(self.piknumberleaf))
file.Write( "oniondata/redonionbud.txt", tostring(self.piknumberbud))
file.Write( "oniondata/redonionflower.txt", tostring(self.piknumberflower))
else
file.CreateDir( "oniondata" )
file.Write( "oniondata/redonionleaf.txt", tostring(self.piknumberleaf))
file.Write( "oniondata/redonionbud.txt", tostring(self.piknumberbud))
file.Write( "oniondata/redonionflower.txt", tostring(self.piknumberflower))
end

if (CurTime() - time >= 2.7) then
self:Remove()
end
end
end

function ENT:Boot()
if (IsValid( self.ent2 )) then
self.ent2:SetColor(Color(self:GetColor().r, self:GetColor().g, self:GetColor().b, 0))
else
-- non-existant
end
self:SetPos(Vector(self:GetPos().x, self:GetPos().y,self:GetPos().z-180))
self:SetColor(Color(10, 10, 10, 255))
local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
self:ResetSequence( 64 )
end

function ENT:BootUp()
if (IsValid( self.ent2 )) then
self.ent2:SetColor(Color(self:GetColor().r, self:GetColor().g, self:GetColor().b, 0))
else
-- non-existant
end
if (CurTime() - time >= 1) then
self:SetPos(Vector(self:GetPos().x, self:GetPos().y,self:GetPos().z+180))
self:SetColor(Color(10, 10, 10, 255))
self:ResetSequence( 3 )
local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:EnableMotion(true)
		phys:Wake()
	end
end
if (CurTime() - time >= 4) then
	self:ResetSequence( 64 )
	self:SetColor(Color(255, 255, 255, 255))
		if (CurTime() - time >= 8) then
	if (IsValid( self.ent2 )) then
self.ent2:SetColor(Color(self:GetColor().r, self:GetColor().g, self:GetColor().b, 255))
else
-- non-existant
end
end
	end
if (CurTime() - time >= 8) then
self.bootup = -1
end
end

function ENT:Think()

if (file.IsDir( "oniondata", "DATA" )) then
if (self.piknumberleaf > 0) then
file.Write( "oniondata/redonionleaf.txt", tostring(self.piknumberleaf))
else
file.Write( "oniondata/redonionleaf.txt", "0")
end
if (self.piknumberbud > 0) then
file.Write( "oniondata/redonionbud.txt", tostring(self.piknumberbud))
else
file.Write( "oniondata/redonionbud.txt", "0")
end
if (self.piknumberflower > 0) then
file.Write( "oniondata/redonionflower.txt", tostring(self.piknumberflower))
else
file.Write( "oniondata/redonionflower.txt", "0")
end
else
file.CreateDir( "oniondata" )
if (self.piknumberleaf > 0) then
file.Write( "oniondata/redonionleaf.txt", tostring(self.piknumberleaf))
else
file.Write( "oniondata/redonionleaf.txt", "0")
end
if (self.piknumberbud > 0) then
file.Write( "oniondata/redonionbud.txt", tostring(self.piknumberbud))
else
file.Write( "oniondata/redonionbud.txt", "0")
end
if (self.piknumberflower > 0) then
file.Write( "oniondata/redonionflower.txt", tostring(self.piknumberflower))
else
file.Write( "oniondata/redonionflower.txt", "0")
end
end

self.ent2:SetModel("models/anti-noclip_field/cone.mdl")
	self.ent2:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z - 350))
	self.ent2:SetAngles(Angle(0, 0, 0))
	self.ent2:SetCollisionGroup( 10 )
	self.ent2:SetColor(Color(255, 0, 0))
	self.ent2:Spawn()
	self.ent2:Activate()
	
	self:SetSkin(2)

if (!self.absorbing) then
if (self.piknumber == 0 or self.piknumber > 0) then
self:ResetSequence( 1 )
self.CallOutPikis = true
end
if (self.piknumber > 99) then
self:ResetSequence( 0 )
self.CallOutPikis = true
end
if (self.piknumber == -64) then
self:ResetSequence( 3 )
self.CallOutPikis = false
end
end
for k,v in pairs(ents.FindByClass("pik_corpse")) do
local mypos = self:GetPos()
local thatpos = v:GetPos()
local dist = mypos:Distance(thatpos)
if (dist <= 100) then
self.absorbing = true
v:GetPhysicsObject():EnableMotion(false)
constraint.RemoveAll( v )
local model = v:GetRagModel()
local modelname = model:GetModel()
model:SetModelScale( model:GetModelScale() / 9, 1 )
v:SetPos(Vector(v:GetPos().x, v:GetPos().y, v:GetPos().z+1))
v:SetCollisionGroup( 10 )
timer.Create( "flyup", 0.1, 6, function()
v:SetPos(Vector(self:GetPos().x, self:GetPos().y, v:GetPos().z+15))
end)
timer.Create( "playanim", 0.7, 1, function( )
self:ResetSequence( 4 )
end)
timer.Create( "stopanim", 2, 1, function( )
self:ResetSequence( 1 )
end)
timer.Create( "expel", 1, 1, function( )
self:ResetSequence( 3 )
end)
timer.Create( "makeseeds", 2, 1, function( )
if (modelname == "models/jasherton/pikmin2/bulborb/bulborb.mdl") then
local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
local pluck = ents.Create("pik_pluckred");
			local pluck2 = ents.Create("pik_pluckred");
			local pluck3 = ents.Create("pik_pluckred");
			local pluck4 = ents.Create("pik_pluckred");
			local pluck5 = ents.Create("pik_pluckred");
			local pluck6 = ents.Create("pik_pluckred");
			local pluck7 = ents.Create("pik_pluckred");
			local pluck8 = ents.Create("pik_pluckred");
			local pluck9 = ents.Create("pik_pluckred");
			local pluck10 = ents.Create("pik_pluckred");
			local pluck11 = ents.Create("pik_pluckred");
			local pluck12 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck ) ) then return end
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck6:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck7:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck8:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck9:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck10:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck11:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck12:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck:Spawn()
			pluck2:Spawn()
			pluck3:Spawn()
			pluck4:Spawn()
			pluck5:Spawn()
			pluck6:Spawn()
			pluck7:Spawn()
			pluck8:Spawn()
			pluck9:Spawn()
			pluck10:Spawn()
			pluck11:Spawn()
			pluck12:Spawn()
			v:Remove()
end

if (modelname == "models/jasherton/pikmin2/giant_breadbug.mdl") then
local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
local pluck = ents.Create("pik_pluckred");
			local pluck2 = ents.Create("pik_pluckred");
			local pluck3 = ents.Create("pik_pluckred");
			local pluck4 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck ) ) then return end
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck:Spawn()
			pluck2:Spawn()
			pluck3:Spawn()
			pluck4:Spawn()
			v:Remove()
end

end)
timer.Create( "reset", 2, 1, function( )
self.absorbing = false
end)
end
end
for k,v in pairs(ents.FindByClass("pik_gbreadbug")) do
local mypos = self:GetPos()
local thatpos = v:GetPos()
local dist = mypos:Distance(thatpos)
local object = v:GetObj()
if (object == nil) then
--nothing to check for!
else
if (dist <= 110) then
if (object:GetClass() == "pik_pellet") then
v:SetCollisionGroup( 10 )
v:SetPos(Vector(v:GetPos().x, v:GetPos().y, v:GetPos().z+50))
constraint.RemoveAll( v )
v:TakeDamage( 701, self, self )
end
end
end
end
for k,v in pairs(ents.FindByClass("pik_pellet")) do
local mypos = self:GetPos()
local thatpos = v:GetPos()
local dist = mypos:Distance(thatpos)
if (dist <= 100 and !self.absorbing) then
self.check = true
self.absorbing = true
v:GetPhysicsObject():EnableMotion(false)
constraint.RemoveAll( v )
v:SetModelScale( v:GetModelScale() / 9, 1 )
v:SetCollisionGroup( 10 )
v:SetPos(Vector(v:GetPos().x, v:GetPos().y, v:GetPos().z+1))
timer.Create( "flyup", 0.1, 9, function()
v:SetPos(Vector(self:GetPos().x, self:GetPos().y, v:GetPos().z+15))
end)
timer.Create( "playanim"  , 1.1, 1, function( )
self:ResetSequence( 4 )
end)
timer.Create( "stopanim", 2, 1, function( )
self:ResetSequence( 1 )
end)
timer.Create( "expel", 1, 1, function( )
self:ResetSequence( 3 )
end)
timer.Create( "makeseeds", 1, 1, function()
if (v:GetSkin() == 2) then
local pluck3 = ents.Create("pik_pluckred");
local pluck4 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck3 ) ) then return end
			local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:Spawn()
			v:Remove()
			else
			local pluck3 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck3 ) ) then return end
			local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:Spawn()
			v:Remove()
			end
			end)
timer.Create( "reset", 1, 1, function( )
self.check = false
self.absorbing = false
end)
end
end
for k,v in pairs(ents.FindByClass("pik_pellet5")) do
local mypos = self:GetPos()
local thatpos = v:GetPos()
local dist = mypos:Distance(thatpos)
if (dist <= 100 and !self.absorbing) then
self.check = true
self.absorbing = true
v:GetPhysicsObject():EnableMotion(false)
constraint.RemoveAll( v )
v:SetCollisionGroup( 10 )
v:SetPos(Vector(v:GetPos().x, v:GetPos().y, v:GetPos().z+1))
v:SetModelScale( v:GetModelScale() / 12, 1 )
timer.Create( "flyup", 0.1, 9, function()
v:SetPos(Vector(self:GetPos().x, self:GetPos().y, v:GetPos().z+15))
end)
timer.Create( "playanim", 0.7, 1, function( )
self:ResetSequence( 4 )
end)
timer.Create( "stopanim", 2, 1, function( )
self:ResetSequence( 1 )
end)
timer.Create( "expel", 1, 1, function( )
self:ResetSequence( 3 )
end)
timer.Create( "makeseeds", 1, 1, function()
if (v:GetSkin() == 2) then
local pluck3 = ents.Create("pik_pluckred");
local pluck4 = ents.Create("pik_pluckred");
local pluck5 = ents.Create("pik_pluckred");
local pluck6 = ents.Create("pik_pluckred");
local pluck7 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck3 ) ) then return end
			local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck5:Spawn()
			pluck6:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck6:Spawn()
			pluck7:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck7:Spawn()
			v:Remove()
			else
			local pluck3 = ents.Create("pik_pluckred");
			local pluck4 = ents.Create("pik_pluckred");
			local pluck5 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck3 ) ) then return end
			local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck5:Spawn()
			v:Remove()
			end
			end)
timer.Create( "reset", 1, 1, function( )
self.check = false
self.absorbing = false
end)
end
end
for k,v in pairs(ents.FindByClass("pik_pellet10")) do
local mypos = self:GetPos()
local thatpos = v:GetPos()
local dist = mypos:Distance(thatpos)
if (dist <= 100 and !self.absorbing) then
self.check = true
self.absorbing = true
v:GetPhysicsObject():EnableMotion(false)
constraint.RemoveAll( v )
v:SetCollisionGroup( 10 )
v:SetPos(Vector(v:GetPos().x, v:GetPos().y, v:GetPos().z+1))
v:SetModelScale( v:GetModelScale() / 100, 1 )
timer.Create( "flyup", 0.1, 9, function()
v:SetPos(Vector(self:GetPos().x, self:GetPos().y, v:GetPos().z+15))
end)
timer.Create( "playanim", 0.7, 1, function( )
self:ResetSequence( 4 )
end)
timer.Create( "stopanim", 2, 1, function( )
self:ResetSequence( 1 )
end)
timer.Create( "expel", 1, 1, function( )
self:ResetSequence( 3 )
end)
timer.Create( "makeseeds", 1, 1, function()
if (v:GetSkin() == 2) then
local pluck3 = ents.Create("pik_pluckred");
local pluck4 = ents.Create("pik_pluckred");
local pluck5 = ents.Create("pik_pluckred");
local pluck6 = ents.Create("pik_pluckred");
local pluck7 = ents.Create("pik_pluckred");
local pluck8 = ents.Create("pik_pluckred");
local pluck8 = ents.Create("pik_pluckred");
local pluck9 = ents.Create("pik_pluckred");
local pluck10 = ents.Create("pik_pluckred");
local pluck11 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck3 ) ) then return end
			local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck5:Spawn()
			pluck6:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck6:Spawn()
			pluck7:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck7:Spawn()
			pluck8:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck8:Spawn()
			pluck9:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck9:Spawn()
			pluck10:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck10:Spawn()
			pluck11:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck11:Spawn()
			v:Remove()
			else
			local pluck3 = ents.Create("pik_pluckred");
			local pluck4 = ents.Create("pik_pluckred");
			local pluck5 = ents.Create("pik_pluckred");
			local pluck6 = ents.Create("pik_pluckred");
			local pluck7 = ents.Create("pik_pluckred");
			if ( !IsValid( pluck3 ) ) then return end
			local rnd = math.random(100, 200);
			local rnd2 = math.random(-100, -200);
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck5:Spawn()
			pluck6:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck6:Spawn()
			pluck7:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-35 ))
			pluck7:Spawn()
			v:Remove()
			end
			end)
timer.Create( "reset", 1, 1, function( )
self.check = false
self.absorbing = false
end)
end
end
for k,v in pairs(ents.FindByClass("pikmin")) do
local mypos = self:GetPos()
local thatpos = v:GetPos()
local dist = mypos:Distance(thatpos)
if (dist <= 50 and !self.absorbing) then
if (self.check == false) then
v.AtkTarget = nil
end
end
end
self:NextThink(CurTime() + 0.25);  return true;
end