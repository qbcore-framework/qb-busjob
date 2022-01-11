local Translations = {
    error = {
        drop_off_passenger = "Déposez les passagers avant d'arrêter le travail",
        already_driving_bus = "Vous conduisez déjà un bus",
        not_in_bus = "Vous n'êtes pas dans un bus",
        one_bus_only = "Vous ne pouvez avoir qu'un bus actif à la fois"
    },
    success = {
        person_dropped = "Une personne a été déposée",
        goto_bus_stop = "Allez a l'arrêt de bus",

    },
    info = {
        standard_bus = "Bus Standard",
        bus_stop = "~g~[E]~w~ Arrêt de bus",
        bus_depot = "Dépôt de Bus",
        job_vehicles = "~g~[E]~w~ Véhicules de service",
        stop_working = "~g~[E]~w~ Arrêt du travail",
        bus_vehicles = "Garage des bus",
        close_menu = "⬅ Fermer Menu"
    }
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })    
end