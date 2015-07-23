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
### Question: How have emissions from motor vehicle sources changed from 
### 1999–2008 in Baltimore City?

data1 <- NEI %>% filter(fips == "24510" & type == "ON-ROAD") %>% group_by(year) %>%
    summarize(total = sum(Emissions) / 1000)
png(filename = "Plot5.png")
plot5 <- ggplot(data=data1, aes(x=year, y=total)) +
         geom_bar(stat="identity", fill = "green") + 
         labs(title = expression("Baltimore City, MD on Road " * PM[2.5] * " Emissions")) +
         labs(y = "Emissions (thousand tons)")
print(plot5)
dev.off()
