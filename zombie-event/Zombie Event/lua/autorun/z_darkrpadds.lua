
timer.Simple(10, function()

	TEAM_ZOMBIE = DarkRP.createJob("Zombie", {
		color = Color(160, 0, 0, 255),
		model = Z_Event.Z_ZombieModel,
		description = [[Mmmmmmmm Brainsssss.]],
		weapons = Z_Event.Z_Weapon,
		command = "zombie",
		max = 0,
		salary = Z_Event.Z_Salary,
		admin = 1,
		vote = false,
		hasLicense = false,
		PlayerLoadout = function(ply)
		ply:SetHealth(Z_Event.Z_Health)
		ply:SetWalkSpeed(Z_Event.Z_Walkspeed)
		ply:SetRunSpeed(Z_Event.Z_Runspeed)
		return true
	end
	})

end)
