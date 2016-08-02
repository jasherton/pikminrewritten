//Template for code block comments
//Template for code block comments
/*****************************************

******************************************/


AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include('shared.lua');


/*****************************************
Initialize and spawn functions
Gotta have these, or we have no SEnt!
******************************************/

function ENT:Initialize()
	self:SetModel("models/pikmin/props/candypop_bud.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self.transfer = false
	self.color = nil
	self.inamount = 0
	self.start = false
	local rnd = math.random(0, 4);
	self:SetSkin( rnd )
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 1));
	local ent = ents.Create("pik_bud");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Candypop Bud");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:Think()
if (self.transfer == false and self.inamount < 5) then
for k, v in pairs(ents.FindByClass("pikmin")) do
local thepos = v:GetPos()
local mypos = self:GetPos()
local dist = mypos:Distance(thepos)
if (dist <= 100 and v.JustThrown) then
v:EmitSound("pikmin/cry.mp3", 100, 100)
v:Remove()
self.inamount = self.inamount+1
end
end
end
if (self.inamount == 5 and self.start == false) then
self.start = true
timer.Create("close", 0, 1, function()
self:EmitSound("pikmin/bud/close.mp3", 100, 100)
self:SetModel("models/pikmin/props/candypop_bud_closed.mdl")
end)
timer.Create("begin", 1, 1, function()
local skinnum = tonumber(self:GetSkin())
if (skinnum == 0) then
self.color = "red"
local pluck = ents.Create("pik_pluck" .. self.color);
local pluck2 = ents.Create("pik_pluck" .. self.color);
local pluck3 = ents.Create("pik_pluck" .. self.color);
local pluck4 = ents.Create("pik_pluck" .. self.color);
local pluck5 = ents.Create("pik_pluck" .. self.color);
			if ( !IsValid( pluck ) ) then return end
			local rnd = math.random(100, 150);
			local rnd2 = math.random(-50, -100);
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck:Spawn()
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck2:Spawn()
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck5:Spawn()
end
if (skinnum == 1) then
self.color = "blue"
local pluck = ents.Create("pik_pluck" .. self.color);
local pluck2 = ents.Create("pik_pluck" .. self.color);
local pluck3 = ents.Create("pik_pluck" .. self.color);
local pluck4 = ents.Create("pik_pluck" .. self.color);
local pluck5 = ents.Create("pik_pluck" .. self.color);
			if ( !IsValid( pluck ) ) then return end
			local rnd = math.random(100, 150);
			local rnd2 = math.random(-50, -100);
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck:Spawn()
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck2:Spawn()
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck5:Spawn()
end
if (skinnum == 2) then
self.color = "yellow"
local pluck = ents.Create("pik_pluck" .. self.color);
local pluck2 = ents.Create("pik_pluck" .. self.color);
local pluck3 = ents.Create("pik_pluck" .. self.color);
local pluck4 = ents.Create("pik_pluck" .. self.color);
local pluck5 = ents.Create("pik_pluck" .. self.color);
			if ( !IsValid( pluck ) ) then return end
			local rnd = math.random(100, 150);
			local rnd2 = math.random(-50, -100);
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck:Spawn()
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck2:Spawn()
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck5:Spawn()
end
if (skinnum == 3) then
self.color = "purple"
local pluck = ents.Create("pik_pluck" .. self.color);
local pluck2 = ents.Create("pik_pluck" .. self.color);
local pluck3 = ents.Create("pik_pluck" .. self.color);
local pluck4 = ents.Create("pik_pluck" .. self.color);
local pluck5 = ents.Create("pik_pluck" .. self.color);
			if ( !IsValid( pluck ) ) then return end
			local rnd = math.random(100, 150);
			local rnd2 = math.random(-50, -100);
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-42 ))
			pluck:Spawn()
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-42 ))
			pluck2:Spawn()
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-42 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-42 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-42 ))
			pluck5:Spawn()
end
if (skinnum == 4) then
self.color = "white"
local pluck = ents.Create("pik_pluck" .. self.color);
local pluck2 = ents.Create("pik_pluck" .. self.color);
local pluck3 = ents.Create("pik_pluck" .. self.color);
local pluck4 = ents.Create("pik_pluck" .. self.color);
local pluck5 = ents.Create("pik_pluck" .. self.color);
			if ( !IsValid( pluck ) ) then return end
			local rnd = math.random(100, 150);
			local rnd2 = math.random(-50, -100);
			pluck:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck:Spawn()
			pluck2:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck2:Spawn()
			pluck3:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck3:Spawn()
			pluck4:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck4:Spawn()
			pluck5:SetPos( Vector( (self:GetPos().x)+rnd+rnd2,(self:GetPos().y)+rnd+rnd2,(self:GetPos().z)-36 ))
			pluck5:Spawn()
end
end)
timer.Create("kill", 1, 1, function()
self:EmitSound("pikmin/bud/wither.mp3", 100, 100)
self:SetModel("models/pikmin/props/candypop_bud.mdl")
end)
timer.Create("shrink", 0.1, 15, function()
self:SetCollisionGroup( 10 )
self:SetModel("models/pikmin/props/candypop_bud.mdl")
self:ManipulateBoneScale( 0, Vector(self:GetManipulateBoneScale( 0 ).x / 2, self:GetManipulateBoneScale( 0 ).y / 2, self:GetManipulateBoneScale( 0 ).z / 2))
end)
timer.Create("truelydead", 1.6, 1, function()
self:Remove()
end)
end
self:NextThink(CurTime() + 0.25);  return true;
end