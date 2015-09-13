## plot3 function
##
## Reads household consumption data from given URL, selects certain dates
## and plots in watt-hour of active energy consumption for different subsets
## per selected days as line into PNG file

plot3 <- function() {
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
                      select=c(Sub_metering_1, Sub_metering_2, Sub_metering_3, Date, Time))
    
    ## Add new datetime field for sorting
    newdata$Datetime <- as.POSIXct(paste(newdata$Date, newdata$Time), format="%Y-%m-%d %H:%M:%S")
    ## Sort per datetime
    attach(newdata)
    newdata <- newdata[order(Datetime),]
    detach(newdata)
    
    ## Create plot & write to file
    png("plot3.png")
    with(newdata, plot(Datetime, Sub_metering_1, main="",
                       ylab="Energy sub metering", xlab="", type="l"))
    with(newdata, lines(Datetime, Sub_metering_2, col = "red"))
    with(newdata, lines(Datetime, Sub_metering_3, col = "blue"))
    legend("topright", lty = c(1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1",
                                                                   "Sub_metering_2",
                                                                   "Sub_metering_3"))
    dev.off()
}
