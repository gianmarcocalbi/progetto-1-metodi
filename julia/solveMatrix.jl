using MatrixMarket
using SuiteSparse
using BenchmarkTools
using MAT
function solveMatrix(x...)

    #Creo cellArray
    matrices = Array{Any}(8)

    #Array per i risultati
    allTimes = []
    allErrors = []
    allSizes = []
    allMems = []

    #Carico le matrici FEMLAB nel cellArray
    print("Loading data...")
    openedMat = matread("../matrices/mat/one20414.mat")
    matrices[1] = openedMat["A"]
    openedMat = matread("../matrices/mat/two367.mat")
    matrices[2] = openedMat["A"]
    openedMat = matread("../matrices/mat/three13514.mat")
    matrices[3] = openedMat["A"]
    openedMat = matread("../matrices/mat/four85623.mat")
    matrices[4] = openedMat["A"]
    openedMat = matread("../matrices/mat/five415.mat")
    matrices[5] = openedMat["A"]
    openedMat = matread("../matrices/mat/six12504.mat")
    matrices[6] = openedMat["A"]
    openedMat = matread("../matrices/mat/seven29067.mat")
    matrices[7] = openedMat["A"]
    openedMat = matread("../matrices/mat/eigth42930.mat")
    matrices[8] = openedMat["A"]

    #Calcola quanti parametri in input ci sono
    howManyOptional = length(x)

    #Matrici in input - se ce ne sono
    if howManyOptional>0
        inputMatrices = Array{Any}(howManyOptional)
        for ll=1 : howManyOptional
            openedMat = matread(x[ll])
            inputMatrices[ll] = openedMat["A"]
        end
    end

    #Codice da eseguire se ci sono matrici in input
    if (howManyOptional>0)
        print("\nProcessing input matrices...")
        (allMems, allTimes, allErrors, allSizes) = interCalc(inputMatrices, allMems, allTimes, allErrors, allSizes)
    else
        print("\nProcessing FEMLAB matrices...")
        (allMems, allTimes, allErrors, allSizes) = interCalc(matrices, allMems, allTimes, allErrors, allSizes)
    end

    #Lunghezza
    if howManyOptional>0
        numDiMatrici = howManyOptional;
    else
        numDiMatrici = 8;
    end

    #Creo matrici contenti i valori dei grafici
    #Ordino anche in modo crescento rispetto alla size
    print("Collecting results...\n")
    firstTime = [allSizes ; allTimes];
    firstTime = reshape(firstTime,numDiMatrici,2);
    firstTimeSor = sortrows(firstTime,by=y->(y[1]))
    firstTimeSor = reshape(firstTimeSor,numDiMatrici,2);

    secondErrors = [allSizes ; allErrors];
    secondErrors = reshape(secondErrors,numDiMatrici,2);
    secondErrorsSor = sortrows(secondErrors,by=y->(y[1]))
    secondErrorsSor = reshape(secondErrorsSor,numDiMatrici,2);

    thirdRAM = [allSizes ; allMems];
    thirdRAM = reshape(thirdRAM,numDiMatrici,2);
    thirdRAMSor = sortrows(thirdRAM,by=y->(y[1]));
    thirdRAMSor = reshape(thirdRAMSor,numDiMatrici,2);
	
	print(minimum(firstTimeSor[:,2]));
	print("\n");
	print(maximum(firstTimeSor[:,2]));
	print("\n");
	print(sum(firstTimeSor[:,2]));
	print("\n_________________________________");
	print("\n\n\n");
	
	print(minimum(secondErrorsSor[:,2]));
	print("\n");
	print(maximum(secondErrorsSor[:,2]));
	print("\n");
	print(sum(secondErrorsSor[:,2]));
	print("\n_________________________________");
	print("\n\n\n");
	print(minimum(thirdRAMSor[:,2]));
	print("\n");
	print(maximum(thirdRAMSor[:,2]));
	print("\n");
	print(sum(thirdRAMSor[:,2]));
print("\n_________________________________");
    return firstTimeSor, secondErrorsSor, thirdRAMSor;

end

function interCalc(matrices, allMems, allTimes, allErrors, allSizes)
     for o=1 : size(matrices,1)
        #gc(); workspace();
        tic();

        #Salvo la soluzione esatta xe del sistema
        xe = ones(size(matrices[o],1));

        #Calcolo del right hand side
        b = matrices[o]*xe;
		matrices[o] = lufact(matrices[o]);

        #Risoluzione
        profiling = @timed(matrices[o]\b);
        profiling = profiling[3];
        x = matrices[o]\b;
        print("Processing matrix ",size(matrices[o],1));

        #Errore relativo
        errRel = norm(x-xe)/norm(xe);

        #Salvo dati utili
        elapsed = toc();
        allTimes = [allTimes ; elapsed];
        allSizes = [allSizes ; size(matrices[o],1)];
        allErrors = [allErrors ; errRel];
        #allMems = [allMems];
        allMems = [allMems ; profiling];


    end

    return allMems, allTimes, allErrors, allSizes;

end
