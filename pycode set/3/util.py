#coding = utf-8

import math
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import learning_curve
from sklearn.decomposition import PCA


def get_val_woe_map(feature_values, target_values):
    '''
    feature_values: numpy array of shape (1,)
    target_values: numpy array of shape (1,)
    
    returns:
    a dict mapping each unique value in feature_values to their woe value
    '''
    
    val_woe_map = dict()
    uniq_val_list = np.unique(feature_values)
    total_sample_num = len(target_values)
    total_pos_sample_num = target_values.sum()
    total_neg_sample_num = total_sample_num - total_pos_sample_num
    
    for val in uniq_val_list:
        
        sub_target_values = target_values[feature_values == val]
        
        sub_total_sample_num = len(sub_target_values)
        positive_sample_num = sub_target_values.sum()
        negative_sample_num = sub_total_sample_num - positive_sample_num
        
        pos_rate = float(positive_sample_num) / total_pos_sample_num
        neg_rate = float(negative_sample_num) / total_neg_sample_num
        woe_val = math.log((pos_rate + 0.000001) / (neg_rate + 0.000001))
        
        val_woe_map[val] = woe_val

    return val_woe_map


def compute_ks_gini(target, predict_proba, segment_cnt = 100, plot = False):
    '''
    target: numpy array of shape (1,)
    predict_proba: numpy array of shape (1,), predicted probability of the sample being positive
    segment_cnt: segment count for computing KS score, more segments result in more accurate estimate of KS score, default is 100
    plot: boolean or string, whether to draw the KS plot, save to a file if plot is string of the file name
    
    returns:
    gini: float, gini score estimation
    ks: float, ks score estimation
    '''
    
    proba_descend_idx = np.argsort(predict_proba)
    proba_descend_idx = proba_descend_idx[::-1]
    
    one_segment_sample_num = int(len(predict_proba) / segment_cnt)
    grp_idx = 1
    start_idx = 0
    total_sample_cnt = len(predict_proba)
    total_positive_sample_cnt = target.sum()
    total_negative_sample_cnt = total_sample_cnt - total_positive_sample_cnt
    
    cumulative_positive_percentage = 0.0
    cumulative_negative_percentage = 0.0
    cumulative_random_positive_percentage = 0.0
    random_positive_percentage_step = 100.0 / segment_cnt
    ks_pos_percent_list = list()
    ks_neg_percent_list = list()
    ks_score = 0.0
    gini_a_area = 0.0
    
    while start_idx < total_sample_cnt:
        
        segment_idx_list = proba_descend_idx[start_idx : start_idx + one_segment_sample_num]
        segment_target = target[segment_idx_list]
        
        segment_sample_cnt = len(segment_idx_list)
        
        segment_pos_cnt = segment_target.sum()
        segment_neg_cnt = segment_sample_cnt - segment_pos_cnt
        
        pos_percentage_in_total = float(segment_pos_cnt * 100) / total_positive_sample_cnt
        neg_percentage_in_total = float(segment_neg_cnt * 100) / total_negative_sample_cnt
        
        cumulative_positive_percentage += pos_percentage_in_total
        cumulative_negative_percentage += neg_percentage_in_total
        
        ks = cumulative_positive_percentage - cumulative_negative_percentage
        ks_score = max(ks_score, ks)
        
        cumulative_random_positive_percentage += random_positive_percentage_step
        
        gini_a_area += (cumulative_positive_percentage - cumulative_random_positive_percentage) * (1.0 / segment_cnt)
        
        ks_pos_percent_list.append(cumulative_positive_percentage)
        ks_neg_percent_list.append(cumulative_negative_percentage)
        
        grp_idx += 1
        start_idx += one_segment_sample_num
        
    gini_score = gini_a_area * 2
    
    if plot:
        file_name = plot if isinstance(plot, str) else None
        plot_ks(ks_pos_percent_list, ks_neg_percent_list, file_name)
    
    return (gini_score, ks_score)


def plot_ks(pos_percent, neg_percent, file_name = None):
    '''
    pos_percent: 1-d array, cumulative positive sample percentage
    neg_percent: 1-d array, cumulative negative sample percentage
    
    return:
    None
    '''
    
    plt.plot(pos_percent, 'ro-', label = "positive")
    plt.plot(neg_percent, 'go-', label = "negative")
    
    plt.grid(True)
    plt.legend(loc = 0)
    plt.xlabel("population")
    plt.ylabel("cumulative percentage")
    
    if file_name is not None:
        plt.savefig(file_name)
        
    else:
        plt.show()
        
    plt.close()
    
    
def ks_scorer(estimator, x, y):
    '''
    compute ks score for a pre-fitted estimator on provided data
    
    estimator: pre-fitted estimator with a predict_proba method
    x: numpy array of shape (N, K), with N samples and K features
    y: numpy array of shape (1,), target
    
    return:
    ks: float, ks score
    '''
    
    proba = estimator.predict_proba(x)
    proba = proba[:, 1]
    
    _, ks = compute_ks_gini(y, proba, plot = False)
    
    return ks


def dict_to_string(**d):
    '''
    convert an information dict to a string
    
    d: an iterable of key value pair
    
    return:
    info: string
    '''
    
    il = list()
    for k,v in d.items():
        il.append("%s:%s" % (str(k), str(v)))
        
    return ", ".join(il)
    
    
def plot_learning_curve(estimator, x, y, file_name = None, **estimator_info):
    '''
    plot the learning curve of a estimator configured with a specific set of parameters
    
    estimator: unfitted estimator with a specific set of parameters already set
    x: numpy array of shape (N, K), with N samples and K features
    y: numpy array of shape (1,), target
    file_name: the file name to save the plot, if None, plot the graph on a window
    estimator_info: dict, details about the estimator and parameter configuration
    
    return:
    None
    '''
    
    train_sizes, train_scores, test_scores = learning_curve(estimator, x, y, cv = 5, scoring = ks_scorer, n_jobs = 6)
    
    plt.figure()
    plt.title(dict_to_string(**estimator_info))

    plt.xlabel("Training examples")
    plt.ylabel("Score")

    train_scores_mean = np.mean(train_scores, axis=1)
    train_scores_std = np.std(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)
    test_scores_std = np.std(test_scores, axis=1)
    plt.grid()

    plt.fill_between(train_sizes, train_scores_mean - train_scores_std,
                     train_scores_mean + train_scores_std, alpha=0.1,
                     color="r")
    plt.fill_between(train_sizes, test_scores_mean - test_scores_std,
                     test_scores_mean + test_scores_std, alpha=0.1, color="g")
    plt.plot(train_sizes, train_scores_mean, 'o-', color="r",
             label="Training score")
    plt.plot(train_sizes, test_scores_mean, 'o-', color="g",
             label="Cross-validation score")

    plt.legend(loc="best")
    
    if file_name is not None:
        plt.savefig(file_name)
        
    else:
        plt.show()
        
    plt.close()
    
    
def draw_feature_pca(feature_values, target_values, file_name = None):
    '''
    draw a scatter plot of the first two principal component of the features of the positive and negative class respectively
    
    feature_values: numpy array of shape (N, K), with N samples and K features
    target_values: numpy array of shape (1,), target
    file_name: the file name to save the plot, if None, plot the graph on a window
    
    return:
    None
    '''
    
    pca = PCA(n_components = 2)
    feature_pc = pca.fit_transform(feature_values)
    
    feature_pc_pos = feature_pc[target_values == 1]
    feature_pc_neg = feature_pc[target_values == 0]
    
    plt.plot(feature_pc_pos[:, 0], feature_pc_pos[:, 1], c = "red", alpha = 0.6, label = "positive class")
    plt.plot(feature_pc_neg[:, 0], feature_pc_neg[:, 1], c = "blue", alpha = 0.6, label = "nagetive class")
    plt.legend(loc = "best")
    
    if file_name is not None:
        plt.savefig(file_name)
        
    else:
        plt.show()
    
    
def draw_pairwise_pca(feature_values, target_values, k = 4, scatter_file_name = None, scree_file_name = None):
    '''
    draw the pairwise scatter plot of the first k principal components, 
    and a scree plot of the accumulated explained ratio of the principal components
    
    feature_values: numpy array of shape (N, K), with N samples and K features
    target_values: numpy array of shape (1,), target
    k: int, the number of components to consider
    scatter_file_name: the file name to save the scatter plot, if None, plot the graph on a window
    scree_file_name: the file name to save the scree plot, if None, plot the graph on a window
    
    return:
    None
    '''
    
    pca = PCA()
    feature_pc = pca.fit_transform(feature_values)
    
    feature_pc_pos = feature_pc[target_values == 1]
    feature_pc_neg = feature_pc[target_values == 0]
    
    plot_num = math.factorial(k - 1)
    row_num = int(plot_num / 2)
    if plot_num % 2 != 0:
        row_num += 1
    
    f, axs = plt.subplots(nrows = row_num, ncols = 2, squeeze = False)
    axs = axs.ravel()
    ax_idx = 0
    f.set_size_inches(20, 20)
    
    for i in range(k):
        
        i_explained_var_ratio = pca.explained_variance_ratio_[i]
        
        for j in range(i + 1, k):
            
            j_explained_var_ratio = pca.explained_variance_ratio_[j]

            axes = axs[ax_idx]
            
            pos_sub_sample = feature_pc_pos[np.random.choice(len(feature_pc_pos), 5000, replace = False)]
            neg_sub_sample = feature_pc_neg[np.random.choice(len(feature_pc_neg), 5000, replace = False)]
            
            axes.scatter(pos_sub_sample[:, i], pos_sub_sample[:, j], c = "r", alpha = 0.5, label = "positive samples")
            axes.scatter(neg_sub_sample[:, i], neg_sub_sample[:, j], c = 'b', alpha = 0.5, label = "negative samples")
            
            axes.set_title("Principal Component %d vs %d" % (i, j))
            axes.set_xlabel("Component %d(%f)" % (i, i_explained_var_ratio))
            axes.set_ylabel("component %d(%f)" % (j, j_explained_var_ratio))
            axes.legend(loc = "best")
            
            ax_idx += 1
            
    if scatter_file_name is not None:
        f.savefig(scatter_file_name)
        
    else:
        plt.show()
            
    plt.figure(2)
    plt.subplot(111)
    
    cumu_explained_var_ratio = np.cumsum(np.array(pca.explained_variance_ratio_))
    x = range(1, pca.n_components_ + 1)
    plt.plot(x, cumu_explained_var_ratio, 'o-', color = 'g')
    plt.xlabel("component index")
    plt.ylabel("explained variance ratio")
    plt.title("cumulative explained variance ratio of principal components")
    
    if scree_file_name is not None:
        plt.savefig(scree_file_name)
        
    else:
        plt.show()
        
        
def draw_class_feature_distribution(feature_df, target_s, base_file_name):
    '''
    draw feature probability density function(PDF) with respect to two classes
    
    feature_df: pandas DataFrame containing the feature values
    target_s: pandas Series conataning the target(class) values
    base_file_name: string, the file name prefix for storing all the distribution graph
    
    returns:
    None
    '''
    
    for feature_name in feature_df.columns:
        
        feature_s = feature_df[feature_name]
        feature_s_pos = feature_s.loc[target_s == 1]
        feature_s_neg = feature_s.loc[target_s == 0]
        
        fig = plt.figure(figsize = (10, 10))
        plt.hist([feature_s_pos.values,feature_s_neg.values], bins = 20, color = ["r", "b"], normed = True, label = ["positive", "negative"])
        
        plt.xlabel("feature value")
        plt.ylabel("probability density")
        plt.title("distribution for feature: %s" % feature_name)
        plt.legend(loc = "best")
        
        plt.savefig("%s_%s.png" % (base_file_name, feature_name))
        plt.close(fig)