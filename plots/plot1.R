
#1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

#Checks for the dataset and if it does not exist, downloads and extracts the files.
NEI <- "summarySCC_PM25.rds"
SCC <- "Source_Classification_Code.rds"
if (!file.exists(NEI) | !file.exists(SCC)) {
    temp <- tempdir()
    url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    file <- basename(url)
    download.file(url, file)
    unzip(file)
    unlink(temp)
}

#Read the two files to dataframe.
NEI <- readRDS(NEI)
SCC <- readRDS(SCC)

#The sum PM2.5 emission values for each year are calculated and assigned to a new dataframe.
totalPerYear <- aggregate(Emissions ~ year, NEI, sum)

#A plot is made indicating the total PM2.5 values per year.
png("plot1.png")
plot(totalPerYear$year, totalPerYear$Emissions/1000000, type = "b", 
    xlab = "Year", ylab = "Total PM2.5 (per million tons)", 
    main = "Total PM2.5 emissions per year", xaxt='n')
lines(totalPerYear$year, totalPerYear$Emissions/1000000, type = "h")
axis(side=1, at=seq(1999, 2008, 3), labels = c("1999","2001","2003","2004"))
dev.off()
