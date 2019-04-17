Z_Event = {}
--Event Properties
Z_Event.Z_EventLength  				    = 180 // Duration of event in seconds
------------------------------------------------------------------------------
Z_Event.Z_PreEventTime 				    = 30 // Time before the event starts in seconds
------------------------------------------------------------------------------
Z_Event.Z_Prize 					        = true // Whether or not the players who survive the time should get money
------------------------------------------------------------------------------
Z_Event.Z_PrizeAmount  				    = 25000 // Amount of money awarded to winner/winners
------------------------------------------------------------------------------
Z_Event.Z_MinPlayers   				    = 10 // Minimum ammount of players needed for a zombie event
------------------------------------------------------------------------------
Z_Event.Z_MinVotes     				    = 1   // Minimum number of votes needed to start a zombie event
------------------------------------------------------------------------------
Z_Event.Z_VoteRatio    				    = .5  // Ratio needed for the vote to succeed
------------------------------------------------------------------------------
Z_Event.Z_PlayerTeamDamage 			  = true // Whether or not players can kill eachother during the event
------------------------------------------------------------------------------
Z_Event.Z_ZombieKillAward  			  = true // Whether or not players should be given money when they kill a zombie
------------------------------------------------------------------------------
Z_Event.Z_ZombieKillAwardAmount 	= 50 // If Z_ZombieKillAward is set to true, how much money the player gets for killing a zombie

------------------------------------------------------------------------------
--Zombie Properties
------------------------------------------------------------------------------
Z_Event.Z_ZombieModel				      = "models/player/charple.mdl" // Player model for the zombie
------------------------------------------------------------------------------
Z_Event.Z_Weapon					        = {"zombie_fists"} // Weapon/Weapons the zombies spawn with
------------------------------------------------------------------------------
Z_Event.Z_Health	   				      = 150 // Amount of health zombies spawn with
------------------------------------------------------------------------------
Z_Event.Z_Walkspeed	   				    = 220 // Walkspeed of the zombies (Default walk speed is 160)
------------------------------------------------------------------------------
Z_Event.Z_Runspeed	   				    = 300 // Runspeed of the zombies (Default run speed is 240)
------------------------------------------------------------------------------
Z_Event.Z_Percentage   				    = 20  // Percentage of players to intitially spawn as zombies
------------------------------------------------------------------------------
Z_Event.Z_Salary					        = 100 // Salary for zombies
------------------------------------------------------------------------------
Z_Event.Z_Damage 	   				      = 50 // Damage zombies do per punch
  ------------------------------------------------------------------------------
Z_Event.Z_CanBreakDoors           = true // Whether or not zombies can break open doors
------------------------------------------------------------------------------
Z_Event.Z_CanBreakFade            = true // Whether or not zombies can break open fading doors
------------------------------------------------------------------------------
Z_Event.Z_FadeTimer               = true // Whether or not fading doors should auto-respawn after being broken into
------------------------------------------------------------------------------
Z_Event.Z_FadeTime                = 5 // Number of time in seconds until the fading door respawns (Only if Z_FadeTimer is true)
------------------------------------------------------------------------------
Z_Event.Z_NumHits                 = 3 // Number of hits it takes to break open a door/fading door
------------------------------------------------------------------------------
Z_Event.Z_PlayerKillAwardAmount   = 100 // If Z_PlayerKillAward is set to true, how much money the zombie gets for killing a player
------------------------------------------------------------------------------
Z_Event.Z_PlayerKillAward 			  = true // Whether or not zombies should be given money when they kill a player
------------------------------------------------------------------------------
Z_Event.Z_ZombieProps 				    = false // Whether or not zombies can spawn props
------------------------------------------------------------------------------
Z_Event.Z_ZombieVehicles			    = false // Whether or not zombies can enter vehicles
------------------------------------------------------------------------------
Z_Event.Z_ZombiePickup			      = false // Whether or not zombies can pickup weapons
------------------------------------------------------------------------------
Z_Event.Z_Arrest					        = false // Whether or not zombies can be arrested
------------------------------------------------------------------------------
Z_Event.Z_ZombieTeamDamage 			  = false // Whether or not zombies can do team damage
