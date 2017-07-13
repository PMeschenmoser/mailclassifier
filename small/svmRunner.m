d = DataWrapper(); 
t = Tester(); 
c = ClassificationWrapper(); 
model = getModel(c, 'svm')
run(t, 'D:\enron\small\testing small\', model,getWeightingVector(d));
