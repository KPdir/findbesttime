geoCode <- function(place){
        # Geocoding using google geocode api
        # Along the lines of exmple: 
        # http://www.r-bloggers.com/web-scraping-working-with-apis/ by Rolf Fredheim,
        
        
        
        locationUrl <- function(address) {
                baseURL <- "http://maps.google.com/maps/api/geocode/json?"
                u <- paste0(baseURL,"address=", address, "&sensor=false")
                return(URLencode(u))
        }

        # Get latitude and longitude info
        target <- locationUrl(place)
        dat <- fromJSON(target)
        if (dat$status == "OK"){
                latitude <- dat$results[[1]]$geometry$location["lat"]
                longitude <- dat$results[[1]]$geometry$location["lng"]
                formatted_address <- dat$results[[1]]$formatted_address
                return(list( place = place, formatted_address = formatted_address,
                             lat =  latitude, lng = longitude, status = dat$status))
        }
        else {return(list( place = place, status = dat$status))}
}