.PHONY: clean

clean:
	rm -rf figures/*
	rm -rf derived_data/*


# Summary Plots of the dataset
# Heatmap plot of pearson correlations among covariates of interests
# Biplot after Principle Component Analysis.
figures/Plot_Cor.png figures/Plot_PCA.png: bone-marrow.csv\
 BIOS611_Project_Dataprocessing.R
	Rscript BIOS611_Project_Dataprocessing.R