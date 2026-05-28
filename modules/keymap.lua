local timers = {}

local function startKeyRepeat(newMods, newKey, mods, key)
	-- 如果已经有一个定时器在运行，先停止它
	if timers[newKey] then
		timers[newKey]:stop()
	end

	-- 创建一个新的定时器，初始延迟后开始频繁触发按键事件
	timers[newKey] = hs.timer.doAfter(0.2, function()
		-- 初始延迟后，立即发送一次按键事件
		hs.eventtap.keyStroke(mods, key, 0)

		-- 开始频繁触发按键事件
		timers[newKey] = hs.timer.doEvery(0.02, function()
			hs.eventtap.keyStroke(mods, key, 0)
		end)
	end)
end

local function stopKeyRepeat(newMods, newKey, mods, key)
	hs.eventtap.keyStroke(mods, key, 0)
	-- 停止定时器
	if timers[newKey] then
		timers[newKey]:stop()
		timers[newKey] = nil
	end
end

local function remapKeyWithRepeat(newMods, newKey, mods, key)
	return hs.hotkey.bind(newMods, newKey, function()
		startKeyRepeat(newMods, newKey, mods, key)
	end, function()
		stopKeyRepeat(newMods, newKey, mods, key)
	end)
end

local function remapKey(newMods, newKey, mods, key)
	return hs.hotkey.bind(newMods, newKey, function()
		hs.eventtap.keyStroke(mods, key, 0)
	end)
end

local terminalApps = {
	Alacritty = true,
	Ghostty = true,
	iTerm2 = true,
	kitty = true,
	Terminal = true,
	WezTerm = true,
}

local function isTerminalApp()
	local app = hs.application.frontmostApplication()
	return app and terminalApps[app:name()] == true
end

local function isChineseInputSource()
	local sourceID = string.lower(hs.keycodes.currentSourceID() or "")
	return sourceID:find("chinese", 1, true)
		or sourceID:find("pinyin", 1, true)
		or sourceID:find("rime", 1, true)
		or sourceID:find("scim", 1, true)
		or sourceID:find("sogou", 1, true)
		or sourceID:find("baidu", 1, true)
		or sourceID:find("wetype", 1, true)
end

-- 使用 Alt + h, Alt + j, Alt + k, Alt + l 替代方向键
remapKeyWithRepeat({ "alt" }, "k", {}, "up")
remapKeyWithRepeat({ "alt" }, "j", {}, "down")
remapKeyWithRepeat({ "alt" }, "h", {}, "left")
remapKeyWithRepeat({ "alt" }, "l", {}, "right")

-- Ctrl+H → Backspace（兼容输入法 composition 状态）
local ctrlHToDelete = remapKeyWithRepeat({ "ctrl" }, "h", {}, "delete")

local function updateCtrlHToDelete()
	if isTerminalApp() and not isChineseInputSource() then
		ctrlHToDelete:disable()
	else
		ctrlHToDelete:enable()
	end
end

ctrlHAppWatcher = hs.application.watcher.new(updateCtrlHToDelete)
ctrlHAppWatcher:start()
hs.keycodes.inputSourceChanged(updateCtrlHToDelete)
updateCtrlHToDelete()

-- 使用 Alt + Shift + k/j/h/l 选中文字（相当于 Shift + 方向键）
remapKeyWithRepeat({ "alt", "shift" }, "k", { "shift" }, "up")
remapKeyWithRepeat({ "alt", "shift" }, "j", { "shift" }, "down")
remapKeyWithRepeat({ "alt", "shift" }, "h", { "shift" }, "left")
remapKeyWithRepeat({ "alt", "shift" }, "l", { "shift" }, "right")

