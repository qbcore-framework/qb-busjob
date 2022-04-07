local Translations = {
    error = {
        already_driving_bus = 'Du fährst bereits einen Bus!',
        not_in_bus = 'Du bist nicht einem Bus!',
        one_bus_active = 'Du kannst nur einen Bus haben!',
        drop_off_passengers = 'Lasse die Passagiere raus bevor du deinen Job Beendest!'
    },
    success = {
        dropped_off = 'Person wurde Raus gelassen!',
    },
    info = {
        bus = 'Standart Bus',
        goto_busstop = 'Gehe zum Bus Stop',
        busstop_text = '~g~E~s~ Bus Stop',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = 'Bus Depot',
        bus_stop_work = '~g~E~s~ Schicht Beenden',
        bus_job_vehicles = '~g~E~s~ Job Fahrzeuge'
    },
    menu = {
        bus_header = 'Bus Fahrzeuge',
        bus_close = '⬅ Menu Schließen'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
