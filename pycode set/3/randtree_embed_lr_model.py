#coding=utf-8

import datetime
import sklearn.model_selection
import sklearn.pipeline
import sklearn.ensemble
from sklearn.linear_model import LogisticRegressionCV
import util

class RtlrModel(object):
    
    def __init__(self):
        
        self.best_cls = None
    
    
    def fit_for_best_cls(self, feature_values, target_values):
        
        embedder = sklearn.ensemble.RandomTreesEmbedding()
        cls = LogisticRegressionCV(class_weight = "balanced", n_jobs = 2)
        
        pipe = sklearn.pipeline.Pipeline([("emb", embedder), ("cls", cls)])
        
        model_params = {"emb__n_estimators" : [10, 20, 30], "emb__max_depth" : [3, 4, 5]}
        #model_params = {"emb__n_estimators" : [10], "emb__max_depth" : [2]}

        gs = sklearn.model_selection.GridSearchCV(estimator = pipe, 
                                                  param_grid = model_params,
                                                  n_jobs = 2, 
                                                  cv = 3, 
                                                  scoring = util.ks_scorer)
        
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
        
        detail["model_name"] = "RandomTree embedding + LR"
        detail["emb__n_estimators"] = params["emb__n_estimators"]
        detail["emb__max_depth"] = params["emb__max_depth"]
        
        return detail