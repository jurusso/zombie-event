
-- Commands for Zombie Event

local CATEGORY_NAME = "Zombie Event"


-- Admin Start Event

function ulx.startzevent(calling_ply)
	if (Z_Event.Z_Event_Active or Z_Event.Z_PreEvent_Active) then
		DarkRP.notify(calling_ply, 1, 5, "Zombie event already active!")
		return
	end
	if (#player.GetAll() < Z_Event.Z_MinPlayers) then
		DarkRP.notify(calling_ply, 1, 5, "Need " .. Z_Event.Z_MinPlayers .. " players to start a zombie event!")
		return
	end

	ulx.fancyLogAdmin( calling_ply, "#A started a Zombie Event!")
	Z_Event.preEvent(calling_ply)
end
local startzevent = ulx.command(CATEGORY_NAME, "ulx startzevent", ulx.startzevent, "!startzevent")
startzevent:defaultAccess( ULib.ACCESS_ADMIN )
startzevent:help( "Starts a zombie event." )


-- Admin End Event

function ulx.endzevent(calling_ply)
	if !(Z_Event.Z_Event_Active or Z_Event.Z_PreEvent_Active) then
		DarkRP.notify(calling_ply, 1, 5, "Zombie event not active!")
		return
	end
	ulx.fancyLogAdmin( calling_ply, "#A ended the Zombie Event!")
	Z_Event.endEvent(calling_ply)
end
local endzevent = ulx.command(CATEGORY_NAME, "ulx endzevent", ulx.endzevent, "!endzevent")
endzevent:defaultAccess( ULib.ACCESS_ADMIN )
endzevent:help( "Ends the zombie event." )

-- Vote Event

local function votezeventDone( t )
	local results = t.results
	local winner
	local winnernum = 0
	for id, numvotes in pairs( results ) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	local ratioNeeded = Z_Event.Z_VoteRatio
	local minVotes = Z_Event.Z_MinVotes
	local str
	if winner ~= 1 or winnernum < minVotes or winnernum / t.voters < ratioNeeded then
		str = "Vote results: Event will not be started. (" .. (results[ 1 ] or "0") .. "/" .. t.voters .. ")"
	else
		if Z_Event.Z_Event_Active then
			str = "Vote results: Event voted to start but already active."
		else
			str = "Vote results: Event will now be started. (" .. winnernum .. "/" .. t.voters .. ")"
			Z_Event.preEvent(voteply)
		end
	end

	ULib.tsay( _, str )
	ulx.logString( str )
	Msg( str .. "\n" )
end



function ulx.votezevent( calling_ply )
	if (Z_Event.Z_Event_Active or Z_Event.Z_preEvent_Active) then
		DarkRP.notify(calling_ply, 1, 5, "Zombie event already active!")
		return
	end
	if (#player.GetAll() < Z_Event.Z_MinPlayers) then
		DarkRP.notify(calling_ply, 1, 5, "Need " .. Z_Event.Z_MinPlayers .. " players to start a zombie event!")
		return
	end

	if ulx.voteInProgress then
		ULib.tsayError( calling_ply, "There is already a vote in progress. Please wait for the current one to end.", true )
		return
	end

	voteply = calling_ply
	ulx.doVote( "Zombie Event?", { "Yes", "No" }, votezeventDone )
	ulx.fancyLogAdmin( calling_ply, "#A started a vote for a Zombie Event")

end
local votezevent = ulx.command( CATEGORY_NAME, "ulx votezevent", ulx.votezevent, "!votezevent" )
votezevent:defaultAccess( ULib.ACCESS_ADMIN )
votezevent:help( "Starts a public vote to start the Zombie Event." )
