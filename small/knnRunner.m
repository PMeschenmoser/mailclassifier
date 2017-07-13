d = DataWrapper(); 
t = Tester(); 
c = ClassificationWrapper(); 
mdl = getModel(c, 'knn-jaccard-20')
run(t, 'D:\enron\small\testing small\', mdl,getWeightingVector(d));
