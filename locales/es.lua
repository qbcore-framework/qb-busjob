local Translations = {
    error = {
        already_driving_bus = 'Ya estás manejando un autobús',
        not_in_bus = 'No estás en un autobús',
        one_bus_active = 'Solo puedes tener un autobús activo a la vez',
        drop_off_passengers = 'Lleva a tus pasajeros antes de dejar de trabajar'
    },
    success = {
        dropped_off = 'Una persona se bajó'
    },
    info = {
        bus = 'Autobús estándar',
        goto_busstop = 'Ir a la siguiente parada de autobús',
        busstop_text = '~g~E~s~ Parada de autobús',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = 'Estación de autobuses',
        bus_stop_work = '~g~E~s~ Dejar de trabajar',
        bus_job_vehicles = '~g~E~s~ Vehículos de trabajo'
    },
    menu = {
        bus_header = 'Autobuses',
        bus_close = '⬅ Cerrar menú'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
