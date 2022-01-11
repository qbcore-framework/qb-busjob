local Translations = {
    error = {
        drop_off_passenger = "Drop off the passengers before you stop working",
        already_driving_bus = "You Are Already Driving Bus",
        not_in_bus = "You Are Not In A Bus",
        one_bus_only = "You can only have one active bus at a time"
    },
    success = {
        person_dropped = "Person Was Dropped Off",
        goto_bus_stop = "Goto the bus stop",

    },
    info = {
        standard_bus = "Standard Bus",
        bus_stop = "~g~[E]~w~ Bus Stop",
        bus_depot = "Bus Depot",
        job_vehicles = "~g~[E]~w~ Job Vehicles",
        stop_working = "~g~[E]~w~ Stop Working",
        bus_vehicles = "Bus Vehicles",
        close_menu = "⬅ Close Menu"
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })    
end