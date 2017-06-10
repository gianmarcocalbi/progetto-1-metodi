function [allMems,allTimes,allErrors,allSizes] = internalComputation(matrix,allMems,allTimes,allErrors,allSizes)
    
    %Per ogni matrice presente nel cellArray svolgo i calcoli richiesti
    for i=1 : size(matrix,2)
        
        %Memoria usata da MATLAB all'inizio del programma
        user = memory;
        user = user.MemUsedMATLAB;

        %Estraggo matrice corrente
        A = matrix(1,i);
        A = A{1};
        
        %Salvo la soluzione esatta xe del sistema
        xe = ones(size(A,1),1);

        %Calcolo b utilizzando xe e A
        b = A*xe;

        %Tempo necessario per calcolare la soluzione x tramite UMFPACK (backslash in MATLAB)
        tic; x = A\b; toc;
        time = toc;
        disp(time);
        
        %Memoria usata da MATLAB alla fine del programma
        user2 = memory;
        user2 = user2.MemUsedMATLAB;

        %Errore relativo
        relErr = norm(x-xe)/norm(xe);   
        
        %Memoria consumata da MATLAB per il calcolo della soluzione
        usedMem = user2-user;
        usedMem = abs(usedMem);
        
        %Valori per i grafici concatenati negli array dei risultati
        allMems=[allMems; usedMem];
        allTimes=[allTimes; time];
        allErrors=[allErrors; relErr];
        allSizes=[allSizes; size(A,1)];
    end
end