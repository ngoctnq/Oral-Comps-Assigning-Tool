param DAY;
param SESSION;
set STUDENT;
set TEACHER;
set DEPT0;
set DEPT1;
set DEPT2;
set DEPT3;

param SNR {TEACHER, 1..2} binary
	default 0;

param BUSY {1..DAY, 1..SESSION, TEACHER} binary
	default 0;
param TRIPLE {STUDENT} binary
	default 0;
var Y {1..DAY, 1..SESSION, STUDENT} binary;
var C {TEACHER, STUDENT} binary;
var P {TEACHER, STUDENT, 1..4} binary;
var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;

minimize CONST: 1;

subject to Student_Timeslot_Binary {l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} Y[i,j,l] = 1;
subject to Student_Timeslot_Count {i in 1..DAY, j in 1..SESSION, l in STUDENT}:
	sum {k in TEACHER} X[i,j,k,l] = (3 + TRIPLE[l]) * Y[i,j,l];
subject to Teacher_Clone_Jutsu {i in 1..DAY, j in 1..SESSION, k in TEACHER}:
	sum {l in STUDENT} X[i,j,k,l] <= 1;
subject to Prof_No_Consecutive_Sesh {i in 1..DAY, j in 1..SESSION-1, k in TEACHER}:
	sum {l in STUDENT} (X[i,j,k,l] + X[i,j+1,k,l]) <= 1;
subject to Prof_Max_Per_Day {i in 1..DAY, k in TEACHER}:
	sum {j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= 2;
subject to Prof_Is_Busy {i in 1..DAY, j in 1..SESSION, k in TEACHER}:
	BUSY[i,j,k] * sum {l in STUDENT} X[i,j,k,l] = 0;
subject to Is_Prof_Student_Pair {k in TEACHER, l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = C[k,l];
subject to Integrity_P_Nontriple {l in STUDENT, i in 1..3}:
	sum {k in TEACHER} P[k,l,i] = 1;
subject to Integrity_P_Triple {l in STUDENT}:
	sum {k in TEACHER} P[k,l,4] <= 1;
subject to Prof_Student_Timeslot {k in TEACHER, l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = sum {i in 1..4} P[k,l,i];
subject to Prof_Student_0_Dept_1:
	sum {k in DEPT1} P[k,0,1] = 1;
subject to Prof_Student_0_Minor:
	sum {k in DEPT2} P[k,0,2] = 1;
subject to Prof_Student_0_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT2)} P[k,0,3 + TRIPLE[0]] = 1;
subject to Prof_Student_1_Dept_0:
	sum {k in DEPT0} P[k,1,1] = 1;
subject to Prof_Student_1_Minor:
	sum {k in DEPT1} P[k,1,2] = 1;
subject to Prof_Student_1_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT1)} P[k,1,3 + TRIPLE[1]] = 1;
subject to Prof_Student_2_Dept_0:
	sum {k in DEPT0} P[k,2,1] = 1;
subject to Prof_Student_2_Dept_1:
	sum {k in DEPT1} P[k,2,2] = 1;
subject to Prof_Student_2_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT1)} P[k,2,3 + TRIPLE[2]] = 1;
subject to No_New_Major_Board_Student_0:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] < 1;
subject to No_New_Major_Board_Student_1:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] < 1;
subject to No_New_Major_Board_Student_2:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] < 2;
subject to Maj_Prof_2ndYr_Then_No_New_0:
	(numberof 1 in ({k in TEACHER, i in 1..1} P[k,0,i]) > 0) or (numberof 1 in ({k in TEACHER, i in 1..4} P[k,0,i]) = 0);
subject to Maj_Prof_2ndYr_Then_No_New_1:
	(numberof 1 in ({k in TEACHER, i in 1..1} P[k,1,i]) > 0) or (numberof 1 in ({k in TEACHER, i in 1..4} P[k,1,i]) = 0);
subject to Maj_Prof_2ndYr_Then_No_New_2:
	(numberof 1 in ({k in TEACHER, i in 1..2} P[k,2,i]) > 0) or (numberof 1 in ({k in TEACHER, i in 1..4} P[k,2,i]) = 0);
