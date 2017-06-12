function matrixConversion(typeConv,varargin)
    switch typeConv
        case 'structmat_mat'
            for ind=1 : size(varargin,1)
                load(varargin{ind})
                v = Problem.A;
                [i,j,val] = find(v);
                data_dump = [i,j,val];
                data = spconvert(data_dump);

                newStr = 'tempMat';
                iterationchar = int2str(ind);
                almostReady = strcat(iterationchar, '.mat');
                finalString = strcat(newStr,almostReady);

                fid = fopen(finalString,'w');
                fprintf(fid,'%d %d %f\n', transpose(data_dump));
                fclose(fid);
            end
            
        case 'structmat_mtx'
            for ind=1 : size(varargin,1)
                load(varargin{ind})
                v = Problem.A;
                [i,j,val] = find(v);
                data_dump = [i,j,val];
                data = spconvert(data_dump);

                newStr = 'tempMat';
                iterationchar = int2str(ind);
                almostReady = strcat(iterationchar, '.mtx');
                finalString = strcat(newStr,almostReady);

                fid = fopen(finalString,'w');
                fprintf(fid,'%d %d %f\n', transpose(data_dump));
                fclose(fid);
            end
        
        case 'mat_mtx'
            for ind=1 : size(varargin,1)
                load(varargin{ind})
                [i,j,val] = find(A);
                data_dump = [i,j,val];
                data = spconvert(data_dump);
                sizeM = size(A,1);

                newStr = 'tempMat';
                iterationchar = int2str(ind);
                almostReady = strcat(iterationchar, '.mtx');
                finalString = strcat(newStr,almostReady);

                fid = fopen(finalString,'w');
                fprintf(fid,'%d %d\n', [sizeM,sizeM]);
                fprintf(fid,'%d %d %f\n', transpose(data_dump));
                fclose(fid);
            end            
    end
end