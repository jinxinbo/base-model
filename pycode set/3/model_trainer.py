'''
thin wrapper around sklearn classifiers, provide easy access and some additional model evaluation metrics
'''

import logging
import numpy as np
import scipy.stats
import scipy.sparse
from sklearn.linear_model import LogisticRegressionCV

class ModelTrainer(object):
    
    def __init__(self):
        
        self.model = None
        self.feature_name_coef_map = None
    
    
    def fit(self, feature_values, target_values, feature_names):
        
        self.model = LogisticRegressionCV(penalty = "l2", max_iter = 200, cv = 10, class_weight = "balanced")
        
        logging.info("start train logistic regression model with 10-fold cross validation")
        
        self.model.fit(feature_values, target_values)
        
        logging.info("train model finished, start evaluate model coefficients")
        
        self.eval_model_coef(feature_values, feature_names)

        return self
    
    
    def eval_model_coef(self, feature_values, feature_names):
        
        self.feature_name_coef_map = dict()
        wald_stat = self.wald_test(feature_values)
        wald = scipy.stats.wald()
        
        w = wald_stat[0]
        p_value = wald.pdf(w)
        self.feature_name_coef_map["Intercept"] = (self.model.intercept_[0], w, p_value)
        logging.info("Intercept: %f, wald: %f, p_value: %f" % (self.model.intercept_[0], w, p_value))
        
        for idx in range(len(feature_names)):
            coef = self.model.coef_[0][idx]
            w = wald_stat[idx + 1]
            p_value = wald.pdf(w)
            
            self.feature_name_coef_map[feature_names[idx]] = (coef, w, p_value)
            logging.info("%s: %f, wald: %f, p_value: %f" % (feature_names[idx], coef, w, p_value))
    
    
    def predict(self, feature_values):
        
        if self.model is None:
            return None
        
        return self.model.predict(feature_values)
    
    
    def predict_proba(self, feature_values):
        
        if self.model is None:
            return None
        
        proba = self.model.predict_proba(feature_values)
        proba = proba[:, 1]
        
        return proba
    
    
    def get_feature_coef_map(self):
        
        return self.feature_name_coef_map
    
    
    def wald_test(self, X):
        
        if self.model is None:
            return
        
        pred_probs = np.matrix(self.model.predict_proba(X))
        X_design = np.hstack((np.ones(shape = (X.shape[0], 1)), X))
        diag_array = np.multiply(pred_probs[:, 0], pred_probs[:, 1]).A1
        V = scipy.sparse.diags(diag_array)
        m1 = X_design.T * V
        m2 = m1.dot(X_design)
        cov_mat = np.linalg.inv(m2)
        
        model_params = np.hstack((self.model.intercept_[0], self.model.coef_[0]))
        wald_stats = (model_params / np.sqrt(np.diag(cov_mat))) ** 2
        
        return wald_stats