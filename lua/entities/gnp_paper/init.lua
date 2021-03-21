include( "shared.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( "models/props/cs_office/Paper_towels.mdl" )

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
		if ent:GetPaper() < ent:GetMaxPaper() then
			self:Remove()
			ent:SetPaper( math.min( ent:GetMaxPaper(), ent:GetPaper() + GNPrinter.Config.PaperQuantity ) )
		end
    end
end