hs.window.animationDuration = 0
local function getWinList(name)
	return hs.window.filter.new(false):setAppFilter(name, { currentSpace = true }):getWindows()
end

local function launchOrNextWindow(name)
	-- 获取应用程序对象
	local app = hs.application.get(name)
	-- hs.alert(name)
	if not app then
		-- 如果应用程序未运行，则启动它
		hs.application.launchOrFocus(name)
	else
		local findName = name
		local appName = hs.application.frontmostApplication():name()
		-- hs.alert(appName)
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
				local win = wlist[1]
				if win:isMinimized() then
					win:unminimize()
				else
					-- win:minimize()
				end
			end
		end
	end
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

-- 切换应用程序的可见性
local function toggleAppVisibility(appName)
	local app = hs.application.get(appName)

	if app then
		if isAppFrontmostByWindows(appName) then
			-- 如果应用程序在前台，隐藏所有窗口
			app:hide()
		else
			-- 否则，启动或聚焦到应用程序
			hs.application.launchOrFocus(appName)
		end
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
	launchOrNextWindow("Lark")
end)

hs.hotkey.bind({ "alt" }, "w", function()
	toggleAppVisibility("WeChat")
end)

hs.hotkey.bind({ "alt" }, "i", function()
	-- launchOrNextWindow("iTerm2")
	launchOrNextWindow("Ghostty")
end)

hs.hotkey.bind({ "alt" }, "q", function()
	-- launchOrNextWindow("iTerm2")
	launchOrNextWindow("Ghostty")
end)

-- hs.hotkey.bind({ 'alt' }, 'v', function()
--   launchOrNextWindow('', 'com.microsoft.VSCode')
-- end)
--
-- hs.hotkey.bind({ 'alt' }, 'u', function()
--   launchOrNextWindow('', 'com.electron.lark.iron')
-- end)
