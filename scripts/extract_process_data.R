#Extract and Process the relevant data

library(arrow) #Importing the parquet file
library(dplyr) #Manipulating
library(tidyr) #Manipulating

#setwd("/Users/manriquecamacho/Library/CloudStorage/OneDrive-UniversidaddeCostaRica/GitHub/Predicción_Cancer/data/raw")


#Importing the dataset
df = read_parquet("raw_data.parquet")

#Filtering the data for the variables of interest

#------------ DEMOGRAPHICS 
df$`_STATE` #State
df$SEXVAR #Sex, combining both land line survey with cellphone survey
df$MARITAL #Maritial status
df$`_RACE1` #Race
df$`_AGE80` #AGE
df$WEIGHT2 #Weight
df$HEIGHT3 #Height
df$EDUCA #Education

#------------- HABITS
df$SLEPTIM1 #Average of hours of sleep in a 24-hour period
df$DRNK3GE5 #how many times during the past 30 days did you have 5 or more drinks for men or 4 or more drinks for women on an occasion
df$LCSNUMCG #On average, when you {smoke/smoked} regularly, about how many cigarettes {do/did} you usually smoke each day


#------------- HEALTH
df$GENHLTH #General Health
df$MENTHLTH #Mental Health, days where mental health was not good in a span of 30 days.
df$POORHLTH #General Health and Mental Health impeding doing usual activities, like selfcare.
df$EXERANY2 #Participate in any pyhsical or exercise activities
#df$CVDINFR4 #Ever experienced a heart attack -- Puede ser solo que hay que buscar literatura
df$`_SMOKER3` #Four level smoker status: Everyday (1), Someday (2), Former (3), Non (4), No response (9)
df$`_BMI5` #Body Mass Index (BMI)
df$DIFFWALK #Serious difficulty walking or climbing stairs
df$ADDEPEV3 #Have you had a depressive disorder


#------------- Breast Cancer
df$CNCRTYP2 == 5 #The value 5 indicates breast cancer
df$HADMAM #Ever had a mammogram
df$HOWLONG #How long has it been since the last mammogram
df$CNCRDIFF #How many types of cancer
df$CNCRAGE #At what age you told that you had cancer



df = df %>% 
      #filter(CNCRTYP2 == 5) %>% #Breast Cancer
      mutate(Breast = 
               case_when(CNCRTYP2 == 5 ~ "Breast Cancer",
                         CNCRTYP2 != 5 ~ "No Breast Cancer")) %>% 
      select(`_STATE`, SEXVAR, MARITAL, `_RACE1`, `_AGE80`, WEIGHT2, HEIGHT3, EDUCA, #Demographics
             SLEPTIM1, DRNK3GE5, LCSNUMCG, #Habits
             GENHLTH, MENTHLTH, POORHLTH, EXERANY2, `_SMOKER3`, `_BMI5`, DIFFWALK, ADDEPEV3, #Health
             HADMAM, HOWLONG, CNCRDIFF, CNCRAGE, Breast #Breast Cancer
             ) %>% 
      drop_na(Breast)


colnames(df) = c("State", "Sex", "Marital", "Race", #Demographics
                 "Age", "Weight", "Height", "Education", #Demographics
                 "TimeSlept", "AlcoholConsumption", "EverSmoked", "Smoke", #Habits
                 "GeneralHealth", "MentalHealth", "PoorHealthAct", #Health
                 "Exercise", "TypeSmoker", "BMI", "WalkingDiff", "MentalDis", #Health
                 "EverMammo", "TimeMammo", "DiffCancer", "AgeCancer", "BreastCancer")

#View(df)

setwd("/Users/manriquecamacho/Library/CloudStorage/OneDrive-UniversidaddeCostaRica/GitHub/Predicción_Cancer/data/processed")

write.csv(df, "data.csv")  

