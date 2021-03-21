include( "shared.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

sound.Add( {
	name = "gnprinter_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = { 95, 110 },
	sound = "ambient/machines/pump_loop_1.wav"
} )

function ENT:DefaultSetup()
    --  ENT:SetupPrinter
    self:SetMaxTime( 5 )
    self:SetMaxDucks( 5 )

    self:SetMaxPaper( 125 )
    self:SetMaxInk( 75 )
    self:SetMaxBattery( 100 )

    self:SetGain( 0.5 )

    -- ENT:SetupColors
    self:SetMainBackground( GNLib.Colors.MidnightBlue:ToVector() )
    self:SetMainForeground( GNLib.Colors.WetAsphalt:ToVector() )

    self:SetMoneyBackground( GNLib.Colors.GreenSea:ToVector() )
    self:SetMoneyForeground( GNLib.Colors.Turquoise:ToVector() )

    self:SetTimerBackground( GNLib.Colors.Wisteria:ToVector() )
    self:SetTimerForeground( GNLib.Colors.Amethyst:ToVector() )

    self:SetPaperBackground( GNLib.Colors.Asbestos:ToVector() )
    self:SetPaperForeground( GNLib.Colors.Concrete:ToVector() )

    self:SetInkBackground( GNLib.Colors.BelizeHole:ToVector() )
    self:SetInkForeground( GNLib.Colors.PeterRiver:ToVector() )

    self:SetBatteryBackground( GNLib.Colors.Nephritis:ToVector() )
    self:SetBatteryForeground( GNLib.Colors.Emerald:ToVector() )
end

function ENT:SetupPrinter() end

function ENT:SetupColors() end

function ENT:Initialize()
    self:SetModel( "models/props_lab/reciever01a.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) )  then
		phys:Wake()
    end

    self:SetHealth( 50 )
    
    self:DefaultSetup()
    self:SetupPrinter()
    self:SetupColors()

    self:SetCurTime( 0 )
    self:SetDucks( 0 )

    self:SetBattery( self:GetMaxBattery() / 2 )
    self:SetPaper( self:GetMaxPaper() / 2 )
    self:SetInk( self:GetMaxInk() / 2 )

    self:EmitSound( "gnprinter_loop" )
end

function ENT:OnRemove()
    self:StopSound( "gnprinter_loop" )
end

function ENT:CanPrint()
    return self:GetDucks() ~= self:GetMaxDucks() and self:GetBattery() > 0 and self:GetPaper() > 0 and self:GetInk() > 0
end

function ENT:Think()
    if self:GetCurTime() >= self:GetMaxTime() then
        self:SetDucks( math.Clamp( self:GetDucks() + self:GetGain(), 0, self:GetMaxDucks() ) )

        self:SetBattery( math.max( 0, self:GetBattery() - 2 ) )
        self:SetPaper( math.max( 0, self:GetPaper() - 1 ) )
        self:SetInk( math.max( 0, self:GetInk() - 4 ) )

        self:SetCurTime( 0 )
    return end
    if not self:CanPrint() then self:SetCurTime( 0 ) return end

    self:SetCurTime( math.Clamp( self:GetCurTime() + FrameTime() * 10, 0, self:GetMaxTime() ) )
end

function ENT:Use( activator, caller )
    if self:GetDucks() <= 0 then return end
    caller:addMoney( self:GetDucks() * GNPrinter.Config.DuckPrice )
    self:SetDucks( 0 )
    self:SetCurTime( 0 )

    self:EmitSound( "buttons/weapon_confirm.wav", 80, 100, 1 )
end

function ENT:OnTakeDamage( dmg )
    self:SetHealth( self:Health() - dmg:GetDamage() )

    if self:Health() <= 0 then
        local ent = ents.Create( "env_explosion" )
            ent:SetPos( self:GetPos() )
            ent:SetKeyValue( "iMagnitude", dmg:GetDamage() / 10 )
	        ent:Fire( "Explode", 0, 0 )
            ent:Spawn()

        self:Remove()
        self:StopSound( "gnprinter_loop" )
    end
end