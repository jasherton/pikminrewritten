hook.Add( "HUDPaint", "drawsometext", function()

	for k, v in pairs (ents.FindByClass("pik_pellet")) do
	positionsx = v:GetPos()
	screenx = positionsx:ToScreen()
	object = v
		local piks2 = {};
	for k, v in pairs(ents.FindByClass("pikmin")) do
		--if (constraint.Find( v, object, "Weld", 0, 0) == object) then
		table.insert(piks2, v);
		--end
		end
	draw.SimpleText( table.Count(piks2), "Default", screenx.x+3, screenx.y-85, Color(255,255,255,255), 1, 1)
	surface.SetFont( "Default" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( screenx.x, screenx.y-110 )
	surface.DrawText( "1" )
	surface.SetFont( "Default" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( screenx.x, screenx.y-105 )
	surface.DrawText( "_" )
end
local piks3 = {};
local pikteam = {};
local selfpik = nil
	for k, v in pairs(ents.FindByClass("pikmin") ) do
		table.insert(piks3, v);
		end
		
	for k, v in pairs(ents.FindByClass("pikmin")) do
	if (v.Olimar == nil) then
		table.insert(pikteam, v);
		end
		end
		--end
draw.SimpleText( "Pikmin On Field: "..table.Count(piks3), "CloseCaption_Bold", 900, 1000, Color(150,150,150,255), 1, 1)
draw.SimpleText( "Pikmin In Squad: "..table.Count(pikteam), "CloseCaption_Bold", 1140, 1000, Color(150,150,150,255), 1, 1)
draw.RoundedBox( 5, 800, 985, 450, 30, Color(0,0,0,150) )
end )

function loadthehud()
hook.Add( "HUDPaint2", "drawsometext2", function()
draw.SimpleText( "Pikmin On Field: "..table.Count(piks3), "CloseCaption_Bold", 900, 1000, Color(150,150,150,255), 1, 1)
draw.SimpleText( "Pikmin In Squad: "..table.Count(pikteam), "CloseCaption_Bold", 1140, 1000, Color(150,150,150,255), 1, 1)
draw.RoundedBox( 5, 800, 985, 450, 30, Color(0,0,0,150) )
end )
end

local DermaPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
DermaPanel:SetPos( 0,0 ) -- Position on the players screen
DermaPanel:SetSize( ScrW(), ScrH()) -- Size of the frame
DermaPanel:SetTitle( "Load File" ) -- Title of the frame
DermaPanel:SetVisible( false )
DermaPanel:SetDraggable( false ) -- Draggable by mouse?
DermaPanel:ShowCloseButton( true ) -- Show the close button?
DermaPanel.Paint = function()
	draw.RoundedBox( 0, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), Color( 0, 0, 0, 255 ) )
end
DermaPanel:MakePopup() -- Show the frame

local DermaButton = vgui.Create( "DButton" )	// Create the button
DermaButton:SetParent( DermaPanel )			 // Set its parent to the panel
DermaButton:SetText( "File1" )				 // Set the text on the button
DermaButton:SetPos( 25, 50 )					// Set the position on the frame
DermaButton:SetSize( 250, 30 )				 // Set the size
DermaButton.DoClick = function()
DermaPanel:SetVisible( true )
print("does nothing yet :L")
end


function loadmusic()
timer.Simple( 2, function()
		local map = string.Replace(game.GetMap(), " ", "")
if (file.Exists("lua/" .. map .. "_m.lua", "GAME")) then
print("music data found.")
				local file2 = file.Read("lua/" .. map .. "_m.lua", "GAME");
				local file3 = string.Explode(" ", file2);
timer.Simple( 2, function() surface.PlaySound(""..file3[2]) end)
timer.Simple( 12, function() LocalPlayer():ConCommand( "stopsound" ) timer.Simple( 1, function() surface.PlaySound("pikmin/endofday.wav") timer.Simple( 18, function() LocalPlayer():ConCommand( "nothing" ) end) end) end)
else
print("no music data")
end
end)
end

timer.Simple( 1, function()
loadmusic()
end)