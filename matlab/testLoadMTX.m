% prova di caricamento di file MTX

load('matrices/problem1.mtx')

% mtx = readmtx(fname,nrows,ncols,precision,...,nheadbytes)
mtx = readmtx('matrices/problem1.mtx', nrows, ncols, precision, ...,nheadbytes)