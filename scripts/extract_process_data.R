#Extract and Process the relevant data

library(arrow) #Importing the parquet file
library(dplyr) #Manipulating
library(tidyr) #Manipulating

setwd("/Users/manriquecamacho/Library/CloudStorage/OneDrive-UniversidaddeCostaRica/GitHub/Predicción_Cancer/data/raw")


#Importing the dataset
df = read_parquet("raw_data.parquet")


#Filtering the data for the variables of interest

#------------ DEMOGRAPHICS 
df$`_STATE` #State
#df$SEXVAR #Sex, combining both land line survey with cellphone survey
df$`_RACE1` #Race
df$`_AGE80` #AGE
df$EDUCA #Education
df$`_CHLDCNT` #Count of children on the household

#------------- HABITS
df$SLEPTIM1 #Average of hours of sleep in a 24-hour period
df$ALCDAY4#How many days per week or per month did the respondent have at least one drink of any alcoholic beverage

#------------- HEALTH
df$GENHLTH #General Health
df$EXERANY2 #Participate in any pyhsical or exercise activities
df$`_SMOKER3` #Four level smoker status: Everyday (1), Someday (2), Former (3), Non (4), No response (9)
df$`_BMI5` #Body Mass Index (BMI)
df$ADDEPEV3 #Have you had a depressive disorder

#------------- Breast Cancer
df$CNCRTYP2 == 5 #The value 5 indicates breast cancer
df$HADMAM #Ever had a mammogram

#----------- Economic
df$PRIMINSR


#------------ Filtro de la base
df = df %>% 
      filter(SEXVAR == 2) %>% 
      mutate(Breast = 
               case_when(CNCRTYP2 == 5 ~ "Breast Cancer",
                         CNCRTYP2 != 5 ~ "No Breast Cancer"),
             AlcoholCons = 
               case_when((ALCDAY4>100) & (ALCDAY4<200) == TRUE ~ (ALCDAY4-100)*4,
                         (ALCDAY4>200) & (ALCDAY4<300) == TRUE ~ ALCDAY4-200,
                         ALCDAY4 == 888 ~ 0,
                         TRUE ~ NA),
             Smoker = 
               case_when(`_SMOKER3` == 1 ~ 1,
                         `_SMOKER3` == 2 ~ 1,
                         `_SMOKER3` == 3 ~ 1,
                         `_SMOKER3` == 4 ~ 0,
                         `_SMOKER3` == 9 ~ NA), 
             Depression = 
               case_when(ADDEPEV3 < 3 ~ ADDEPEV3,
                         TRUE ~ NA),
             Exercise = 
               case_when(EXERANY2 < 3 ~ EXERANY2,
                         TRUE ~ NA),
             
             Mammo = 
               case_when(HADMAM < 3 ~ HADMAM,
                         TRUE ~ NA),
             Race = 
               case_when(`_RACE1` < 9 ~ `_RACE1`,
                         TRUE ~ NA),
             Education = 
               case_when(EDUCA<9 ~ EDUCA,
                         TRUE~NA),
             Sleep = 
               case_when(SLEPTIM1 < 77 ~ SLEPTIM1,
                         TRUE ~ NA),
             GeneralHealth = 
               case_when(GENHLTH < 7 ~ GENHLTH,
                         TRUE ~ NA),
             Coverage = 
               case_when(PRIMINSR == 1 ~ "Comprehensive Coverage",
                         PRIMINSR == 2 ~ "Comprehensive Coverage",
                         PRIMINSR == 3 ~ "Moderate Coverage",
                         PRIMINSR == 4 ~ "Moderate Coverage",
                         PRIMINSR == 5 ~ "Moderate Coverage",
                         PRIMINSR == 7 ~ "Moderate Coverage",
                         PRIMINSR == 9 ~ "Moderate Coverage",
                         PRIMINSR == 6 ~ "Limited or no Coverage or Uncertain",
                         PRIMINSR == 8 ~ "Limited or no Coverage or Uncertain",
                         PRIMINSR == 10 ~ "Limited or no Coverage or Uncertain",
                         PRIMINSR == 88 ~ "Limited or no Coverage or Uncertain",
                         PRIMINSR == 99 ~ NA
                         ),
             Children = 
               case_when(`_CHLDCNT` == 1 ~ 0,
                         `_CHLDCNT` == 2 ~ 1,
                         `_CHLDCNT` == 3 ~ 2,
                         `_CHLDCNT` == 4 ~ 3,
                         `_CHLDCNT` == 5 ~ 3,
                         `_CHLDCNT` == 6 ~ 3,
                         TRUE ~ NA),
             Income = 
               case_when(`_INCOMG1`== 1 ~ `_INCOMG1`,
                         `_INCOMG1`== 2 ~ `_INCOMG1`,
                         `_INCOMG1`== 3 ~ `_INCOMG1`,
                         `_INCOMG1`== 4 ~ `_INCOMG1`,
                         `_INCOMG1`== 5 ~ `_INCOMG1`,
                         `_INCOMG1`== 6 ~ `_INCOMG1`,
                         `_INCOMG1`== 7 ~ `_INCOMG1`,
                         TRUE ~ NA),
             UrbRur = `_METSTAT`) %>%
      select(`_STATE`, `_AGE80`, Race, Education, `_BMI5`,Coverage,
             GeneralHealth, Children, Sleep, Depression, Exercise, 
             Smoker, AlcoholCons, Mammo, Breast, Income, UrbRur) %>% 
      drop_na()


colnames(df) = c("State", "Age", "Race", "Education", "BMI", "Coverage", "GeneralHealth", "Children","Sleep", "Depression",
                 "Exercise","Smoker","AlcoholCons", "Mammo", "Breast", "Income", "UrbanRural")

#View(df)

setwd("/Users/manriquecamacho/Library/CloudStorage/OneDrive-UniversidaddeCostaRica/GitHub/Predicción_Cancer/data/processed")

write.csv(df, "data.csv")

