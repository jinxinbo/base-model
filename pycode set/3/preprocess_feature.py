#coding = utf-8

import pandas as pd
import feature_selector as fs
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import TruncatedSVD


def train_feature_selector(feature_df, target_s):
    
    selector = fs.FeatureSelector()
    
    selector.fit(feature_df, target_s)
    
    return selector


def train_feature_scaler(feature_df):
    
    scaler = StandardScaler()
    
    scaler.fit(feature_df.values)
    
    return scaler


def feature_transform(feature_df, feature_selector = None, feature_scaler = None):
    
    if feature_selector is not None:
        feature_df = feature_selector.transform(feature_df)
        
    if feature_scaler is not None:
        feature_list = list(feature_df.columns)
        feature_matrix = feature_scaler.transform(feature_df.values)
        feature_df = pd.DataFrame(feature_matrix, columns = feature_list)
        
    return feature_df


def preprocess_feature(train_file, target_name, validation_file, save_train_file, save_validation_file):
    
    df_train = pd.read_csv(train_file)
    
    target_s = df_train[target_name]
    feature_df = df_train.drop([target_name], axis = 1)
    
    selector = train_feature_selector(feature_df, target_s)
    feature_df = feature_transform(feature_df, feature_selector = selector)
    
    scaler = train_feature_scaler(feature_df)
    feature_df = feature_transform(feature_df, feature_scaler = scaler)
    
    feature_df[target_name] = target_s.values
    feature_df.to_csv(save_train_file, index = False)
    
    df_validation = pd.read_csv(validation_file)
    target_s = df_validation[target_name]
    feature_df = df_validation.drop([target_name], axis = 1)
    
    feature_df = feature_transform(feature_df, feature_selector = selector, feature_scaler = scaler)
    feature_df[target_name] = target_s.values
    feature_df.to_csv(save_validation_file, index = False)
    
    
def select_and_process_feature_manual(train_file, target_name, validation_file, save_train_file, save_validation_file):
    
    features_to_keep = [
        "pos_dd_fail_ratio",
        "pos_dd_fail_cnt",
        "dd2_pos",
        "dd1_pos",
        "dd3_pos",
        "dd4_pos",
        "hist_other_pay_cnt",
        "cus_sex",
        "pos_sales_commission",
        "dd5_pos",
        "pos_sa_city"
        ]
    
    df_train = pd.read_csv(train_file)
    
    target_s = df_train[target_name]
    feature_df = df_train[features_to_keep]
    
    scaler = train_feature_scaler(feature_df)
    feature_df = feature_transform(feature_df, feature_scaler = scaler)
    
    feature_df[target_name] = target_s.values
    feature_df.to_csv(save_train_file, index = False)
    
    df_validation = pd.read_csv(validation_file)
    target_s = df_validation[target_name]
    feature_df = df_validation[features_to_keep]
    
    feature_df = feature_transform(feature_df, feature_scaler = scaler)
    feature_df[target_name] = target_s.values
    feature_df.to_csv(save_validation_file, index = False)
    
    
def preprocess_feature_svd(train_file, target_name, validation_file, save_train_file, save_validation_file):
    
    dummy_feature_names = ["comp_%02d" % i for i in range(1,16)]
    
    df_train = pd.read_csv(train_file)
    
    target_s = df_train[target_name]
    feature_df = df_train.drop([target_name], axis = 1)
    
    scaler = train_feature_scaler(feature_df)
    feature_df = feature_transform(feature_df, feature_scaler = scaler)
    
    svd = TruncatedSVD(n_components = 15)
    svd.fit(feature_df.values)
    
    svd_feature_values = svd.transform(feature_df.values)
    feature_df = pd.DataFrame(svd_feature_values, columns = dummy_feature_names)
    
    feature_df[target_name] = target_s.values
    feature_df.to_csv(save_train_file, index = False)
    
    df_validation = pd.read_csv(validation_file)
    target_s = df_validation[target_name]
    feature_df = df_validation.drop([target_name], axis = 1)
    
    feature_df = feature_transform(feature_df, feature_scaler = scaler)
    
    svd_feature_values = svd.transform(feature_df.values)
    feature_df = pd.DataFrame(svd_feature_values, columns = dummy_feature_names)
    
    feature_df[target_name] = target_s.values
    feature_df.to_csv(save_validation_file, index = False)
    
    
def main():
    
    train_file = r"D:\data\hive\pos_train_filter_processed.csv"
    validation_file = r"D:\data\hive\pos_validation_filter_processed.csv"
    target_name = "target"
    save_train_file = r"D:\data\hive\pos_train_filter_processed_preprocess.csv"
    save_validation_file = r"D:\data\hive\pos_validation_filter_processed_preprocess.csv"
    
    save_train_file_manual = r"D:\data\hive\pos_train_filter_processed_manual.csv"
    save_validation_file_manual = r"D:\data\hive\pos_validation_filter_processed_manual.csv"
    
    save_train_file_svd = r"D:\data\hive\pos_train_filter_processed_svd.csv"
    save_validation_file_svd = r"D:\data\hive\pos_validation_filter_processed_svd.csv"
    
    # preprocess_feature(train_file, target_name, validation_file, save_train_file, save_validation_file)
    
    # select_and_process_feature_manual(train_file, target_name, validation_file, save_train_file_manual, save_validation_file_manual)
    
    preprocess_feature_svd(train_file, target_name, validation_file, save_train_file_svd, save_validation_file_svd)
    

if __name__ == "__main__":
    
    main()
    