
#5. How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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

#The sum PM2.5 emission values for each year per motor vehicle source are calculated and assigned to a new dataframe.
index <- as.character(SCC$EI.Sector)
SCCMobile <- subset(SCC,grepl(".*Mobile", index))
SCCMobile <- SCCMobile[SCCMobile$EI.Sector != "Mobile - Aircraft", ]
SCCMobile <- SCCMobile[SCCMobile$EI.Sector != "Mobile - Commercial Marine Vessels", ]
baltimoreNEI <- NEI[NEI$fips == "24510", ]
mobileNEI <- merge(SCCMobile, baltimoreNEI, by="SCC")
mobileNEI <- aggregate(Emissions ~ year + EI.Sector, mobileNEI, sum)

#A plot is made with regressions of PM2.5 emissions per year by motor vehicle source in Baltimore.
library(ggplot2)
png("plot5.1.png")
x <- qplot(year, Emissions, data=mobileNEI, geom=c("point", "smooth"),
      method="lm", formula=y~x, color=EI.Sector,
      main="Regression of PM2.5 emissions \nby motor vehicle sources",
      xlab="Years", ylab="PM2.5 emissions")
print(x)
dev.off()

library(lattice)
png("plot5.2.png")
x <- xyplot(Emissions ~ year | EI.Sector, mobileNEI, layout = c(4, 2), 
       main = "Variation of the above plot", ylab = "PM2.5 emissions (per thousand tons)", 
       xlab = "Years", 
       panel = function(x, y) {
           panel.xyplot(x, y)
           panel.lmline(x, y, lty = 1, col = "red")
           par.strip.text = list(cex = 0.8)}, 
       as.table = T)
print(x)
dev.off()
