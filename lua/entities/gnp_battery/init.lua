include( "shared.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( "models/Items/car_battery01.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) )  then
		phys:Wake()
    end
end

function ENT:Touch( ent )
	if ent:GetClass() == "gn_printer_base" or ent.Base == "gn_printer_base" then
		if ent:GetBattery() < ent:GetMaxBattery() then
			self:Remove()
			ent:SetBattery( math.min( ent:GetMaxBattery(), ent:GetBattery() + GNPrinter.Config.BatteryQuantity ) )
		end
    end
end