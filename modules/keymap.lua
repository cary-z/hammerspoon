local timers = {}

local function startKeyRepeat(newMods, newKey, mods, key)
	-- 如果已经有一个定时器在运行，先停止它
	if timers[newKey] then
		timers[newKey]:stop()
	end

	-- 创建一个新的定时器，初始延迟后开始频繁触发按键事件
	timers[newKey] = hs.timer.doAfter(0.3, function()
		-- 初始延迟后，立即发送一次按键事件
		hs.eventtap.keyStroke(mods, key, 0)

		-- 开始频繁触发按键事件
		timers[newKey] = hs.timer.doEvery(0.05, function()
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
	hs.hotkey.bind(newMods, newKey, function()
		startKeyRepeat(newMods, newKey, mods, key)
	end, function()
		stopKeyRepeat(newMods, newKey, mods, key)
	end)
end

local function remapKey(newMods, newKey, mods, key)
	hs.hotkey.bind(newMods, newKey, function()
		hs.eventtap.keyStroke(mods, key, 0)
	end)
end

-- 使用 Alt + h, Alt + j, Alt + k, Alt + l 替代方向键
remapKeyWithRepeat({ "alt" }, "k", {}, "up")
remapKeyWithRepeat({ "alt" }, "j", {}, "down")
remapKeyWithRepeat({ "alt" }, "h", {}, "left")
remapKeyWithRepeat({ "alt" }, "l", {}, "right")

-- 使用组合键位代替回车和回退
-- remapKey({ "alt" }, "o", {}, "return")
-- remapKeyWithRepeat({ "alt" }, "p", {}, "delete")
