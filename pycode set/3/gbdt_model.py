#coding=utf-8

import numpy as np
import datetime
import sklearn.ensemble
import sklearn.model_selection
import pickle
import util

class GbdtModel(object):
    
    def __init__(self):
        
        self.best_gbdt = None
        
        
    def get_sample_weight(self, target_values):
        
        pos_sample_num = target_values.sum()
        neg_sample_num = len(target_values) - pos_sample_num
        
        pos_sample_weight = float(neg_sample_num) / len(target_values)
        neg_sample_weight = float(pos_sample_num) / len(target_values)
        
        sample_weight = np.zeros(shape = len(target_values))
        
        sample_weight[target_values == 1] = pos_sample_weight
        sample_weight[target_values == 0] = neg_sample_weight
        
        return sample_weight
    
    
    def fit_for_best_gbdt(self, feature_values, target_values):
        
        gbdt = sklearn.ensemble.GradientBoostingClassifier(max_features = "auto")
        
        model_params = {"n_estimators" : [300, 500, 600, 800], "max_depth" : [3], "learning_rate" : [0.1, 0.01, 0.05], "subsample" : [0.3, 0.5, 0.7]}
        fit_params = {"sample_weight" : self.get_sample_weight(target_values)}

        gs = sklearn.model_selection.GridSearchCV(estimator = gbdt, 
                                                  param_grid = model_params,
                                                  fit_params = fit_params,
                                                  n_jobs = 3, 
                                                  cv = 5, 
                                                  scoring = util.ks_scorer,
                                                  verbose = 10)
        
        now = datetime.datetime.now()
        print ("grid search begins: %s" % str(now))

        gs.fit(feature_values, target_values)
        
        now = datetime.datetime.now()
        print ("grid search finished: %s" % str(now))
        
        print ("best params : %s" % str(gs.best_params_))
        print ("best score : %s" % str(gs.best_score_))
        
        self.best_gbdt = gs.best_estimator_
        
        f = open("gbdt_cls.pkl", "wb")
        pickle.dump(self.best_gbdt, f)
        f.close()
        
    
    def fit(self, feature_values, target_values):
        
        self.fit_for_best_gbdt(feature_values, target_values)
        
        
    def predict(self, feature_values):
        
        assert self.best_gbdt is not None, "fit model first"
        
        return self.best_gbdt.predict(feature_values)
    
    
    def predict_proba(self, feature_values):
        
        assert self.best_gbdt is not None, "fit model first"
        
        return self.best_gbdt.predict_proba(feature_values)[:, 1]
    
    
    def get_base_estimator(self):
        
        return self.best_gbdt
    
    
    def get_model_detail(self):
        
        assert self.best_gbdt is not None, "fit model first"
        
        params = self.best_gbdt.get_params()
        detail = dict()
        
        detail["model_name"] = "GBDT"
        detail["n_estimators"] = params["n_estimators"]
        detail["max_depth"] = params["max_depth"]
        detail["learning_rate"] = params["learning_rate"]
        detail["subsample"] = params["subsample"]
        
        return detail