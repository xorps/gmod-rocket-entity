SWEP.Author 				=	"Corvidus"
SWEP.PrintName				=	"OG Rocket Jumper"
SWEP.Instructions			=	"Left-Click: Shoot Rocket"

if CLIENT then
	
	SWEP.WepSelectIcon 		=	surface.GetTextureID("vgui/entities/og_rocket_jumper.vtf")
	SWEP.BounceWeaponIcon	=	false
end

SWEP.Slot					=	4
SWEP.SlotPos				=	1
SWEP.Category				=	"Rocket Jumpers"
SWEP.Spawnable				=	true
SWEP.AdminOnly				=	false

SWEP.ViewModel				=	"models/weapons/c_rpg.mdl"
SWEP.ViewModelFlip			=	false
SWEP.UseHands				=	true
SWEP.WorldModel				=	"models/weapons/w_rocket_launcher.mdl"
SWEP.SetHoldType			=	"rpg"

SWEP.Weight					=	5
SWEP.AutoSwitchTo			=	false
SWEP.AutoSwitchFrom			=	false

SWEP.DrawAmmo				=	false
SWEP.DrawCrosshair			=	true

SWEP.Primary.ClipSize		=	-1
SWEP.Primary.DefaultClip	=	-1
SWEP.Primary.Ammo			=	"none"
SWEP.Primary.Automatic		=	false
SWEP.Primary.Delay			=	0.5

SWEP.Secondary.ClipSize		=	-1
SWEP.Secondary.DefaultClip	=	-1
SWEP.Secondary.Ammo			=	"none"
SWEP.Secondary.Automatic	=	false

SWEP.ShouldDropOnDie		=	false

local shootsound			=	Sound("weapons/rpg/rocketfire1.wav")

function SWEP:GetViewModelPosition(pos, ang)
 
	ang:RotateAroundAxis(ang:Forward(), 90)
	
	return pos, ang
 
end

function SWEP:Initialize()
	self:SetHoldType( "Rpg" )
end

function SWEP:PrimaryAttack()

	if(self:CanPrimaryAttack()) then return end
	
	local ply = self:GetOwner()
	
	ply:LagCompensation(true)
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:EmitSound(shootsound)
	self:ShootEffects(self)

	if(!SERVER) then return end
	
	local entpos = self.Owner:GetShootPos()
	entpos = entpos + self.Owner:GetUp() * -5
	
	local entang = self.Owner:EyeAngles()
	entang = entang - Angle(0, 0, 0)
	
	local ent = ents.Create("rocketjump_rocket")
	ent:SetOwner(ply)
	
	if (IsValid(ent)) then
		
		ent:SetPos(entpos)
		ent:SetAngles(entang)
		ent:Spawn()

		ent:GetPhysicsObject():SetVelocity(entang:Forward() * 2000)
		ent:SetOwner(self.Owner)
		
	end
	
	ply:LagCompensation(false)
end

function SWEP:Reload()

end

function SWEP:SecondaryAttack()

end

