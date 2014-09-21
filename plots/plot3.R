
#3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?

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

#The sum PM2.5 emission values for each year and type in Baltimore are calculated and assigned to a new dataframe.
baltimoreNEI <- NEI[NEI$fips == "24510", ]
baltimoreType <- aggregate(Emissions ~ year + type, baltimoreNEI, sum)

#A plot is made showing distribution of PM2.5 emissions by Type in Baltimore.
png("plot3.1.png")
library(ggplot2)
x <- qplot(Emissions, data=baltimoreType, geom="density", fill=type, alpha=I(.5),
      main="Distribution of PM2.5 emissions by type", xlab="PM2.5 emissions",
      ylab="Density")
print(x)
dev.off()

#A plot is made with regressions of PM2.5 emissions by Type per year in Baltimore.
png("plot3.2.png")
x <- qplot(year, Emissions/1000, data=baltimoreType, geom=c("point", "smooth"),
      method="lm", formula=y~x, color=type,
      main="Regression of PM2.5 emissions by type",
      xlab="Years", ylab="PM2.5 emissions (per thousand tons)")
print(x)
dev.off()
