local Translations = {
    error = {
        already_driving_bus = '您正在駕駛巴士',
        not_in_bus = '您並不在巴士內',
        one_bus_active = '您一次只能領取一輛巴士',
        drop_off_passengers = '結束工作前請勿必讓乘客先下車'
    },
    success = {
        dropped_off = '乘客已安全下車',
    },
    info = {
        bus = '灰狗巴士',
        goto_busstop = '駛向下一站',
        busstop_text = '停靠並讓乘客上下車',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = '灰狗巴士',
        bus_stop_work = '[E] 結束工作',
        bus_job_vehicles = '[E] 工作車輛'
    },
    menu = {
        bus_header = '灰狗巴士車庫',
        bus_close = '⬅ 關閉目錄'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})