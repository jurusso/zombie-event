resource.AddFile( "resource/fonts/Quikhand.ttf" )
util.AddNetworkString( "PreEventStarted" )
util.AddNetworkString( "EventEnded" )
util.AddNetworkString( "JoinZombie" )
util.AddNetworkString( "LeaveZombie" )

Z_Event.Z_Event_Active = false
Z_Event.Z_PreEvent_Active = false
local Event_Winner = {}
local ZJobs = {}
local Z_Count = 0

local function pickZombie()
	local numzombies = math.ceil((Z_Event.Z_Percentage / 100) * player.GetCount())
	ZJobs = {}
	for i, j in pairs(player.GetAll()) do
		ZJobs[i] = j:Team()
	end

	for i = 1, numzombies do
		local plyindex = math.random( 1, player.GetCount() )
		for k, v in pairs(player.GetAll()) do
			if ( k == plyindex and v:Team() != TEAM_ZOMBIE) then
				Z_Count = Z_Count + 1
				net.Start("JoinZombie")
				net.WriteInt(timer.TimeLeft("EventTimer"), 32)
				net.WriteInt(Z_Count, 32)
				net.Broadcast()
				v:changeTeam( TEAM_ZOMBIE, true )
			end
		end
	end
end

local function startEvent(calling_ply)
	Z_Event.Z_Event_Active = true
	Z_Count = 0
	Event_Winner = {}
	timer.Create( "EventTimer", Z_Event.Z_EventLength, 1, function()
		for k , v in pairs(player.GetAll()) do
			if (v:Team() != TEAM_ZOMBIE) then
				table.insert(Event_Winner, v)
			end
		end
	Z_Event.endEvent(calling_ply)
	end )
	pickZombie()
	ulx.csay(calling_ply, "WARNING! A zombie event has started!")
end

Z_Event.preEvent = function(calling_ply)
	Z_Event.Z_PreEvent_Active = true
	if (Z_Event.Z_PreEventTime < 60) then
	    ulx.csay(calling_ply, "WARNING! A zombie event is starting in ".. Z_Event.Z_PreEventTime .. " seconds!")
	elseif (Z_Event.Z_PreEventTime % 60 == 0) then
			ulx.csay(calling_ply, "WARNING! A zombie event is starting in ".. Z_Event.Z_PreEventTime / 60 .. " minutes!")
	else
			ulx.csay(calling_ply, "WARNING! A zombie event is starting in ".. math.floor(Z_Event.Z_PreEventTime / 60) .. " minutes and ".. Z_Event.Z_PreEventTime % 60 .. " seconds!")
	end
	timer.Create( "PreEventTimer", Z_Event.Z_PreEventTime, 1, function()
		startEvent(calling_ply)
		Z_Event.Z_PreEvent_Active = false
	end)
	net.Start( "PreEventStarted" )
	net.WriteInt(timer.TimeLeft("PreEventTimer"), 32)
	net.Broadcast()
end

local function restoreJobs()
	for k, v in pairs(ZJobs) do
		if (v != player.GetAll()[k]:Team()) then
			player.GetAll()[k]:changeTeam( v , true)
			player.GetAll()[k]:SetHealth(100)
		end
	end
	table.Empty(ZJobs)
end

Z_Event.endEvent = function(calling_ply)

	timer.Remove("PreEventTimer")
	Z_Event.Z_PreEvent_Active = false

	timer.Remove("EventTimer")
	Z_Event.Z_Event_Active = false
	restoreJobs()

	ulx.csay(calling_ply, "Zombie event has ended!")
	net.Start( "EventEnded" )
	net.WriteTable(Event_Winner)
	net.Broadcast()

	if (next(Event_Winner) != nil) then
		for k , v in pairs(Event_Winner) do
			if (Z_Prize) then
				local split = math.ceil(Z_Event.Z_PrizeAmount / table.Count(Event_Winner))
				v:addMoney(split)
				DarkRP.notify(v, 0, 7, "You recieved $" .. string.Comma( split ) .. " for winning!")
			end
		end
	end
end







hook.Add( "PlayerDeath", "Zombie_Change", function( victim, inflictor, attacker )
	if Z_Event.Z_Event_Active then

		if (victim:Team() != TEAM_ZOMBIE) then
			Z_Count = Z_Count + 1
			net.Start("JoinZombie")
			net.WriteInt(timer.TimeLeft("EventTimer"), 32)
			net.WriteInt(Z_Count, 32)
			net.Broadcast()
			timer.Simple( 0, function() victim:changeTeam( TEAM_ZOMBIE, true) end)
		end

		if (attacker:IsPlayer() and attacker:Team() == TEAM_ZOMBIE and victim:Team() != TEAM_ZOMBIE) then
			if Z_Event.Z_PlayerKillAward then
				attacker:addMoney(Z_Event.Z_PlayerKillAwardAmount)
				DarkRP.notify(attacker, 0, 7, "You recieved $" .. string.Comma( Z_Event.Z_PlayerKillAwardAmount ) .. " for killing a player!")
			end
		end

		if (victim:Team() == TEAM_ZOMBIE and attacker:IsPlayer()) then
			if Z_Event.Z_ZombieKillAward then
				attacker:addMoney(Z_Event.Z_ZombieKillAwardAmount)
				DarkRP.notify(attacker, 0, 7, "You recieved $" .. string.Comma( Z_Event.Z_ZombieKillAwardAmount ) .. " for killing a zombie!")
			end
		end

		if (Z_Count == #player.GetAll()) then
			timer.Simple( 0, function()
				Z_Event.endEvent(victim)
				return
			end)
		end
	end
end )

hook.Add( "PlayerInitialSpawn", "Zombie_Spawn", function( ply )
	if Z_Event.Z_Event_Active then
		table.insert(ZJobs, table.KeyFromValue( player.GetAll(), ply ), GAMEMODE.DefaultTeam )
		Z_Count = Z_Count + 1
		net.Start("JoinZombie")
		net.WriteInt(timer.TimeLeft("EventTimer"), 32)
		net.WriteInt(Z_Count, 32)
		net.Broadcast()
		timer.Simple( 0, function() ply:changeTeam( TEAM_ZOMBIE, true) end)
	end

	if Z_Event.Z_PreEvent_Active then
		net.Start( "PreEventStarted" )
		net.WriteInt(timer.TimeLeft("PreEventTimer"), 32)
		net.Broadcast()
	end
end )

hook.Add( "PlayerDisconnected", "Player_Leave", function( ply )
	if Z_Event.Z_Event_Active then
		if ( ply:Team() == TEAM_ZOMBIE) then
			Z_Count = Z_Count - 1
			net.Start("LeaveZombie")
			net.WriteInt(Z_Count, 32)
			net.Broadcast()
		end
		table.remove(ZJobs, table.KeyFromValue( player.GetAll(), ply ))
		timer.Simple(0, function()
			if ( Z_Count == #player.GetAll() or Z_Count == 0) then
				Z_Event.endEvent(ply)
				return
			end
		end)
	end
end )

hook.Add( "OnPlayerChangedTeam", "Store_Team_Change", function( ply , before, after )
	if (ply:Team() != TEAM_ZOMBIE and Z_Event.Z_Event_Active) then
		ZJobs[table.KeyFromValue( player.GetAll(), ply )] = after
	end
end )

hook.Add( "playerCanChangeTeam", "Prevent_Zombie_Change", function( ply )
	if ( ply:Team() == TEAM_ZOMBIE and Z_Event.Z_Event_Active) then
		DarkRP.notify(ply, 1, 5, "Can't change jobs during zombie event!")
		return false
	end
end )

hook.Add( "PlayerShouldTakeDamage", "Team_Damage", function( victim, attacker )
	if (Z_Event.Z_ZombieTeamDamage == false and attacker:IsPlayer()) then
		if ( victim:Team() == TEAM_ZOMBIE and attacker:Team() == TEAM_ZOMBIE and Z_Event.Z_Event_Active) then
			return false
		end
	end
	if (Z_Event.Z_PlayerTeamDamage == false and attacker:IsPlayer()) then
		if ( victim:Team() != TEAM_ZOMBIE and attacker:Team() != TEAM_ZOMBIE and Z_Event.Z_Event_Active) then
			return false
		end
	end
end )

hook.Add( "PlayerSpawnProp", "Zombie_Spawn_Props", function( ply )
	if !Z_Event.Z_ZombieProps then
		if (ply:Team() == TEAM_ZOMBIE) then
			DarkRP.notify(ply, 1, 5, "Can't spawn props as a zombie!")
			return false
		end
	end
end )

hook.Add( "CanPlayerEnterVehicle", "Zombie_Enter_Vehicle", function( ply )
	if !Z_Event.Z_ZombieVehicles then
		if (ply:Team() == TEAM_ZOMBIE) then
			DarkRP.notify(ply, 1, 5, "Can't use vehicles as a zombie!")
			return false
		end
	end
end )

hook.Add( "canArrest", "Zombie_Arrest", function( ply, target )
	if !Z_Event.Z_Arrest then
		if (target:Team() == TEAM_ZOMBIE) then
			DarkRP.notify(ply, 1, 5, "Can't arrest zombies!")
			return false
		end
	end
end )

hook.Add( "PlayerCanPickupWeapon", "Zombie Pickup", function( ply, wep )
	if !Z_Event.Z_ZombiePickup then
		if (ply:Team() == TEAM_ZOMBIE and !table.HasValue(Z_Event.Z_Weapon, wep:GetClass())) then
			DarkRP.notify(ply, 1, 5, "Can't pickup weapons as a zombie!")
			return false
		end
	end
end )
