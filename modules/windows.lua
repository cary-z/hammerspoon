-- window management
local hotkey = require("hs.hotkey")
local window = require("hs.window")
local layout = require("hs.layout")
local alert = require("hs.alert")
local fnutils = require("hs.fnutils")
local geometry = require("hs.geometry")
local mouse = require("hs.mouse")

-- left half
hotkey.bind({ "cmd", "alt" }, "h", function()
	if window.focusedWindow() then
		window.focusedWindow():moveToUnit(layout.left50)
	else
		alert.show("No active window")
	end
end)

-- right half
hotkey.bind({ "cmd", "alt" }, "l", function()
	window.focusedWindow():moveToUnit(layout.right50)
end)

-- -- top half
hotkey.bind({ "cmd", "alt" }, "k", function()
	window.focusedWindow():moveToUnit("[0,0,100,50]")
end)
--
-- -- bottom half
hotkey.bind({ "cmd", "alt" }, "j", function()
	window.focusedWindow():moveToUnit("[0,50,100,100]")
end)
--
-- left top quarter
hotkey.bind({ "alt", "shift" }, "h", function()
	window.focusedWindow():moveToUnit("[0,0,50,50]")
end)
--
--
-- right top quarter
hotkey.bind({ "alt", "shift" }, "l", function()
	window.focusedWindow():moveToUnit("[50,0,100,50]")
end)
--
-- left bottom quarter
hotkey.bind({ "alt", "shift" }, "k", function()
	window.focusedWindow():moveToUnit("[0,50,50,100]")
end)

-- right bottom quarter
hotkey.bind({ "alt", "shift" }, "j", function()
	window.focusedWindow():moveToUnit("[50,50,100,100]")
end)

-- full screen
hotkey.bind({ "cmd", "alt" }, "F", function()
	local win = window.focusedWindow()
	win:maximize()
end)

-- move active window to previous monitor
hotkey.bind({ "cmd", "alt", "ctrl" }, "h", function()
	window.focusedWindow():moveOneScreenWest():maximize()
end)

-- move active window to next monitor
hotkey.bind({ "cmd", "alt", "ctrl" }, "l", function()
	window.focusedWindow():moveOneScreenEast():maximize()
end)
--

--Predicate that checks if a window belongs to a screen
local function isInScreen(targetScreen, win)
	return win:screen() == targetScreen
end

local function focusScreen(screen1)
	local windows = fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreen, screen1))
	local windowToFocus = #windows > 0 and windows[1] or window.desktop()
	if windowToFocus ~= nil then
		windowToFocus:focus()
	end

	local pt = geometry.rectMidPoint(screen1:fullFrame())
	mouse.setAbsolutePosition(pt)
end
-- move cursor to previous monitor
hotkey.bind({ "alt" }, "Left", function()
	focusScreen(window.focusedWindow():screen():previous())
end)

-- move cursor to next monitor
hotkey.bind({ "alt" }, "Right", function()
	focusScreen(window.focusedWindow():screen():next())
end)

-- 显示桌面
hotkey.bind({ "cmd" }, "h", function()
	local apps = hs.application.runningApplications()
	for i = 1, #apps do
		apps[i]:hide()
	end
end)
