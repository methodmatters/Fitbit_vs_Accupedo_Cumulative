##### Load the packages we'll need
##### Load the packages we'll need
##### Load the packages we'll need
##### Load the packages we'll need

library(readr)
library(plyr); library(dplyr)
library(ggplot2)
library(BlandAltmanLeh)
library(ggridges)



##### Read in the data
##### Read in the data
##### Read in the data
##### Read in the data

# specify input directory
in_dir = 'D:\\Data Analysis Projects\\Fitbit\\Data\\Derived\\'

# read in the data
merged_data <- read_csv(paste0(in_dir, 'merged_data.csv'),
                        col_types = cols(hour_diff_apedo_fbit = col_double() )
                        )
# make column for difference in cumulative steps
merged_data$cumul_diff_apedo_fbit <- merged_data$cumulative_daily_steps_apedo - merged_data$cumulative_daily_steps_fbit

# check out:
# size of data
# number of unique dates
# first and last dates
dim(merged_data)
length(unique(merged_data$date))
min(merged_data$date)
max(merged_data$date)




##### Correspondence Plot
##### Correspondence Plot
##### Correspondence Plot
##### Correspondence Plot

# plot hourly steps against one another
ggplot(data = merged_data, aes(x = cumulative_daily_steps_apedo, 
                               y = cumulative_daily_steps_fbit, color = week_weekend)) + 
  geom_point(alpha = .5) + 
  geom_abline(intercept = 0, slope = 1, color = 'blue', 
              linetype = 2, size = 2, show.legend = TRUE) +
  geom_smooth(method="lm", fill=NA) +
  labs(x = "Accupedo", y = "Fitbit", title = 'Cumulative Step Count' ) + 
  scale_color_manual(values=c("black", "red")) +
  labs(color='Week/Weekend') 

# what's the correlation between the two columns?
# correlation of .97
cor.test(merged_data$cumulative_daily_steps_apedo, merged_data$cumulative_daily_steps_fbit)



##### Bland Altman Plot
##### Bland Altman Plot
##### Bland Altman Plot
##### Bland Altman Plot

# https://cran.r-project.org/web/packages/BlandAltmanLeh/vignettes/Intro.html
# https://stackoverflow.com/questions/41940000/modifying-ggplot-objects-after-creation

# Bland Altman plot - color the points
# by weekday/weekend and make points
# semi-transparent
trans_red <- rgb(1,0,0,alpha=0.5) 
trans_blk <- rgb(0,0,0,alpha=0.5) 
week_weekday_color <- ifelse(merged_data$week_weekend == 'Weekday', trans_blk, trans_red)
bland.altman.plot(merged_data$cumulative_daily_steps_apedo, 
                  merged_data$cumulative_daily_steps_fbit, 
                  conf.int=.95,
                  main="Bland Altman Plot: Cumulative Step Counts", 
                  xlab="Mean of Measurements", ylab="Differences", 
                  pch = 19, col = week_weekday_color)
legend(x = "topright", legend = c("Weekday","Weekend"), fill = 1:2)


# calculate the mean, standard deviation
# and the one-sample t-test against zero
mean(merged_data$cumul_diff_apedo_fbit)
sd(merged_data$cumul_diff_apedo_fbit)
t.test(merged_data$cumul_diff_apedo_fbit, mu=0, 
       alternative="two.sided", conf.level=0.95)

# effect size
# -.09 - very small!
-135.94/1592.76



#### Differences in Cumulative Step Counts Across the Day
#### Differences in Cumulative Step Counts Across the Day
#### Differences in Cumulative Step Counts Across the Day
#### Differences in Cumulative Step Counts Across the Day

# plot distributions for each hour
# separate week/weekend with facet
ggplot(data = merged_data, aes(x = cumul_diff_apedo_fbit, 
                               y = as.factor(hour),  
                               fill = week_weekend)) + 
  geom_density_ridges() + 
  geom_vline(xintercept = 0, color = 'darkgreen', 
             linetype = 3, size = 1) +
  coord_flip() + 
  facet_wrap(~week_weekend) +
  labs(y = "Hour of Day", 
       x = "Difference Cumulative Steps (Accupedo - Fitbit)" ) + 
  scale_fill_manual(values=c("black", "red"))  +
  labs(fill='Week/Weekend') 


#### Differences in Cumulative Step Count Differences - by Weekday vs. Weekend
#### Differences in Cumulative Step Count Differences - by Weekday vs. Weekend
#### Differences in Cumulative Step Count Differences - by Weekday vs. Weekend
#### Differences in Cumulative Step Count Differences - by Weekday vs. Weekend

lm1 <- lm(cumul_diff_apedo_fbit ~ week_weekend, data = merged_data)
summary(lm1)

# estimated difference for weekends 
# (from regression model)
447.885 + -263.907
