function matrixConversion(typeConv,varargin)
    switch typeConv
        case 'structmat_mat'
            for ind=1 : size(varargin,2)
                load(varargin{ind})
                A = Problem.A;
                newStr = 'tempMatFromStruct';
                iterationchar = int2str(ind);
                almostReady = strcat(iterationchar, '.mat');
                finalString = strcat(newStr,almostReady);
                save(finalString,'A');
            end
            
        case 'mtx_mat'
            for ind=1 : size(varargin,2)                
                A = mmread(varargin{ind});
                [i,j,val] = find(A);
                data_dump = [i,j,val];
                
                newStr = 'tempMatFromMTX';
                iterationchar = int2str(ind);
                almostReady = strcat(iterationchar, '.mat');
                finalString = strcat(newStr,almostReady);
                
                save(finalString,'A');
            end              
    end
end