library(shellpipes)
loadEnvironments()

project = preprocess_steps$project_description
preprocess_steps$project_description = NULL
info = paste0(c(project, preprocess_steps), collapse = " ")
end = "Help me write a draft manuscript to be submitted to a scientific journal. Include the following sections: Project title, Abstract, Introduction, Methods, Results, Discussion, Limitations, Explanation about the performance metrics, and References. Make it detailed to contain all key components."

prompt = paste0(info, end)
prompt

writeLines(prompt, paste0(targetname(), ".Rout.txt"))
