AddCSLuaFile("entities/rocketjump_rocket/cl_init.lua")
AddCSLuaFile("entities/rocketjump_rocket/shared.lua")

include("entities/rocketjump_rocket/shared.lua")

function ENT:Initialize()

	self:SetModel("models/weapons/w_missile_closed.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetCustomCollisionCheck(true)
	
	local phys	= self:GetPhysicsObject()
	
	if(phys:IsValid()) then
	
		phys:Wake()
		phys:EnableGravity(false)
		phys:EnableDrag(false) 
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0)
	end
end

function ENT:Think()
	
	self:GetPhysicsObject():Wake()
end

function GAMEMODE:ShouldCollide(ent1, ent2)
	
	if ent1:GetClass() == "rocketjump_rocket" and ent2:GetClass() == "rocketjump_rocket" then
		return false
	else
		return true
	end
end

function ENT:PhysicsCollide(data, phys)
	
	local inradius = ents.FindInSphere(data.HitPos, 150)
	
	for key, ent in ipairs(inradius) do
		if ent:GetClass() != "rocketjump_rocket" then
			if ent:IsValid() then
				--[[
				local x = (ent:GetPos().x - data.HitPos.x) * (500 / data.HitPos:Distance(ent:GetPos()))
				local y = (ent:GetPos().y - data.HitPos.y) * (500 / data.HitPos:Distance(ent:GetPos()))
				local z = (ent:GetPos().z - data.HitPos.z + 3) * (500 / data.HitPos:Distance(ent:GetPos()))
			
				ent:SetVelocity(Vector(x, y, z))
				if ent:GetPhysicsObject():IsValid()  then
					ent:GetPhysicsObject():SetVelocity(Vector(x, y, z))
				end
				]]
				local dir = ent:GetPos() - data.HitPos
				--[[
				local mins, maxs = data.PhysObject:GetAABB()
				local mins = data.PhysObject:LocalToWorld(mins)
				local maxs = data.PhysObject:LocalToWorld(maxs)
				local dir = ent:GetPos() - (mins + maxs) * 0.5
				]]
				local dir = dir:GetNormalized()
				local dir = Vector(dir.x, dir.y, dir.z + 25)
				local dir = dir * 30
				local newVel = ent:GetVelocity()
				local newVel = Vector(newVel.x, newVel.y, 0)
				local newVel = newVel + dir
				ent:SetVelocity(newVel)
				if ent:GetPhysicsObject():IsValid() then
					ent:GetPhysicsObject():SetVelocity(newVel)
				end
			end
		end
	end
	
	local explode = ents.Create("env_explosion")
	if !IsValid(explode) then return end
	
	explode:SetPos(data.HitPos)
	
	explode:SetKeyValue("Radius Override", 0)
	explode:SetKeyValue("spawnflags", 1)
	
	explode:Spawn()
	explode:Activate()
	
	explode:Fire("Explode", "", 0)
	explode:Fire("Kill", "", 1)
	
	self:Remove()
	
end