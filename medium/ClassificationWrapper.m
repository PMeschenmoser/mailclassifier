classdef ClassificationWrapper
    properties
    end
    
    methods
        function r = computeKNN(obj, data, numneighbors, metric)
            model = fitcknn(getTF(data),getLabelVector(data),'NumNeighbors',numneighbors, 'Distance', metric );
            save(strcat('models/knn-',metric,'-',num2str(numneighbors),'.mat'), 'model'); 
        end
        function r = getModel(obj, modelname)
            load(strcat('models/',modelname,'.mat'), 'model'); 
            r = model; 
        end
    end
    
end

