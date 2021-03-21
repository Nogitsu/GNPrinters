--  > Customisation panel
local main_color = GNLib.Colors.Clouds
local hovered_color = GNLib.Colors.Silver
local group_h = 210

local entry_x, entry_y = 1, 0
local function ValueEntry( pnl, info, min, value )
    --[[
    local text = vgui.Create( "GNLabel", pnl )
    text:SetText( info )
    text:SetPos( 15, 80 + 30 * i )
    text:SetFont( "GNLFontB20" )

    local num = vgui.Create( "DNumberWang", pnl )
    num:SetPos( 5 + text:GetWide(), 80 + 30 * i )
    num:SetMinMax( min, math.huge )
    num:SetValue( value )
    ]]

    local num = pnl:Add( "GNNumEntry" )
        num:SetPos( 15 + 110 * entry_x, 25 + entry_y * 35 )
        num:SetSize( 180, 30 )
        num:SetTitle( info )
        num:SetMin( min )
        num:SetValue( value )
        num:SetColor( main_color )
        num:SetHoveredColor( hovered_color )

    entry_y = entry_y + 1
    if entry_y == 3 then
        entry_x = 2
        entry_y = 0
    end

    return num
end

local color_x, color_y = 0, 1
local function CircleColors( pnl, info, back_col, front_col )
    --[[
    local title = vgui.Create( "GNLabel", pnl )
    title:SetText( info )
    title:SetPos( 15, 275 + 300 * i )
    title:SetFont( "GNLFontB20" )

    local text_back = vgui.Create( "GNLabel", pnl )
    text_back:SetText( "Background" )
    text_back:SetPos( 35, title.y + title:GetTall() )
    text_back:SetFont( "GNLFontB20" )
    ]]--

    local color_box = pnl:Add( "GNGroupBox" )
        color_box:SetSize( 450, group_h )
        color_box:SetPos( color_x * ( color_box:GetWide() + 15 ), ( color_box:GetTall() + 15 ) * color_y )
        color_box:SetTitle( info )
        color_box:SetColor( main_color )
        color_box:SetFont( "GNLFontB20" )

    local back_label = color_box:Add( "DLabel" )
        back_label:SetPos( 40, 25 )
        back_label:SetText( "Background" )
        back_label:SetFont( "GNLFontB20" )
        back_label:SetColor( GNLib.Colors.Clouds )
        back_label:SizeToContents()

    local back = vgui.Create( "DPanel", color_box )
        back:SetPos( 40, 50 )

    local selector_back = vgui.Create( "GNColorPicker", back )
        selector_back:SetPos( 5, 5 )
        selector_back:SetSize( group_h / 1.5, group_h / 1.5 )
        selector_back:SetColor( back_col )

    back:SetSize( selector_back:GetWide() + 10, selector_back:GetTall() + 10 )
    function back:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, selector_back:GetColor() )
    end

    local front_label = color_box:Add( "DLabel" )
        front_label:SetPos( 250, 25 )
        front_label:SetText( "Foreground" )
        front_label:SetFont( "GNLFontB20" )
        front_label:SetColor( GNLib.Colors.Clouds )
        front_label:SizeToContents()

    local front = vgui.Create( "DPanel", color_box )
        front:SetPos( 250, 50 )

    local selector_front = vgui.Create( "GNColorPicker", front )
        selector_front:SetPos( 5, 5 )
        selector_front:SetSize( group_h / 1.5, group_h / 1.5 )
        selector_front:SetColor( table.Copy( front_col ) )

    front:SetSize( selector_front:GetWide() + 10, selector_front:GetTall() + 10 )
    function front:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, selector_front:GetColor() )
    end

    color_y = color_y + 1
    if color_y > 2 then
        color_y = -1
        color_x = color_x + 1
    end

    return selector_back, selector_front
end

local function EditPrinter( p_class, printer )
    local frame = GNLib.CreateFrame( "GNPrinter - " .. (printer and ("Editing '%s'"):format( printer.PrintName ) or "Adding New Printer")  )
    function frame:OnRemove()
        RunConsoleCommand( "gnprinters" )
    end

    entry_x, entry_y = 0, 0
    color_x, color_y = 0, 1

    local icop = vgui.Create( "DScrollPanel", frame )
    icop:Dock( FILL )
    icop:DockMargin( 20, 0, -20, 0 )

    local stats_box = vgui.Create( "GNGroupBox", icop )
        stats_box:SetTitle( "Statistics" )
        stats_box:SetSize( 450, group_h )
        stats_box:SetColor( main_color )
        stats_box:SetFont( "GNLFontB20" )

    local name = vgui.Create( "GNTextEntry", stats_box )
        name:SetFont( "GNLFontB17" )
        name:SetTitle( "Printer's Name" )
        name:SetPlaceholder( "Custom printer" )
        name:SetText( printer and printer.PrintName or "" )
        name:SetPos( 15, 20 )
        name:SetWide( 200 )
        name:SetColor( main_color )
        name:SetHoveredColor( hovered_color )

    local class = vgui.Create( "GNTextEntry", stats_box )
        class:SetFont( "GNLFontB17" )
        class:SetTitle( "Printer's Class" )
        class:SetPlaceholder( "my_printer" )
        class:SetText( p_class or "" )
        class:SetPos( 235, 20 )
        class:SetWide( 200 )
        class:SetColor( main_color )
        class:SetHoveredColor( hovered_color )

    local num_box = vgui.Create( "GNGroupBox", stats_box )
        num_box:SetTitle( "Settings" )
        num_box:SetPos( 10, 60 )
        num_box:SetSize( 450 - 20, group_h / 1.5 )
        num_box:SetColor( main_color )
        num_box:SetFont( "GNLFontB20" )

    --  > Values
    local time = ValueEntry( num_box, "Time between gains", 0.1, printer and printer.stats.max_time or 0.1 )
    local ducks = ValueEntry( num_box, "Max Ducks", 1, printer and printer.stats.max_ducks or 2 )
    local gain = ValueEntry( num_box, "Gains", 0.1, printer and printer.stats.ducks_gain or 0.1 )

    local paper = ValueEntry( num_box, "Paper storage", 2, printer and printer.stats.max_paper or 2 )
    local ink = ValueEntry( num_box, "Ink storage", 2, printer and printer.stats.max_ink or 2 )
    local battery = ValueEntry( num_box, "Battery capacity", 2, printer and printer.stats.max_battery or 2 )

    --  > Colors
    local colors_main_back, colors_main_front = CircleColors( icop, "Main colors", printer and printer.colors.main.background or GNLib.Colors.MidnightBlue, printer and printer.colors.main.foreground or GNLib.Colors.WetAsphalt )
    local colors_money_back, colors_money_front = CircleColors( icop, "Money colors", printer and printer.colors.money.background or GNLib.Colors.GreenSea, printer and printer.colors.money.foreground or GNLib.Colors.Turquoise )
    local colors_timer_back, colors_timer_front = CircleColors( icop, "Timer colors", printer and printer.colors.timer.background or GNLib.Colors.Wisteria, printer and printer.colors.timer.foreground or GNLib.Colors.Amethyst )

    local colors_paper_back, colors_paper_front = CircleColors( icop, "Paper colors", printer and printer.colors.paper.background or GNLib.Colors.Asbestos, printer and printer.colors.paper.foreground or GNLib.Colors.Concrete )
    local colors_ink_back, colors_ink_front = CircleColors( icop, "Ink colors", printer and printer.colors.ink.background or GNLib.Colors.BelizeHole, printer and printer.colors.ink.foreground or GNLib.Colors.PeterRiver )
    local colors_battery_back, colors_battery_front = CircleColors( icop, "Battery colors", printer and printer.colors.battery.background or GNLib.Colors.Nephritis, printer and printer.colors.battery.foreground or GNLib.Colors.Emerald )

    --  > Saving
    local save = vgui.Create( "GNButton", icop )
        save:SetPos( frame:GetWide() - save:GetWide() - 45, frame:GetTall() - 85 )
        save:SetText( "Save" )
        save:SetColor( GNLib.Colors.Nephritis )
        save:SetHoveredColor( GNLib.Colors.Emerald )
        save:SetTextColor( GNLib.Colors.Clouds )
        save:SetHoveredTextColor( GNLib.Colors.Silver )
    function save:DoClick()
        local new_printer = {
            colors = {
                main = { 
                    background = colors_main_back:GetColor(),
                    foreground = colors_main_front:GetColor(),
                },
                money = { 
                    background = colors_money_back:GetColor(),
                    foreground = colors_money_front:GetColor(),
                },
                timer = { 
                    background = colors_timer_back:GetColor(),
                    foreground = colors_timer_front:GetColor(),
                },
                paper = { 
                    background = colors_paper_back:GetColor(),
                    foreground = colors_paper_front:GetColor(),
                },
                ink = { 
                    background = colors_ink_back:GetColor(),
                    foreground = colors_ink_front:GetColor(),
                },
                battery = { 
                    background = colors_battery_back:GetColor(),
                    foreground = colors_battery_front:GetColor(),
                }
            },
            stats = {
                max_time = time:GetValue(),
                max_ducks = ducks:GetValue(),
                ducks_gain = gain:GetValue(),
                max_paper = paper:GetValue(),
                max_ink = ink:GetValue(),
                max_battery = battery:GetValue()
            }  
        }

        local compressed = util.Compress( util.TableToJSON( new_printer ) )

        net.Start( "GNPrinters:SaveNew" )
            net.WriteString( class:GetValue() )
            net.WriteString( name:GetValue() )
            net.WriteData( compressed, #compressed )
        net.SendToServer()

        frame:Close()
    end

    local remove = vgui.Create( "GNButton", icop )
        remove:SetPos( save.x - remove:GetWide() - 25, save.y )
        remove:SetText( "Remove" )
        remove:SetColor( GNLib.Colors.Alizarin )
        remove:SetHoveredColor( GNLib.Colors.Pomegranate )
        remove:SetTextColor( GNLib.Colors.Clouds )
        remove:SetHoveredTextColor( GNLib.Colors.Silver )
    function remove:DoClick()
        net.Start( "GNPrinters:Remove" )
            net.WriteString( class:GetValue() )
        net.SendToServer()

        frame:Close()
    end
end

--  > List panel
local function PrinterSlot( slots, class, printer )
    local stats = {
        { text = "Max time: " .. printer.stats.max_time, theme = printer.colors.timer },
        { text = "Max ducks: " .. printer.stats.max_ducks, theme = printer.colors.money },
        { text = printer.stats.ducks_gain .. " Ducks per time", theme = printer.colors.money },
        { text = "Max paper: " .. printer.stats.max_paper, theme = printer.colors.paper },
        { text = "Max ink: " .. printer.stats.max_ink, theme = printer.colors.ink },
        { text = "Max battery: " .. printer.stats.max_battery, theme = printer.colors.battery },
    }

    local slot = slots:Add( "DButton" )
    slot:SetSize( 200, 175 )
    slot:SetText( "" )
    function slot:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, color_white )

        draw.RoundedBox( 10, 1, 1, w - 2, h - 2, printer.colors.main.background )
        draw.RoundedBoxEx( 10, 1, 1, w - 2, 25, printer.colors.main.foreground, true, true )

        GNLib.SimpleTextShadowed( printer.PrintName, "GNLFontB20", w / 2, 13, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, _, _, _ )

        for i, v in ipairs( stats ) do
            surface.SetFont( "GNLFontB20")
            local text_w, text_h = surface.GetTextSize( v.text )

            GNLib.DrawElipse( 5, 15 + i * (text_h + 5), text_w + 10, text_h, self:IsHovered() and v.theme.foreground or v.theme.background )

            surface.SetTextColor( color_white )
            surface.SetTextPos( 10, 15 + i * (text_h + 5) )
            surface.DrawText( v.text )
        end
    end
    function slot:DoClick()
        EditPrinter( class, printer )
        slots:GetParent():Remove()
    end
end

local function GNPrintersConfig( printers )
    local frame = GNLib.CreateFrame( "GNPrinter - Configuration" )

    local slots = vgui.Create( "DTileLayout", frame )
    slots:Dock( FILL )
    slots:DockMargin( 5, 15, 5, 5)
    slots:SetSpaceY( 5 )
    slots:SetSpaceX( 5 )

    for k, v in pairs( printers ) do
        PrinterSlot( slots, k, v )
    end

    local new_printer = slots:Add( "DButton" )
    new_printer:SetText( "" )
    new_printer:SetSize( 75, 175 )
    function new_printer:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, self:IsHovered() and GNLib.Colors.Amethyst or GNLib.Colors.Wisteria )
        GNLib.SimpleTextShadowed( "+", "GNLFontB40", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, _, _, _ )
    end
    function new_printer:DoClick()
        EditPrinter()
        frame:Remove()
    end
end

concommand.Add( "gnprinters", function()
    net.Start( "GNPrinter:OpenMenu" )
    net.SendToServer()
end )

net.Receive( "GNPrinter:OpenMenu", function( len )
    local printers = net.ReadData( len )

    GNPrintersConfig( util.JSONToTable( util.Decompress( printers ) ) )
end )

--  > Register

net.Receive( "GNPrinter:Register", function( len )
    local class = net.ReadString()
    local name = net.ReadString()

    local new_printer = scripted_ents.Get( "gn_printer_base" )
    new_printer.PrintName = name
    
    scripted_ents.Register( new_printer, class )
end )

hook.Add( "InitPostEntity", "GNPrinter:RegisterClientside", function()
    net.Start( "GNPrinter:Register" )
    net.SendToServer()
end )