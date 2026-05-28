hs.hotkey.bind({ "cmd", "alt" }, "R", function()
	hs.reload()
end)

hs.alert("reload hammerspoonrc")

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "s", function()
	local currentActiveApp = hs.application.frontmostApplication()
	local name = currentActiveApp:name()
	hs.alert(name)
end)

require("modules/keymap")
require("modules/launch")
require("modules/windows")
