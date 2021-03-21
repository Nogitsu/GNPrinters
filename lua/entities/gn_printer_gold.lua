AddCSLuaFile()

ENT.Base = "gn_printer_base"
ENT.Type = "anim"

ENT.PrintName = "GN Printer Gold"
ENT.Category = "GN DarkRP"
ENT.Author = "Nogitsu & Guthen"
ENT.Spawnable = true

function ENT:SetupPrinter()
    self:SetMaxTime( 2 )

    self:SetDucks( 0 )
    self:SetMaxDucks( 50 )

    self:SetGain( 0.5 )
end

function ENT:SetupColors()
    self:SetMainBackground( GNLib.Colors.Orange:ToVector() )
    self:SetMainForeground( GNLib.Colors.SunFlower:ToVector() )

    self:SetMoneyBackground( GNLib.Colors.GreenSea:ToVector() )
    self:SetMoneyForeground( GNLib.Colors.Turquoise:ToVector() )

    self:SetTimerBackground( GNLib.Colors.Wisteria:ToVector() )
    self:SetTimerForeground( GNLib.Colors.Amethyst:ToVector() )
end