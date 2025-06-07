# Getting and Cleaning Data Course Project

# creating Data directory if not existed
if(!file.exists("./data")){dir.create("./data")}

# Install Required Packages
# install.packages("data.table")
# install.packages("reshape2")

# Load Packages
library(data.table)  
library(reshape2)

# Load Packages (another method)
# packages <- c("data.table", "reshape2")
# sapply(packages, require, character.only=TRUE, quietly=TRUE)

