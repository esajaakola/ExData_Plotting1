
## plot1 function
##
## Reads household consumption data from given URL, selects certain dates
## and plots active power consumption into PNG file

plot1 <- function() {
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
                      select=c(Global_active_power))
    
    ## Create plot
    png("plot1.png")    
    hist(newdata$Global_active_power, col="red", main="Global Active Power",
         xlab="Global Active Power (kilowatts)")
    dev.off()
}