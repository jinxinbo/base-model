#coding = utf-8


import numpy as np
from sklearn.ensemble import RandomForestClassifier


class FeatureSelector(object):
    
    def __init__(self, 
                 correlation_threshold = 0.7,
                 feature_importance_threshold = 0.0005):
        
        self.features_to_drop = None
        
        self.correlation_threshold = correlation_threshold
        self.feature_importance_threshold = feature_importance_threshold
        
        
    def fit(self, feature_df, target_s):
        
        feature_df = feature_df.copy()
        self.features_to_drop = list()

        drop_list = self.select_on_rf_feature_importance(feature_df, target_s)
        self.features_to_drop.extend(drop_list)
        feature_df = feature_df.drop(drop_list, axis = 1)

        # drop_list = self.select_on_feature_correlation(feature_df)
        # self.features_to_drop.extend(drop_list)
        # feature_df = feature_df.drop(drop_list, axis = 1)

        return self.features_to_drop
    
    def transform(self, feature_df):
        
        assert self.features_to_drop is not None, "fit the selector first"
        
        return feature_df.drop(self.features_to_drop, axis = 1)
    
    
    def select_on_feature_correlation(self, feature_df):
        
        feature_list = list(feature_df.columns)
        feature_num = len(feature_list)
        features_to_drop = list()
        
        corr_matrix = np.corrcoef(feature_df.values, rowvar = 0)
        corr_matrix = np.absolute(corr_matrix)
        
        for i in range(feature_num):
            corr_matrix[i, i] = 0
        
        while True:
            
            max_idx = np.argmax(corr_matrix)
            
            i = int(max_idx / feature_num)
            j = max_idx % feature_num
            
            if corr_matrix[i, j] < self.correlation_threshold:
                break
            
            ave_corr_i = np.average(corr_matrix[i])
            ave_corr_j = np.average(corr_matrix[j])
            drop_index = i if ave_corr_i >= ave_corr_j else j
            
            print ("+" * 20)
            print ("correlation between %s and %s is %f" % (feature_list[i], feature_list[j], corr_matrix[i, j]))
            print ("average correlation for %s is %f" % (feature_list[i], ave_corr_i))
            print ("average correlation for %s is %f" % (feature_list[j], ave_corr_j))
            print ("drop feature: %s" % (feature_list[drop_index]))
            print ("+" * 20)
            
            features_to_drop.append(feature_list[drop_index])
            corr_matrix[drop_index, :] = 0
            corr_matrix[:, drop_index] = 0
            
        return features_to_drop
            
    
    def select_on_rf_feature_importance(self, feature_df, target_s):
        
        feature_list = list(feature_df.columns)
        feature_num = len(feature_list)
        features_to_drop = list()
        
        print ("+" * 20)
        print ("select feature on random forest feature importance")

        forest = RandomForestClassifier(n_estimators = 100, n_jobs = 6, class_weight = "balanced", max_depth = 10, max_features = 0.8)
        forest.fit(feature_df.values, target_s.values)
        
        for i in range(feature_num):
            
            importance = forest.feature_importances_[i]
            
            if importance < self.feature_importance_threshold:
                features_to_drop.append(feature_list[i])
                print ("%s will be dropped, importance: %f" % (feature_list[i], importance))
                
        return features_to_drop
