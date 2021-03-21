ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName = "GN Printer Base"
ENT.Category = "GN DarkRP"
ENT.Author = "Nogitsu & Guthen"
ENT.Spawnable = true

function ENT:SetupDataTables()
    --  > Printer's caracteristics
    self:NetworkVar( "Float", 0, "CurTime" )
    self:NetworkVar( "Float", 1, "MaxTime" )

    self:NetworkVar( "Float", 2, "Ducks" )
    self:NetworkVar( "Float", 3, "MaxDucks" )

    self:NetworkVar( "Float", 4, "Paper" )
    self:NetworkVar( "Float", 5, "MaxPaper" )

    self:NetworkVar( "Float", 6, "Ink" )
    self:NetworkVar( "Float", 7, "MaxInk" )

    self:NetworkVar( "Float", 8, "Battery" )
    self:NetworkVar( "Float", 9, "MaxBattery" )

    self:NetworkVar( "Float", 10, "Gain" )

    --  > Interface's colors
    self:NetworkVar( "Vector", 0, "MainBackground")
    self:NetworkVar( "Vector", 1, "MainForeground")

    self:NetworkVar( "Vector", 2, "MoneyBackground")
    self:NetworkVar( "Vector", 3, "MoneyForeground")

    self:NetworkVar( "Vector", 4, "TimerBackground")
    self:NetworkVar( "Vector", 5, "TimerForeground")

    self:NetworkVar( "Vector", 6, "PaperBackground")
    self:NetworkVar( "Vector", 7, "PaperForeground")

    self:NetworkVar( "Vector", 8, "InkBackground")
    self:NetworkVar( "Vector", 9, "InkForeground")

    self:NetworkVar( "Vector", 10, "BatteryBackground")
    self:NetworkVar( "Vector", 11, "BatteryForeground")
end