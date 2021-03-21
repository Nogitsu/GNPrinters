include( "shared.lua" )

--  > Positions
local w, h = 2180, 1380
local circle_r = 320

local circle_time_x, circle_time_y = w - circle_r * 2, h - circle_r * 2.15
local circle_money_x, circle_money_y = w - circle_r * 4.5, h - circle_r * 2.15

GNLib.CreateFonts( "GNP", "Caviar Dreams Bold", { 75, 150, 200 } )

function ENT:DrawTop()
    local pos = self:LocalToWorld( Vector( -7.4, -10.9, 3.05 ) )
    local ang = self:LocalToWorldAngles( Angle( 0, 0, 0 ) )

    ang:RotateAroundAxis( ang:Up(), 90 )

    cam.Start3D2D( pos, ang, 0.01 )
        --  > Background
        surface.SetDrawColor( self:GetMainBackground():ToColor() )
        surface.DrawRect( 0, 0, w, h )

        --  > Header
        surface.SetDrawColor( self:GetMainForeground():ToColor() )
        surface.DrawRect( 0, 0, w, 300 )

        GNLib.SimpleTextShadowed( ("%s's Printer"):format(FPP and IsValid( FPP.entGetOwner( self ) ) and FPP.entGetOwner( self ):Name() or "???"), "GNP200", w / 2, 150, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 10, 10 )

        --  > Circle Time        
        GNLib.DrawCircle( circle_time_x, circle_time_y, circle_r, 0, 360, self:GetTimerBackground():ToColor() )
        GNLib.DrawCircle( circle_time_x, circle_time_y, circle_r, 0, self:GetCurTime() / self:GetMaxTime() * 360, self:GetTimerForeground():ToColor() )
   
        GNLib.SimpleTextShadowed( math.ceil( self:GetMaxTime() - self:GetCurTime() ) .. "s", "GNP150", circle_time_x, circle_time_y, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 7, 7 ) 

        --  > Money
        self.lerp_money = Lerp( FrameTime() * 5, self.lerp_money, self:GetDucks() / self:GetMaxDucks() )
        
        GNLib.DrawCircle( circle_money_x, circle_money_y, circle_r, 0, 360, self:GetMoneyBackground():ToColor() )
        GNLib.DrawCircle( circle_money_x, circle_money_y, circle_r, 0, self.lerp_money * 360, self:GetMoneyForeground():ToColor() )
        GNLib.SimpleTextShadowed( ("%s Ducks"):format( math.Round( self:GetDucks(), 2 ) or 0), "GNP150", circle_money_x, circle_money_y, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 7, 7 )

        --  > Footer
        surface.SetDrawColor( self:GetMainForeground():ToColor() )
        surface.DrawRect( 0, h - 200, w, 200 )
        
        GNLib.SimpleTextShadowed( ("Press [%s] to take (%s$)"):format( input.LookupBinding( "+use" ):upper(), math.ceil( self:GetDucks() * GNPrinter.Config.DuckPrice ) ), "GNP150", w / 2, h - 100, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 7, 7 )
     cam.End3D2D()
end

local w, h = 1382, 607
local circle_r = 100
local circle_money_x, circle_money_y = 130 + circle_r * 2, h - circle_r * 2.7

function ENT:DrawFront()
    local pos = self:LocalToWorld( Vector( 6.39, 10.9, 3.04 ) )
    local ang = self:LocalToWorldAngles( Angle( 0, 180, 90 ) )

    cam.Start3D2D( pos, ang, 0.01 )
        --  > Background
        surface.SetDrawColor( self:GetMainBackground():ToColor() )
        surface.DrawRect( 0, 0, w, h )

        --  > Left side
        surface.SetDrawColor( self:GetMainForeground():ToColor() )
        surface.DrawRect( 0, 0, 200, h )

        --  > Right side
        surface.SetDrawColor( self:GetMainForeground():ToColor() )
        surface.DrawRect( w - 300, 0, 300, h )

        --  > Paper
        self.paper = self:GetPaper() / self:GetMaxPaper()

        GNLib.SimpleTextShadowed( "Papier", "GNP75", circle_money_x, circle_money_y - circle_r * 1.3, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, 2 )
        GNLib.DrawCircle( circle_money_x, circle_money_y, circle_r, 0, 360, self:GetPaperBackground():ToColor() )
        GNLib.DrawCircle( circle_money_x, circle_money_y, circle_r, 90, self.paper * 360 + 90, self:GetPaperForeground():ToColor() )
        GNLib.SimpleTextShadowed( ("%s%%"):format( math.Round( self.paper * 100, 2 ) ), "GNP75", circle_money_x, circle_money_y, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, 4 )

        --  > Ink
        self.ink = self:GetInk() / self:GetMaxInk()

        GNLib.SimpleTextShadowed( "Encre", "GNP75", circle_money_x + circle_r * 3, circle_money_y - circle_r * 1.3, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, 2 )
        GNLib.DrawCircle( circle_money_x + circle_r * 3, circle_money_y, circle_r, 0, 360, self:GetInkBackground():ToColor() )
        GNLib.DrawCircle( circle_money_x + circle_r * 3, circle_money_y, circle_r, 90, self.ink * 360 + 90, self:GetInkForeground():ToColor() )
        GNLib.SimpleTextShadowed( ("%s%%"):format( math.Round( self.ink * 100, 2 ) ), "GNP75", circle_money_x + circle_r * 3, circle_money_y, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, 4 )

        --  > Battery
        self.battery = self:GetBattery() / self:GetMaxBattery()

        GNLib.SimpleTextShadowed( "Batterie", "GNP75", circle_money_x + circle_r * 6, circle_money_y - circle_r * 1.3, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, 2 )
        GNLib.DrawCircle( circle_money_x + circle_r * 6, circle_money_y, circle_r, 0, 360, self:GetBatteryBackground():ToColor() )
        GNLib.DrawCircle( circle_money_x + circle_r * 6, circle_money_y, circle_r, 90, self.battery * 360 + 90, self:GetBatteryForeground():ToColor() )
        GNLib.SimpleTextShadowed( ("%s%%"):format( math.Round( self.battery * 100, 2 ) ), "GNP75", circle_money_x + circle_r * 6, circle_money_y, _, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, 4 )

    cam.End3D2D()
end

function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 10^5 then return end

    self.lerp_money = self.lerp_money or 0

    self:DrawTop()
    self:DrawFront()
end