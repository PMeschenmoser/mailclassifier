% 
% mdl = fitcknn(getTF(wrapper),getLabelVector(wrapper),'NumNeighbors',20, 'Distance', 'jaccard')
% importFromFolder(wrapper, 'D:\enron\enron1\ham\') 
% importFromFolder(wrapper, 'D:\enron\enron2\spam\') 
% run(t, 'D:\enron\sample\', mdl,getWeightingVector(wrapper));
classdef Tester
    properties 
        alltokens
        tfmatrix
        testmatrix
        testfiles
    end
    
    methods
        function obj = Tester()
            % Constructor
            % Add the current folder to the python search path
            if count(py.sys.path,'') == 0
                insert(py.sys.path,int32(0),'');
            end
        end
        
        function r = run(obj, path, model, weightingVector)
            load('indexsmall.mat');
            obj.alltokens = savedtokenlist; 
            obj.tfmatrix = savedtf; 
            obj.testmatrix = [];
            
            truecount = 0; 
            
            dirlist = dir(strcat(path,'*.txt'));
            obj.testfiles = {};
            for i = 1:length(dirlist)
                curr  = strcat(path,dirlist(i).name); 
                obj.testfiles{1,i} =curr;
            end
            
            newrows = zeros(length(dirlist),size(obj.tfmatrix,2)); 
            obj.testmatrix = vertcat(obj.testmatrix, newrows); 
            
            display('run pre-processor');
   
            % preprocessed data
            % [{token:count,...}{token:count,...}]
            mails = py.preprocessor.run(py.list(obj.testfiles));     
               display('end pre-processor');
            i = 1;
            for mail = mails
                localdict = struct(mail{1}); 
                tokens = fieldnames(localdict); 
                for j = 1: length(tokens)
                    colindex = ismember(obj.alltokens,tokens{j,1});
                    obj.testmatrix(i, colindex) = localdict.(tokens{j}) ; % insert actual counts 
                end
                i = i+1; 
                display(i); 
            end
            %obj.testmatrix =  bsxfun(@times, obj.testmatrix, weightingVector);
            obj.testmatrix(isnan(obj.testmatrix)) = 0
            for j= 1: i-1
               prediction = predict(model, obj.testmatrix(j,:));
               isham = strfind(obj.testfiles(1,j), 'ham'); 
               isspam = strfind(obj.testfiles(1,j), 'spam'); 
     
               if ((prediction == 0) && ~isempty(isham{1}))
                   truecount = truecount +1; 
                   display('Correct ham classification:' ); 
               elseif ((prediction == 1) && ~isempty(isspam{1}))
                    truecount = truecount +1; 
                    display('Correct spam classification:'); 
               else 
                   display('Misclassification');  
               end
               %display(predict(model, obj.testmatrix(j,:))); 
            end
            r = truecount/(i-1) 
        end   
    end
end

