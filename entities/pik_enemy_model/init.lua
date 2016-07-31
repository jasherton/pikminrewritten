//Lul, look at this tiny SEnt.  I found this to be the easiest way to do the animations.
//All I do is set the  .Anim  variable from the actual Pikmin and the animation will change.

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include('shared.lua');

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetColor(Color(255, 255, 255, 255));
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:EnableCollisions(false);
		phys:EnableDrag(false);
		phys:EnableGravity(false);
		phys:Wake();
	end
end

function ENT:Think()
	self:NextThink(CurTime());
	return true;
end
