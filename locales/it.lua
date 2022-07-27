local Translations = {
    error = {
        already_driving_bus = 'Stai già guidando un autobus',
        not_in_bus = 'Non sei su un autobus',
        one_bus_active = 'Puoi avere un solo autobus',
        drop_off_passengers = 'Lascia i passeggeri prima di finire il turno di lavoro'
    },
    success = {
        dropped_off = 'Passeggeri lasciati a destianzione',
    },
    info = {
        bus = 'Autobus',
        goto_busstop = 'Vai alla fermata dell\'autobus',
        busstop_text = '[E] Fermata dell\'autobus',
        bus_plate = 'BUS', -- Può essere lungo 3 o 4 caratteri (il resto sono 4 cifre casuali)
        bus_depot = 'Deposito Autobus',
        bus_stop_work = '[E] Smetti di lavorare',
        bus_job_vehicles = '[E] Veicoli di servizio'
    },
    menu = {
        bus_header = 'Autobus',
        bus_close = '⬅ Chiudi Menù'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
