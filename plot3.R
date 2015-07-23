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
    NEI$type <- as.factor(NEI$type)
}  
### Question: Of the four types of sources indicated by the type (point, 
### nonpoint, onroad, nonroad) variable, which of these four sources have seen
### decreases in emissions from 1999–2008 for Baltimore City? Which have seen 
### increases in emissions from 1999–2008? Use the ggplot2 plotting system to 
### make a plot answer this question.

#remove single outlier
NEI[NEI$fips == "24510" & NEI$Emissions > 1000, "Emissions"] <- 100
data1 <- NEI %>% filter(fips == "24510") %>% group_by(type, year) %>%
    summarize(total = sum(Emissions))
png(filename = "Plot3.png")
plot3 <- ggplot(data=data1, aes(x=type, y=total, fill=year)) +
         geom_bar(stat="identity", position=position_dodge())
print(plot3)
dev.off()
