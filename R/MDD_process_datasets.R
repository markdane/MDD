#create datasets from public MDD data files
library(tidyverse)
library(rrscale)
source("R/MDD_functions.R")
md <- read_csv("metadata/MDD_sample_annotations.csv")

#Read on the ATAC seq motif values
ATACseq_motif_values <- read_csv("ATACseq/Data/MDD_ATACseq_MotifFamilyScores.csv") %>%
  gather(specimenID, value, -family) %>%
  rename(feature = family) %>%
  left_join(md,by = "specimenID") %>%
  mutate(feature = paste0(feature, "_motif")) %>%
  preprocess_level3("motifs")

#Read in and process cycIF values
biomarkers <- c("p21waf1cip1_3_af647cy5_int_mean_nuc",
                "cyclind1_8_af488fitc_int_mean_nuc",
                "ki67_5_efluor570cy3_int_mean_nuc",
                "egfr_2_af488fitc_int_mean_nuc",
                "egfr_2_af488fitc_int_mean_cytoplasm",
                "met_6_af488fitc_int_mean_nuc",
                "met_6_af488fitc_int_mean_cytoplasm",
                "ndg1pt346_3_af488fitc_int_mean_nuc",
                "ndg1pt346_3_af488fitc_int_mean_cytoplasm",
                "s6_6_pecy3_int_mean_nuc",
                "s6_6_pecy3_int_mean_cytoplasm",
                "s6ps235s236_5_af647cy5_int_mean_nuc",
                "s6ps235s236_5_af647cy5_int_mean_cytoplasm",
                "s6ps240244_5_af488fitc_int_mean_nuc",
                "s6ps240244_5_af488fitc_int_mean_cytoplasm",
                "cateninbeta_4_af647cy5_int_mean_nuc",
                "cateninbeta_4_af647cy5_int_mean_cytoplasm",
                "nfkbp65_2_af647cy5_int_mean_nuc",
                "cjun_9_af488fitc_int_mean_nuc",
                "stat1ps727_2_pecy3_int_mean_nuc",
                "stat1alphaisoform_8_af647cy5_int_mean_nuc",
                "pdl1_6_af647cy5_int_mean_cytoplasm",
                "stat3_4_af488fitc_int_mean_nuc",
                "ecadherin_7_af647cy5_int_mean_nuc",
                "ecadherin_7_af647cy5_int_mean_cytoplasm",
                "vimentin_3_af555cy3_int_mean_nuc",
                "vimentin_3_af555cy3_int_mean_cytoplasm",
                "cytokeratin7human_4_af555cy3_int_mean_nuc",
                "cytokeratin7human_4_af555cy3_int_mean_cytoplasm",
                "cytokeratin18_7_af488fitc_int_mean_nuc",
                "cytokeratin18_7_af488fitc_int_mean_cytoplasm",
                "hes1_9_af647cy5_int_mean_nuc",
                "lc3ab_7_af555cy3_txt_standev_cytoplasm")

cycIF_values <- read_csv("cycIF/Data/MDD_cycIF_Level3.csv") %>%
  filter(feature %in% biomarkers) %>%
  gather(specimenID, value = value, -feature) %>%
  spread(key = feature, value = value) %>%
  mutate(egfr_2_af488fitc_int_mean_cell = (egfr_2_af488fitc_int_mean_nuc + egfr_2_af488fitc_int_mean_cytoplasm)/2,
         met_6_af488fitc_int_mean_cell = (met_6_af488fitc_int_mean_nuc + met_6_af488fitc_int_mean_cytoplasm)/2,
         ndg1pt346_3_af488fitc_int_mean_cell = (ndg1pt346_3_af488fitc_int_mean_nuc + ndg1pt346_3_af488fitc_int_mean_cytoplasm)/2,
         s6_6_pecy3_int_mean_cell = (s6_6_pecy3_int_mean_nuc + s6_6_pecy3_int_mean_cytoplasm)/2,
         s6ps235s236_5_af647cy5_cell = (s6ps235s236_5_af647cy5_int_mean_nuc + s6ps235s236_5_af647cy5_int_mean_cytoplasm)/2,
         s6_6_pecy3_int_mean_cell = (s6_6_pecy3_int_mean_nuc + s6_6_pecy3_int_mean_cytoplasm)/2,
         s6ps240244_5_af488fitc_int_mean_cell = (s6ps240244_5_af488fitc_int_mean_nuc + s6ps240244_5_af488fitc_int_mean_cytoplasm)/2,
         cateninbeta_4_af647cy5_int_mean_cell = (cateninbeta_4_af647cy5_int_mean_nuc + cateninbeta_4_af647cy5_int_mean_cytoplasm)/2,
         ecadherin_7_af647cy5_int_mean_cell = (ecadherin_7_af647cy5_int_mean_nuc + ecadherin_7_af647cy5_int_mean_cytoplasm)/2,
         vimentin_3_af555cy3_int_mean_cell = (vimentin_3_af555cy3_int_mean_nuc + vimentin_3_af555cy3_int_mean_cytoplasm)/2,
         cytokeratin7human_4_af555cy3_int_mean_cell = (cytokeratin7human_4_af555cy3_int_mean_nuc + cytokeratin7human_4_af555cy3_int_mean_cytoplasm)/2,
         cytokeratin18_7_af488fitc_int_mean_cell = (cytokeratin18_7_af488fitc_int_mean_nuc + cytokeratin18_7_af488fitc_int_mean_cytoplasm)/2) %>%
  dplyr::select(-egfr_2_af488fitc_int_mean_nuc,
         -egfr_2_af488fitc_int_mean_cytoplasm,
         -met_6_af488fitc_int_mean_nuc,
         -met_6_af488fitc_int_mean_cytoplasm,
         -ndg1pt346_3_af488fitc_int_mean_nuc,
         -ndg1pt346_3_af488fitc_int_mean_cytoplasm,
         -s6_6_pecy3_int_mean_nuc,
         -s6_6_pecy3_int_mean_cytoplasm,
         -s6ps235s236_5_af647cy5_int_mean_nuc,
         -s6ps235s236_5_af647cy5_int_mean_cytoplasm,
         -s6ps240244_5_af488fitc_int_mean_nuc,
         -s6ps240244_5_af488fitc_int_mean_cytoplasm,
         -cateninbeta_4_af647cy5_int_mean_nuc,
         -cateninbeta_4_af647cy5_int_mean_cytoplasm,
         -ecadherin_7_af647cy5_int_mean_nuc,
         -ecadherin_7_af647cy5_int_mean_cytoplasm,
         -vimentin_3_af555cy3_int_mean_nuc,
         -vimentin_3_af555cy3_int_mean_cytoplasm,
         -cytokeratin7human_4_af555cy3_int_mean_nuc,
         -cytokeratin7human_4_af555cy3_int_mean_cytoplasm,
         -cytokeratin18_7_af488fitc_int_mean_nuc,
         -cytokeratin18_7_af488fitc_int_mean_cytoplasm) %>%
  gather(feature, value, -specimenID) %>%
  left_join(md, by = "specimenID") %>%
  mutate(feature = str_remove(feature, "_.*"),
         feature = paste0(feature, "_cycIF")) %>%
  preprocess_level3(type = "cycIF")

#Read in and process GCP values
GCP_values <- read_csv("GCP/Data/MDD_GCP_Level3.csv") %>%
  rename(feature = histone) %>%
  gather(specimenID, value = value, -feature) %>%
  left_join(md, by = "specimenID") %>%
  mutate(value = 2^value,
         feature = paste0(feature, "_GCP")) %>%
  filter(!feature == "H3K27ac1K36me0_GCP") %>%
  preprocess_level3(type = "GCP") %>%
  replace( is.na(.), .001)

#Read in Hallmark pathways that are based on RNAseq data
hallmark_pathways <- read_csv("RNAseq/Data/MDD_RNAseq_HallmarkNES.csv") %>%
  gather(condition, value, -variable) %>%
  rename(feature = variable) %>%
  mutate(experimentalTimePoint = str_remove(condition, ".*_"),
         experimentalTimePoint = as.integer(experimentalTimePoint),
         ligand = str_remove(condition, "_.*"),
         feature = paste0(feature, "_Hallmark")) %>%
  dplyr::select(-condition) %>%
  preprocess_level3(type =  "Hallmark")

selected_IF_features_regex <-c("G2m_Proportion",
		"Intensity_MeanIntensity_KRT5",
		"Number_Neighbors",
		"Normalized_Second_Neighbor_Dist",
		"Well_Cell_Count",
		"Mean_Cells_per_Cluster") %>%
  paste(collapse= "|")

#Read in and process IF values
IF_values <- read_csv("IF/Data/MDD_IF_Level4.csv") %>%
  rename(feature = X1) %>%
  gather(key = "condition_collection", value = "value", -feature) %>%
  filter(str_detect(feature, selected_IF_features_regex)) %>%
  mutate(collection = str_remove(condition_collection, ".*_"),
         ligand = str_remove(condition_collection, "_.*"),
         experimentalTimePoint = str_extract(condition_collection, "_.*_"),
         experimentalTimePoint = str_remove_all(experimentalTimePoint,"_"),
         experimentalTimePoint = as.numeric(experimentalTimePoint),
         value = as.numeric(value),
         Type = "IF",
         feature = paste0(feature, "_IF")) %>%
  filter(!feature %in% c("collection_IF", "conditionName_IF","experimentalTimePoint_IF", "ligand_IF")) %>%
  dplyr::select(-condition_collection) %>%
  group_by(feature, ligand, experimentalTimePoint, Type) %>%
  summarise(value = median(value, na.rm = TRUE)) %>%
  ungroup()
  
#Read in RNAseq values
RNA_values <- read_csv("RNAseq/Data/MDD_RNAseq_med.csv") %>%
  drop_na() %>%
  mutate(feature = paste0(feature, "_RNA"),
         ligand = str_remove(condition, "_.*"),
         experimentalTimePoint = str_remove(condition, ".*_"),
         experimentalTimePoint = as.integer(experimentalTimePoint)) %>%
  rename(experimentalCondition = condition) %>%
  preprocess_level3("RNA")

#Read in RPPA values and merge with metadata
RPPA_values <- read_csv("RPPA/Data/MDD_RPPA_Level3.csv") %>%
  mutate(feature = paste0(antibody,"_RPPA")) %>%
  gather(specimenID, value = value, -feature, -antibody) %>%
  left_join(md, by = "specimenID") %>%
  mutate(value = 2^value) %>%
  preprocess_level3(type = "RPPA")

#Read in RPPA pathways scores, mean summarise within condition
# RPPA_pathways <- read_csv("RPPA/Data/MDD_Pathways_Score.csv") %>%
#   rename(specimenID = X1) %>%
#   gather(key = feature, value = value, -specimenID) %>%
#   inner_join(md, by = "specimenID") %>%
#   dplyr::select(experimentalCondition, feature, value) %>%
#   rename(condition = experimentalCondition) %>%
#   mutate(experimentalTimePoint = str_remove(condition, ".*_"),
#          experimentalTimePoint = as.integer(experimentalTimePoint),
#          ligand = str_remove(condition, "_.*"),
#          feature = paste0(feature, "_RPPApathway")) %>%
#   dplyr::select(-condition) %>%
#   preprocess_level3(type =  "RPPApathway")

# TFs <- get_TFs(dir_path = "RNAseq/Data/ChEA3_results_MD_OHSU", pattern = "ctrl_vs_.*xlsx", sheet =1)
# TFs_details <- map(2:7, get_TFs, dir_path = "RNAseq/Data/ChEA3_results_MD_OHSU", pattern = "ctrl_vs_.*xlsx") %>%
#   bind_rows()
# 
# TFs_input <- TFs_details %>%
#   dplyr::select(Query.Name, TF, Odds.Ratio, FDR, Library_only) %>%
#   right_join(TFs, by = c("Query.Name", "TF", "Library_only"))
# 
# TFs_values <- TFs_input %>%
#   dplyr::select(condition, Odds.Ratio, feature) %>%
#   rename(experimentalCondition = condition) %>%
#   mutate(feature = paste0(feature, "_TF")) %>%
#   rename(value = Odds.Ratio) %>%
#   mutate(value = as.numeric(value),
#          Type = "ChEA3 TF") %>%
#   rename(condition = experimentalCondition) %>%
#   mutate(experimentalTimePoint = str_remove(condition, ".*_"),
#          experimentalTimePoint = as.integer(experimentalTimePoint),
#          ligand = str_remove(condition, "_.*")) %>%
#   dplyr::select(-condition)

assay_pk_data <- bind_rows(ATACseq_motif_values,
                           cycIF_values,
                           GCP_values,
                           hallmark_pathways,
                           IF_values,
                           RNA_values,
                           RPPA_values,
                           #RPPA_pathways
                           )

save(assay_pk_data,
     md,
     file = "Data/assay_pk_data.rda") 

#Create selected dataset
ATACseq_variance_probs_thresh <- 0
GCP_variance_probs_thresh <- 0.25
RPPA_variance_probs_thresh <- 0.25

#filter RPPA features on variance
RPPA_selected <- select_features(RPPA_values, RPPA_variance_probs_thresh)

#filter GCP features on variance
GCP_selected <- select_features(GCP_values, GCP_variance_probs_thresh)

#use RNAseq genes filterd on variance within each condition
RNAseq_variance_genes <- read_csv("RNAseq/Data/MDD_geneList_lfc15.csv") %>%
  mutate(feature= paste0(hgnc_symbol, "_RNA")) %>%
  dplyr::select(-hgnc_symbol)

RNAseq_selected <- RNA_values %>%
  inner_join(RNAseq_variance_genes)

selected_assay_pk_data <- bind_rows(ATACseq_motif_values,
                                    cycIF_values,
                                    GCP_selected,
                                   # hallmark_pathways,
                                    IF_values,
                                    RNAseq_selected,
                                    RPPA_selected,
                                    #RPPA_pathways
                                    )

save(selected_assay_pk_data,
     ATACseq_motif_values,
     cycIF_values,
     GCP_selected, 
     #hallmark_pathways,
     IF_values,
     RNAseq_selected,
     RPPA_selected,
    # RPPA_pathways,
     file = "Data/selected_assay_pk_data.rda")

zscore_cutoff <- Inf
  ATACseq_motifs_rr <- rrscale_assay(ATACseq_motif_values, zscore_cutoff = zscore_cutoff)
  cycIF_values_rr <- rrscale_assay(cycIF_values, zscore_cutoff = zscore_cutoff)
  GCP_selected_rr <- rrscale_assay(GCP_selected, zscore_cutoff = zscore_cutoff)
  #hallmark_pathways_rr <- rrscale_assay(hallmark_pathways, zscore_cutoff = zscore_cutoff)
  IF_values_rr <- IF_values %>%
    group_by(feature) %>%
    mutate(value = rrscaleValues(value, zeros = 0.01, zscore_cutoff = Inf)[["RR"]]) %>%
    ungroup()

  RPPA_selected_rr <- rrscale_assay(RPPA_selected, zscore_cutoff = zscore_cutoff)
  #RPPA_pathways_rr <- rrscale_assay(RPPA_pathways, zscore_cutoff = zscore_cutoff)
  RNAseq_selected_rr <- rrscale_assay(RNAseq_selected, zscore_cutoff = zscore_cutoff)

  selected_assay_pk_data_rr <-  bind_rows(ATACseq_motifs_rr,
                                          cycIF_values_rr,
                                          GCP_selected_rr,
                                          #hallmark_pathways_rr,
                                          IF_values_rr,
                                          RNAseq_selected_rr, 
                                          RPPA_selected_rr,
                                          #RPPA_pathways_rr
                                          )
  save(zscore_cutoff,
       GCP_variance_probs_thresh,
       RPPA_variance_probs_thresh,
       ATACseq_motifs_rr,
       cycIF_values_rr,
       GCP_selected_rr,
       #hallmark_pathways_rr,
       IF_values_rr,
       RNAseq_selected_rr, 
       RPPA_selected_rr,
       #RPPA_pathways_rr,
       selected_assay_pk_data_rr,
       file = "Data/selected_assay_pk_data_rr.rda")

  