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

# plot global active power data and create a PNG file
png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))

# plot 1 (top left)
plot(data$Time, data$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")

# plot 2 (top right)
plot(data$Time, data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

# plot 3 (bottom left)
plot(data$Time, data$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "", col = "black")
points(data$Time, data$Sub_metering_2, type = "l", xlab = "", ylab = "Sub_metering_2", col = "red")
points(data$Time, data$Sub_metering_3, type = "l", xlab = "", ylab = "Sub_metering_3", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

# plot 4 (bottom right)
plot(data$Time, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", ylim = c(0, 0.5))

dev.off()

