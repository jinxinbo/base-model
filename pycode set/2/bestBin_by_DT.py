import sys
import csv
import pandas as pd
import pydotplus
from sklearn import tree
from IPython.display import Image,display
from sklearn.feature_extraction import DictVectorizer
from sklearn.preprocessing import OneHotEncoder


def get_decision_tree_index_interval_map(self):
    '''
    return a dict that maps the decision tree node index to its respective interval
    key: decision tree node index (woe index)
    value: (left_boundary, right_boundary, left_closed, right_closed)
    '''

    if self is None:
        return

    tree = self.tree.tree_

    children_left = tree.children_left
    children_right = tree.children_right
    threshold = tree.threshold

    idx_interval_map = dict()
    stack = [(0, -sys.maxsize, sys.maxsize, 0,
              0)]  # (node_idex, left_boundary, right_boundary, is_left_boundary_closed, is_right_boundary_closed)

    while len(stack) > 0:

        idx, left_boundary, right_boundary, left_closed, right_closed = stack.pop()

        if children_left[idx] == children_right[idx]:  # leaf node
            idx_interval_map[idx] = (left_boundary, right_boundary, left_closed, right_closed)

        else:
            left_idx, right_idx = children_left[idx], children_right[idx]

            stack.append((left_idx, left_boundary, threshold[idx], left_closed, 1))
            stack.append((right_idx, threshold[idx], right_boundary, 0, right_closed))

    return idx_interval_map

def read_data_from_excel(excel_name, id_name, target_name):
    dt = pd.read_excel(excel_name,index_col = id_name)

    return dt.drop([target_name], axis = 1), dt[target_name]


def decession_tree_bin(X,y):

    clf=tree.DecisionTreeClassifier(criterion = 'entropy',
                                    max_leaf_nodes= 7,
                                    min_samples_leaf = 0.05).fit(X,y)

    # 基本输出
    n_nodes = clf.tree_.node_count
    # print(n_nodes)
    children_left = clf.tree_.children_left
    children_right = clf.tree_.children_right
    threshold = clf.tree_.threshold
    boundary = []
    for i in range(n_nodes):
        if children_left[i]!=children_right[i]:
            boundary.append(threshold[i])
    sort_boundary = sorted(boundary)
    return sort_boundary



if __name__ == '__main__':

    pathname=r'E:\python工程\cash_tree\tmp.xlsx'

    X, y = read_data_from_excel(pathname, 'cus_id', 'target')

    allbin = dict()
    feature_names = list(X)
    print(feature_names)
    writer = csv.writer(open("allbin.csv", "w"))
    for i in range(len(feature_names)):
        drop_columns = feature_names[0:i] + feature_names[i + 1:]
        test_X = X.drop(drop_columns,axis=1)
        # print(test_X)
        test_y = y
        out_bud = decession_tree_bin(test_X, test_y)
        allbin[feature_names[i]] = out_bud
        writer.writerow([feature_names[i], out_bud])
        writer.writerow([feature_names[i], out_bud])


    # feat_imp = pd.Series(clf.feature_importances_, feature_names).sort_values(ascending=False)
    # feat_imp.to_csv('feature.csv', sep='\t')


