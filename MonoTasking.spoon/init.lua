--- === MonoTasking ===
---
--- MonoTasking
local MonoTasking = {}

-- Metadata
MonoTasking.name = 'MonoTasking'
MonoTasking.version = '1.0.1'
MonoTasking.author = 'Charles(hi@charles-t.com)'
MonoTasking.homepage = 'https://github.com/y1feng200156/MonoTasking'
MonoTasking.license = "MIT - https://opensource.org/licenses/MIT"

local menubar = hs.menubar.new()
local clock = 0
local clocks = {'🕛', '🕐', '🕑', '🕒', '🕓', '🕔', '🕕', '🕖', '🕗', '🕘', '🕙', '🕚'}
local stopIcon = '⏱'
local defaultTitle = stopIcon .. '00:00'
local menus
local work
local timer

local function timerEnd()
    work.stop()
    timer:stop()
    menubar:setTitle(defaultTitle)
    menubar:setMenu(menus)
    hs.notify.show('工作结束', '当前工作结束', '')
end

local function updateTitle()
    local luaTime = os.date('*t')
    clock = clock % 12 + 1
    local countdown = os.date('*t', math.modf(work:nextTrigger()))
    menubar:setTitle(string.format('%s%02s:%02s', clocks[clock], countdown.min, countdown.sec))
end

local function stopTimer()
    work:stop()
    timer:stop()
    menubar:setTitle(defaultTitle)
    menubar:setMenu(menus)
end
local function updateTimer()
    local luaTime = os.date('*t')
    local time = os.time()
    if luaTime.min + 25 > 60 then
        time =
            os.time(
            {sec = 00, hour = luaTime.hour, min = 30, day = luaTime.day, month = luaTime.month, year = luaTime.year}
        ) + hs.timer.hours(1)
    elseif luaTime.min + 25 > 30 then
        time =
            os.time(
            {sec = 00, hour = luaTime.hour, min = 00, day = luaTime.day, month = luaTime.month, year = luaTime.year}
        ) + hs.timer.hours(1)
    elseif luaTime.min + 25 <= 30 then
        time =
            os.time(
            {sec = 00, hour = luaTime.hour, min = 30, day = luaTime.day, month = luaTime.month, year = luaTime.year}
        )
    end
    luaTime = os.date('*t', time)
    work = hs.timer.doAt(luaTime.hour .. ':' .. luaTime.min, timerEnd)
    timer = hs.timer.new(1, updateTitle)
    clock = 0
    work:start()
    timer:start()
    menubar:setMenu(
        {
            {title = string.format('截至 %02s:%02s', luaTime.hour, luaTime.min), disabled = true},
            {tile = '-'},
            {title = '结束工作', fn = stopTimer}
        }
    )
end

--- MonoTasking:init()
--- Method
--- init MonotoTasking menubar
function MonoTasking:init()
    menus = {
        {title = '开始工作', fn = updateTimer}
    }

    menubar:setTitle(defaultTitle)
    menubar:setTooltip('单核工作')
    menubar:setMenu(menus)
end

return MonoTasking
