
AddCSLuaFile()

SWEP.PrintName = "Zombie Fists"
SWEP.Author = "chewitdude"
SWEP.Purpose = "Fists for zombies"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.HoldType = "fist"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

if SERVER then
	util.AddNetworkString( "Door" )
	util.AddNetworkString( "notDoor" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType)
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_HL2MP_IDLE_FIST )
	self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "fists_draw" ) )
	if (self.Owner:Alive()) then
	timer.Simple(1, function()
		if IsValid(self) then
			self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "fists_idle_02" ) )
		end
	end)
	end
	return false
end


function SWEP:PrimaryAttack( right )

	local ply = self.Owner
	local tr = util.TraceHull( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 45 ),
	filter = self.Owner,
	mins = Vector( -10, -10, -10 ),
	maxs = Vector( 10, 10, 10 ),
	mask = MASK_SHOT_HULL
	} )

	local ent = tr.Entity
	local door = false

		ply:SetAnimation( PLAYER_ATTACK1 )

		if right then
			ply:GetViewModel():SendViewModelMatchingSequence(ply:GetViewModel():LookupSequence("fists_right"))
		else
			ply:GetViewModel():SendViewModelMatchingSequence(ply:GetViewModel():LookupSequence("fists_left"))
		end

		timer.Simple(.5, function()
			ply:GetViewModel():SendViewModelMatchingSequence( ply:GetViewModel():LookupSequence( "fists_idle_01" ) )
		end)

		if ent:IsPlayer() then
			if SERVER then
				timer.Simple(.2, function() if IsValid(self) and IsValid(ent) then ent:TakeDamage( Z_Event.Z_Damage, ply, self ) end end)
			end
		end

		if SERVER then
			if ent:isDoor() and Z_Event.Z_CanBreakDoors then
				if ent.Zhits == nil then ent.Zhits = Z_Event.Z_NumHits - 1 end
				if ent.Zhits == 0 then
					ent:keysUnLock()
	    		ent:Fire("open", "", .6)
	    		ent:Fire("setanimation", "open", .6)
					ent.Zhits = Z_Event.Z_NumHits
				end
				net.Start( "Door" )
				net.Send( ply )
				door = true
				ent.Zhits = ent.Zhits - 1
			end
		end

		if ent.fadeActivate and Z_Event.Z_CanBreakFade then
			 if ent.Zhits == nil then ent.Zhits = Z_Event.Z_NumHits - 1 end
			 if ent.Zhits == 0 then
				 timer.Simple(.2, function() ent:fadeActivate() end)
						if Z_Event.Z_FadeTimer then
				 				timer.Simple(Z_FadeTime, function() if IsValid(ent) and ent.fadeActive then ent:fadeDeactivate() end end)
			 			end
				 ent.Zhits = Z_Event.Z_NumHits
			 end
			 net.Start( "Door" )
			 net.Send( ply )
			 door = true
			 ent.Zhits = ent.Zhits - 1
		end

		if ent:IsValid() or ent:IsWorld() then
			if !door and SERVER then
				net.Start( "notDoor" )
 			 	net.Send( ply )
			end
	  end

		net.Receive( "Door", function()
			timer.Simple(.2, function() if IsValid(self) then self:EmitSound(Sound("physics/wood/wood_box_impact_hard3.wav")) end end)
		end )

		net.Receive( "notDoor", function()
				timer.Simple(.2, function() if IsValid(self) then self:EmitSound( Sound( "Flesh.ImpactHard" )) end end)
		end )

		self:EmitSound( Sound( "WeaponFrag.Throw" ) )
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack( true )
end


function SWEP:OnDrop()
	self:Remove()
end
