#coding = utf-8

import util
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import TruncatedSVD

def draw_feature_pdf(feature_file_name, target_name, base_file_name):
    
    df_raw = pd.read_csv(feature_file_name)
    
    target_s = df_raw[target_name]
    feature_df = df_raw.drop([target_name], axis = 1)
    
    util.draw_class_feature_distribution(feature_df, target_s, base_file_name)
    
    
def draw_pairwise_pca(feature_file_name, target_name, pca_file_name, scree_file_name):
    
    df_raw = pd.read_csv(feature_file_name)
    
    target_s = df_raw[target_name]
    feature_df = df_raw.drop([target_name], axis = 1)
    feature_values = feature_df.values
    
    scaler = StandardScaler()
    feature_values = scaler.fit_transform(feature_values)
    
    #svd = TruncatedSVD(n_components = 10)
    #feature_values = svd.fit_transform(feature_values)
    
    #ind = np.random.choice(len(feature_values), size = 5000)
    
    util.draw_pairwise_pca(feature_values, target_s.values, scatter_file_name = pca_file_name, scree_file_name = scree_file_name)
    
    
def main():
    
    raw_feature_file_name = r"D:\data\hive\pos_train_filter_processed.csv"
    target_name = "target"
    feature_pdf_base_file_name = r"E:\modeling\unify\generic\exp_data\pdf"
    pca_file_name = r"E:\modeling\unify\generic\exp_data\pca_pairwise.png"
    scree_file_name = r"E:\modeling\unify\generic\exp_data\pca_scree.png"
    
    #draw_feature_pdf(raw_feature_file_name, target_name, feature_pdf_base_file_name)
    draw_pairwise_pca(raw_feature_file_name, target_name, pca_file_name, scree_file_name)
    
    
if __name__ == "__main__":
    
    main()