set STUDENT;
set TEACHER;

var X {STUDENT, TEACHER} binary;

minimize CONST:
    1;

subject to CONSTR1 {i in STUDENT}:
    sum {j in TEACHER} X[i,j] = 1;