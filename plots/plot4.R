
#4. Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

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

#The sum PM2.5 emission values for each year per coal combustion-related source are calculated and assigned to a new dataframe.
index <- as.character(SCC$EI.Sector)
SCCCoal <- subset(SCC,grepl(".*Coal", index))
coalNEI <- merge(SCCCoal, NEI, by="SCC")
coalNEI <- aggregate(Emissions ~ year + EI.Sector, coalNEI, sum)

#A plot is made with regressions of PM2.5 emissions per year by coal combustion-related source.
library(ggplot2)
png("plot4.png")
x <- qplot(year, Emissions/1000, data=coalNEI, geom=c("point", "smooth"),
      method="lm", formula=y~x, color=EI.Sector,
      main="Regression of PM2.5 emissions \nby coal combustion-related sources",
      xlab="Years", ylab="PM2.5 emissions (per thousand tons)")
print(x)
dev.off()
