import read


def group_var(dataset,feature_index):
    group_count = {}
    for data in dataset:
        if data[feature_index] not in group_count.keys():
            group_count[data[feature_index]] = 1
        else:
            group_count[data[feature_index]] += 1
    return group_count
    # sorted_label_count = sorted(label_count.items(), key=operator.itemgetter(1), reverse=True)
    # return sorted_label_count[0][0]

train_feature,train_dataset=read.read("learn1.xls","sheet")
count=group_var(train_dataset,3)
print(count)
# print(list(count.keys()))

# for i in count.keys():
#     count[i]={}
#     for data in train_dataset:
#         if data[3]==list(count.keys())[i]:
#             if data[5] not in count[i].keys():
#                 count[i][data[5]]=1
#             else:
#                 count[i][data[5]]+=1




