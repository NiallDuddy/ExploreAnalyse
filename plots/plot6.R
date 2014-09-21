#6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
# in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

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

#The sum PM2.5 emission values for each year per motor vehicle source and city are calculated and assigned to a new dataframe.
losAngelesNEI <- NEI[NEI$fips == "06037", ]
losAngelesNEI$city <- "los angeles"
baltimoreNEI <- NEI[NEI$fips == "24510", ]
baltimoreNEI$city <- "baltimore"
combinedNEI <- rbind(baltimoreNEI, losAngelesNEI)
combinedNEI <- merge(SCCMobile, combinedNEI, by="SCC")
combinedNEI <- aggregate(Emissions ~ year + EI.Sector + city, combinedNEI, sum)

#A plot is made with regressions of PM2.5 emissions per year by motor vehicle source in Los Angeles.
library(ggplot2)
png("plot6.1.png")
x <- qplot(year, Emissions/1000, data=combinedNEI[combinedNEI$city == "los angeles", ], 
      geom=c("point", "smooth"),
      method="lm", formula=y~x, color=EI.Sector,
      main="Regression of PM2.5 emissions \nby motor vehicle sources",
      xlab="Years", ylab="PM2.5 emissions (per thousand tons)")
print(x)
dev.off()

png("plot6.2.png")
x <- ggplot(aggregate(Emissions ~ year + city, combinedNEI, sum), 
             aes(x = year, y = Emissions/1000, fill = city))
x <- x + geom_bar(stat = "identity", position = position_dodge())
print(x)
dev.off()

png("plot6.3.png")
x <- qplot(year, Emissions/1000, data=aggregate(Emissions ~ year + city, combinedNEI, sum), 
      geom=c("point", "smooth"),
      method="lm", formula=y~x, color=city,
      main="Regression of PM2.5 emissions \nby motor vehicle sources",
      xlab="Years", ylab="PM2.5 emissions (per thousand tons)")
print(x)
dev.off()
