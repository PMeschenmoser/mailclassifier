t = Tester(); 
c = ClassificationWrapper(); 
mdl = getModel(c, 'knn-jaccard-20')
run(t, 'D:\enron\small\validation small\bla\', mdl,getWeightingVector(wrapper));
