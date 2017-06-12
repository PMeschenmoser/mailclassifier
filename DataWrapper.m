% Run via wrapper = new DataWrapper()
% wrapper.importFromFolder('C:\Users\user\Documents\GitHub\mailclassifier\pre2006\enron1\ham\')
% Wait a few seconds

classdef DataWrapper
    properties 
        alltokens
        allfiles
        tfmatrix
    end
    
    methods
        function obj = DataWrapper()
            % Constructor
            % Add the current folder to the python search path
            if count(py.sys.path,'') == 0
                insert(py.sys.path,int32(0),'');
            end
            load('index.mat')
            obj.alltokens = savedtokenlist; 
            obj.allfiles = savedfilelist;
            obj.tfmatrix = savedtf; 
        end

        
        function r = importFromFolder(obj, path)
            dirlist = dir(strcat(path,'*.txt'));
            tmpfiles = {}; 
            for i = 1:length(dirlist)
                curr  = strcat(path,dirlist(i).name); 
                tmpfiles{1,i} =curr;
            end
            newfiles = sort(setdiff(tmpfiles, obj.allfiles)); 
            obj.allfiles = sort(horzcat(obj.allfiles, newfiles)); 
            
            for i = 1:length(newfiles)
                index = find(ismember(obj.allfiles,newfiles{1,i}));
                newrow = zeros(1,size(obj.tfmatrix,2)); 
                obj.tfmatrix = [obj.tfmatrix(1:index,:); newrow; obj.tfmatrix(index+1:end,:)]; 
            end    
            display(obj.tfmatrix); 
            % preprocessed data
            % [{token:count,...}{token:count,...}]
            mails = py.preprocessor.run(py.list(newfiles));
            
            tmptokens = {};  %build a list of tokens in the new files 
            for mail = mails
                tokens = fieldnames(struct(mail{1})); % ordered tokens 
                tmptokens = vertcat(tmptokens, tokens);  
            end
            newtokens = setdiff(tmptokens, obj.alltokens); 
                     
            obj.alltokens = vertcat(obj.alltokens, newtokens); 
            
            %sort, unique and save cell array
            obj.alltokens = sort(obj.alltokens);
            for i = 1: length(newtokens)
                index = find(ismember(obj.alltokens,newtokens{i,1}));
                newcol = zeros(size(obj.tfmatrix,1),1); 
                obj.tfmatrix = [obj.tfmatrix(:,1:index) newcol obj.tfmatrix(:,index+1:end)];
                %TODO: FILL TF!
            end
            
            savedtf = obj.tfmatrix; 
            savedtokenlist = obj.alltokens;
            savedfilelist = obj.allfiles;
            save('index.mat', 'savedtokenlist');
            save('index.mat', 'savedfilelist', '-append');
            save('index.mat', 'savedtf', '-append'); 
        end   
    end
end

