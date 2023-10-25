library(shellpipes)

prompt = "You are an expert in application of machine learning in public health. Also include abstract, limitations and reference sections and explam all the models and performance metrics used in the analysis. Help me write a detailed manuscript give the following. I trained a model to predict heart disease in nairobi. The model accuracy was 0.98 for random forest, 0.7 for lasso, and 0.8 for elastic net. Top 3 variables selected by best performing models was x1, xr and yy."

writeLines(prompt, paste0(targetname(), ".Rout.txt"))
