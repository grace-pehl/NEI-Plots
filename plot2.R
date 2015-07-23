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
### Question: Have total emissions from PM2.5 decreased in the Baltimore City, 
### Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system
### to make a plot answering this question.

#remove single outlier
NEI[NEI$fips == "24510" & NEI$Emissions > 1000, "Emissions"] <- 100
data1 <- NEI %>% filter(fips == "24510") %>% group_by(year) %>%
    summarize(total = sum(Emissions) / 10^3)
png(filename = "Plot2.png")
barplot(data1$total, names.arg = data1$year, ylab = "Emissions (thousand tons)", 
        main = expression("Total Baltimore City, MD " * PM[2.5] * " Emissions"), axes = TRUE)
dev.off()
