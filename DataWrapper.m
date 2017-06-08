classdef DataWrapper
    properties
    end
    
    methods
        function obj = DataWrapper(path, max)
            if nargin > 0
                py.preprocessor.run(path, max)
            end
        end
    end
    
    methods (Static)
        function r = importFromFolder(path,max)
            r = py.preprocessor.run(path, max); 
        end   
    end
    
end

