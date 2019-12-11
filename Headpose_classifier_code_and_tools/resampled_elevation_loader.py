import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import random
import sys
import scipy as sp
import joblib
import os
from PIL import Image as im
import tensorflow as tf
from tensorflow import keras
from sklearn import preprocessing as pre
from tensorflow.keras.callbacks import ModelCheckpoint
from sklearn import metrics
from sklearn.model_selection import train_test_split as tts
from sklearn.model_selection import GridSearchCV as gs
import pandas as pd
import sklearn.linear_model as l
import xgboost as x
from sklearn.utils import class_weight
from imblearn.over_sampling import SMOTE as sm
from math import sqrt


n_samples=797
n_features=43
def create_data():
    data=[]
    for filename in os.listdir('data_selected'):
        dat=(pd.read_csv(os.path.join("data", filename,), header=None))
        data.append(dat.to_numpy())
    return data

def create_labels():
    dat = (pd.read_csv(os.path.join("label", "classlabel_40bin.csv"), header=None))
    return dat.to_numpy()



def integrated_data(data):
    integrated = np.zeros((n_samples,n_features))
    for i in range(n_samples):
       for j in range(6):
           cur = data[i][:,j]-data[i][0,j]
           data[i][:, j] = cur
           integrated[i][j] = np.trapz(cur, x=data[i][:, 6])
           integrated[i][j+6] = np.sum(cur)/(data[i][np.size(cur,0)-1,6]-data[i][0,6]+1)
           integrated[i][j+12] = sp.stats.kurtosis(cur)
           integrated[i][j+18] = sp.stats.skew(cur)
           integrated[i][j+24] = sp.stats.variation(cur+1)-1
           integrated[i][j + 30] = np.sign(np.sum(np.sign(cur)))
           integrated[i][j + 36] = np.linalg.norm(cur)
           #integrated[i][j + 42] = sp.stats.iqr(cur)
           #integrated[i][j + 48] = sp.stats.entropy(cur)
       integrated[i][n_features-1] = data[i][-1,6]-data[i][0, 6]

    return integrated, data




def normalise(data):
    for i in range(n_samples):
        for j in range(6):
            mi=np.min(data[i][:,j])
            ma=np.max(data[i][:,j])
            #print(mi, ma, '\n')
            data[i][:,j]=(((data[i][:,j]-mi)/(ma-mi+1))-0.5)*2
    return data


def normalise_features(data,i):
    for j in range(i):
        mi=np.min(data[:,j])
        ma=np.max(data[:,j])
        if ma == mi:
            ma = mi+1
        data[:,j]=(((data[:,j]-mi)/(ma-mi))-0.5)*2
    return data


data = create_data()
data = np.asarray(data)
data = normalise(data)
integrated, data = integrated_data(data)
print(np.max(integrated))
print(np.min(integrated))
final_data = normalise_features(integrated, n_features)
print(np.max(final_data))
print(np.min(final_data))
final_data = final_data.reshape(n_samples,n_features)
label = np.asarray(create_labels())



traindata, testdata, trainlabels, testlabels = tts(final_data, label, test_size=0.08, shuffle= True)
testlabel=testlabels[:,0]
trainlabel=trainlabels[:,0]

model = joblib.load('xgboost_elevation2_40bin.dat')
preds = model.predict(testdata)
print(preds)
print(testlabel)
best_preds = ((np.asarray(preds)*40)-120)

print(metrics.accuracy_score(testlabel,preds))
print(metrics.mean_absolute_error(testlabels[:,1],best_preds))
print(sqrt(metrics.mean_squared_error(testlabels[:,1],best_preds)))
print(metrics.max_error(testlabels[:,1],best_preds))
print(metrics.f1_score(testlabel,preds, average='macro'))



