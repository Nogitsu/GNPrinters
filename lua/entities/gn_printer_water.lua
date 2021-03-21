AddCSLuaFile()

ENT.Base = "gn_printer_base"
ENT.Type = "anim"

ENT.PrintName = "GN Printer Water"
ENT.Category = "GN DarkRP"
ENT.Author = "Nogitsu & Guthen"
ENT.Spawnable = true

function ENT:SetupPrinter()
    self:SetMaxTime( 10 )

    self:SetDucks( 0 )
    self:SetMaxDucks( 50 )

    self:SetGain( .1 )
end

function ENT:SetupColors()
    self:SetMainBackground( GNLib.Colors.BelizeHole:ToVector() )
    self:SetMainForeground( GNLib.Colors.PeterRiver:ToVector() )

    self:SetMoneyBackground( GNLib.Colors.PeterRiver:ToVector() )
    self:SetMoneyForeground( GNLib.Colors.BelizeHole:ToVector() )

    self:SetTimerBackground( GNLib.Colors.PeterRiver:ToVector() )
    self:SetTimerForeground( GNLib.Colors.BelizeHole:ToVector() )
end