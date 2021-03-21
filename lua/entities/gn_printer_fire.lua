AddCSLuaFile()

ENT.Base = "gn_printer_base"
ENT.Type = "anim"

ENT.PrintName = "GN Printer Fire"
ENT.Category = "GN DarkRP"
ENT.Author = "Nogitsu & Guthen"
ENT.Spawnable = true

function ENT:SetupPrinter()
    self:SetMaxTime( 1 )

    self:SetDucks( 0 )
    self:SetMaxDucks( 3 )

    self:SetGain( 0.1 )
end

function ENT:SetupColors()
    self:SetMainBackground( GNLib.Colors.Pomegranate:ToVector() )
    self:SetMainForeground( GNLib.Colors.Alizarin:ToVector() )

    self:SetMoneyBackground( GNLib.Colors.Alizarin:ToVector() )
    self:SetMoneyForeground( GNLib.Colors.Pomegranate:ToVector() )

    self:SetTimerBackground( GNLib.Colors.Alizarin:ToVector() )
    self:SetTimerForeground( GNLib.Colors.Pomegranate:ToVector() )
end