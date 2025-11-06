hs.window.animationDuration = 0
local function getWinList(name)
	return hs.window.filter.new(false):setAppFilter(name, { currentSpace = true }):getWindows()
end

local function launchOrNextWindow(name)
	-- 获取应用程序对象
	local app = hs.application.get(name)
	if not app then
		-- 如果应用程序未运行，则启动它
		hs.application.launchOrFocus(name)
	else
		local findName = name
		local appName = hs.application.frontmostApplication():name()
		if findName ~= appName then
			-- 如果应用程序正在运行，切换到下一个窗口
			local window = app:mainWindow()
			if window then
				window:focus()
			else
				-- 如果没有主窗口，启动焦点到应用程序
				hs.application.launchOrFocus(appName)
			end
		else
			local wlist = getWinList(findName)
			local wcount = #wlist
			if wcount > 1 then
				hs.eventtap.keyStroke({ "cmd" }, "`")
			else
				app:hide()
			end
		end
	end
end

local function isWeChatFrontmost()
	local fw = hs.window.frontmostWindow()
	if not fw then
		return false
	end
	local app = fw:application()
	return app and app:bundleID() == "com.tencent.xinWeChat"
end

-- 检查应用程序的窗口是否在前台
local function isAppFrontmostByWindows(appName)
	local app = hs.application.get(appName)
	if not app then
		return false
	end

	local windows = app:allWindows()
	for _, window in ipairs(windows) do
		if window:isVisible() and window:isFrontmost() then
			return true
		end
	end

	return false
end

local function focusChromeWindowByTitle(titlePattern)
	for _, win in ipairs(hs.window.allWindows()) do
		if win:application():name() == "Google Chrome" and string.match(win:title(), titlePattern) then
			win:focus()
			return
		end
	end
	hs.alert("No matching Chrome window found")
end

-- 切换应用程序的可见性
local function toggleWeChatVisibility(appName)
	local app = hs.application.get(appName)

	if app then
		hs.eventtap.keyStroke({ "shift", "cmd" }, "w")
		-- if isWeChatFrontmost(appName) then
		-- 	-- 如果应用程序在前台，隐藏所有窗口
		-- 	app:hide()
		-- else
		-- 	-- 否则，启动或聚焦到应用程序
		-- 	hs.application.launchOrFocus(appName)
		-- end
	else
		-- 如果应用程序未运行，启动它
		hs.application.launchOrFocus(appName)
	end
end

-- hs.hotkey.bind({ 'cmd' }, 'i', function()
--    launchOrNextWindow('Alacritty')
-- end)

hs.hotkey.bind({ "alt" }, "g", function()
	launchOrNextWindow("Google Chrome")
	-- launchOrNextWindow("Arc")
end)

hs.hotkey.bind({ "alt" }, "b", function()
	-- launchOrNextWindow("Google Chrome")
	launchOrNextWindow("Arc")
end)

hs.hotkey.bind({ "alt" }, "e", function()
	launchOrNextWindow("飞书")
end)

hs.hotkey.bind({ "alt" }, "u", function()
	launchOrNextWindow("Simulator")
	focusChromeWindowByTitle("React Native DevTools")
end)

hs.hotkey.bind({ "alt" }, "w", function()
	toggleWeChatVisibility("WeChat")
end)

hs.hotkey.bind({ "alt" }, "i", function()
	-- launchOrNextWindow("iTerm2")
	launchOrNextWindow("Ghostty")
end)

hs.hotkey.bind({ "alt" }, "q", function()
	-- launchOrNextWindow("iTerm2")
	launchOrNextWindow("Cursor")
end)

hs.hotkey.bind({ "alt" }, "x", function()
	launchOrNextWindow("Xcode")
end)

-- hs.hotkey.bind({ 'alt' }, 'v', function()
--   launchOrNextWindow('', 'com.microsoft.VSCode')
-- end)
--
-- hs.hotkey.bind({ 'alt' }, 'u', function()
--   launchOrNextWindow('', 'com.electron.lark.iron')
-- end)
