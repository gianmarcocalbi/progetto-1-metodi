def solve(*args):
    import scipy.io   
    import pylab
    
    #Array dei risultati
    firstTime = []
    secondErrors = []
    thirdRAM = []
            
    #Importa tutti i file MTX e le relative info
    mat1 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat1info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat2 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/poisson2D.mtx')
    mat2info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat3 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/poisson3Da.mtx')
    mat3info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat4 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/poisson3Db.mtx')
    mat4info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat5 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/problem1.mtx')
    mat5info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat6 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/sme3Da.mtx')
    mat6info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat7 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/sme3Db.mtx')
    mat7info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
    mat8 = scipy.io.mmread('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/sme3Dc.mtx')
    mat8info = scipy.io.mminfo('C:/Users/Nico/Dropbox/ProgettoMETODI/SparseMatrices-MM/ns3Da.mtx')
       
    #Lista di matrici
    matrices = [mat1,mat2,mat3,mat4,mat5,mat6,mat7,mat8]
    matricesInfos = [mat1info,mat2info,mat3info,mat4info,mat5info,mat6info,mat7info,mat8info]
    
    #Computazione
    numb=len(args)    
    
    if(numb>0):
        #Argomenti opzionali
        optionMatrices = []
        optionMatricesInfos = []
        for count, thing in enumerate(args):  #count è il contatore, thing è l'oggetto corrente  
            temp = scipy.io.mmread(thing)
            tempInfo = scipy.io.mminfo(thing)
            optionMatrices.append(temp)
            optionMatricesInfos.append(tempInfo)
        firstTime, secondErrors, thirdRAM = mainComput(optionMatrices,optionMatricesInfos,firstTime,secondErrors,thirdRAM)
    else:
        firstTime, secondErrors, thirdRAM = mainComput(matrices,matricesInfos,firstTime,secondErrors,thirdRAM)
    
    #Ordino valori in base alla colonna della dimensione
    firstTime = sorted(firstTime,key=lambda x: (x[0],x[1]))
    secondErrors = sorted(secondErrors,key=lambda x: (x[0],x[1]))
    thirdRAM = sorted(thirdRAM,key=lambda x: (x[0],x[1]))
        
    #Calcolo primo grafico
    pylab.figure(1)
    pylab.title('Size and elapsed time')
    pylab.xlabel('Matrix dimension')
    pylab.ylabel('Time (sec)')
    pylab.plot([i[0] for i in firstTime], [j[1] for j in firstTime], marker='.', alpha=1, color='b')
    
    #calcolo secondo grafico
    pylab.figure(2)
    pylab.title('Size and errors - logarithmic scale')
    pylab.xlabel('Matrix dimension')
    pylab.ylabel('Error')	
    pylab.plot([i[0] for i in secondErrors], [j[1] for j in secondErrors], marker='.', alpha=1, color='b')
    pylab.yscale('log')

    #Calcolo terzo grafico
    pylab.figure(3)
    pylab.title('Size and RAM - standard plot')
    pylab.xlabel('Matrix dimension')
    pylab.ylabel('RAM used (K)')
    pylab.plot([i[0] for i in thirdRAM], [j[1] for j in thirdRAM], marker='.', alpha=1, color='b')
    
    #Stampo tutti i grafici
    pylab.show()
    
    
    
    
def mainComput(matrices,matricesInfos,firstTime,secondErrors,thirdRAM):    
    import psutil
    import numpy
    from scikits.umfpack import spsolve#, splu
    import time
    import os
   
    for i in range(0,len(matrices)):  
        print('Working on matrix numb ',i+1)
        
        #Ottengo matrice i-esima
        print(matrices[i])
        print(matrices[i][0])
        print(matrices[i][1])
        print(matrices[i][2])
        sizeM = matricesInfos[i][0]
        print(sizeM)
        A = numpy.zeros((sizeM,sizeM))
        #for indrow in range(0,sizeM-1):
        #   for indcol in range(0,sizeM-1):
        #      print(8)
                
        #Memoria RAM usata da python
        process = psutil.Process(os.getpid())    
        firstRAM = process.memory_info().rss
        
        #Soluzione esatta del sistema
        xe = numpy.ones(sizeM);
        
        #Calcolo right-hand side
        b = A * xe
        
        #Calcolo matrice e tempo di calcolo
        t = time.time()
        #lu = splu(A)
        x = spsolve(A, b)
        elapsed = time.time()-t
        
        #Calcolo dell'errore
        relErr = numpy.linalg.norm(x-xe)/numpy.linalg.norm(xe)
        
        #Calcolo della RAM utilizzata
        process2 = psutil.Process(os.getpid())
        secondRAM = process2.memory_info().rss
        usedMem = firstRAM - secondRAM
        usedMem = numpy.abs(usedMem)
        
        #Appendo valori
        firstTime.append([sizeM,elapsed])
        secondErrors.append([sizeM,relErr])
        thirdRAM.append([sizeM,usedMem])
    
    
    return firstTime, secondErrors, thirdRAM    