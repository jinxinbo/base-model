from sklearn import tree
from sklearn.datasets import load_iris
from IPython.display import Image,display
import pydotplus

iris=load_iris()
clf=tree.DecisionTreeClassifier()
clf=clf.fit(iris.data,iris.target)


dot_data=tree.export_graphviz(clf,out_file=None,
                              feature_names=iris.feature_names,
                              class_names=iris.target_names,
                              filled=True,rounded=True,
                              special_characters=True)
graph=pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf("iris.pdf")


# with open("iris.dot","w") as f:
#     f=tree.export_graphviz(clf,out_file=f)

# dot_data=tree.export_graphviz(clf,out_file=None,
#                               feature_names=iris.feature_names,
#                               class_names=iris.target_names,
#                               filled=True,rounded=True,
#                               special_characters=True)
# graph=pydotplus.graph_from_dot_data(dot_data)
# Image(graph.create_png())
# display(img)
