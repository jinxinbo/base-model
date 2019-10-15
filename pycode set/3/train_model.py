#coding=utf-8

import pandas as pd
import util
import random_forest_model
import gbdt_model
import svm_model
import randtree_embed_lr_model
import adaboost_lr_model
import adaboost_dt_model


def get_train_validation_data(train_file, target_name, validation_file = None):
    '''
    properly read in train and validation data, convert then into nunpy arrays
    
    train_file: string, file name for train data
    target_name: string, name of the target column
    validation_file(optional): string, file name for validation data
    
    returns:
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) if validation_file is provided
    (feature_name_list, train_feature_values, train_target_values) if validation_file is not provided
    '''
    
    df_train = pd.read_csv(train_file)
    train_target_values = df_train[target_name].values
    df_train = df_train.drop([target_name], axis = 1)
    feature_name_list = list(df_train.columns)
    train_feature_values = df_train.values
    
    ret = (feature_name_list, train_feature_values, train_target_values)
    
    if validation_file is not None:
        df_validation = pd.read_csv(validation_file)
        
        validation_target_values = df_validation[target_name].values
        df_validation = df_validation.drop([target_name], axis = 1)
        validation_feature_values = df_validation.values
        
        ret += (validation_feature_values, validation_target_values)
    
    return ret


def train(modeler, train_feature_values, train_target_values, feature_name_list, ks_plot_file_name, learning_curve_file_name):
    
    estimator = modeler()
    
    estimator.fit(train_feature_values, train_target_values)
    model_detail = estimator.get_model_detail()
    detail_info = util.dict_to_string(**model_detail)
    
    proba = estimator.predict_proba(train_feature_values)
    gini, ks = util.compute_ks_gini(train_target_values, proba, plot = ks_plot_file_name)
    
    #util.plot_learning_curve(estimator.get_base_estimator(), train_feature_values, train_target_values, learning_curve_file_name, **model_detail)
    
    print ("+" * 20)
    print ("model training info")
    print ("modeler: %s" % modeler.__name__)
    print ("model detail: %s" % detail_info)
    print ("KS on training data: %0.2f" % ks)
    print ("GINI on training data: %0.2f" % gini)
    print ("ks plot saved to file: %s" % ks_plot_file_name)
    print ("learning curve plot saved to file: %s" % learning_curve_file_name)
    print ("+" * 20)
    
    return estimator


def validate(estimator, validation_feature_values, validation_target_values, feature_name_list, ks_plot_file_name):
    
    proba = estimator.predict_proba(validation_feature_values)
    gini, ks = util.compute_ks_gini(validation_target_values, proba, plot = ks_plot_file_name)
    
    print ("+" * 20)
    print ("model validation info")
    print ("modeler: %s" % estimator.__class__.__name__)
    print ("KS on validation data: %0.2f" % ks)
    print ("GINI on validation data: %0.2f" % gini)
    print ("ks plot saved to file: %s" % ks_plot_file_name)
    print ("+" * 20)
    
    
def train_random_forest(train_file, target_name, validation_file = None):
    
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) = get_train_validation_data(train_file, target_name, validation_file)
    
    args = dict()
    args["modeler"] = random_forest_model.RandomForestModel
    args["train_feature_values"] = train_feature_values
    args["train_target_values"] = train_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\train_ks_random_forest.png"
    args["learning_curve_file_name"] = r"E:\modeling\unify\generic\learning_curve_random_forest.png"
    
    estimator = train(**args)
    
    args = dict()
    args["estimator"] = estimator
    args["validation_feature_values"] = validation_feature_values
    args["validation_target_values"] = validation_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\validation_ks_random_forest.png"
    
    validate(**args)
    
    
def train_gbdt(train_file, target_name, validation_file = None):
    
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) = get_train_validation_data(train_file, target_name, validation_file)
    
    args = dict()
    args["modeler"] = gbdt_model.GbdtModel
    args["train_feature_values"] = train_feature_values
    args["train_target_values"] = train_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\train_ks_gbdt.png"
    args["learning_curve_file_name"] = r"E:\modeling\unify\generic\learning_curve_gbdt.png"
    
    estimator = train(**args)
    
    args = dict()
    args["estimator"] = estimator
    args["validation_feature_values"] = validation_feature_values
    args["validation_target_values"] = validation_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\validation_ks_gbdt.png"
    
    validate(**args)
    
    
def train_svm(train_file, target_name, validation_file = None):
    
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) = get_train_validation_data(train_file, target_name, validation_file)
    
    args = dict()
    args["modeler"] = svm_model.SvmModel
    args["train_feature_values"] = train_feature_values
    args["train_target_values"] = train_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\train_ks_svm.png"
    args["learning_curve_file_name"] = r"E:\modeling\unify\generic\learning_curve_svm.png"
    
    estimator = train(**args)
    
    args = dict()
    args["estimator"] = estimator
    args["validation_feature_values"] = validation_feature_values
    args["validation_target_values"] = validation_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\validation_ks_svm.png"
    
    validate(**args)
    
    
def train_rtlr(train_file, target_name, validation_file = None):
    
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) = get_train_validation_data(train_file, target_name, validation_file)
    
    args = dict()
    args["modeler"] = randtree_embed_lr_model.RtlrModel
    args["train_feature_values"] = train_feature_values
    args["train_target_values"] = train_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\train_ks_rtlr.png"
    args["learning_curve_file_name"] = r"E:\modeling\unify\generic\learning_curve_rtlr.png"
    
    estimator = train(**args)
    
    args = dict()
    args["estimator"] = estimator
    args["validation_feature_values"] = validation_feature_values
    args["validation_target_values"] = validation_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\validation_ks_rtlr.png"
    
    validate(**args)
    
    
def train_adalr(train_file, target_name, validation_file = None):
    
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) = get_train_validation_data(train_file, target_name, validation_file)
    
    args = dict()
    args["modeler"] = adaboost_lr_model.AdalrModel
    args["train_feature_values"] = train_feature_values
    args["train_target_values"] = train_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\train_ks_adalr.png"
    args["learning_curve_file_name"] = r"E:\modeling\unify\generic\learning_curve_adalr.png"
    
    estimator = train(**args)
    
    args = dict()
    args["estimator"] = estimator
    args["validation_feature_values"] = validation_feature_values
    args["validation_target_values"] = validation_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\validation_ks_adalr.png"
    
    validate(**args)
    
    
def train_adadt(train_file, target_name, validation_file = None):
    
    (feature_name_list, train_feature_values, train_target_values, validation_feature_values, validation_target_values) = get_train_validation_data(train_file, target_name, validation_file)
    
    args = dict()
    args["modeler"] = adaboost_dt_model.AdadtModel
    args["train_feature_values"] = train_feature_values
    args["train_target_values"] = train_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\train_ks_adadt.png"
    args["learning_curve_file_name"] = r"E:\modeling\unify\generic\learning_curve_adadt.png"
    
    estimator = train(**args)
    
    args = dict()
    args["estimator"] = estimator
    args["validation_feature_values"] = validation_feature_values
    args["validation_target_values"] = validation_target_values
    args["feature_name_list"] = feature_name_list
    args["ks_plot_file_name"] = r"E:\modeling\unify\generic\validation_ks_adadt.png"
    
    validate(**args)
    
    
def main():
    
    train_file = r"D:\data\hive\pos_train_filter_processed.csv"
    validation_file = r"D:\data\hive\pos_validation_filter_processed.csv"
    target_name = "target"
    
    #train_random_forest(train_file, target_name, validation_file)
    train_gbdt(train_file, target_name, validation_file)
    #train_svm(train_file, target_name, validation_file)
    #train_rtlr(train_file, target_name, validation_file)
    #train_adalr(train_file, target_name, validation_file)
    #train_adadt(train_file, target_name, validation_file)
    

if __name__ == "__main__":
    
    main()
