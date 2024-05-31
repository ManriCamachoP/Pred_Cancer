#Script to transform raw data to upload it to the repo from Github in parquet format

#install.packages("arrow")
library(arrow) #Write parquet file because file in csv is too big
library(haven) #Read the data .xpt

#Set working directory
#setwd("/Users/manriquecamacho/Library/CloudStorage/OneDrive-UniversidaddeCostaRica/GitHub/Predicción_Cancer/data/raw")


#Importing the dataset from a XPT file
df = read_xpt("Library/CloudStorage/OneDrive-UniversidaddeCostaRica/GitHub/Predicción_Cancer/data/raw/LLCP2022.xpt")

#Save the raw dataframe in a parquet file
write_parquet(df, "raw_data.parquet")
