
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
__title__ = 'PLA and Pocket Algorithm'
__author__ = 'w1d2s'
__mtime__ = '2015/10/5'
"""
import sys
import string
import random
import time
from numpy import *
from numpy.linalg import *

def Data_Pretreatment(path):
    rawData = open(path).readlines()
    dataNum = len(rawData)
    dataDim = len(rawData[0].strip().split(' ')) + 1
    dataIdx = 0
    X = zeros([dataNum, dataDim])
    X[:, 0] = 1
    Y = zeros(dataNum)
    print(dataNum, dataDim)
    for line in rawData:
        temp = line.strip().split('\t')
        temp[0] = temp[0].split(' ')
        Y[dataIdx] = string.atof(temp[1])
        X[dataIdx, 1:] = double(temp[0])
        dataIdx += 1
    return (X, Y)

def PLA_Cycle(X, Y, eta, IsRandom):
    # X : input set of training data, Y : output set of..., eta : learning ratio (0 ~ 1)
    # IsRandom == False -> Naive Cycle,  IsRandom == True -> Random Cycle
    (dataNum, dataDim) = X.shape
    W = zeros(dataDim)
    permutation = range(0, dataNum)
    if IsRandom:
        random.shuffle(permutation)
    else:
        pass
    upDateTimes = 0
    lastUpDateIdx = 0
    pmtIdx = 0
    dataIdx = 0
    iteCnt = 0
    halt = False
    while not halt:
        dataIdx = permutation[pmtIdx]
        dotProduct = dot(W, X[dataIdx])
        if dotProduct * Y[dataIdx] > 0:
            if dataIdx == lastUpDateIdx:
                halt = True
            else:
                pass
        else:
            # PLA update: W(t+1) = W(t) + eta*Y(n)*X(n)
            W += eta * Y[dataIdx] * X[dataIdx]
            upDateTimes += 1
            lastUpDateIdx = dataIdx
        pmtIdx = (pmtIdx + 1) % dataNum
        iteCnt += 1
        # print(iteCnt, W)
    print('upDateTimes: ', upDateTimes, '\n')
    return (W, upDateTimes)


def Is_Same_Sign(W, vector, y):
    if (dot(W, vector) > 0 and y > 0) or (dot(W, vector) <= 0 and y < 0):
        return True
    else:
        return False

def Get_Err_Num(X, Y, W):
    (dataNum, dataDim) = X.shape
    Sum = 0
    for i in range(0, dataNum):
        if not Is_Same_Sign(W, X[i], Y[i]):
            Sum += 1
    return Sum

def Pocket_Algo(X, Y, eta, iterateTimes):
    (dataNum, dataDim) = X.shape
    W_p = zeros(dataDim)
    id_p = 0
    ErrNum_p = Get_Err_Num(X, Y, W_p)
    W = zeros(dataDim)
    ErrNum = 0
    iterate = 0
    dataIdx = 0
    #random.seed(int(time.time() % 3000))
    while iterate <= iterateTimes:
        dataIdx = random.randint(0, dataNum - 1)
        if not Is_Same_Sign(W, X[dataIdx], Y[dataIdx]):
            iterate += 1
            W = W + eta * Y[dataIdx] * X[dataIdx] #!!!! W += eta * Y[dataIdx] * X[dataIdx] will change value of W_p
            ErrNum = Get_Err_Num(X, Y, W)
            if ErrNum < ErrNum_p:
                W_p = W
                ErrNum_p = ErrNum
    # print 'ErrNum_p: ' + str(ErrNum_p)
    return W_p


if __name__ == '__main__':
    """
    (X, Y) = Data_Pretreatment('train.txt')
    #W = PLA_Cycle(X, Y, 1, 'N')
    #print W
    sum = 0
    for i in range(0, 2000):
        (W, upDateTimes) = PLA_Cycle(X, Y, 0.5, True)
        sum += upDateTimes
    print str(int(sum/2000))
    """
    (X_train, Y_train) = Data_Pretreatment('18_train.txt')
    (X_test, Y_test) = Data_Pretreatment('18_test.txt')
    errSum = 0

    for times in range(0, 100):
        #random.seed(times)
        W_pocket = Pocket_Algo(X_train, Y_train, 1, 100)
        errNum_out = Get_Err_Num(X_test, Y_test, W_pocket)
        errSum += errNum_out
        print (str(errNum_out))

    errRate_out = errSum/100
    print (str(errRate_out))