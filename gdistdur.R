gdistdur <- function(origin , destination, departure_time){ 
        
        
        gdistURL <- function(origin, destination, departure_time) {
                baseURL <- "https://maps.google.com/maps/api/distancematrix/json?"
                u <- paste0(baseURL,"origins=", origin, "&destinations=" ,destination,
                            "&departure_time=",departure_time,"&traffic_model=pessimistic", 
                            "&mode=driving&language=en","&key=", getOption("gdistkey"))
                return(URLencode(u))
        }
        
        # Get distcance and travel time info from google
        
        target <- gdistURL(origin = origin, destination = destination, 
                           departure_time = as.character(departure_time))
        con <-  curl(target)
        answer_json <- readLines(con)
        close(con)
        dat <- answer_json %>% jsonlite::fromJSON()
        
        if (dat$status=="OK"){
        return( list( destination_addresses = dat$destination_addresses,
                      origin_addresses = dat$origin_addresses, 
                      status = dat$status, 
                      distance = dat$rows$elements[[1]]$distance$value,
                      traffduration = dat$rows$elements[[1]]$duration_in_traffic$value,
                      traffdurationtxt = dat$rows$elements[[1]]$duration_in_traffic$text,
                      tdstatus = dat$rows$elements[[1]]$status
                ))
        }
        else {return( list( status = dat$status, traffduration = 0, distance = 0))}
}
