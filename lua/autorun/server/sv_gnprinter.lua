GNPrinter = GNPrinter or {}

local function Vectorize( color ) -- Looks like Color:ToVector() isn't working with our tables
    return Color( color.r, color.g, color.b, color.a ):ToVector()
end

function GNPrinter.RemovePrinter( class )
    local path = "gnprinters/printers/gnprinters_" .. class:gsub( "gnprinters_", "" ) .. ".json"
    if file.Exists( path, "DATA" ) then
        file.Delete( path )
    end
end

function GNPrinter.SavePrinter( class, name, printer )
    file.CreateDir( "gnprinters" )
    file.CreateDir( "gnprinters/printers" )

    printer.PrintName = name

    file.Write( "gnprinters/printers/gnprinters_" .. class:gsub( "gnprinters_", "" ) .. ".json", util.TableToJSON( printer ) )
end

util.AddNetworkString( "GNPrinters:SaveNew" )
net.Receive( "GNPrinters:SaveNew", function( len, ply )
    if not ply:IsSuperAdmin() then return end

    local class = net.ReadString()
    local name = net.ReadString()
    local data = net.ReadData( len - #class - #name )
    local printer = util.JSONToTable( util.Decompress( data ) )

    GNPrinter.SavePrinter( class, name, printer )
    ply:PrintMessage( HUD_PRINTTALK, "You need to restart your game/server to apply the changes." )
end )

util.AddNetworkString( "GNPrinters:Remove" )
net.Receive( "GNPrinters:Remove", function( len, ply )
    if not ply:IsSuperAdmin() then return end
    
    local class = net.ReadString()

    GNPrinter.RemovePrinter( class )
    ply:PrintMessage( HUD_PRINTTALK, "You need to restart your game/server to apply the changes." )
end )

function GNPrinter.GetPrinter( class )
    return util.JSONToTable( file.Read( "gnprinters/printers/gnprinters_" .. class:gsub( "gnprinters_", "" ) .. ".json" ) ) or GNLib.Error()
end

function GNPrinter.GetPrintersList()
    local files = file.Find( "gnprinters/printers/gnprinters_*.json", "DATA" )
    if not files then return end

    local printers = {}
    
    for i, v in ipairs( files ) do
        printers[ i ] = v:gsub( ".json", "" )    
    end

    return printers
end

function GNPrinter.GetPrinters()
    local printers = {}
    
    for i, v in ipairs( GNPrinter.GetPrintersList() ) do
        printers[ v ] = GNPrinter.GetPrinter( v ) 
    end

    return printers
end

util.AddNetworkString( "GNPrinter:Register" )
function GNPrinter.RegisterAll()
    local printer_base = scripted_ents.Get( "gn_printer_base" )

    for k, v in pairs( GNPrinter.GetPrinters() ) do
        local new_printer = table.Copy( printer_base )
        
        new_printer.PrintName = v.PrintName

        function new_printer:DefaultSetup()
            --  ENT:SetupPrinter
            self:SetMaxTime( v.stats.max_time )
            self:SetMaxDucks( v.stats.max_ducks )
        
            self:SetMaxPaper( v.stats.max_paper )
            self:SetMaxInk( v.stats.max_ink )
            self:SetMaxBattery( v.stats.max_battery )
        
            self:SetGain( v.stats.ducks_gain )
        
            -- ENT:SetupColors
            self:SetMainBackground( Vectorize( v.colors.main.background ) )
            self:SetMainForeground( Vectorize( v.colors.main.foreground ) )
        
            self:SetMoneyBackground( Vectorize( v.colors.money.background ) )
            self:SetMoneyForeground( Vectorize( v.colors.money.foreground ) )
        
            self:SetTimerBackground( Vectorize( v.colors.timer.background ) )
            self:SetTimerForeground( Vectorize( v.colors.timer.foreground ) )
        
            self:SetPaperBackground( Vectorize( v.colors.paper.background ) )
            self:SetPaperForeground( Vectorize( v.colors.paper.foreground ) )
        
            self:SetInkBackground( Vectorize( v.colors.ink.background ) )
            self:SetInkForeground( Vectorize( v.colors.ink.foreground ) )
        
            self:SetBatteryBackground( Vectorize( v.colors.battery.background ) )
            self:SetBatteryForeground( Vectorize( v.colors.battery.foreground ) )
        end

        scripted_ents.Register( new_printer, k )
    end
end

hook.Add( "InitPostEntity", "GNPrinter:RegisterOnPostInit", function()
    GNPrinter.RegisterAll()
end )

net.Receive( "GNPrinter:Register", function( len, ply )
    for k, v in pairs( GNPrinter.GetPrinters() ) do
        net.Start( "GNPrinter:Register" )
            net.WriteString( k )
            net.WriteString( v.PrintName )
        net.Send( ply )
    end

    ply:ConCommand( "spawnmenu_reload" )
end )

util.AddNetworkString( "GNPrinter:OpenMenu" )
net.Receive( "GNPrinter:OpenMenu", function( _, ply )
    local compressed = util.Compress( util.TableToJSON( GNPrinter.GetPrinters() ) )
    net.Start( "GNPrinter:OpenMenu" )
        net.WriteData( compressed, #compressed )
    net.Send( ply )
end )