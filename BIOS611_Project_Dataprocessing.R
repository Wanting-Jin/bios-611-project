## Set up Library
library(tidyverse)
library(reshape2)
library(ggplot2)
library(gtsummary)
library(flextable)
library(webshot)
webshot::install_phantomjs(force = TRUE)

## Read in the Data Set
data <- read.csv("bone-marrow.csv")
data <- data[,c(3:4,7,12,23:24,1,32,8:9,13:14,17,6,10,11,22,15,2,16,29:31,33:34,27,35,28,26,36:37)]

data1 <- data %>%
  mutate(
    DonorABO = case_when(DonorABO=='-1'~'O',
                         DonorABO=='0'~'A',
                         DonorABO=='1'~'B',
                         DonorABO=='2'~'AB'),
    RecipientABO = case_when(RecipientABO=='-1'~'O',
                             RecipientABO=='0'~'A',
                             RecipientABO=='1'~'B',
                             RecipientABO=='2'~'AB'),
    time_to_ANCrec = ANCrecovery,
    ANCrecovery = as.numeric(ANCrecovery<1000000),
    time_to_PLTrec = PLTrecovery,
    PLTrecovery = as.numeric(PLTrecovery<1000000),
    aGvHDIIIIV = as.numeric(aGvHDIIIIV==0),
    extcGvHD = as.numeric(extcGvHD==0),
    Txpostrelapse = as.numeric(Txpostrelapse==0),
  )

data1[data1$aGvHDIIIIV==0,"time_to_aGvHD_III_IV"] <- NA
data1[data1$PLTrecovery==0,"time_to_PLTrec"] <- NA
data1[data1$ANCrecovery==0,"time_to_ANCrec"] <- NA

write.csv(data1,file = "derived_data/processed-bone-marrow.csv")

## Summary statistics for the dataset
table1 <- data1 %>%
  #  select(Enthusiasm,Gender)  %>%
  tbl_summary(by = survival_status,missing = "ifany",
              type = list(CMVstatus~"continuous",HLAgrI~"continuous"),
              statistic = list(all_continuous()~c("{mean} ({sd})"),all_categorical()~"{n}({p}%)"),
              digits = list(all_continuous()~c(1,2)),
              label = list())%>%
  modify_caption("**Table 1. Patient Characteristics**") %>%
  add_overall()%>%
  add_p()%>%
  bold_labels()%>%
  as_flex_table()
table1


save_as_image(table1,path = "tables/Table1.png")


## Correlation Matrix For covariates
data$Disease <- as.numeric(as.factor(data$Disease))

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