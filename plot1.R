# a script to plot household power consumption

# download zipped file and decompress it
if(!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/household_power_consumption.zip", method = "curl")
unzip(zipfile="./data/household_power_consumption.zip", exdir = "./data")

# read txt file into R and create a dataframe
data <- read.table("./data/household_power_consumption.txt", 
        header = TRUE, 
        sep = ";", 
        na.strings = c("?",""))

# convert factors to Dates in Date col
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# convert factors to POSIXlt in Time col
data$timetemp <- paste(data$Date, data$Time)
data$Time <- strptime(data$timetemp, format = "%Y-%m-%d %H:%M:%S")
# eliminate temporary column
data <- data[ , 1:9]

# subset dataset, reduce observations to Feb 1, 2007 and Feb 2, 2007 and exclude NAs
data <- data[which(data$Time >= "2007-02-01 00:00:00" & data$Time < "2007-02-03 00:00:00"), ]

# plot global active power
hist(data$Global_active_power, col = "red", main = "Global Active Power")
