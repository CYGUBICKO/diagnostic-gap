library(shellpipes)
library(plyr)
library(dplyr)
library(haven)
library(googledrive)


loadEnvironments()

## Load value lables recoding file

file_name <- fileSelect(ext="xlsx", pat="data_processing_file")
sheets <- readxl::excel_sheets(file_name)
data_processing_file <- sapply(sheets, function(x){
	readxl::read_excel(file_name, sheet = x)
}, simplify = FALSE)

## Data source
data_source = data_processing_file$data_source$data_source

## Data path
data_path = data_processing_file$data_path$data_path

## File type
file_type = get_file_ext(data_path)

if (data_source == "google_drive") {
	df_id <- try(drive_find(shared_drive = c(shared_drive_find(pattern = data_path)$id))$id, silent = TRUE)
	if (any(class(df_id) %in% "try-error")) {
	  df_id <- drive_find(pattern=data_path, type='folder')
	  query <- paste('"', df_id$id, '"',  ' in parents', sep='')
	  df_id <- drive_find(q=query)$id
	}
	downloaded_file <- drive_download(as_id(df_id), overwrite = TRUE) 
	data_path = downloaded_file$local_path
	file_type = get_file_ext(data_path)
}

## Add other file types here
if (file_type == "dta") {
	df = haven::read_dta(data_path)
} else if (file_type == "csv") {
	df = readr::read_csv(data_path)
} else if (file_type == "xlsx") {
	df = readxl::read_excel(data_path)
}

if (data_source == "google_drive") {
	unlink(data_path)
}

saveVars(df
	, sheets
	, data_processing_file
	, check_missing
	, factor2numeric
	, get_excel_param
	, get_excel_param_all
	, get_file_ext
	, labelall
	, labelsfun
	, na_codes
	, preprocessFun
	, seqx
)

