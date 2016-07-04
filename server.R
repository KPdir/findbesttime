server <- function(input, output, session) {
        # You can access the value of the widget with input$text, e.g.
        v <- reactiveValues( Ostatus = "NOTOK", Dstatus = "NOTOK",  
                             Otz = NULL, plotready = FALSE)
        observeEvent(input$Go, {
                gco <- geoCode(input$origin)
                gcd <- geoCode(input$destination)
                v$gco <- gco
                v$gcd <- gcd
                
                 if(gco$status=="OK" & gcd$status=="OK"){
                        v$yay <- "yay"
                        v$Olat <- gco$lat
                        v$Olng <- gco$lng
                        v$Oaddress <- gco$formatted_address
                        v$Daddress <- gcd$formatted_address
                        v$Oplace <- gco$place
                        v$Ostatus <- gco$status
                        v$Dstatus <- gcd$status
                        Otz <- GNtimezone(lat = gco$lat, lng = gco$lng ,radius = 50)$timezone
                        Otz <- ifelse(is.null(Otz),"GMT", as.character(Otz)) 
                        v$Otz <- Otz
                        
                        datetime <- paste(as.character(input$tdate), "00:00")
                        datetimeutc <- strptime(datetime, 
                                                format = "%Y-%m-%d %H:%M", tz = Otz)
                        v$OtzPOSIX <- as.POSIXlt(datetimeutc)$zone
                        v$date <- as.character(input$tdate)
                        v$deptime_utc <- datetimeutc
                        deptime_num <- as.numeric(datetimeutc)
                        v$deptime_num <- deptime_num
                        
                        trafdurtxt <- character(length = 48)
                        trafdur <- numeric(length = 48)
                        tstamps <- numeric(length = 48)
                        trafdist <- numeric(length = 48)
                        trafstatus <- character(length = 48)
                        
                        for (ii in 0:47) {
                                tstamps[ii+1] = deptime_num + ii*0.5*60*60;
                                dat <- gdistdur(input$origin, input$destination, tstamps[ii+1])
                                trafdur[ii+1] <- dat$traffduration
                                trafdist[ii+1] <- dat$distance
                                trafstatus[ii+1] <- dat$status 
                                trafdurtxt[ii+1] <- dat$traffdurationtxt
                        } # End of  for (ii in 0:47)
                        dep_time <- as.POSIXct( tstamps , origin="1970-01-01 00:00:00" ,tz = Otz)
                        
                        v$trafdur <- trafdur/3600; # convert seconds to hours
                        v$dep_time <- dep_time;
                        v$trafdurtxt <- trafdurtxt;
                        v$plotready <- TRUE;
                         
                 }  # End of if (gco$status=="OK" & gcd$status=="OK")
                 else{  v$Ostatus <- gco$status
                        v$Dstatus <- gcd$status
                        }
        })
        output$value1 <- renderText({ ifelse(v$Ostatus=="OK" & v$Dstatus=="OK", v$Oaddress, '') })
        output$value2 <- renderText({ ifelse(v$Ostatus=="OK" & v$Dstatus=="OK", v$Daddress, '') })
        
        output$tsplot <- renderPlot({
                if (v$Ostatus=="OK" & v$Dstatus=="OK" & v$plotready==TRUE){
                        v$yay2 <- "yay2"
                        ggplot(data = data.frame(x = v$dep_time, y = v$trafdur),aes(x ,y)) +
                        geom_line(colour="red", linetype="dashed", size=1.5) +
                        labs(title = paste( "Travel duration for various departure times on", v$date), 
                             x = paste("Departure Time [ 24 hrs : timezone:", v$OtzPOSIX, "]"), 
                             y = "Travel Duration [hrs]") +
                        scale_x_datetime(breaks = "2 hour", labels = date_format("%H:%M", tz = v$Otz)) + 
                                theme(axis.text.x = element_text(angle = 90, 
                                                                 colour = "black", size = 12),
                                      axis.text.y = element_text(colour = "black", size = 12),  
                                      axis.title = element_text(colour = "blue", size = 18), 
                                      title = element_text(colour = "blue", size = 18))
               }
                else {return()}
         })
        
}