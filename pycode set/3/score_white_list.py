#coding = utf-8

import numpy as np
import pandas as pd
import pickle
import matplotlib.pylab as plt


def get_feature_list(file_name, target_name = "target"):
    
    df = pd.read_csv(file_name)
    df = df.drop([target_name], axis = 1)
    
    return list(df.columns)


def load_model(file_name):
    
    f = open(file_name, "rb")
    cls = pickle.load(f)
    f.close()
    
    return cls


def score(df_raw, cls, feature_names):
    
    feature_df = df_raw[feature_names]
    
    score_vec = cls.predict_proba(feature_df.values)[:, 1]
    
    df_raw["score"] = score_vec
    
    df_raw.sort_values("score", axis = 0, inplace = True)
    
    return df_raw


def save_white_list_score(df, num_to_keep, keep_feature_list, file_name):
    
    df = df[keep_feature_list]
    
    if len(df) > num_to_keep:
        df = df.iloc[:num_to_keep]
        
    df.to_csv(file_name, index = False)
    
    
def run_score():
    
    raw_feature_file_name = r"D:\data\hive\wl\super_white_list_feature_0725.csv"
    model_file_name = "gbdt_cls.pkl"
    train_file_name = r"D:\data\hive\pos_validation_filter_processed.csv"
    num_to_keep = 1500000
    keep_feature_list = ["cus_id", "certid", "phone", "credit", "pos_finished_periods_cnt", "max_hist_cpd_pos", "debt_collection_hist_contact_cnt", "score"]
    wl_save_file = r"D:\data\hive\wl\super_white_list_with_score_0725.csv"
    
    model_feature_list = get_feature_list(train_file_name)
    cls = load_model(model_file_name)
    
    df_raw = pd.read_csv(raw_feature_file_name)
    
    df_raw = score(df_raw, cls, model_feature_list)
    
    save_white_list_score(df_raw, num_to_keep, keep_feature_list, wl_save_file)
    
    
def dist_stat(df):
    
    score = df["score"].values
    
    for col in ["pos_finished_periods_cnt", "max_hist_cpd_pos", "debt_collection_hist_contact_cnt"]:
        
        print ("+" * 20)
        print ("dist stat for %s" % col)
        
        sub = df[col].values
        uniq = np.unique(sub)
        uniq.sort()
        
        for val in uniq:
            score_sub = score[sub == val]
            ave = np.average(score_sub)
            std = np.std(score_sub)
            
            print ("%d:\t%f\t%f\t%d" % (val, ave, std, len(score_sub)))
    
    
def validate():
    
    wl_file = r"D:\data\hive\super_white_list_with_score.csv"
    finish_periods_plot_file = r"E:\modeling\unify\generic\wl\pos_finished_periods_cnt.png"
    max_cpd_plot_file = r"E:\modeling\unify\generic\wl\max_hist_cpd_pos.png"
    debt_collection_plot_file = r"E:\modeling\unify\generic\wl\debt_collection_hist_contact_cnt.png"
    
    df = pd.read_csv(wl_file)
    
    df_sample = df.iloc[np.random.choice(len(df), len(df)/100, replace = False)]
    del df
    
    plt.figure()
    plt.scatter(df_sample["score"], df_sample["pos_finished_periods_cnt"])
    plt.xlabel("score")
    plt.ylabel("pos_finished_periods_cnt")
    plt.savefig(finish_periods_plot_file)
    plt.close()
    
    plt.figure()
    plt.scatter(df_sample["score"], df_sample["max_hist_cpd_pos"])
    plt.xlabel("score")
    plt.ylabel("max_hist_cpd_pos")
    plt.savefig(max_cpd_plot_file)
    plt.close()
    
    plt.figure()
    plt.scatter(df_sample["score"], df_sample["debt_collection_hist_contact_cnt"])
    plt.xlabel("score")
    plt.ylabel("debt_collection_hist_contact_cnt")
    plt.savefig(debt_collection_plot_file)
    plt.close()
    
    
def validate2():
    
    wl_file = r"D:\data\hive\super_white_list_with_score.csv"
    
    df = pd.read_csv(wl_file)
    
    dist_stat(df)
    
    
def feature_importance():
    
    train_file = r"D:\data\hive\pos_validation_filter_processed.csv"
    model_file_name = "gbdt_cls.pkl"
    
    feature_list = get_feature_list(train_file)
    cls = load_model(model_file_name)
    
    l = list()
    
    for i in range(len(feature_list)):
        
        l.append((feature_list[i], cls.feature_importances_[i]))
        
    l.sort(key = lambda e : e[1], reverse = True)
    
    for fn, fi in l:
        print ("%s\t%f" % (fn, fi))
    
    
    
    
if __name__ == "__main__":
    
    run_score()
    #validate2()
    #feature_importance()