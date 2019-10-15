#coding=utf-8

import datetime
import sklearn.model_selection
import sklearn.ensemble
from sklearn.tree import DecisionTreeClassifier
import util

class AdadtModel(object):
    
    def __init__(self):
        
        self.best_cls = None
    
    
    def fit_for_best_cls(self, feature_values, target_values):

        dt = DecisionTreeClassifier(class_weight = "balanced", max_depth = 3)
        ada = sklearn.ensemble.AdaBoostClassifier(base_estimator = dt)
        
        #model_params = {"n_estimators" : [100, 150, 200], "learning_rate" : [0.01, 0.1]}
        model_params = {"n_estimators" : [200], "learning_rate" : [1.0]}

        gs = sklearn.model_selection.GridSearchCV(estimator = ada, 
                                                  param_grid = model_params,
                                                  n_jobs = 3, 
                                                  cv = 4, 
                                                  scoring = util.ks_scorer,
                                                  verbose = 1)
        
        now = datetime.datetime.now()
        print ("grid search begins: %s" % str(now))

        gs.fit(feature_values, target_values)
        
        now = datetime.datetime.now()
        print ("grid search finished: %s" % str(now))
        
        print ("best params : %s" % str(gs.best_params_))
        print ("best score : %s" % str(gs.best_score_))
        
        
        self.best_cls = gs.best_estimator_
        
    
    def fit(self, feature_values, target_values):
        
        self.fit_for_best_cls(feature_values, target_values)
        
        
    def predict(self, feature_values):
        
        assert self.best_cls is not None, "fit model first"
        
        return self.best_cls.predict(feature_values)
    
    
    def predict_proba(self, feature_values):
        
        assert self.best_cls is not None, "fit model first"
        
        return self.best_cls.predict_proba(feature_values)[:, 1]
    
    
    def get_base_estimator(self):
        
        return self.best_cls
    
    
    def get_model_detail(self):
        
        assert self.best_cls is not None, "fit model first"
        
        params = self.best_cls.get_params()
        detail = dict()
        
        detail["model_name"] = "AdaBoost with dt"
        detail["n_estimators"] = params["n_estimators"]
        detail["learning_rate"] = params["learning_rate"]
        
        return detail