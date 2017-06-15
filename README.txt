%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PROGETTO1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Obiettivo: risoluzione sistemi lineari usando metodi diretti
Linguaggi utilizzati: MATLAB, Python, Julia
Matrici utilizzate: 8 matrici FEMLAB reperibili al sito 
					https://www.cise.ufl.edu/research/sparse/matrices/FEMLAB/
Formato delle matrici: double sparse matrix (.MAT files)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E' opportuno notare che i file scaricabili da FEMLAB sono 2:
- MAT : formato STRUCT di MATLAB che contiene vari campi. Uno di questi include
		la matrice sparsa in formato Double Sparse Matrix.
- MTX : formato Matrix Market, contiene triple <indiceRiga indiceColonna, valore>.
		E' un formato comune per le matrici sparse.
		
Tutti e 3 i linguaggi utilizzano SOLAMENTE il formato Double Sparse Matrix
(formato dell'oggetto MATLAB per le matrici sparse).
Esso NON E' il file MAT scaricabile dal sito, poichè quello è una struct.
E' stato quindi messo a disposizione uno script MATLAB ("matrixConversion.mat")
grazie al quale è possibile eseguire delle conversioni.
A tutte le funzioni di matrixConversion.mat (elencate qui sotto) occorre passare 
in input uno o più path indicanti i file da convertire.

1. Struct Mat to Double Sparse Matrix --> chiamare la funzione 'structmat_mat()'
2. Struct Mat to MTX --> chiamare la funzione 'structmat_mtx()"
3. Double Sparse Matrix to MTX --> chiamare la funzione 'mat_mtx()'
4. MTX to Double Sparse Matrix --> chiamare la funzione 'mtx_mat()'

Lo script salva nella cartella del progetto il nuovo file convertito.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Chiamare la funzione "solveMatrix()" con questi input:
- nessuno : vengono elaborate e risolte le 8 matrici FEMLAB e stampati i grafici
- uno o più path indicanti file .mat: vengono elaborate e risolte le matrici in
input. Assicurarsi che esse siano nel formate Double Sparse Matrix.

La funzione "solveMatrix()" chiamerà la funzione "internalComputation()" che si 
occupa di gestire e risolvere una matrice alla volta.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PYTHON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Chiamare la funzione "solveMatrix()" con questi input:
- nessuno : vengono elaborate e risolte le 8 matrici FEMLAB e stampati i grafici
- uno o più path indicanti file .mat: vengono elaborate e risolte le matrici in
input. Assicurarsi che esse siano nel formate Double Sparse Matrix.

La funzione "solveMatrix()" chiamerà la funzione "mainComput()" che si 
occupa di gestire e risolvere una matrice alla volta.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% JULIA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Chiamare la funzione "(p,t,s) = solveMatrix()" con questi input:
- nessuno : vengono elaborate e risolte le 8 matrici FEMLAB.
- uno o più path indicanti file .mat: vengono elaborate e risolte le matrici in
input. Assicurarsi che esse siano nel formate Double Sparse Matrix.
Lo script NON STAMPA NESSUN GRAFICO, ma ritorna una tripla contenente 3 matrici
di risultati (p=times, t=errors, s=allocatedRAM).

Per visualizzare i grafici  risultanti eseguire i seguenti step:
1. Installare il package "Gadfly" da linea di comando ed includerlo (using Gadfly)
2. Visualizzare graficamente le tempistiche, lanciando l'istruzione:
	plot(x=p[:,1], y=p[:,2], Guide.xlabel("Size"), Guide.ylabel("Time seconds"), Geom.point, Geom.line)
3. Visualizzare graficamente gli errori relativi, lanciando l'istruzione:
	plot(x=s[:,1], y=s[:,2], Guide.xlabel("Size"), Guide.ylabel("Errore relativo"), Geom.point, Geom.line, Scale.y_log10)
4. Visualizzare graficamente i byte allocati, lanciando l'istruzione:
	plot(x=t[:,1], y=t[:,2], Guide.xlabel("Size"), Guide.ylabel("Allocated Bytes"), Geom.point, Geom.line)

La funzione "solveMatrix()" chiamerà la funzione "interCalc()" che si 
occupa di gestire e risolvere una matrice alla volta.