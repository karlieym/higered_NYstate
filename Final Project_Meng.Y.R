##1. Research questions 
##Question 1: What are some factors that can predict number of applications? 
##Such as tuition, financial aid, student-faculty ratio, faculty salary, and type
## of schools(classified by what degrees they offer)



 
##2.Citation of the dataset
##The dataset I'm using is from IPEDS (Integrated Postsecondary Education Data System). 
##project from the National Center for Eudaction Statistics website.It provides various 
##kind of data from higher education institutions in the U.S. I created a customized
##dataset using their data selection tool, which merges only the variables I'm interested in. 
##To make life easier, I focus on higher education data from New York State of 
##2022 only for this project. 

##3.Variable list 
# Load the data
hEd_NY <- read.csv(file = "/Users/yuxinkarlie/Library/Mobile Documents/com~apple~CloudDocs/TC columbia/Summer A/R/Final project/CSV_6262024-505/CSV_6262024-505.csv")
head(hEd_NY)
# change vairable names
names(hEd_NY)[4:9] <- c("sf_ratio", "salary", "fees", "category", "finanAid_percent", "applicants")
print(names(hEd_NY))

#Examine the number of missing values 
colSums(is.na(hEd_NY) | hEd_NY == "")
#Remove missing values
library("tidyverse")
hEd_NY <- hEd_NY %>% drop_na()

# Remove institution names for privacy concerns
hEd_NY <- subset(hEd_NY, select = -institution.name)

##Examing the structure of the dataset
str(hEd_NY)


# Variable list and description
# "unitid": University ID
# "year": The year in which the data was collected, which is 2022 here.
# "sf_ratio": Student to faculty ratio
# "salary": Average faculty salary
# "fees": Total cost of tuition and other school fees
# "category": Institutional category
# "finanAid_percent": Percent of students receiving financial aid
# "applicants": the number of total applicants in 2022.



##4.Descriptive statistics for each variable.

#Descriptive analysis of numeric variables
#Create a function called summary that calculates all desired descriptive analysis.
summar <- function(vec1) {
  # Contents of function 
  mean <- mean(vec1)
  sd <- sd(vec1)
  Q <- quantile(x = vec1, probs = seq(0, 1, 0.25))
  Q1 <- Q[2]
  Q2 <- Q[3]
  Q3 <- Q[4]
  IQR <- Q3 - Q1
  max <- max(vec1)
  min <- min(vec1)
  # Output of the function
  out <- c(mean, sd, Q1, Q2, Q3, IQR, max, min)
  names(out) <- c("mean", "sd","Q1", "Q2","Q3", "IQR","max", "min")
  out
}
#Loop the descriptive analysis through all numeric vairables.
#create a dataframe with only numeric variables.
numeric <- subset(hEd_NY, select = c("sf_ratio", "salary", "fees", "finanAid_percent", "applicants"))
#Create an ampty list to score the looping outcome
descri_num <- list()
# Construct and run the loop.
for(i in 1:ncol(numeric)){
  descri_num [[i]] <- summary(numeric[[i]])
}
# Name the output with the column names of the variables. 
names(descri_num ) <- colnames(numeric)
descri_num


#Descriptive analysis of categorical variables
# change value names in catehorical vairable
hEd_NY$category <- gsub("Degree-granting, primarily baccalaureate or above", "baccalaureate", hEd_NY$category)
hEd_NY$category <- gsub("Degree-granting, associate's and certificates", "asso&certificate", hEd_NY$category)
hEd_NY$category<-gsub(pattern = "Degree-granting, not primarily baccalaureate or above", replacement = "non-baccalaureate", hEd_NY$category)
#Numbers of each category
category_table <- table(hEd_NY$category)
category_table
#Frequencies
category_frequency <- prop.table(category_table) 
as.data.frame(category_frequency)

category_table
barplot(category_table, beside = TRUE, col = 2:4,
        main = "baccalaureate vs non baccalaureate",
        xlab = "school category",
        ylab = "number of schools")


##box plot 
#Take log(applications because the distributions are too different)
hEd_NY$log_applicants <- log1p(hEd_NY$applicants)
colors <- c("baccalaureate" = "skyblue", "asso&certificate" = "lightgreen", "non-baccalaureate" = "salmon")
boxplot(hEd_NY$log_applicants ~ hEd_NY$category,
        xlab = "Category",
        ylab = "log(Applications)",
        horizontal = FALSE,
        outline = FALSE,
        col = colors, 
        )


#Research question Analysis
#Examine correlations among numeric vairables
install.packages("car")
library(car)
he <- as.data.frame(hEd_NY[,c("sf_ratio", "salary", "applicants",
                                     "fees", "finanAid_percent")])

cor(he)
#scatterplot matrics
scatterplotMatrix(he, spread=FALSE, smoother.args=list(lty=2),
                  main="Scatter Plot Matrix")

#Run the regression
lmout <- lm(applicants ~ sf_ratio + salary+ fees+ finanAid_percent, data=hEd_NY)
summary(lmout)
#From the summary of model one, we can see that only salary is significant. So 
#we need to check further  of the model assumptions to see what's going on.

#Constant variance check
install.packages("car")
library(car)
plot(rstudent(lmout)^2 ~ fitted(lmout)) # studentized residuals vs fitted values
abline(h=0, col="red")
#The vairance looks fine, except for a few outliers.
#Rmoving outliers
outliers <- abs(rstudent(lmout)) > 3
sum(outliers) 
hEd_NY <- lmout$model[!outliers, ] 

#multicolineality check
vif(lmout)
#looks like there is no multicolineality problem(VIF<10)

#QQ plot on normality
qqPlot(lmout)
hist(hEd_NY$applicants) # From the histogram, we can see it's right skewed


#Trying to solve normality problem by taking the log of it
hEd_NY$log_applicants <- log1p(hEd_NY$applicants)
lmout2 <- lm(log_applicants ~ sf_ratio + salary+ fees+ finanAid_percent , data = hEd_NY)
qqplot(lmout2)
hist(hEd_NY$log_applicants)

summary(lmout2)


#It seems from the model result that the sf_ratio is not significant, so we take it out.
lmout3 <- lm(log_applicants ~ salary+ fees+ finanAid_percent , data = hEd_NY)
summary(lmout3)
#Looks good! All coefficient is significant. Now let's add categorical vairiables,
#which is the categories of schools, classified by what types of degree they offer.

## Add categorical variables into regression. 
lmout4 <- lm(log_applicants ~ salary+ fees+ finanAid_percent+ category, data = hEd_NY)
summary(lmout4)
## when we add categorical vairbales, there are three coeffcient become not
## significant, fees, financialAid_percent.

## Check model assumptions again for why this happens.
#Constant variance
plot(rstudent(lmout4)^2 ~ fitted(lmout4)) # studentized residuals vs fitted values
abline(h=0, col="red")
#It can be seen from the graph that the values are not evenly distributed around
#y=0, so this might be the reason why adding variable makes other variables in-
#significant,

#multicolineality check
vif(lmout4)
#looks like there is no multicolineality problem(VIF<10)

#QQ plot on normality
qqPlot(lmout4)
#The qqPlot looks fine.

##lmout4 visualization
#visualize lmout 4 by averaging out numeric veriable with each individual level
# of categorical variable.
mean(hEd_NY$salary)
mean(hEd_NY$fees)
mean(hEd_NY$finanAid_percent)
#equation 1=-1.452+5.183e-05*salary+1.819e-05*26217.46+1.241e-02*83.87912
          #=5.183e-05*salary+0.06583548
#equation2=5.183e-05*salary+0.06583548+3.132e+00=5.183e-05*salary+3.197835
#equation3=5.183e-05*salary+0.06583548+2.516=5.183e-05*salary+2.581835

#make the plot
plot(x=hEd_NY$salary, y=hEd_NY$log_applicants,xlab = "Salary", ylab = "Applicants")
abline(a = 0.06583548, b = 5.183e-05, col = "red", lwd = 2) # Equation 1
abline(a = 3.197835, b = 5.183e-05, col = "blue", lwd = 2) # Equation 2
abline(a = 2.581835, b = 5.183e-05, col = "green", lwd = 2) # Equation 3
legend("bottomright", legend = c("asso&certificate", "baccalaureate", "non-baccalaureate"),
       col = c("red", "blue", "green"), lty = c(1, 2, 3), lwd = 2, cex=0.65)




