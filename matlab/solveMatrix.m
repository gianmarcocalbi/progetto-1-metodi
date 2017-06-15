function [firstTime,secondErrors,thirdRAM] = solveMatrix(varargin) 
     
    %Creo cellArray
    matrices = [];
    
    %Array per i risultati
    allTimes=[];
    allErrors=[];
    allSizes=[];
    allMems=[];

    %Carico le 8 matrici FEMLAB nel cellArray
    cd(pwd)
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/one20414.mat')]; 
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/two367.mat')];
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/three13514.mat')];
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/four85623.mat')];
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/five415.mat')];
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/six12504.mat')];
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/seven29067.mat')];
    matrices = [matrices; load('progetto-1-metodi/matrices/mat/eigth42930.mat')];
    
    %Matrici in input (se ce ne sono)
    if(nargin>0)
        inputMatrices = [];
        for ll=1 : nargin            
            inputMatrices = [inputMatrices ; load(varargin{ll})];
        end
    end
       
    %Esegui se ci sono file in input
    if(nargin>0)
        [allMems,allTimes,allErrors,allSizes] = internalComputation(inputMatrices,allMems,allTimes,allErrors,allSizes);
    else
	%Computazione interna delle matrici
		[allMems,allTimes,allErrors,allSizes] = internalComputation(matrices,allMems,allTimes,allErrors,allSizes);
    end
    
    %Creo matrici contenenti i valori dei 3 grafici, ordinando in modo
    %crescente in base alla prima colonna (cio� la dimensione della matrice)
    firstTime = [allSizes,allTimes];
    firstTime = sortrows(firstTime,1);
    secondErrors = [allSizes,allErrors];
    secondErrors = sortrows(secondErrors,1);
    thirdRAM = [allSizes,allMems];
    thirdRAM = sortrows(thirdRAM,1);
    
    %Grafici da plottare con titoli e punti
    plot(firstTime(:,1),firstTime(:,2));
    title('Size and elapsed time');
    xlabel('Matrix size (rows)');
    ylabel('Time (seconds)');
    hold on
    scatter(firstTime(:,1),firstTime(:,2),'.');
    
    figure, loglog(secondErrors(:,1),secondErrors(:,2));
    title('Size and errors - logarithmic scale');
    xlabel('Matrix size (rows)');
    ylabel('Error');
    hold on
    scatter(secondErrors(:,1),secondErrors(:,2),'.');
    
    figure, plot(thirdRAM(:,1),thirdRAM(:,2));
    title('Size and RAM');
    xlabel('Matrix size (rows)');
    ylabel('RAM used (bytes)');
    hold on
    scatter(thirdRAM(:,1),thirdRAM(:,2),'.');
end