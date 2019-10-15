# -*- coding:utf-8 -*-
import copy
import uuid
import pickle
from collections import defaultdict, namedtuple
from math import log2


class DecessionTreeClassifier(object):

    def split_dataset(self,dataset, classes, feat_idx):
        ''' 根据某个特征以及特征值划分数据集
        :param dataset: 待划分的数据集
        :param classes: 数据集对应的类型，y值
        :param feat_idx: 特征在特征向量中的索引
        :param splited_dict 
        :return: 
        '''
        splited_dict={}
        for data_vect,cls in zip(dataset, classes):
            feat_val=data_vect[feat_idx]
            sub_dataset,sub_classes=splited_dict.setdefault(feat_val,[[],[]])
            sub_dataset.append(data_vect[:feat_idx]+data_vect[feat_idx+1:])
            sub_classes.append.append(cls)
        return splited_dict

    def get_shanno_entropy(self, values):
        '''根据给定列表的值计算entropy
        '''
        uniq_vals=set(values)
        val_nums={key:values.count(key) for key in uniq_vals}
        probs=[v/len(values) for k,v in val_nums.items()]
        entropy=sum([-prob*log2(prob) for prob in probs])
        return entropy

    def choose_best_split_feature(self, dataset, classes):
        '''根据信息增益确定最好的划分数据集的特征
        
        :param dataset: 
        :param classes: 
        :return: 
        '''

        base_entropy = self.get_shanno_entropy(classes)

        feat_num=len(dataset[0])
        entropy_gains=[]
        for i in range(feat_num):
            splited_dict=self.split_dataset(dataset, classes, i)
            new_entropy=sum([
                len(sub_classes)/len(classes)*self.get_shanno_entropy(sub_classes)
                for _, (_, sub_classes) in splited_dict.items()
            ])
            entropy_gains.append(base_entropy - new_entropy)

        return entropy_gains.index(max(entropy_gains))

    def get_majority(self, classes):
        '''返回类型中占大多数的类型
        
        :param classes: 
        :return: 
        '''

        cls_num = defaultdict(lambda : 0)
        for cls in classes:
            cls_num[cls] += 1

        return max(cls_num, key=cls.get)

    def create_tree(self, dataset, classes, feat_names):
        '''
        
        :param dataset: 数据集
        :param classes: 数据集中数据对应的特征名称
        :param feat_names: 数据集中数据相应的类型
        :return: 
        '''
        #如果数据集中只有一种类型停止分裂树
        if len(set(classes)) == 1:
            return classes[0]

        #如果遍历完所有的特征，返回比例最多的类型
        if len(feat_names) == 0:
            return self.get_majority(classes)

        #分裂创建新的子树
        tree = {}
        best_feat_idx = self.choose_best_split_feature(dataset, classes)
        feature = feat_names[best_feat_idx]
        tree[feature] = {}

        #创建用于递归创建子树的子数据集
        sub_feat_names = feat_names[:]
        sub_feat_names.pop(best_feat_idx)

        splited_dict = self.split_dataset(dataset, classes, best_feat_idx)
        for feat_val, (sub_dataset, sub_clases) in splited_dict.items():
            tree[feature][feat_val] = self.create_tree(sub_dataset,
                                                       sub_clases,
                                                       sub_feat_names)
        self.tree = tree
        self.feat_names = feat_names

        return tree
