set STUDENT;
set TEACHER;
set DEPT0;
set DEPT1;
set DEPT2;
set DEPT3;

var X {STUDENT, TEACHER} binary;

minimize CONST:
    1;

subject to CONSTR1 {i in STUDENT}:
    sum {j in TEACHER} X[i,j] = 1;
