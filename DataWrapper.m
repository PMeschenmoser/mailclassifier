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
        end
        
        function r = importFromFolder(obj, path)
            load('index.mat')
            obj.alltokens = savedtokenlist; 
            obj.allfiles = savedfilelist;
            obj.tfmatrix = savedtf; 
            dirlist = dir(strcat(path,'*.txt'));
            tmpfiles = {}; 
            for i = 1:length(dirlist)
                curr  = strcat(path,dirlist(i).name); 
                tmpfiles{1,i} =curr;
            end
            display(obj.allfiles)
            newfiles = sort(setdiff(tmpfiles, obj.allfiles)); 
            obj.allfiles = horzcat(obj.allfiles, newfiles); 
            
            display('building new rows');
            newrow = zeros(1,size(obj.tfmatrix,2)); 
            for i = 1:length(newfiles)
                obj.tfmatrix = [obj.tfmatrix; newrow]; 
            end    
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
            
            display('building new cols')
            %sort, unique and save cell array
            newcol = zeros(size(obj.tfmatrix,1),length(newtokens)); 
            obj.tfmatrix = horzcat(obj.tfmatrix, newcol);
           
            i = 1;
            display('insert mails')
            for mail = mails
                display(i);
                localdict = struct(mail{1}); 
                tokens = fieldnames(localdict); 
                rowindex = ismember(obj.allfiles,newfiles{1,i});
                for j = 1: length(tokens)
                    colindex = ismember(obj.alltokens,tokens{j,1});
                    obj.tfmatrix(rowindex, colindex) =   1 ; 
                end
                i = i+1; 
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

