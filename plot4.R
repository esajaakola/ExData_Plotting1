## plot4 function
##
## Reads household consumption data from given URL, selects certain dates
## and plots 4 views of energy consumption into PNG file

plot4 <- function() {
    ## Download data package
    if(!file.exists("./data")) {
        dir.create("./data")
    }
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile="./data/power.zip", method="curl")
    unzip("./data/power.zip", exdir="./data")
    
    ## Read data
    data <- read.table("./data/household_power_consumption.txt", header = TRUE, sep=";", as.is = TRUE, na.strings="?")
    data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
    
    ## Select only dates 2007-02-01 and 2007-02-02
    newdata <- subset(data, Date == "2007-02-01" | Date == "2007-02-02", 
                      select=c(Global_reactive_power, Voltage, Global_active_power, Sub_metering_1, Sub_metering_2, Sub_metering_3, Date, Time))
    
    ## Add new datetime field for sorting
    newdata$Datetime <- as.POSIXct(paste(newdata$Date, newdata$Time), format="%Y-%m-%d %H:%M:%S")
    ## Sort per datetime
    attach(newdata)
    newdata <- newdata[order(Datetime),]
    detach(newdata)
    
    ## Create plot & write to file
    png("plot4.png")
    par(mfrow=c(2,2))
    ## Plot global active power
    with(newdata, plot(Datetime, Global_active_power, main="",
                       ylab="Global Active Power", xlab="", type="l"))
    ## Plot voltage usage
    with(newdata, plot(Datetime, Voltage, main="",
                       ylab="Voltage", xlab="datetime", type="l"))
    ## Plot energy sub metering
    with(newdata, plot(Datetime, Sub_metering_1, main="",
                       ylab="Energy sub metering", xlab="", type="l"))
    with(newdata, lines(Datetime, Sub_metering_2, col = "red"))
    with(newdata, lines(Datetime, Sub_metering_3, col = "blue"))
    legend("topright", bty = "n", lty = c(1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1",
                                                                                 "Sub_metering_2",
                                                                                 "Sub_metering_3"))
    ## Plot global reactive power
    with(newdata, plot(Datetime, Global_reactive_power, main="",
                       ylab="Global_reactive_power", xlab="datetime", type="l"))
    dev.off()
}
