/*TEAM GARRY'S BALLOON POP EFFECT!  MODIFIED TO NOT GO AS FAR, AND NOT PLAY THE SOUND!  THIS EFFECT IS NOT MINE!*/

/*--------------------------------------------------------- 
   Initializes the effect. The data is a table of data  
   which was passed from the server. 
---------------------------------------------------------*/ 
function EFFECT:Init( data ) 
	 
	local vOffset = data:GetOrigin() 
	local color = data:GetStart() 
	 
	local Low = vOffset - Vector(5, 5, 5 ) 
	local High = vOffset + Vector(5, 5, 5 ) 
	 
	local NumParticles = 5
	 
	local emitter = ParticleEmitter( vOffset, true ) 
	 
		for i=0, NumParticles do 
		 
			local Pos = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) ) 
		 
			local particle = emitter:Add( "particles/balloon_bit", vOffset + Pos * 8 ) 
			if (particle) then 
				 
				particle:SetVelocity( Pos * 15 ) 
				 
				particle:SetLifeTime( 0 ) 
				particle:SetDieTime( 10 ) 
				 
				particle:SetStartAlpha( 255 ) 
				particle:SetEndAlpha( 255 ) 
				 
				local Size = math.Rand( 1, 3 ) 
				particle:SetStartSize( Size ) 
				particle:SetEndSize( 0 ) 
				 
				particle:SetRoll( math.Rand(0, 360) ) 
				particle:SetRollDelta( math.Rand(-2, 2) ) 
				 
				particle:SetAirResistance( 10 ) 
				particle:SetGravity( Vector(0,0,-20) )
				particle:SetColor(color.x, color.y, color.z) 
				 
				particle:SetCollide( true ) 
				 
				particle:SetAngleVelocity( Angle( math.Rand( -50, 50 ), math.Rand( -50, 50 ), math.Rand( -50, 50 ) ) )  
				 
				particle:SetBounce( 1 ) 
				particle:SetLighting( false ) 
				 
			end 
			 
		end 
		 
	emitter:Finish() 
	 
end 
  
  
/*--------------------------------------------------------- 
   THINK 
---------------------------------------------------------*/ 
function EFFECT:Think( ) 
	return false 
end 
  
/*--------------------------------------------------------- 
   Draw the effect 
---------------------------------------------------------*/ 
function EFFECT:Render() 
end  