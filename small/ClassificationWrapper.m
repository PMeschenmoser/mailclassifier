classdef ClassificationWrapper
    properties
    end
    
    methods
        function r = computeKNN(obj, data, numneighbors, metric)
            model = fitcknn(getTF(data),getLabelVector(data),'NumNeighbors',numneighbors, 'Distance', metric );
            save(strcat('models/knn-',metric,'-',num2str(numneighbors),'.mat'), 'model'); 
        end
        function r = computeNaiveBayes(obj, data)
            model = fitcnb(getTF(data),getLabelVector(data),'DistributionNames','kernel','Kernel','box');
            save('models/bayes.mat', 'model','-v7.3'); 
        end
        function r = computeSVM(obj, data)
            model = fitcsvm(getTF(data),getLabelVector(data));
            save('models/svm.mat', 'model', '-v7.3'); 
        end
        function r = computeDTree(obj, data)
            model = fitctree(getTF(data),getLabelVector(data));
            save('models/dtree.mat', 'model', '-v7.3'); 
        end
        function r = getModel(obj, modelname)
            load(strcat('models/',modelname,'.mat'), 'model'); 
            r = model; 
        end
    end
    
end

