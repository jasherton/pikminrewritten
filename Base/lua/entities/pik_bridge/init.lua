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
	self:SetModel("models/brewstersmodels/pikmin3/Bridge.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:DrawShadow( false )
	rownumber = 0
	--self:SetMaterial("models/shiny");
	--local rnd = math.random(0, 2);
	self:SetBodygroup( 1, rownumber )
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
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 16));
	local ent = ents.Create("pik_bridge");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Bridge");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:GetRow()
	if (rownumber) then
		return tonumber(rownumber);
	end
	return nil;
end

function ENT:SetRow(amount)
	if (rownumber) then
		rownumber = amount
	end
	return nil;
end
--side note: each bridge part = + 0.16666666666666666666666666666667

function ENT:StartTouch(thing)
end

function ENT:Think()

print(rownumber)

for k, thing in pairs(ents.GetAll()) do
if (thing:IsPlayer() and rownumber < 9) then
			victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 200) then
						local dir = (thing:GetPos() - self:GetPos());
					dir = (dir + Vector(5, 5, -100));
					thing:SetVelocity( dir * 2 )
					end
end
if (thing:GetClass() == "pik_bridgepart" and rownumber < 9) then
			victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 220) then
			thing:Remove()
			rownumber = rownumber+0.16666666666666666666666666666667
					end
end
if (thing:GetClass() == "pikmin" and rownumber < 9) then
if (thing.AtkTarget == self) then
--it's coming with a part! dont push it away!
victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 200) then
			for k,v in pairs(ents.FindByClass("pik_bridgeparts")) do
			victimpos = thing:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 2000) then
			thing.AtkTarget = v
			end
			end
			end
else
			victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 200) then
									local phys = thing:GetPhysicsObject();
						if (phys:IsValid()) then
						local dir = (thing:GetPos() - self:GetPos());
					dir = (dir + Vector(1, 1, -100));
					phys:ApplyForceCenter( dir * 2 )
						end
end
end
--constraint.NoCollide( self, thing, 0, 0 )
end

if (thing:GetClass() == "pikmin" and rownumber == 9) then
if (thing.AtkTarget == self) then
--bridge is finished. don't collect anymore parts and remove targets.
victimpos = self:GetPos()
			targetpos = thing:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 200) then
			thing.AtkTarget = nil
			for k,v in pairs(ents.FindByClass("pik_bridgeparts")) do
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist <= 200) then
			v:Remove()
			end
			end
end
end
--constraint.NoCollide( self, thing, 0, 0 )

end
end

self:SetBodygroup( 1, rownumber )

--[[if (rownumber == 0) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 1) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 2) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 3) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 4) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 5) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 6) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 7) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 8) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 9) then
self:SetBodygroup( 1, rownumber )
else
--no
end
if (rownumber == 10) then
self:SetBodygroup( 1, rownumber )
else
--no
end--]]
self:NextThink(CurTime());  return true;
end