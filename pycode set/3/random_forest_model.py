#coding=utf-8

import datetime
import sklearn.ensemble
import sklearn.model_selection
import util

class RandomForestModel(object):
    
    def __init__(self):
        
        self.best_rf = None
    
    
    def fit_for_best_random_forest(self, feature_values, target_values):
        
        rf = sklearn.ensemble.RandomForestClassifier(criterion = "gini")
        
        params = {"n_estimators" : [100], "max_depth" : [10], "class_weight" : ["balanced"], "max_features" : ["auto"]}

        gs = sklearn.model_selection.GridSearchCV(estimator = rf, 
                                                  param_grid = params, 
                                                  n_jobs = 2, 
                                                  cv = 5, 
                                                  scoring = util.ks_scorer)
        
        now = datetime.datetime.now()
        print ("grid search begins: %s" % str(now))

        gs.fit(feature_values, target_values)
        
        now = datetime.datetime.now()
        print ("grid search finished: %s" % str(now))
        
        print ("best params : %s" % str(gs.best_params_))
        print ("best score : %s" % str(gs.best_score_))
        
        self.best_rf = gs.best_estimator_
        
        
    def fit_for_single_random_forest(self, feature_values, target_values):
        
        rf = sklearn.ensemble.RandomForestClassifier(criterion = "gini", 
                                                     n_estimators = 500, 
                                                     max_depth = 10, 
                                                     class_weight = "balanced",
                                                     max_features = 0.5,
                                                     n_jobs = 4)
        
        scores = sklearn.model_selection.cross_val_score(rf, feature_values, target_values, scoring = util.ks_scorer, cv = 5)
        
        ave_score = sum(scores) / len(scores)
        
        print ("ave_score: %f" % ave_score)
        print ("score detail: %s" % str(scores))
        
        print ("re-fitting random forest")
        
        rf.fit(feature_values, target_values)
        self.best_rf = rf
        
    
    def fit(self, feature_values, target_values):
        
        #self.fit_for_best_random_forest(feature_values, target_values)
        
        self.fit_for_single_random_forest(feature_values, target_values)
        
        
    def predict(self, feature_values):
        
        assert self.best_rf is not None, "fit model first"
        
        return self.best_rf.predict(feature_values)
    
    
    def predict_proba(self, feature_values):
        
        assert self.best_rf is not None, "fit model first"
        
        return self.best_rf.predict_proba(feature_values)[:, 1]
    
    
    def get_base_estimator(self):
        
        return self.best_rf
    
    
    def get_model_detail(self):
        
        assert self.best_rf is not None, "fit model first"
        
        params = self.best_rf.get_params()
        detail = dict()
        
        detail["model_name"] = "random forest"
        detail["n_estimators"] = params["n_estimators"]
        detail["max_depth"] = params["max_depth"]
        
        return detail