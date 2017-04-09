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
var Y {1..DAY, 1..SESSION, STUDENT} binary;
var C {TEACHER, STUDENT} binary;
var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;

minimize CONST: 1;

subject to Student_Timeslot_Binary {l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} Y[i,j,l] = 1;
subject to Student_Timeslot_Count {i in 1..DAY, j in 1..SESSION, l in STUDENT}:
	sum {k in TEACHER} X[i,j,k,l] = 3 * Y[i,j,l];
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
subject to Prof_Student_0_Dept_0:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT0} X[i,j,k,0] = 1;
subject to Prof_Student_0_Dept_2:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT2} X[i,j,k,0] = 1;
subject to Prof_Student_0_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT0 diff DEPT2 diff DEPT1)} X[i,j,k,0] = 1;
subject to Prof_Student_1_Dept_0:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT0} X[i,j,k,1] = 1;
subject to Prof_Student_1_Minor:
	sum {i in 1..DAY, j in 1..SESSION, k in (DEPT1 union DEPT1 union DEPT2)} X[i,j,k,1] = 1;
subject to Prof_Student_1_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT0 diff DEPT1 diff DEPT2)} X[i,j,k,1] = 1;
subject to Prof_Student_2_Dept_3:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT3} X[i,j,k,2] = 1;
subject to Prof_Student_2_Dept_2:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT2} X[i,j,k,2] = 1;
subject to Prof_Student_2_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT3 diff DEPT2)} X[i,j,k,2] = 1;
subject to Prof_Student_3_Dept_0:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT0} X[i,j,k,3] = 1;
subject to Prof_Student_3_Dept_3:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT3} X[i,j,k,3] = 1;
subject to Prof_Student_3_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT0 diff DEPT3)} X[i,j,k,3] = 1;
subject to Prof_Student_4_Dept_3:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT3} X[i,j,k,4] = 1;
subject to Prof_Student_4_Minor:
	sum {i in 1..DAY, j in 1..SESSION, k in (DEPT0 union DEPT0 union DEPT1)} X[i,j,k,4] = 1;
subject to Prof_Student_4_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT3 diff DEPT0 diff DEPT1)} X[i,j,k,4] = 1;
subject to Prof_Student_5_Dept_3:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT3} X[i,j,k,5] = 1;
subject to Prof_Student_5_Dept_0:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT0} X[i,j,k,5] = 1;
subject to Prof_Student_5_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT3 diff DEPT0)} X[i,j,k,5] = 1;
subject to Prof_Student_6_Dept_0:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT0} X[i,j,k,6] = 1;
subject to Prof_Student_6_Minor:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT2} X[i,j,k,6] = 1;
subject to Prof_Student_6_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT0 diff DEPT2)} X[i,j,k,6] = 1;
subject to Prof_Student_7_Dept_2:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT2} X[i,j,k,7] = 1;
subject to Prof_Student_7_Minor:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT1} X[i,j,k,7] = 1;
subject to Prof_Student_7_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT2 diff DEPT1)} X[i,j,k,7] = 1;
subject to Prof_Student_8_Dept_1:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT1} X[i,j,k,8] = 1;
subject to Prof_Student_8_Minor:
	sum {i in 1..DAY, j in 1..SESSION, k in DEPT2} X[i,j,k,8] = 1;
subject to Prof_Student_8_AtLarge:
	sum {i in 1..DAY, j in 1..SESSION, k in (TEACHER diff DEPT1 diff DEPT2)} X[i,j,k,8] = 1;
