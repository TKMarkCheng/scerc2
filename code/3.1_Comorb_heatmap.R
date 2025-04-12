library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(reshape)

##order of data
Study_order_path <- "output/abe_tables_graphs/30StudyOrder.csv"
Studyorder_df <- read.csv(Study_order_path)

##heatmap
comorb_path <- "output/abe_tables_graphs/30Comorbs.csv"

#select relevant columns with % values for comorbs
comorb_df <- read.csv(comorb_path)
comorb_forheatmap <- subset(comorb_df, select = -c(Total.patients.with.SARS.CoV.2.and.cancer..n., Total.patients.with.SARS.CoV.2.and.without.cancer..n., Total.number.of.patients..n.))


#change column names for heatmap

#change column names for heatmap

renaming_map <- c(                  'Reference' = 'Reference',
                  'Smoking.Cancer....' = 'Smoking.Cancer',
                  'Smoking.Control....' = 'Smoking.Control',
                  'Hypertension.Cancer....' = 'Hypertension.Cancer',
                  'Hypertension.Control....' = 'Hypertension.Control',
                  'Diabetes.Cancer....' = 'Diabetes.Cancer',
                  'Diabetes.Control....' = 'Diabetes.Control',
                  'CVD.Cancer....' = 'CVD.Cancer',
                  'CVD.Control....' = 'CVD.Control',
                  'Diabetes.Control....' = 'CVD.Control',
                  'Cerebrovascular.Disease.Cancer....' = 'Cerebrovascular.Cancer',
                  'Cerebrovascular.Disease.Control....' = 'Cerebrovascular.Control',
                  'Chronic.Liver.Disease.Cancer....' = 'LiverDisease.Cancer',
                  'Chronic.Liver.Disease.Control....' = 'LiverDisease.Control',
                  'CKD.Cancer....' = 'CKD.Cancer',
                  'CKD.Control....' = 'CKD.Control',
                  'Chronic.Lung.Disease.Cancer....' = 'LungDisease.Cancer',
                  'Chronic.Lung.Disease.Control....' = 'LungDisease.Control',
                  'Immunodeficiency.Cancer....' = 'Immunodeficiency.Cancer',
                  'Immunodeficiency.Control....' = 'Immunodeficiency.Control')

colnames(comorb_forheatmap) <- renaming_map[names(comorb_forheatmap)]

#plot heatmap

long_comorb <- melt(comorb_forheatmap, id='Reference')

##reorder data

long_comorb$Reference <- factor(long_comorb$Reference, levels = rev(Studyorder_df$Reference))


#plot heatmap


heatmapcomorbs <-
  ggplot(long_comorb, aes(x=variable, y=factor(Reference), fill=as.numeric(value))) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red")+
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_x_discrete(name = "Comorbidity") +
  scale_y_discrete(name = "Study")+
  labs(fill = "") 
print(heatmapcomorbs)


# save as both pdf and svg
output_file_path_heatmap = "output/abe_tables_graphs/CoMorbHeatmap30"


mapply(function(filenames) ggsave(filenames,plot = heatmapcomorbs,width = 25, height = 12,scale=1,dpi=1200),
       filenames=c(paste0(output_file_path_heatmap,'.pdf'),
                   paste0(output_file_path_heatmap,'.png'))
)

  


