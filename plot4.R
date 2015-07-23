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
### Question: Across the United States, how have emissions from coal 
### combustion-related sources changed from 1999–2008?

### get coal related sources
coal_index <- grep("Coal", SCC$EI.Sector, ignore.case=T)
coal_codes <- as.character(SCC$SCC[coal_index])
data1 <- NEI %>% filter(SCC %in% coal_codes) %>% group_by(year) %>%
    summarize(total = sum(Emissions) / 1000)
png(filename = "Plot4.png")
plot4 <- ggplot(data=data1, aes(x=year, y=total)) +
         geom_bar(stat="identity", fill = "pink") + 
         labs(title = expression("US Coal-Related " * PM[2.5] * " Emissions")) +
         labs(y = "Emissions (thousand tons)")
print(plot4)
dev.off()
