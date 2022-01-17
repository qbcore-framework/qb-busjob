local Translations = {
    error = {
        already_driving_bus = 'Již řídíš autobus',
        not_in_bus = 'Nejsi v autobuse',
        one_bus_active = 'V jednu chvíli můžete mít pouze jeden aktivní autobus',
        drop_off_passengers = 'Než přestanete pracovat, vysaďte všechny cestující'
    },
    success = {
        dropped_off = 'Osoba byla vysazena',
    },
    info = {
        bus = 'Standartní autobus',
        goto_busstop = 'Jeď na autobusovou zastávku',
        busstop_text = '~g~E~s~ Autobusová zastávka',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = 'Autobusové depo',
        bus_stop_work = '~g~E~s~ Přestat pracovat',
        bus_job_vehicles = '~g~E~s~ Firemní vozidla'
    },
    menu = {
        bus_header = 'Bus Vehicles', -- IDK
        bus_close = '⬅ Zavřít menu'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
