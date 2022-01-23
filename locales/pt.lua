local Translations = {
    error = {
        already_driving_bus = 'Já estás a conduzir um autocarro',
        not_in_bus = 'Não estás num autocarro',
        one_bus_active = 'Tu só podes ter um autocarro de cada vez',
        drop_off_passengers = 'Entrega os passageiros antes de terminares o trabalho'
    },
    success = {
        dropped_off = 'Passageiro entregue',
    },
    info = {
        bus = 'Autocarro',
        goto_busstop = 'Vai até à proxima paragem',
        busstop_text = '~g~E~s~ Paragem De Autocarro',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = 'Terminal Rodoviário',
        bus_stop_work = '~g~E~s~ Terminar Trabalho',
        bus_job_vehicles = '~g~E~s~ Veículos De Trabalho'
    },
    menu = {
        bus_header = 'Autocarros',
        bus_close = '⬅ Fechar Menu'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
