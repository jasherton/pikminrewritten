AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = false

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/pikmin/pikmin_collision.mdl");
	self.Entity:SetCollisionGroup( 10 ) -- I'm a hallucination so I shouldn't collide with anything but bullets/projectiles
end

function ENT:GetEnemy()
	return self.Enemy 
end
function ENT:SetEnemy(ent)
	self.Enemy = ent 
end

function ENT:HaveEnemy()
	if (self:GetEnemy() and IsValid(self:GetEnemy())) then 
		return true 
	end
end

function ENT:RunBehaviour()
	while true do
	if ( self:HaveEnemy() )then
		self.loco:SetDesiredSpeed(62.5)
		self:ChaseEnemy()
	end
	coroutine.wait(2)
end
end

function ENT:ChaseEnemy(options)
	local options = options or {}
	local path = Path("Follow")
	path:SetMinLookAheadDistance(options.lookahead or 300)
	path:SetGoalTolerance(options.tolerance or 20)
	path:Compute(self, self:GetEnemy():GetPos())
	if (!path:IsValid()) then return "failed" end
	while (path:IsValid() and self:HaveEnemy()) do

		if (path:GetAge() > 1) then	
			path:Compute(self, self:GetEnemy():GetPos())
		end
		path:Update(self)	
		if (options.draw) then path:Draw() end
		if (self.loco:IsStuck()) then
			self:HandleStuck()
			return "stuck"
		end	
		
		local _ents = ents.FindInSphere( self:GetPos(), 0.1 )
		for k,v in pairs(_ents) do
			if v == self:GetEnemy() then
				local _entsp = ents.FindInSphere( self:GetPos(), 0.1 )
				for k,v in pairs(_entsp) do
					if v:GetClass() == "pikmin" then
						v.IsCarrying = false
					end
				end
			end
		end
					

		
		coroutine.yield()
	end
	return "ok"
end