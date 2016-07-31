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
	self:SetModel("models/brewstersmodels/pikmin3/bridge_pile.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:DrawShadow( false )
	--self:SetMaterial("models/shiny");
	--local rnd = math.random(0, 2);
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	end
end

ENT.partsnumber = 6

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 16));
	local ent = ents.Create("pik_bridgeparts");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Bridge Parts");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:GetParts()
	if (self.partsnumber) then
		return tonumber(self.partsnumber);
	end
	return nil;
end

function ENT:SetRow(amount)
	if (self.partsnumber) then
		self.partsnumber = amount
	end
	return nil;
end
--side note: each bridge part = + 0.16666666666666666666666666666667

function ENT:StartTouch(thing)
end

function ENT:Think()

if (self.partsnumber == 0) then
self:Remove()
end

for k, thing in pairs(ents.GetAll()) do
if (thing:IsPlayer() and self.partsnumber > 0) then
			victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 150) then
			local physamount = {}
			for k, v in pairs(ents.FindByClass("pik_bridgepart")) do
			table.insert(physamount, v)
			end
			if (table.Count(physamount) > 5) then
			print("OHH HELLL NAOOOOOOO")
			end
			if (table.Count(physamount) < 6) then
			timer.Create( "UniqueName1", 0.1, 1, function()
						local dir = (thing:GetPos());
					rand = math.random(-15, 15)
					dir = (dir + Vector(rand, rand, 85));
					local part = ents.Create("pik_bridgepart")
					part:SetPos(dir)
					part:Spawn()
					self.partsnumber = self.partsnumber-1
					end)
					end
					end
end
physamount = {}
if (thing:GetClass() == "pikmin") then
			victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 150) then
			for k, v in pairs(ents.FindByClass("pik_bridgepart")) do
			table.insert(physamount, v)
			end
			if (table.Count(physamount) > 5) then
			print("OHH HELLL NAOOOOOOO")
			end
			if (table.Count(physamount) < 6) then
			timer.Create( "UniqueName1", 0.1, 1, function()
						local dir = (thing:GetPos());
					rand = math.random(-15, 15)
					dir = (dir + Vector(rand, rand, 30));
					local part = ents.Create("pik_bridgepart")
					part:SetPos(dir)
					part:Spawn()
					self.partsnumber = self.partsnumber-1
					thing.AtkTarget = part
					end)
				for k,v in pairs(ents.FindByClass("pik_bridge")) do
	victimpos = thing:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist < 1000) then
			thing.AtkTarget = v
			else
			thing.AtkTarget = nil
	end
	end
					end
					end
else
victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 150) then
thing.AtkTarget = nil
end
end
--constraint.NoCollide( self, thing, 0, 0 )
end
self:NextThink(CurTime());  return true;
end