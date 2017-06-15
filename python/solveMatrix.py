'''
Created on 18 April 2017
Project: solveMatrix
Class: Metodi del calcolo scientifico
@author: Nico
'''
    
def solve(*args):
    import scipy.io   
    import pylab
    import os
    
    #Array dei risultati
    firstTime = []
    secondErrors = []
    thirdRAM = []
    
    #Carico path corrente
    os.chdir(os.getcwd())
            
    #Importa tutti i file MAT
    print("Reading input...")
    mat1 = scipy.io.loadmat('../matrices/mat/one20414.mat')
    mat2 = scipy.io.loadmat('../matrices/mat/two367.mat')
    mat3 = scipy.io.loadmat('../matrices/mat/three13514.mat')
    mat4 = scipy.io.loadmat('../matrices/mat/four85623.mat')
    mat5 = scipy.io.loadmat('../matrices/mat/five415.mat')
    mat6 = scipy.io.loadmat('../matrices/mat/six12504.mat')
    mat7 = scipy.io.loadmat('../matrices/mat/seven29067.mat')
    mat8 = scipy.io.loadmat('../matrices/mat/eigth42930.mat')
    
    #Salva tutte le matrici dai file MAT
    matrix1 = mat1['A']
    matrix2 = mat2['A'] 
    matrix3 = mat3['A']
    matrix4 = mat4['A'] 
    matrix5 = mat5['A']
    matrix6 = mat6['A'] 
    matrix7 = mat7['A']
    matrix8 = mat8['A']
    
    #Lista di matrici
    matrices = [matrix1, matrix2, matrix3, matrix4, matrix5, matrix6, matrix7, matrix8]
    
    #Argomenti opzionali
    optionMatrices = [];
    for count, thing in enumerate(args):  #count è il contatore, thing è l'oggetto corrente  
        temp = scipy.io.loadmat(thing)
        optionMatrices.append(temp['A'])
    
    #Computazione
    numb=len(args)    
    
    if(numb>0):
        print("\nUsing optional matrices...\n")
        firstTime, secondErrors, thirdRAM = mainComput(optionMatrices,firstTime,secondErrors,thirdRAM)
    else:
        print("\nUsing the 8 FEMLAB matrices...\n")
        firstTime, secondErrors, thirdRAM = mainComput(matrices,firstTime,secondErrors,thirdRAM)
    
    #Ordino valori in base alla colonna della dimensione
    firstTime = sorted(firstTime,key=lambda x: (x[0],x[1]))
    secondErrors = sorted(secondErrors,key=lambda x: (x[0],x[1]))
    thirdRAM = sorted(thirdRAM,key=lambda x: (x[0],x[1]))
        
    #Calcolo primo grafico
    print("\nPlotting results...")
    pylab.figure(1)
    pylab.title('Size and elapsed time')
    pylab.xlabel('Matrix size (rows)')
    pylab.ylabel('Time (seconds)')
    pylab.plot([i[0] for i in firstTime], [j[1] for j in firstTime], marker='.', alpha=1, color='b')
    
    #calcolo secondo grafico
    pylab.figure(2)
    pylab.title('Size and errors - logarithmic scale')
    pylab.xlabel('Matrix size (rows)')
    pylab.ylabel('Relative error')	
    pylab.plot([i[0] for i in secondErrors], [j[1] for j in secondErrors], marker='.', alpha=1, color='b')
    pylab.yscale('log')

    #Calcolo terzo grafico
    pylab.figure(3)
    pylab.title('Size and RAM')
    pylab.xlabel('Matrix size (rows)')
    pylab.ylabel('RAM usage (Bytes)')
    pylab.plot([i[0] for i in thirdRAM], [j[1] for j in thirdRAM], marker='.', alpha=1, color='b')
    
    #Stampo tutti i grafici
    pylab.show()
    
    
    
    
def mainComput(matrix,firstTime,secondErrors,thirdRAM):    
    import psutil
    import numpy
    from scikits.umfpack import spsolve, splu
    import time
    import os
   
    for i in range(0,len(matrix)):  
                
        #Ottengo matrice i-esima       
        A = matrix[i]
        sizeM = numpy.shape(A)
        print('Processing matrix n',i+1,', size',sizeM)
        sizeM = sizeM[0]
        
        #Memoria RAM usata da python e tempo attuale       
        process = psutil.Process(os.getpid())    
        firstRAM = process.memory_info().rss
        
        #Soluzione esatta del sistema
        xe = numpy.ones(sizeM);
        
        #Calcolo right-hand side
        b = A * xe
        
        #Calcolo matrice e tempo di calcolo  
        ts = time.time() 
        lu = splu(A)     
        x = spsolve(A, b)
        te = time.time()
        tElapsed = te-ts
        
        #Calcolo dell'errore
        relErr = numpy.linalg.norm(x-xe)/numpy.linalg.norm(xe)
        
        #Calcolo della RAM utilizzata
        process2 = psutil.Process(os.getpid())
        secondRAM = process2.memory_info().rss
        usedMem = firstRAM - secondRAM
        usedMem = numpy.abs(usedMem)
        
        #Appendo valori
        firstTime.append([sizeM,tElapsed])
        secondErrors.append([sizeM,relErr])
        thirdRAM.append([sizeM,usedMem])
    
    
    return firstTime, secondErrors, thirdRAM    