#coding=utf-8

import datetime
import sklearn.svm
import sklearn.model_selection
import util

class SvmModel(object):
    
    def __init__(self):
        
        self.best_svm = None
    
    
    def fit_for_best_svm(self, feature_values, target_values):
        
        cls = sklearn.svm.SVC(probability = True)
        
        model_params = {"C" : [0.1, 1.0, 10], "class_weight" : ["balanced", None]}
        #model_params = {"C" : [1.0], "class_weight" : ["balanced"]}

        gs = sklearn.model_selection.GridSearchCV(estimator = cls, 
                                                  param_grid = model_params,
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
        
        self.best_svm = gs.best_estimator_
        
    
    def fit(self, feature_values, target_values):
        
        self.fit_for_best_svm(feature_values, target_values)
        
        
    def predict(self, feature_values):
        
        assert self.best_svm is not None, "fit model first"
        
        return self.best_svm.predict(feature_values)
    
    
    def predict_proba(self, feature_values):
        
        assert self.best_svm is not None, "fit model first"
        
        return self.best_svm.predict_proba(feature_values)[:, 1]
    
    
    def get_base_estimator(self):
        
        return self.best_svm
    
    
    def get_model_detail(self):
        
        assert self.best_svm is not None, "fit model first"
        
        params = self.best_svm.get_params()
        detail = dict()
        
        detail["model_name"] = "SVM"
        detail["C"] = params["C"]
        detail["class_weight"] = params["class_weight"]
        
        return detail