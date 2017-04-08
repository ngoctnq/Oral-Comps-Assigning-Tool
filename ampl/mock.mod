set DAY;
set SESSION;
set STUDENT;
set TEACHER;
set DEPT0;
set DEPT1;
set DEPT2;
set DEPT3;

param SNR {TEACHER, 1..2};

var Y {DAY, SESSION, STUDENT} binary;
var X {DAY, SESSION, STUDENT, TEACHER} binary;

minimize CONST:
	1;

