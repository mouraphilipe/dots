-----------------------------------------------------------------------------------------------------------------------
--                                                Colorless config                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Load modules
-----------------------------------------------------------------------------------------------------------------------

-- Standard awesome library
------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("awful.autofocus")

-- User modules
------------------------------------------------------------
local redflat = require("redflat")

redflat.startup:activate()

-- Error handling
-----------------------------------------------------------------------------------------------------------------------
require("colorless.ercheck-config") -- load file with error handling


-- Setup theme and environment vars
-----------------------------------------------------------------------------------------------------------------------
local env = require("colorless.env-config") -- load file with environment
env:init({terminal = "st"})


-- Layouts setup
-----------------------------------------------------------------------------------------------------------------------
local layouts = require("colorless.layout-config") -- load file with tile layouts setup
layouts:init()


-- Main menu configuration
-----------------------------------------------------------------------------------------------------------------------
local mymenu = require("colorless.menu-config") -- load file with menu configuration
mymenu:init({ env = env })


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- Separator
--------------------------------------------------------------------------------
local separator = redflat.gauge.separator.vertical()

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, redflat.widget.tasklist.action.select),
	awful.button({}, 2, redflat.widget.tasklist.action.close),
	awful.button({}, 3, redflat.widget.tasklist.action.menu),
	awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Taglist widget
--------------------------------------------------------------------------------
local taglist = {}
taglist.style = { widget = redflat.gauge.tag.orange.new, show_tip = true }
taglist.buttons = awful.util.table.join(
	awful.button({         }, 1, function(t) t:view_only() end),
	awful.button({ env.mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
	awful.button({         }, 2, awful.tag.viewtoggle),
	awful.button({         }, 3, function(t) redflat.widget.layoutbox:toggle_menu(t) end),
	awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
	awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Textclock widget
--------------------------------------------------------------------------------
local textclock = {}
textclock.widget = redflat.widget.textclock({ timeformat = "%H:%M %Y-%m-%d", dateformat = "%b  %d  %a" })
-- local wpp= awful.spawn("surf")
-- wpp:raise()
-- -- Battery widget
--------------------------------------------------------------------------------
local battery= {}
battery.widget = redflat.widget.battery({ func = redflat.system.pformatted.bat(25), arg = "BAT0" },{ timeout = 60, monitor = { label = "BAT" }})

-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc( 1) end),
	awful.button({ }, 3, function () redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
	awful.button({ }, 4, function () awful.layout.inc( 1) end),
	awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray()

tray.buttons = awful.util.table.join(
	awful.button({}, 1, function() redflat.widget.minitray:toggle() end)
)


-- Screen setup
-----------------------------------------------------------------------------------------------------------------------
awful.screen.connect_for_each_screen(
	function(s)
		-- wallpaper
		env.wallpaper(s)

		-- tags
		awful.tag({ "Tag1", "Tag2", "Tag3", "Tag4", "Tag5" , "Tag6", "Tag7", "Tag8", "Tag9"}, s, awful.layout.layouts[1])

		-- layoutbox widget
		layoutbox[s] = redflat.widget.layoutbox({ screen = s })

		-- taglist widget
		taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

		-- tasklist widget
		tasklist[s] = redflat.widget.tasklist({ screen = s, buttons = tasklist.buttons })

		-- panel wibox
		s.panel = awful.wibar({ position = "bottom", screen = s, height = beautiful.panel_height or 36 })

		-- add widgets to the wibox
		s.panel:setup {
			layout = wibox.layout.align.horizontal,
			{ -- left widgets
				layout = wibox.layout.fixed.horizontal,

				-- env.wrapper(mymenu.widget, "mainmenu", mymenu.buttons),
				-- separator,
				env.wrapper(taglist[s], "taglist"),
				env.wrapper(layoutbox[s], "layoutbox", layoutbox.buttons),
				-- separator,
				s.mypromptbox,
			},
			{ -- middle widget
				layout = wibox.layout.align.horizontal,
				expand = "outside",

				nil,
				env.wrapper(tasklist[s], "tasklist"),
			},
			{ -- right widgets
				layout = wibox.layout.fixed.horizontal,

				-- separator,
				-- separator,
				env.wrapper(textclock.widget, "textclock"),
				env.wrapper(battery.widget, "battery"),
				-- separator,
				env.wrapper(tray.widget, "tray", tray.buttons),
			},
		}
	end
)


-- Key bindings
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = require("colorless.keys-config") -- load file with hotkeys configuration
hotkeys:init({ env = env, menu = mymenu.mainmenu })


-- Rules
-----------------------------------------------------------------------------------------------------------------------
local rules = require("colorless.rules-config") -- load file with rules configuration
rules:init({ hotkeys = hotkeys})


-- Titlebar setup
-----------------------------------------------------------------------------------------------------------------------
local titlebar = require("colorless.titlebar-config") -- load file with titlebar configuration
titlebar:init()


-- Base signal set for awesome wm
-----------------------------------------------------------------------------------------------------------------------
local signals = require("colorless.signals-config") -- load file with signals configuration
signals:init({ env = env })

awful.spawn("compton")
awful.spawn("nm-applet")
awful.spawn("mpd")
-- Keyboard settings
awful.spawn("setxkbmap -option caps:escape")
awful.spawn("setxkbmap -option compose:rctrl")
-- Mouse configs
awful.spawn("xinput set-prop 'DLL0675:00 06CB:75DB Touchpad' 'Synaptics Scrolling Distance' -20 -20")
awful.spawn("xinput set-prop 'DLL0675:00 06CB:75DB Touchpad' 'Synaptics Two-Finger Scrolling' 1 0")
awful.spawn("xinput set-prop 'DLL0675:00 06CB:75DB Touchpad' 'Synaptics Edge Scrolling'  0 0 0")
awful.spawn("xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Scrolling Distance' -200 -20")
awful.spawn("xinput set-prop 'DELL0820:00 044E:121F Touchpad' 'libinput Natural Scrolling Enabled' 1")
awful.spawn("xinput set-prop 'DELL0820:00 044E:121F Touchpad' 'libinput Tapping Enabled' 1")

-- wacom
awful.spawn("xinput set-prop 'ELAN Touchscreen' 'Device Enabled' 0")
awful.spawn("xinput set-prop 'Wacom Intuos PT S 2 Finger touch' 'Wacom Touch Gesture Parameters' 1, 10, 10")
awful.spawn("xsetwacom set 'Wacom Intuos PT S 2 Pad pad' Button 3 22")
awful.spawn("xsetwacom set 'Wacom Intuos PT S 2 Pad pad' Button 1 23")
awful.spawn("xsetwacom set 'Wacom Intuos PT S 2 Pad pad' Button 9 24")
awful.spawn("xsetwacom set 'Wacom Intuos PT S 2 Pad pad' Button 8 25")
