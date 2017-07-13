d = DataWrapper(); 
t = Tester(); 
c = ClassificationWrapper(); 
mdl = getModel(c, 'svm')
run(t, 'D:\enron\small\testing small\sample\', mdl,getWeightingVector(d));
