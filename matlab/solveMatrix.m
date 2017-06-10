%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Si applicherà il metodo di risoluzione di Gauss per trovare la soluzione 
% di un sistema lineare Ax=b, in cui A è una matrice sparsa.
% La funzione solveMatrix può prendere in input un numero generico di
% parametri:

% VARARGIN = stringhe separate da una virgola indicanti il PATH del file
%            .mat che si vuole computare.
%
% PATH = 'C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\name.mat'.

% I file .MAT accettabili dall'algoritmo sono quelli scaricati dal sito del
% gruppo FEMLAB. Questi tipi di file sono degli STRUCT contenenti le
% matrici più altri valori. 
% Passare come input le singole matrici porta ad un errore di computazione.

% OUTPUT = i risultati ottenuti (sia per quanto riguarda la RAM, il tempo 
% 			e l'errore relativo) vengono ordinati in maniera crescente rispetto
%			alla dimensione della matrice e succssivamente vengono plottati
%			3 grafici
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [firstTime,secondErrors,thirdRAM] = solveMatrix(varargin) 
     
    %Creo cellArray
    matrices = cell(1,8);
    
    %Array per i risultati
    allTimes=[];
    allErrors=[];
    allSizes=[];
    allMems=[];

    %Carico le 8 matrici FEMLAB nel cellArray
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\ns3Da.mat')
    matrices{1,1} = Problem.A;    
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\poisson2D.mat')
    matrices{1,2} = Problem.A;    
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\poisson3Da.mat')
    matrices{1,3} = Problem.A;     
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\poisson3Db.mat')
    matrices{1,4} = Problem.A;     
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\problem1.mat')
    matrices{1,5} = Problem.A;     
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\sme3Da.mat')
    matrices{1,6} = Problem.A;     
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\sme3Db.mat')
    matrices{1,7} = Problem.A;    
    load('C:\Users\Nico\Dropbox\ProgettoMETODI\SparseMatrices_fullMAT\sme3Dc.mat')
    matrices{1,8} = Problem.A; 
    
    %Matrici in input (se ce ne sono)
    if(nargin>0)
        inputMatrices = cell(1,nargin);
        for ll=1 : nargin            
            load(varargin{ll});
            inputMatrices{1,ll} = Problem.A;
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
    %crescente in base alla prima colonna (cioè la dimensione della matrice)
    firstTime = [allSizes,allTimes];
    firstTime = sortrows(firstTime,1);
    secondErrors = [allSizes,allErrors];
    secondErrors = sortrows(secondErrors,1);
    thirdRAM = [allSizes,allMems];
    thirdRAM = sortrows(thirdRAM,1);
    
    %Grafici da plottare con titoli e punti
    plot(firstTime(:,1),firstTime(:,2));
    title('Size and elapsed time');
    xlabel('Matrix dimension');
    ylabel('Time (sec)');
    hold on
    scatter(firstTime(:,1),firstTime(:,2),'.');
    
    figure, loglog(secondErrors(:,1),secondErrors(:,2));
    title('Size and errors - logarithmic scale');
    xlabel('Matrix dimension');
    ylabel('Error');
    hold on
    scatter(secondErrors(:,1),secondErrors(:,2),'.');
    
    figure, plot(thirdRAM(:,1),thirdRAM(:,2));
    title('Size and RAM');
    xlabel('Matrix dimension');
    ylabel('RAM used (K)');
    hold on
    scatter(thirdRAM(:,1),thirdRAM(:,2),'.');
end