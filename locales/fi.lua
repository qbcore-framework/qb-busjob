local Translations = {
    error = {
        already_driving_bus = 'Ajat jo bussia!',
        not_in_bus = 'Et ole bussissa!',
        one_bus_active = 'Sinulla voi olla vain yksi aktiivinen bussi kerrallaan',
        drop_off_passengers = 'Jätä matkustajat pysäkille ennen kun lopetat työskentelyn'
    },
    success = {
        dropped_off = 'Matkustaja jätetty pysäkille!',
    },
    info = {
        bus = 'Bussi',
        goto_busstop = 'Aja seuraavalle pysäkille',
        busstop_text = '~g~E~s~ Bussipysäkki',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = 'Bussivarikko',
        bus_stop_work = '~g~E~s~ Lopeta työskentely',
        bus_job_vehicles = '~g~E~s~ Työajoneuvot'
    },
    menu = {
        bus_header = 'Bussit',
        bus_close = '⬅ Sulje valikko'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
