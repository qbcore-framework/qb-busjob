local Translations = {
    error = {
        already_driving_bus = 'Du fährst bereits einen Bus',
        not_in_bus = 'Du bist in keinem Bus',
        one_bus_active = 'Du kannst nur ein Bus nutzen',
        drop_off_passengers = 'Setz die Passagiere ab, bevor du mit der Arbeit aufhörst'
    },
    success = {
        dropped_off = 'Peson(en) wurde(n) abgesetzt',
    },
    info = {
        bus = 'Standart Bus',
        goto_busstop = 'Fahre zur Bushaltestelle',
        busstop_text = '~g~E~s~ Bus stoppen',
        bus_plate = 'BUS', -- Can be 3 or 4 characters long (uses random 4 digits)
        bus_depot = 'Bus Depot',
        bus_stop_work = '~g~E~s~ Arbeit beenden',
        bus_job_vehicles = '~g~E~s~ Job Fahrzeuge'
    },
    menu = {
        bus_header = 'Bus Fahrzeuge',
        bus_close = '⬅ Menü schliessen'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
