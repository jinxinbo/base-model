#coding=utf-8

import numpy as np
import pandas as pd
import util
import pickle

class RawFeatureDataProcessor(object):
    
    def __init__(self,
                 train_file_name,
                 target_col_name,
                 save_train_file_name,
                 validation_file_name = None,
                 save_validation_file_name = None,
                 columns_to_drop = None,
                 categorical_feature_names = None):
        
        self.train_file_name = train_file_name
        self.target_col_name = target_col_name
        self.save_train_file_name = save_train_file_name
        self.validation_file_name = validation_file_name
        self.save_validation_file_name = save_validation_file_name
        self.columns_to_drop = columns_to_drop
        self.categorical_feature_names = categorical_feature_names or list()
        
        self.categorical_feature_mapper = None
        
        assert self.train_file_name is not None, "must provide train file name"
        assert self.save_train_file_name is not None, "must provide a file name to save processed train file"
        assert self.target_col_name is not None, "must provide the target column name"
        
        
    def process_train_file(self):
        '''
        process train feature csv file, handle categorical feature conversion
        save the processed file to self.save_train_file_name
        '''
        
        self.categorical_feature_mapper = dict()
        
        df_raw = pd.read_csv(self.train_file_name)
        df_raw.columns = [col.split('.')[-1] for col in df_raw.columns] #in case the head is of the form table_name.feature_name
        target_values = df_raw[self.target_col_name].values
        
        if self.columns_to_drop is not None and len(self.columns_to_drop) > 0:    
            df_raw = df_raw.drop(self.columns_to_drop, axis = 1)
            
        for col in df_raw.columns:
            
            if col == self.target_col_name:
                continue
            
            if (col in self.categorical_feature_names) or (self.determine_feature_type(df_raw[col].values) == 1):
                converter_map = self.fit_categorical_feature_converter(df_raw[col].values, target_values)
                df_raw[col] = self.convert_categorical_feature(df_raw[col].values, converter_map)
                self.categorical_feature_mapper[col] = converter_map
                
        df_raw = df_raw.fillna(0, axis = 1)
        
        df_raw.to_csv(self.save_train_file_name, index = False)
        
        
    def fit_categorical_feature_converter(self, feature_values, target_values):
        '''
        feature_values: numpy array of shape (1,)
        target_values: numpy array of shape (1,)
        
        returns:
        converter_map: a dict for mapping categorical value to it's woe value
        '''
        
        '''
        val_woe_map = util.get_val_woe_map(feature_values, target_values)
        ordered_woe_val_list = sorted(val_woe_map.iteritems(), key = lambda e : e[1])
        converter_map = {ordered_woe_val_list[i][0] : i + 1 for i in xrange(len(ordered_woe_val_list))} #reserve 0 for unseen values
        return converter_map
        '''
        
        return util.get_val_woe_map(feature_values, target_values)
    
    
    def convert_categorical_feature(self, feature_values, converter_map):
        '''
        feature_values: numpy array of shape (1,)
        converter_map: map of categorical value to integer value
        
        returns:
        converted feature values, numpy array of shape (1,)
        '''
        
        return np.array([converter_map.get(v, 0) for v in feature_values])
    
    
    def determine_feature_type(self, feature_values):
        '''
        feature_values: numpy array of shape (1,)
        
        returns:
        0 for continuous
        1 for categorical
        '''
        
        try:
            feature_values.astype(np.float64)
        except:
            return 1
        
        #uniq_val_cnt = len(np.unique(feature_values))
        
        #return 1 if uniq_val_cnt < 20 else 0
        
        return 0
    
    
    def process_feature_file(self, feature_file, save_file, drop_columns = True):
        
        df_raw = pd.read_csv(feature_file)
        df_raw.columns = [col.split('.')[-1] for col in df_raw.columns] #in case the head is of the form table_name.feature_name
        
        if drop_columns and self.columns_to_drop is not None and len(self.columns_to_drop) > 0:
            df_raw = df_raw.drop(self.columns_to_drop, axis = 1)
            
        for col in df_raw.columns:
            
            converter_map = self.categorical_feature_mapper.get(col, None)
            
            if converter_map is not None:
                df_raw[col] = self.convert_categorical_feature(df_raw[col].values, converter_map)
                
        df_raw = df_raw.fillna(0, axis = 1)
        
        df_raw.to_csv(save_file, index = False)
    
    
    def process_validation_file(self):
        '''
        process validation feature csv file, handle categorical feature conversion
        save the processed file to self.save_train_file_name
        '''
        
        self.process_feature_file(self.validation_file_name, self.save_validation_file_name)
    
    
    def run(self):
        '''
        process control
        '''
        
        self.process_train_file()
        
        if self.validation_file_name is not None and self.save_validation_file_name is not None:
            self.process_validation_file()
            
            
def train():
    
    args = dict()
    
    args["train_file_name"] = r"D:\data\hive\pos_train_filter.csv"
    args["save_train_file_name"] = r"D:\data\hive\pos_train_filter_processed.csv"
    args["target_col_name"] = "target"
    args["validation_file_name"] = r"D:\data\hive\pos_validation_filter.csv"
    args["save_validation_file_name"] = r"D:\data\hive\pos_validation_filter_processed.csv"
    args["columns_to_drop"] = [
                            "cus_id",
                            "has_pos_loan",
                            "observe_date",
                            "pos_app_date",
                            "pos_contract_no",
                            "shop_first_loan_date_pos",
                            "dd7_pos",
                            "dd8_pos",
                            "cus_cert_initial4",
                            "sa_cert_initial6_pos",
                            "pos_total_delay_day_cnt",
                            "has_prepay_pos",
                            "sa_inaugurate_date_pos",
                            "active_loan_cnt_pos",
                            "approve_cnt_pos"
                            ]
    
    categorical_feature_names = ["cus_sex",
                                 "pos_period_cnt",
                                 "pos_other_contact_type",
                                 "pos_relative_type",
                                 "pos_sa_city",
                                 "sa_cert_initial4_pos",
                                 'sa_level_pos',
                                 "sa_status_pos",
                                 "shop_type_pos",
                                 "shop_status_pos"
                                 ]
    
    args["categorical_feature_names"] = categorical_feature_names
    
    processor = RawFeatureDataProcessor(**args)
    
    processor.run()
    
    f = open("RawFeatureDataProcessor.pkl", "wb")
    pickle.dump(processor, f)
    f.close()
    
    
def convert():
    
    feature_file_name = r"D:\data\hive\wl\super_white_list_raw_0725.csv"
    save_file_name = r"D:\data\hive\wl\super_white_list_feature_0725.csv"
    
    f = open("RawFeatureDataProcessor.pkl", "rb")
    processor = pickle.load(f)
    f.close()
    
    processor.process_feature_file(feature_file_name, save_file_name, drop_columns = False)
            
            
if __name__ == "__main__":
    
    # train()
    
    convert()