% Run via wrapper = new DataWrapper()
% wrapper.importFromFolder('C:\Users\user\Documents\GitHub\mailclassifier\pre2006\enron1\ham\')
% Wait a few seconds

classdef DataWrapper
    properties 
        alltokens
    end
    
    methods
        function obj = DataWrapper()
            % Constructor
            % Add the current folder to the python search path
            if count(py.sys.path,'') == 0
                insert(py.sys.path,int32(0),'');
            end
            obj.alltokens = load('index.mat', 'alltokens'); 
            display(obj.alltokens)
        end

        function r = importFromFolder(obj, path)
            dirlist = dir(strcat(path,'*.txt'));
            c = {}; 
            for i = 1:length(dirlist)
                c{1,i} = strcat(path,dirlist(i).name);
            end
            % we need a cell area over here
            r = py.preprocessor.run(py.list(c)); 
            for mail = r
                dict = struct(mail{1}); 
                tokens = fieldnames(orderfields(dict)); % ordered tokens 
                for i = 1: length(tokens)
                    if (ismember(obj.alltokens, tokens{i}))
                        % token already contained 
                    else 
                        % token not contained
                        obj.alltokens{length(obj.alltokens)+1} = tokens{i};
                    end
                end
            end
            sort(obj.alltokens);
            alltokens = obj.alltokens;
            save('index.mat', 'alltokens')
        end   
    end
end

