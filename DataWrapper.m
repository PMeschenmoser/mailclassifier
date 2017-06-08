% Run via wrapper = new DataWrapper()
% wrapper.importFromFolder('C:\Users\user\Documents\GitHub\mailclassifier\pre2006\enron1\ham\')
% Wait a few seconds

classdef DataWrapper
    properties
    end
    
    methods
        function obj = DataWrapper()
            % Constructor
            % Add the current folder to the python search path
            if count(py.sys.path,'') == 0
                insert(py.sys.path,int32(0),'');
            end
        end
    end
    
    methods (Static)
        function r = importFromFolder(path)
            dirlist = dir(strcat(path,'*.txt'));
            a = 0; 
            c = {}; 
            for i = 1:length(dirlist)
                c{1,i} = strcat(path,dirlist(i).name);
            end
            % we need a cell area over here
            l = py.list(c); 
            r = py.preprocessor.run(l); 
        end   
    end
end

