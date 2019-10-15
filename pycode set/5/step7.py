from sklearn import tree
from sklearn.datasets import load_iris
# from IPython.display import Image
# import os
import pydot
# import pydot.dot_parser
# from pydot.pydot import graph_from_dot_data
from sklearn.externals.six import StringIO
iris=load_iris()
print(iris)
clf=tree.DecisionTreeClassifier(max_depth=3)
clf=clf.fit(iris.data,iris.target)
# with open("iris.dot", 'w') as f:
#     f = tree.export_graphviz(clf, out_file=f)

# dot_data = StringIO()
# tree.export_graphviz(clf,out_file=dot_data,feature_names=iris.feature_names,class_names=iris.target_names,filled=True,rounded=True,special_characters=True)

dot_data = StringIO()
tree.export_graphviz(clf, out_file=dot_data)
print(dot_data.getvalue())
# dd=dot_data.getvalue()
# print(dd.startswith)
# graph =pydot.pydot.graph_from_dot_data(dot_data.getvalue())
# graph.write_pdf("iris.pdf")
