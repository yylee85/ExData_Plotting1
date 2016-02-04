#################################################################
###                                                           ###
###   R SCRIPT FOR EXPLORATORY DATA ANALYSIS - ASSIGNMENT 1   ###
###                         PLOT 4                            ###
###                       YONG YI LEE                         ###
###                                                           ###
#################################################################

####################################
####   CREATE A TIDY DATA SET   ####   
####################################


## Load dplyr and lubridate packages to aid data set manipulation

library(dplyr)
library(lubridate)


## Check that exdata folder exists in current working directory

if(!file.exists("~/exdata")) {
  file.create("~/exdata")
  setwd("exdata")
} else {
  setwd("exdata")
}


## Check that the electric power consumption data set has been downloaded

if(!file.exists("power_cons.zip")) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileurl, "power_cons.zip")
  unzip("power_cons.zip")
} else {}


## Load dataset into R and format the variables

filename <- "./household_power_consumption.txt"
hpcdat <- read.table(filename, header = TRUE, sep = ";", na.strings = "?",
                     stringsAsFactors = FALSE)
colnames(hpcdat) <- tolower(colnames(hpcdat))
rm(filename)

hpcdat$date_time <- with(hpcdat, paste(date, time, sep = " "))
hpcdat$date_time <- dmy_hms(hpcdat$date_time)
hpcdat$global_active_power <- as.numeric(hpcdat$global_active_power)
hpcdat$global_reactive_power <- as.numeric(hpcdat$global_reactive_power)
hpcdat$voltage <- as.numeric(hpcdat$voltage)
hpcdat$global_intensity <- as.numeric(hpcdat$global_intensity)
hpcdat$sub_metering_1 <- as.numeric(hpcdat$sub_metering_1)
hpcdat$sub_metering_2 <- as.numeric(hpcdat$sub_metering_2)


## Subset observations between the 2007-02-01 and 2007-02-02 and create a 
## single date/time variable

hpcdat <- filter(hpcdat, date_time >= ymd("2007-02-01") 
                 & date_time < ymd("2007-02-03"))

hpcdat = select(hpcdat, date_time, global_active_power:sub_metering_3)
hpcdat = arrange(hpcdat, date_time)




#########################################
####   CREATE EXPLORATORY GRAPHICS   ####   
#########################################


## Create Plot 4 using base graphics

png("plot4.png", width=480, height=480)

par(mar = c(5.1, 5.1, 1.1, 1.1), mfrow = c(2,2))

with(hpcdat, plot(date_time, global_active_power, type = "l", xlab = "", 
                  ylab = "Global Active Power"))

with(hpcdat, plot(date_time, voltage, type = "l", xlab = "datetime", 
                  ylab = "Voltage"))

with(hpcdat, plot(date_time, sub_metering_1, type = "n", xlab = "", 
                  ylab = "Energy sub metering"))
with(hpcdat, lines(date_time, sub_metering_1, col = "black"))
with(hpcdat, lines(date_time, sub_metering_2, col = "red"))
with(hpcdat, lines(date_time, sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       bty = "n", cex = 0.85, pt.cex = 1, xjust = 1, x.intersp = 1, 
       y.intersp = 1, inset = 0)

with(hpcdat, plot(date_time, global_reactive_power, type = "l", 
                  xlab = "datetime", ylab = "Global_reactive_power"))

dev.off()

