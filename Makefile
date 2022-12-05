.PHONY: clean

clean:
	
	rm -rf figures/*
	rm -rf derived_data/*
	rm -rf tables/*
	rm -r BIOS611_Project_Report.html


# Data Processing and Summary Statistics and Plots of the dataset
# Table of summary statistics of the original dataset
# Heatmap plot of pearson correlations among covariates of interests
derived_data/processed-bone-marrow.csv tables/Table1.png figures/Plot_Cor.png: bone-marrow.csv\
 BIOS611_Project_Dataprocessing.R
	Rscript BIOS611_Project_Dataprocessing.R


# Survival Analysis of the processed bone-marrow data
# Log-rank test and K-M estimates by significant covariates
# Cox proportional hazard model
tables/Table_cox.png figures/Plot_KM_Age.png figures/Plot_KM_ANC.png figures/Plot_KM_PLT.png\
 figures/Plot_KM_aGvHD.png figures/Plot_KM_ecGvHD.png: derived_data/processed-bone-marrow.csv\
 BIOS611_Project_Survival.R
	Rscript BIOS611_Project_Survival.R


# Generating the Final Report
BIOS611_Project_Report.html: tables/Table_cox.png figures/Plot_KM_Age.png figures/Plot_KM_ANC.png figures/Plot_KM_PLT.png\
 figures/Plot_KM_aGvHD.png figures/Plot_KM_ecGvHD.png tables/Table1.png figures/Plot_Cor.png\
 BIOS611_Project_Report.Rmd
	Rscript -e 'rmarkdown::render("BIOS611_Project_Report.Rmd")'