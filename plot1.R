library(dplyr)

sourceURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourcefile = "FNEI_data.zip"
datafile = "summarySCC_PM25.rds"

### download the file, if necessary
if (!file.exists(datafile)){
    download.file(sourceURL, sourcefile, mode="wb")
    ### unzip the file into local directory
    unzip(sourcefile)
}
### read in the dataset, if necessary
if (!exists("NEI")){
    cat("Reading in the datafile. Be patient! ")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
    cat("All done now!")
    NEI$year <- as.factor(NEI$year)
}  
### Question: Have total emissions from PM2.5 decreased in the United States 
### from 1999 to 2008? Using the base plotting system, make a plot showing the 
### total PM2.5 emission from all sources for each of the years 1999, 2002, 
### 2005, and 2008.
data1 <- summarize(group_by(NEI, year), total = sum(Emissions) / 10^6)
png(filename = "Plot1.png")
barplot(data1$total, names.arg = data1$year, ylab = "Emissions (million tons)", 
        main = expression("Total US " * PM[2.5] * " Emissions"), axes = TRUE)
dev.off()
