## Install required packages

## Install CRAN packages
new_packages <- c("remotes", "googledrive"
	, "haven", "readxl", "rlang", "factoextra"
	, "ggplot2", "ggfortify", "forcats", "plyr"
	, "scales", "stringr", "recipes", "caret"
	, "dplyr", "BradleyTerry", "randomForest"
	, "xgboost", "pls", "kernlab", "klaR", "mda"
	, "earth" , "tidyr", "naivebayes", "ROCR"
	, "ranger", "gbm", "glmnet", "MLmetrics"
	, "GGally", "keras"
)

new_packages <- new_packages[!(new_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages, repo=NULL, type="source")

### development packages
dev_packages <- c("dushoff/shellpipes")

new_packages <- sapply(dev_packages, "[", 2) 
new_packages <- new_packages[!(new_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) remotes::install_github(dev_packages)


