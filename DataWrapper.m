% Run via wrapper = new DataWrapper()
% wrapper.importFromFolder('C:\Users\user\Documents\GitHub\mailclassifier\pre2006\enron1\ham\')
% Wait a few seconds

classdef DataWrapper
    properties 
        alltokens
        allfiles
        allspam % for each file in the training set, we know whether spam or no spam
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
            load('index.mat');
            obj.alltokens = savedtokenlist; 
            obj.allfiles = savedfilelist;
            obj.tfmatrix = savedtf; 
            obj.allspam = savedspam; 
            
            dirlist = dir(strcat(path,'*.txt'));
            tmpfiles = {}; 
            for i = 1:length(dirlist)
                curr  = strcat(path,dirlist(i).name); 
                tmpfiles{1,i} =curr;
            end
            newfiles = sort(setdiff(tmpfiles, obj.allfiles)); 
            obj.allfiles = horzcat(obj.allfiles, newfiles); 
            
            newrows = zeros(length(newfiles),size(obj.tfmatrix,2)); 
            obj.tfmatrix = vertcat(obj.tfmatrix, newrows); 
   
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
           
            newcols = zeros(size(obj.tfmatrix,1),length(newtokens)); 
            obj.tfmatrix = horzcat(obj.tfmatrix, newcols);
           
            i = 1;
            for mail = mails
                display('Inserting Mail ' + i)
                if (strfind(newfiles{1,i}, 'spam'))
                    obj.allspam{end+1} = newfiles{1,i}; 
                end 
                localdict = struct(mail{1}); 
                tokens = fieldnames(localdict); 
                rowindex = ismember(obj.allfiles,newfiles{1,i});
                for j = 1: length(tokens)
                    colindex = ismember(obj.alltokens,tokens{j,1});
                    obj.tfmatrix(rowindex, colindex) = localdict.(tokens{i}) ; % insert actual counts 
                end
                i = i+1; 
            end
            savedtf = obj.tfmatrix; 
            savedtokenlist = obj.alltokens;
            savedfilelist = obj.allfiles;
            savedspam = obj.allspam; 
            save('index.mat', 'savedtokenlist');
            save('index.mat', 'savedfilelist', '-append');
            save('index.mat', 'savedtf', '-append'); 
            save('index.mat', 'savedspam', '-append'); 
        end   
        function r = resetIndex(obj)
            savedtf = [0]; 
            savedtokenlist = {};
            savedfilelist = {};
            savedspam = {}; 
            save('index.mat', 'savedtokenlist');
            save('index.mat', 'savedfilelist', '-append');
            save('index.mat', 'savedtf', '-append'); 
            save('index.mat', 'savedspam', '-append'); 
        end
        
        function r= getTFIDF(obj)
            % tf-idf
            % tfidf = tf(i,j) * idf(i) = tf(i,j) * log(N/n(i)
            % With:
            % tf(i,j) -> frequency of term i in mail j
            % idf(i) -> weight of term i 
            % N -> number of all mails
            % n(i) -> number of documents, where term i appears
            % This improves the descriptor emails, where tokens appear often,
            % while they appear rarely in other mails, 
            
            %
            load('index.mat');
            idf = savedtf; 
            idf(idf>0) = 1;  % binary matrix, sum this up to get n(i)
            idf = bsxfun(@rdivide, size(savedtf,1), sum(idf)) % divide N/n(i), element-wise
            r =  bsxfun(@times, savedtf, log(idf)) % tf * idf 
        end    
    end
end

