function AtmosTimeHours()
	local hrs = pikmintimeGlobal:GetTime();
	local hours = math.floor( hrs );
	if (hrs != nil) then
		return hours
	else
		return
	end
end

function AtmosMinutes()
	local hrs = pikmintimeGlobal:GetTime();
	local hours = math.floor( hrs );
	local minutes = ( hrs - hours ) * 60;
	if (hrs != nil) then
		math.floor( minutes )
		return minutes
	else
		return
	end
end
local hrs = AtmosTimeHours()

--time = CurTime()

--if (CurTime() - time >= 7) then
--BroadcastLua("chat.AddText( Color( 255, 191, 0), 'Hurry Up! ', Color( 255, 255, 255 ), 'Gather your pikmin before the day ends.')")
--end
--end)