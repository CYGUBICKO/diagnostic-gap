## Iganga study analysis

## https://github.com/CYGUBICKO/idair-compare

current: target
-include target.mk

vim_session:
	bash -cl "vmt"

######################################################################

Sources += $(wildcard *.Rmd *.md *.R *.bst *.bib)
Sources += README.md

######################################################################

## Analysis pipeline

autopipeR = defined

### Linux requirements
linux_requirements:
	sudo apt install cmake

### Install required packages
requirements.Rout: requirements.R
	$(pipeR)

### helper functions for plot
helperfuns.Rout: helperfuns.R requirements.Rout
	$(pipeR)

### Descriptive plots
descplotsfuns.Rout: descplotsfuns.R
	$(pipeR)

plotfuns.Rout: plotfuns.R
	$(pipeR)

### Performance measure bootstrap
bootfuns.Rout: bootfuns.R
	$(pipeR)

### Variable importance
varimpfuns.Rout: varimpfuns.R
   $(pipeR) 

######################################################################

## Data prep

### Load data
data_processing_file = data_processing_file.xlsx
load_data.Rout: load_data.R $(data_processing_file) helperfuns.rda

### Data cleaning
cleaning.Rout: cleaning.R load_data.rda

### Generate SES based on PCA
ses_pca.Rout: ses_pca.R cleaning.rda
ses_pca_plot.Rout: ses_pca_plot.R ses_pca.rda

### Descriptive stats
descriptive_stats.Rout: descriptive_stats.R descplotsfuns.rda ses_pca_plot.rda
outputs += descriptive_stats.Rout.pdf.op

######################################################################

## Modelling prep
### Select variables for analysis
analysis_data.Rout: analysis_data.R descriptive_stats.rda

### Train-test split
data_partition.Rout: data_partition.R analysis_data.rda

### Preprocessing: Build recipes
recipes.Rout: recipes.R data_partition.rda

### Training control
training_control.Rout: training_control.R recipes.rda

## Models and their parameters
Sources += models_hyperparameters.xlsx
models_hyperparameters = models_hyperparameters.xlsx
models_hyperparameters.Rout: models_hyperparameters.R $(models_hyperparameters) training_control.rda

######################################################################

## Model training

### Linear or logistic models
ols_train.Rout: ols_train.R models_hyperparameters.rda
trained_models += ols_train.rda

### Random forest
rf_hyperparameters.Rout: rf_hyperparameters.R models_hyperparameters.rda
rf_train.Rout: rf_train.R rf_hyperparameters.rda 
trained_models += rf_train.rda

### Lasso model
lasso_hyperparameters.Rout: lasso_hyperparameters.R models_hyperparameters.rda
lasso_train.Rout: lasso_train.R lasso_hyperparameters.rda
trained_models += lasso_train.rda

### ridge model
ridge_hyperparameters.Rout: ridge_hyperparameters.R models_hyperparameters.rda
ridge_train.Rout: ridge_train.R ridge_hyperparameters.rda
trained_models += ridge_train.rda

### Enet model
enet_hyperparameters.Rout: enet_hyperparameters.R models_hyperparameters.rda
enet_train.Rout: enet_train.R enet_hyperparameters.rda
trained_models += enet_train.rda

### Gradient boosted model
gbm_hyperparameters.Rout: gbm_hyperparameters.R models_hyperparameters.rda
gbm_train.Rout: gbm_train.R gbm_hyperparameters.rda
trained_models += gbm_train.rda

### Extreem Gradient boosted model
xgbm_hyperparameters.Rout: xgbm_hyperparameters.R models_hyperparameters.rda
xgbm_train.Rout: xgbm_train.R xgbm_hyperparameters.rda
trained_models += xgbm_train.rda

### Support Vector Machine
svm_hyperparameters.Rout: svm_hyperparameters.R models_hyperparameters.rda
svm_train.Rout: svm_train.R svm_hyperparameters.rda
trained_models += svm_train.rda

### MLP model
mlp_hyperparameters.Rout: mlp_hyperparameters.R models_hyperparameters.rda
mlp_train.Rout: mlp_train.R mlp_hyperparameters.rda
trained_models += mlp_train.rda

######################################################################

## Predictive performance
resamples_test_data.Rout: resamples_test_data.R bootfuns.rda $(trained_models)

### AUC plots
auc_plots.Rout: auc_plots.R resamples_test_data.rda descplotsfuns.rda
outputs += auc_plots.Rout.pdf.op

### ROC plots
roc_plots.Rout: roc_plots.R resamples_test_data.rda descplotsfuns.rda
outputs += roc_plots.Rout.pdf.op

### Best performing model
best_model.Rout: best_model.R resamples_test_data.rda

varimp_best.Rout: varimp_best.R varimpfuns.rda $(trained_models)
varimp_plots.Rout: varimp_plots.R best_model.rda descplotsfuns.rda varimp_best.rda
outputs += varimp_plots.Rout.pdf.op

### Rank variable importance
varimp_rank.Rout: varimp_rank.R varimp_best.rda
varimp_rank_plots.Rout: varimp_rank_plots.R varimp_rank.rda
outputs += varimp_rank_plots.Rout.pdf.op

######################################################################

cp_op: $(outputs)
	$(MAKE) $^

######################################################################

### Makestuff

Sources += Makefile

## Sources += content.mk
## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

-include makestuff/chains.mk
-include makestuff/texi.mk
-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
