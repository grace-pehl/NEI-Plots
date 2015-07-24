library(dplyr)
library(ggplot2)

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
### Question: Compare emissions from motor vehicle sources in Baltimore City 
### with emissions from motor vehicle sources in Los Angeles County, California 
### (fips == "06037"). Which city has seen greater changes over time in motor
### vehicle emissions?

data1 <- NEI %>% filter(fips %in% c("06037", "24510") & type == "ON-ROAD") %>% 
        group_by(fips, year) %>%
        summarize(total = sum(Emissions) / 1000)
png(filename = "Plot6.png")
plot1 <- ggplot(data=data1, aes(x=year, y=total, fill=fips)) +
         geom_bar(stat="identity", position = position_dodge()) + 
         labs(y = "Emissions (thousand tons)") +
         scale_fill_discrete(name  ="Municipality", breaks=c("06037", "24510"),
                             labels=c("Los Angeles County, CA", 
                                      "Baltimore City, MD")) +
         ggtitle(expression(PM[2.5] * " On Road Emissions"))
    
print(plot1)
dev.off()
