-- Ctrl+H → Backspace 映射
-- 原生 Ctrl+H 发送 ASCII 0x08 控制字符，输入法在 composition 状态下无法
-- 处理，会先 commit 再删除。用 hs.hotkey 拦截并生成物理 Backspace 事件。
-- 比 hs.eventtap 方案更稳定（macOS 不会自动禁用 hotkey）。

-- 如果输入法中 hotkey 不触发，切回 eventtap + watchdog 方案：
--   hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
--     if e:getKeyCode() == 4 and e:getFlags().ctrl then
--       hs.eventtap.event.newKeyEvent({}, 51, true):post()
--       return true
--     end
--   end):start()

hs.hotkey.bind({ "ctrl" }, "h", function()
    hs.eventtap.keyStroke({}, "delete", 0)
end)
