-- Ctrl+H → Backspace 映射
-- 原生的 Ctrl+H 发送 ASCII 0x08 控制字符，输入法在 composition 状态
-- 下无法处理，会先 commit 再删除。用 eventtap 在底层拦截并替换为
-- 物理 Backspace 按键事件（keyCode 51），让输入法能正常处理。

local keyDown = hs.eventtap.event.types.keyDown
local keyUp = hs.eventtap.event.types.keyUp

local tap = hs.eventtap.new({ keyDown, keyUp }, function(e)
    local keyCode = e:getKeyCode()
    local flags = e:getFlags()

    -- 匹配纯 Ctrl+H（无其他修饰键），H 的 keyCode 固定为 4
    if keyCode == 4 and flags.ctrl and not flags.cmd and not flags.alt and not flags.shift then
        local isDown = (e:getType() == keyDown)
        hs.eventtap.event.newKeyEvent({}, 51, isDown):post()
        return true
    end

    return false
end)

tap:start()
