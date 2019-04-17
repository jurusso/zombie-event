
surface.CreateFont( "CustomFont", {
	font = "Quikhand", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local Event_Active = false
local PreEvent_Active = false

hook.Add( "HUDPaint", "HUDPaint_DrawZHUD", function()

	if not (Event_Active or PreEvent_Active) then
		return
	end

	local time
	local timer_bar_dist
	local numalive = 0

	if Event_Active then
		numalive = #player.GetAll() - numzombies
	end


	if (timer.Exists("PreEventTimer")) then
		time = timer.TimeLeft( "PreEventTimer" )
		elseif (timer.Exists("ZTimer")) then
			time = timer.TimeLeft("ZTimer")
		else
		time = 0
	end

	local timerboxlength = 150
	local timerboxheight = 60

	if PreEvent_Active then
		timer_bar_dist = (timerboxlength * time)/Z_Event.Z_PreEventTime
	else
		timer_bar_dist = (timerboxlength * time)/Z_Event.Z_EventLength
	end

	local color_fade = (180 * timer_bar_dist) / (timerboxlength)

	if (timer_bar_dist/timerboxlength > .5) then
		red_color = 180 - ((color_fade - 90) * 2)
		green_color = 180
		else
		green_color = (color_fade * 2)
		red_color = 180
	end


		//Timer Box
		draw.RoundedBox( 15, 18, 20, timerboxlength + 4, timerboxheight + 4, Color( 90, 90, 90, 190 ) )

		draw.RoundedBox( 15, 20, 22, timerboxlength, timerboxheight, Color( 0, 0, 0, 220 ) )
		draw.RoundedBox( 1, 20, 51, timer_bar_dist, 2, Color( red_color, green_color, 0, 255 ) )

		if Event_Active then
			//Scoreboard Box
			local scoreboxlength = 105
			local scoreboxheight = 60

			draw.RoundedBox( 15, 18, 90, scoreboxlength + 4, scoreboxheight + 4, Color( 90, 90, 90, 190 ) )
			draw.RoundedBox( 15, 20, 92, scoreboxlength, scoreboxheight, Color( 0, 0, 0, 220 ) )
		end


		//Title
		surface.SetFont( "CustomFont" )
		surface.SetTextColor( 180, 0, 0, 255 )
		surface.SetTextPos( 45, 26 )
		surface.DrawText( "Zombie Event" )
		//Time
		if PreEvent_Active then
			surface.SetTextColor( 200, 200, 200, 255 )
			surface.SetTextPos( 27, 56 )
			surface.DrawText( "Starting in" )
			surface.SetTextColor( 200, 200, 200, 255 )
			surface.SetTextPos( 118, 56 )
			surface.DrawText( string.ToMinutesSeconds( time ) )
		else
			surface.SetTextColor( 200, 200, 200, 255 )
			surface.SetTextPos( 73, 56 )
			surface.DrawText( string.ToMinutesSeconds( time ) )
		end
		if Event_Active then
			//Alive #
			surface.SetTextColor( 0, 180, 0, 255 )
			surface.SetTextPos( 30, 99 )
			surface.DrawText( "Alive: " .. tostring(numalive) )
			//Dead #
			surface.SetTextColor( 180, 0, 0, 255 )
			surface.SetTextPos( 30, 125 )
			surface.DrawText( "Zombies: " .. tostring(numzombies) )
		end

end )

net.Receive("JoinZombie", function()
	timer.Create( "ZTimer", net.ReadInt(32), 1, function() end)
	numzombies = net.ReadInt(32)
	Event_Active = true
end)

net.Receive("LeaveZombie", function()
	numzombies = net.ReadInt(32)
end)

net.Receive("PreEventStarted", function()
	timer.Create( "PreEventTimer", net.ReadInt(32), 1, function() PreEvent_Active = false end)
	PreEvent_Active = true
end)

net.Receive( "EventEnded", function()
	Event_Active = false
	if (PreEvent_Active) then
		timer.Remove("PreEventTimer")
		PreEvent_Active = false
		return
	end

	local Winner_Table = net.ReadTable()

	if (next(Winner_Table) == nil) then
		chat.AddText( Color(180,0,0), "The zombies have won the event!")
	else
		for k , v in pairs(Winner_Table) do
			if (LocalPlayer() == v ) then
				chat.AddText( Color(180,0,0), "You won the zombie event!")
			else
				chat.AddText( Color(180,0,0), v:GetName() .. " has won the zombie event!")
			end

		end
	end
end )
