## Set up Library
library(tidyverse)
library(reshape2)
library(ggplot2)

## Read in the Data Set
data <- read.csv("bone-marrow.csv")
data$Disease <- as.numeric(as.factor(data$Disease))

## Correlation Matrix For covariates

get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}
reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  hc <- hclust(dd)
  cormat <-cormat[hc$order, hc$order]
}


plot_corr <- function(corr_1,dataname){
  #corr_1 = reorder_cormat(corr_1)
  upper_tri = get_upper_tri(corr_1)
  
  tri_cormat <- melt(upper_tri, na.rm = TRUE)
  tri_cormat$rvalue = round(tri_cormat$value,2)
  
  ggplot(data = tri_cormat, aes(Var2, Var1, fill = value))+
    geom_tile(color = "white")+
    scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                         midpoint = 0, limit = c(-1,1), space = "Lab", 
                         name="Pearson\nCorrelation") +
    theme_minimal()+ 
    theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                     size = 10, hjust = 1),
          axis.text.y = element_text(size = 10,hjust = 1, vjust = 1))+
    coord_fixed()+
    ggtitle(dataname)+
    geom_text(aes(Var2, Var1, label = rvalue), color = "black", size = 2) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      axis.ticks = element_blank(),
      legend.justification = c(1, 0),
      legend.position = c(0.3, 0.7),
      legend.direction = "horizontal")+
    guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                                 title.position = "top", title.hjust = 0.5))
}

corr_all = cor(data,use = "complete.obs")
corr_all = round(corr_all,4)
plot_corr(corr_all,'Pearson Correlation Matrix among Variables of Concern')

ggsave('figures/Plot_Cor.png',width = 10,height = 10)



## Dimension Reduction By PCA
data_complete = data[complete.cases(data),]
pca <- prcomp(data_complete[,1:32])
pca
summary(pca)

ggplot(pca$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2)) + 
  geom_point(aes(col = as.factor(data_complete$survival_status))) +
  labs(col="Survival Status")

ggsave('figures/Plot_PCA.png',width = 8,height = 6)




