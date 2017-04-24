param DAY;
param SESSION;
set STUDENT;
set TEACHER;
set DIV1;
set DIV2;
set DIV3;
set DEPT0;
set DEPT1;
set DEPT2;
set DEPT3;
set DEPT4;
set DEPT5;
set DEPT6;
set DEPT7;
set DEPT8;
set DEPT9;
set DEPT10;
set DEPT11;
set DEPT12;
set DEPT13;
set DEPT14;
set DEPT15;
set DEPT16;
set DEPT17;
set DEPT18;
set DEPT19;
set DEPT20;
set DEPT21;
set DEPT22;
set DEPT23;
set DEPT24;
set DEPT25;
set DEPT26;
set DEPT27;

param SNR {TEACHER, 1..2} binary
	default 0;

param UCAP {TEACHER} integer
	default 12;
param BUSY {1..DAY, 1..SESSION, TEACHER} binary
	default 0;
param BUSZ {1..DAY, 1..SESSION, STUDENT} binary
	default 0;
param TRIPLE {STUDENT} binary
	default 0;
var Y {1..DAY, 1..SESSION, STUDENT} binary;
var C {TEACHER, STUDENT} binary;
var P {TEACHER, STUDENT, 1..4} binary;
var MAXPALL integer;
var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;

minimize OBJ: MAXPALL;
#minimize OBJ: sum {k in TEACHER} Z[k];

subject to Student_Timeslot_Binary {l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} Y[i,j,l] = 1;
subject to Student_Timeslot_Count {i in 1..DAY, j in 1..SESSION, l in STUDENT}:
	sum {k in TEACHER} X[i,j,k,l] = (3 + TRIPLE[l]) * Y[i,j,l];
subject to Teacher_Clone_Jutsu {i in 1..DAY, j in 1..SESSION, k in TEACHER}:
	sum {l in STUDENT} X[i,j,k,l] <= 1;
subject to Prof_No_Consecutive_Sesh {i in 1..DAY, j in 1..SESSION-1, k in TEACHER}:
	sum {l in STUDENT} (X[i,j,k,l] + X[i,j+1,k,l]) <= 1;
subject to Prof_Max_Per_Day {i in 1..DAY, k in TEACHER}:
	sum {j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= 4;
subject to Prof_Max_All {k in TEACHER}:
	sum {i in 1..DAY, j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= UCAP[k];
subject to Prof_Max_All_REAL {k in TEACHER}:
	sum {i in 1..DAY, j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= MAXPALL;
subject to Prof_Is_Busy {i in 1..DAY, j in 1..SESSION, k in TEACHER}:
	BUSY[i,j,k] * sum {l in STUDENT} X[i,j,k,l] = 0;
subject to Stud_Is_Busy {i in 1..DAY, j in 1..SESSION, l in STUDENT}:
	BUSZ[i,j,l] * sum {k in TEACHER} X[i,j,k,l] = 0;
subject to Is_Prof_Student_Pair {k in TEACHER, l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = C[k,l];
subject to Integrity_P_Nontriple {l in STUDENT, i in 1..3}:
	sum {k in TEACHER} P[k,l,i] = 1;
subject to Integrity_P_Triple {l in STUDENT}:
	sum {k in TEACHER} P[k,l,4] = TRIPLE[l];
subject to Prof_Student_Timeslot {k in TEACHER, l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = sum {i in 1..4} P[k,l,i];
subject to Prof_Student_0_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,0,i] = 1;
subject to Prof_Student_0_Minor:
	sum {k in (DEPT1 union DEPT2)} P[k,0,2] = 1;
subject to Prof_Student_0_AtLarge_D1:
	(sum {k in DIV1} (P[k,0,1] + P[k,0,2])) * sum {k in DIV1} P[k,0,3] = 0;
subject to Prof_Student_0_AtLarge_D2:
	(sum {k in DIV2} (P[k,0,1] + P[k,0,2])) * sum {k in DIV2} P[k,0,3] = 0;
subject to Prof_Student_0_AtLarge_D3:
	(sum {k in DIV3} (P[k,0,1] + P[k,0,2])) * sum {k in DIV3} P[k,0,3] = 0;
subject to Prof_Student_1_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,1,i] = 1;
subject to Prof_Student_1_Minor:
	sum {k in DEPT1} P[k,1,2] = 1;
subject to Prof_Student_1_AtLarge_D1:
	(sum {k in DIV1} (P[k,1,1] + P[k,1,2])) * sum {k in DIV1} P[k,1,3] = 0;
subject to Prof_Student_1_AtLarge_D2:
	(sum {k in DIV2} (P[k,1,1] + P[k,1,2])) * sum {k in DIV2} P[k,1,3] = 0;
subject to Prof_Student_1_AtLarge_D3:
	(sum {k in DIV3} (P[k,1,1] + P[k,1,2])) * sum {k in DIV3} P[k,1,3] = 0;
subject to Prof_Student_2_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,2,i] = 1;
subject to Prof_Student_2_Minor:
	sum {k in DEPT5} P[k,2,2] = 1;
subject to Prof_Student_2_AtLarge_D1:
	(sum {k in DIV1} (P[k,2,1] + P[k,2,2])) * sum {k in DIV1} P[k,2,3] = 0;
subject to Prof_Student_2_AtLarge_D2:
	(sum {k in DIV2} (P[k,2,1] + P[k,2,2])) * sum {k in DIV2} P[k,2,3] = 0;
subject to Prof_Student_2_AtLarge_D3:
	(sum {k in DIV3} (P[k,2,1] + P[k,2,2])) * sum {k in DIV3} P[k,2,3] = 0;
subject to Prof_Student_3_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,3,i] = 1;
subject to Prof_Student_3_Minor:
	sum {k in DEPT1} P[k,3,2] = 1;
subject to Prof_Student_3_AtLarge_D1:
	(sum {k in DIV1} (P[k,3,1] + P[k,3,2])) * sum {k in DIV1} P[k,3,3] = 0;
subject to Prof_Student_3_AtLarge_D2:
	(sum {k in DIV2} (P[k,3,1] + P[k,3,2])) * sum {k in DIV2} P[k,3,3] = 0;
subject to Prof_Student_3_AtLarge_D3:
	(sum {k in DIV3} (P[k,3,1] + P[k,3,2])) * sum {k in DIV3} P[k,3,3] = 0;
subject to Prof_Student_4_Dept_7:
	sum {k in DEPT7, i in 1..1} P[k,4,i] = 1;
subject to Prof_Student_4_Minor:
	sum {k in DEPT5} P[k,4,2] = 1;
subject to Prof_Student_4_AtLarge_D1:
	(sum {k in DIV1} (P[k,4,1] + P[k,4,2])) * sum {k in DIV1} P[k,4,3] = 0;
subject to Prof_Student_4_AtLarge_D2:
	(sum {k in DIV2} (P[k,4,1] + P[k,4,2])) * sum {k in DIV2} P[k,4,3] = 0;
subject to Prof_Student_4_AtLarge_D3:
	(sum {k in DIV3} (P[k,4,1] + P[k,4,2])) * sum {k in DIV3} P[k,4,3] = 0;
subject to Prof_Student_5_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,5,i] = 1;
subject to Prof_Student_5_Minor:
	sum {k in DEPT4} P[k,5,2] = 1;
subject to Prof_Student_5_AtLarge_D1:
	(sum {k in DIV1} (P[k,5,1] + P[k,5,2])) * sum {k in DIV1} P[k,5,3] = 0;
subject to Prof_Student_5_AtLarge_D2:
	(sum {k in DIV2} (P[k,5,1] + P[k,5,2])) * sum {k in DIV2} P[k,5,3] = 0;
subject to Prof_Student_5_AtLarge_D3:
	(sum {k in DIV3} (P[k,5,1] + P[k,5,2])) * sum {k in DIV3} P[k,5,3] = 0;
subject to Prof_Student_6_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,6,i] = 1;
subject to Prof_Student_6_Minor:
	sum {k in DEPT10} P[k,6,2] = 1;
subject to Prof_Student_6_AtLarge_D1:
	(sum {k in DIV1} (P[k,6,1] + P[k,6,2])) * sum {k in DIV1} P[k,6,3] = 0;
subject to Prof_Student_6_AtLarge_D2:
	(sum {k in DIV2} (P[k,6,1] + P[k,6,2])) * sum {k in DIV2} P[k,6,3] = 0;
subject to Prof_Student_6_AtLarge_D3:
	(sum {k in DIV3} (P[k,6,1] + P[k,6,2])) * sum {k in DIV3} P[k,6,3] = 0;
subject to Prof_Student_7_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,7,i] = 1;
subject to Prof_Student_7_Minor:
	sum {k in DEPT2} P[k,7,2] = 1;
subject to Prof_Student_7_AtLarge_D1:
	(sum {k in DIV1} (P[k,7,1] + P[k,7,2])) * sum {k in DIV1} P[k,7,3] = 0;
subject to Prof_Student_7_AtLarge_D2:
	(sum {k in DIV2} (P[k,7,1] + P[k,7,2])) * sum {k in DIV2} P[k,7,3] = 0;
subject to Prof_Student_7_AtLarge_D3:
	(sum {k in DIV3} (P[k,7,1] + P[k,7,2])) * sum {k in DIV3} P[k,7,3] = 0;
subject to Prof_Student_8_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,8,i] = 1;
subject to Prof_Student_8_Minor:
	sum {k in DEPT11} P[k,8,2] = 1;
subject to Prof_Student_8_AtLarge_D1:
	(sum {k in DIV1} (P[k,8,1] + P[k,8,2])) * sum {k in DIV1} P[k,8,3] = 0;
subject to Prof_Student_8_AtLarge_D2:
	(sum {k in DIV2} (P[k,8,1] + P[k,8,2])) * sum {k in DIV2} P[k,8,3] = 0;
subject to Prof_Student_8_AtLarge_D3:
	(sum {k in DIV3} (P[k,8,1] + P[k,8,2])) * sum {k in DIV3} P[k,8,3] = 0;
subject to Prof_Student_9_Dept_12:
	sum {k in DEPT12, i in 1..3} P[k,9,i] = 1;
subject to Prof_Student_9_Dept_3:
	sum {k in DEPT3, i in 1..3} P[k,9,i] = 1;
subject to Prof_Student_9_Dept_0:
	sum {k in DEPT0, i in 1..3} P[k,9,i] = 1;
subject to Prof_Student_9_AtLarge_D1:
	(sum {k in DIV1} (P[k,9,1] + P[k,9,2] + P[k,9,3])) * sum {k in DIV1} P[k,9,4] = 0;
subject to Prof_Student_9_AtLarge_D2:
	(sum {k in DIV2} (P[k,9,1] + P[k,9,2] + P[k,9,3])) * sum {k in DIV2} P[k,9,4] = 0;
subject to Prof_Student_9_AtLarge_D3:
	(sum {k in DIV3} (P[k,9,1] + P[k,9,2] + P[k,9,3])) * sum {k in DIV3} P[k,9,4] = 0;
subject to Prof_Student_10_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,10,i] = 1;
subject to Prof_Student_10_Minor:
	sum {k in DEPT14} P[k,10,2] = 1;
subject to Prof_Student_10_AtLarge_D1:
	(sum {k in DIV1} (P[k,10,1] + P[k,10,2])) * sum {k in DIV1} P[k,10,3] = 0;
subject to Prof_Student_10_AtLarge_D2:
	(sum {k in DIV2} (P[k,10,1] + P[k,10,2])) * sum {k in DIV2} P[k,10,3] = 0;
subject to Prof_Student_10_AtLarge_D3:
	(sum {k in DIV3} (P[k,10,1] + P[k,10,2])) * sum {k in DIV3} P[k,10,3] = 0;
subject to Prof_Student_11_Dept_15:
	sum {k in DEPT15, i in 1..1} P[k,11,i] = 1;
subject to Prof_Student_11_Minor:
	sum {k in DEPT16} P[k,11,2] = 1;
subject to Prof_Student_11_AtLarge_D1:
	(sum {k in DIV1} (P[k,11,1] + P[k,11,2])) * sum {k in DIV1} P[k,11,3] = 0;
subject to Prof_Student_11_AtLarge_D2:
	(sum {k in DIV2} (P[k,11,1] + P[k,11,2])) * sum {k in DIV2} P[k,11,3] = 0;
subject to Prof_Student_11_AtLarge_D3:
	(sum {k in DIV3} (P[k,11,1] + P[k,11,2])) * sum {k in DIV3} P[k,11,3] = 0;
subject to Prof_Student_12_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,12,i] = 1;
subject to Prof_Student_12_Minor:
	sum {k in DEPT10} P[k,12,2] = 1;
subject to Prof_Student_12_AtLarge_D1:
	(sum {k in DIV1} (P[k,12,1] + P[k,12,2])) * sum {k in DIV1} P[k,12,3] = 0;
subject to Prof_Student_12_AtLarge_D2:
	(sum {k in DIV2} (P[k,12,1] + P[k,12,2])) * sum {k in DIV2} P[k,12,3] = 0;
subject to Prof_Student_12_AtLarge_D3:
	(sum {k in DIV3} (P[k,12,1] + P[k,12,2])) * sum {k in DIV3} P[k,12,3] = 0;
subject to Prof_Student_13_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,13,i] = 1;
subject to Prof_Student_13_Minor:
	sum {k in DEPT11} P[k,13,2] = 1;
subject to Prof_Student_13_AtLarge_D1:
	(sum {k in DIV1} (P[k,13,1] + P[k,13,2])) * sum {k in DIV1} P[k,13,3] = 0;
subject to Prof_Student_13_AtLarge_D2:
	(sum {k in DIV2} (P[k,13,1] + P[k,13,2])) * sum {k in DIV2} P[k,13,3] = 0;
subject to Prof_Student_13_AtLarge_D3:
	(sum {k in DIV3} (P[k,13,1] + P[k,13,2])) * sum {k in DIV3} P[k,13,3] = 0;
subject to Prof_Student_14_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,14,i] = 1;
subject to Prof_Student_14_Minor:
	sum {k in DEPT9} P[k,14,2] = 1;
subject to Prof_Student_14_AtLarge_D1:
	(sum {k in DIV1} (P[k,14,1] + P[k,14,2])) * sum {k in DIV1} P[k,14,3] = 0;
subject to Prof_Student_14_AtLarge_D2:
	(sum {k in DIV2} (P[k,14,1] + P[k,14,2])) * sum {k in DIV2} P[k,14,3] = 0;
subject to Prof_Student_14_AtLarge_D3:
	(sum {k in DIV3} (P[k,14,1] + P[k,14,2])) * sum {k in DIV3} P[k,14,3] = 0;
subject to Prof_Student_15_Dept_17:
	sum {k in DEPT17, i in 1..2} P[k,15,i] = 1;
subject to Prof_Student_15_Dept_8:
	sum {k in DEPT8, i in 1..2} P[k,15,i] = 1;
subject to Prof_Student_15_AtLarge_D1:
	(sum {k in DIV1} (P[k,15,1] + P[k,15,2])) * sum {k in DIV1} P[k,15,3] = 0;
subject to Prof_Student_15_AtLarge_D2:
	(sum {k in DIV2} (P[k,15,1] + P[k,15,2])) * sum {k in DIV2} P[k,15,3] = 0;
subject to Prof_Student_15_AtLarge_D3:
	(sum {k in DIV3} (P[k,15,1] + P[k,15,2])) * sum {k in DIV3} P[k,15,3] = 0;
subject to Prof_Student_16_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,16,i] = 1;
subject to Prof_Student_16_Minor:
	sum {k in DEPT18} P[k,16,2] = 1;
subject to Prof_Student_16_AtLarge_D1:
	(sum {k in DIV1} (P[k,16,1] + P[k,16,2])) * sum {k in DIV1} P[k,16,3] = 0;
subject to Prof_Student_16_AtLarge_D2:
	(sum {k in DIV2} (P[k,16,1] + P[k,16,2])) * sum {k in DIV2} P[k,16,3] = 0;
subject to Prof_Student_16_AtLarge_D3:
	(sum {k in DIV3} (P[k,16,1] + P[k,16,2])) * sum {k in DIV3} P[k,16,3] = 0;
subject to Prof_Student_17_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,17,i] = 1;
subject to Prof_Student_17_Minor:
	sum {k in DEPT1} P[k,17,2] = 1;
subject to Prof_Student_17_AtLarge_D1:
	(sum {k in DIV1} (P[k,17,1] + P[k,17,2])) * sum {k in DIV1} P[k,17,3] = 0;
subject to Prof_Student_17_AtLarge_D2:
	(sum {k in DIV2} (P[k,17,1] + P[k,17,2])) * sum {k in DIV2} P[k,17,3] = 0;
subject to Prof_Student_17_AtLarge_D3:
	(sum {k in DIV3} (P[k,17,1] + P[k,17,2])) * sum {k in DIV3} P[k,17,3] = 0;
subject to Prof_Student_18_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,18,i] = 1;
subject to Prof_Student_18_Minor:
	sum {k in DEPT15} P[k,18,2] = 1;
subject to Prof_Student_18_AtLarge_D1:
	(sum {k in DIV1} (P[k,18,1] + P[k,18,2])) * sum {k in DIV1} P[k,18,3] = 0;
subject to Prof_Student_18_AtLarge_D2:
	(sum {k in DIV2} (P[k,18,1] + P[k,18,2])) * sum {k in DIV2} P[k,18,3] = 0;
subject to Prof_Student_18_AtLarge_D3:
	(sum {k in DIV3} (P[k,18,1] + P[k,18,2])) * sum {k in DIV3} P[k,18,3] = 0;
subject to Prof_Student_19_Dept_12:
	sum {k in DEPT12, i in 1..1} P[k,19,i] = 1;
subject to Prof_Student_19_Minor:
	sum {k in (DEPT0 union DEPT6)} P[k,19,2] = 1;
subject to Prof_Student_19_AtLarge_D1:
	(sum {k in DIV1} (P[k,19,1] + P[k,19,2])) * sum {k in DIV1} P[k,19,3] = 0;
subject to Prof_Student_19_AtLarge_D2:
	(sum {k in DIV2} (P[k,19,1] + P[k,19,2])) * sum {k in DIV2} P[k,19,3] = 0;
subject to Prof_Student_19_AtLarge_D3:
	(sum {k in DIV3} (P[k,19,1] + P[k,19,2])) * sum {k in DIV3} P[k,19,3] = 0;
subject to Prof_Student_20_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,20,i] = 1;
subject to Prof_Student_20_Minor:
	sum {k in DEPT6} P[k,20,2] = 1;
subject to Prof_Student_20_AtLarge_D1:
	(sum {k in DIV1} (P[k,20,1] + P[k,20,2])) * sum {k in DIV1} P[k,20,3] = 0;
subject to Prof_Student_20_AtLarge_D2:
	(sum {k in DIV2} (P[k,20,1] + P[k,20,2])) * sum {k in DIV2} P[k,20,3] = 0;
subject to Prof_Student_20_AtLarge_D3:
	(sum {k in DIV3} (P[k,20,1] + P[k,20,2])) * sum {k in DIV3} P[k,20,3] = 0;
subject to Prof_Student_21_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,21,i] = 1;
subject to Prof_Student_21_Minor:
	sum {k in DEPT0} P[k,21,2] = 1;
subject to Prof_Student_21_AtLarge_D1:
	(sum {k in DIV1} (P[k,21,1] + P[k,21,2])) * sum {k in DIV1} P[k,21,3] = 0;
subject to Prof_Student_21_AtLarge_D2:
	(sum {k in DIV2} (P[k,21,1] + P[k,21,2])) * sum {k in DIV2} P[k,21,3] = 0;
subject to Prof_Student_21_AtLarge_D3:
	(sum {k in DIV3} (P[k,21,1] + P[k,21,2])) * sum {k in DIV3} P[k,21,3] = 0;
subject to Prof_Student_22_Dept_9:
	sum {k in DEPT9, i in 1..2} P[k,22,i] = 1;
subject to Prof_Student_22_Dept_7:
	sum {k in DEPT7, i in 1..2} P[k,22,i] = 1;
subject to Prof_Student_22_AtLarge_D1:
	(sum {k in DIV1} (P[k,22,1] + P[k,22,2])) * sum {k in DIV1} P[k,22,3] = 0;
subject to Prof_Student_22_AtLarge_D2:
	(sum {k in DIV2} (P[k,22,1] + P[k,22,2])) * sum {k in DIV2} P[k,22,3] = 0;
subject to Prof_Student_22_AtLarge_D3:
	(sum {k in DIV3} (P[k,22,1] + P[k,22,2])) * sum {k in DIV3} P[k,22,3] = 0;
subject to Prof_Student_23_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,23,i] = 1;
subject to Prof_Student_23_Minor:
	sum {k in DEPT7} P[k,23,2] = 1;
subject to Prof_Student_23_AtLarge_D1:
	(sum {k in DIV1} (P[k,23,1] + P[k,23,2])) * sum {k in DIV1} P[k,23,3] = 0;
subject to Prof_Student_23_AtLarge_D2:
	(sum {k in DIV2} (P[k,23,1] + P[k,23,2])) * sum {k in DIV2} P[k,23,3] = 0;
subject to Prof_Student_23_AtLarge_D3:
	(sum {k in DIV3} (P[k,23,1] + P[k,23,2])) * sum {k in DIV3} P[k,23,3] = 0;
subject to Prof_Student_24_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,24,i] = 1;
subject to Prof_Student_24_Minor:
	sum {k in DEPT0} P[k,24,2] = 1;
subject to Prof_Student_24_AtLarge_D1:
	(sum {k in DIV1} (P[k,24,1] + P[k,24,2])) * sum {k in DIV1} P[k,24,3] = 0;
subject to Prof_Student_24_AtLarge_D2:
	(sum {k in DIV2} (P[k,24,1] + P[k,24,2])) * sum {k in DIV2} P[k,24,3] = 0;
subject to Prof_Student_24_AtLarge_D3:
	(sum {k in DIV3} (P[k,24,1] + P[k,24,2])) * sum {k in DIV3} P[k,24,3] = 0;
subject to Prof_Student_25_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,25,i] = 1;
subject to Prof_Student_25_Minor:
	sum {k in DEPT19} P[k,25,2] = 1;
subject to Prof_Student_25_AtLarge_D1:
	(sum {k in DIV1} (P[k,25,1] + P[k,25,2])) * sum {k in DIV1} P[k,25,3] = 0;
subject to Prof_Student_25_AtLarge_D2:
	(sum {k in DIV2} (P[k,25,1] + P[k,25,2])) * sum {k in DIV2} P[k,25,3] = 0;
subject to Prof_Student_25_AtLarge_D3:
	(sum {k in DIV3} (P[k,25,1] + P[k,25,2])) * sum {k in DIV3} P[k,25,3] = 0;
subject to Prof_Student_26_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,26,i] = 1;
subject to Prof_Student_26_Minor:
	sum {k in DEPT0} P[k,26,2] = 1;
subject to Prof_Student_26_AtLarge_D1:
	(sum {k in DIV1} (P[k,26,1] + P[k,26,2])) * sum {k in DIV1} P[k,26,3] = 0;
subject to Prof_Student_26_AtLarge_D2:
	(sum {k in DIV2} (P[k,26,1] + P[k,26,2])) * sum {k in DIV2} P[k,26,3] = 0;
subject to Prof_Student_26_AtLarge_D3:
	(sum {k in DIV3} (P[k,26,1] + P[k,26,2])) * sum {k in DIV3} P[k,26,3] = 0;
subject to Prof_Student_27_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,27,i] = 1;
subject to Prof_Student_27_Minor:
	sum {k in DEPT14} P[k,27,2] = 1;
subject to Prof_Student_27_AtLarge_D1:
	(sum {k in DIV1} (P[k,27,1] + P[k,27,2])) * sum {k in DIV1} P[k,27,3] = 0;
subject to Prof_Student_27_AtLarge_D2:
	(sum {k in DIV2} (P[k,27,1] + P[k,27,2])) * sum {k in DIV2} P[k,27,3] = 0;
subject to Prof_Student_27_AtLarge_D3:
	(sum {k in DIV3} (P[k,27,1] + P[k,27,2])) * sum {k in DIV3} P[k,27,3] = 0;
subject to Prof_Student_28_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,28,i] = 1;
subject to Prof_Student_28_Minor:
	sum {k in DEPT14} P[k,28,2] = 1;
subject to Prof_Student_28_AtLarge_D1:
	(sum {k in DIV1} (P[k,28,1] + P[k,28,2])) * sum {k in DIV1} P[k,28,3] = 0;
subject to Prof_Student_28_AtLarge_D2:
	(sum {k in DIV2} (P[k,28,1] + P[k,28,2])) * sum {k in DIV2} P[k,28,3] = 0;
subject to Prof_Student_28_AtLarge_D3:
	(sum {k in DIV3} (P[k,28,1] + P[k,28,2])) * sum {k in DIV3} P[k,28,3] = 0;
subject to Prof_Student_29_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,29,i] = 1;
subject to Prof_Student_29_Minor:
	sum {k in (DEPT0 union DEPT10)} P[k,29,2] = 1;
subject to Prof_Student_29_AtLarge_D1:
	(sum {k in DIV1} (P[k,29,1] + P[k,29,2])) * sum {k in DIV1} P[k,29,3] = 0;
subject to Prof_Student_29_AtLarge_D2:
	(sum {k in DIV2} (P[k,29,1] + P[k,29,2])) * sum {k in DIV2} P[k,29,3] = 0;
subject to Prof_Student_29_AtLarge_D3:
	(sum {k in DIV3} (P[k,29,1] + P[k,29,2])) * sum {k in DIV3} P[k,29,3] = 0;
subject to Prof_Student_30_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,30,i] = 1;
subject to Prof_Student_30_Minor:
	sum {k in DEPT20} P[k,30,2] = 1;
subject to Prof_Student_30_AtLarge_D1:
	(sum {k in DIV1} (P[k,30,1] + P[k,30,2])) * sum {k in DIV1} P[k,30,3] = 0;
subject to Prof_Student_30_AtLarge_D2:
	(sum {k in DIV2} (P[k,30,1] + P[k,30,2])) * sum {k in DIV2} P[k,30,3] = 0;
subject to Prof_Student_30_AtLarge_D3:
	(sum {k in DIV3} (P[k,30,1] + P[k,30,2])) * sum {k in DIV3} P[k,30,3] = 0;
subject to Prof_Student_31_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,31,i] = 1;
subject to Prof_Student_31_Minor:
	sum {k in DEPT21} P[k,31,2] = 1;
subject to Prof_Student_31_AtLarge_D1:
	(sum {k in DIV1} (P[k,31,1] + P[k,31,2])) * sum {k in DIV1} P[k,31,3] = 0;
subject to Prof_Student_31_AtLarge_D2:
	(sum {k in DIV2} (P[k,31,1] + P[k,31,2])) * sum {k in DIV2} P[k,31,3] = 0;
subject to Prof_Student_31_AtLarge_D3:
	(sum {k in DIV3} (P[k,31,1] + P[k,31,2])) * sum {k in DIV3} P[k,31,3] = 0;
subject to Prof_Student_32_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,32,i] = 1;
subject to Prof_Student_32_Minor:
	sum {k in DEPT18} P[k,32,2] = 1;
subject to Prof_Student_32_AtLarge_D1:
	(sum {k in DIV1} (P[k,32,1] + P[k,32,2])) * sum {k in DIV1} P[k,32,3] = 0;
subject to Prof_Student_32_AtLarge_D2:
	(sum {k in DIV2} (P[k,32,1] + P[k,32,2])) * sum {k in DIV2} P[k,32,3] = 0;
subject to Prof_Student_32_AtLarge_D3:
	(sum {k in DIV3} (P[k,32,1] + P[k,32,2])) * sum {k in DIV3} P[k,32,3] = 0;
subject to Prof_Student_33_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,33,i] = 1;
subject to Prof_Student_33_Minor:
	sum {k in DEPT3} P[k,33,2] = 1;
subject to Prof_Student_33_AtLarge_D1:
	(sum {k in DIV1} (P[k,33,1] + P[k,33,2])) * sum {k in DIV1} P[k,33,3] = 0;
subject to Prof_Student_33_AtLarge_D2:
	(sum {k in DIV2} (P[k,33,1] + P[k,33,2])) * sum {k in DIV2} P[k,33,3] = 0;
subject to Prof_Student_33_AtLarge_D3:
	(sum {k in DIV3} (P[k,33,1] + P[k,33,2])) * sum {k in DIV3} P[k,33,3] = 0;
subject to Prof_Student_34_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,34,i] = 1;
subject to Prof_Student_34_Minor:
	sum {k in DEPT1} P[k,34,2] = 1;
subject to Prof_Student_34_AtLarge_D1:
	(sum {k in DIV1} (P[k,34,1] + P[k,34,2])) * sum {k in DIV1} P[k,34,3] = 0;
subject to Prof_Student_34_AtLarge_D2:
	(sum {k in DIV2} (P[k,34,1] + P[k,34,2])) * sum {k in DIV2} P[k,34,3] = 0;
subject to Prof_Student_34_AtLarge_D3:
	(sum {k in DIV3} (P[k,34,1] + P[k,34,2])) * sum {k in DIV3} P[k,34,3] = 0;
subject to Prof_Student_35_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,35,i] = 1;
subject to Prof_Student_35_Minor:
	sum {k in DEPT10} P[k,35,2] = 1;
subject to Prof_Student_35_AtLarge_D1:
	(sum {k in DIV1} (P[k,35,1] + P[k,35,2])) * sum {k in DIV1} P[k,35,3] = 0;
subject to Prof_Student_35_AtLarge_D2:
	(sum {k in DIV2} (P[k,35,1] + P[k,35,2])) * sum {k in DIV2} P[k,35,3] = 0;
subject to Prof_Student_35_AtLarge_D3:
	(sum {k in DIV3} (P[k,35,1] + P[k,35,2])) * sum {k in DIV3} P[k,35,3] = 0;
subject to Prof_Student_36_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,36,i] = 1;
subject to Prof_Student_36_Minor:
	sum {k in DEPT7} P[k,36,2] = 1;
subject to Prof_Student_36_AtLarge_D1:
	(sum {k in DIV1} (P[k,36,1] + P[k,36,2])) * sum {k in DIV1} P[k,36,3] = 0;
subject to Prof_Student_36_AtLarge_D2:
	(sum {k in DIV2} (P[k,36,1] + P[k,36,2])) * sum {k in DIV2} P[k,36,3] = 0;
subject to Prof_Student_36_AtLarge_D3:
	(sum {k in DIV3} (P[k,36,1] + P[k,36,2])) * sum {k in DIV3} P[k,36,3] = 0;
subject to Prof_Student_37_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,37,i] = 1;
subject to Prof_Student_37_Minor:
	sum {k in DEPT0} P[k,37,2] = 1;
subject to Prof_Student_37_AtLarge_D1:
	(sum {k in DIV1} (P[k,37,1] + P[k,37,2])) * sum {k in DIV1} P[k,37,3] = 0;
subject to Prof_Student_37_AtLarge_D2:
	(sum {k in DIV2} (P[k,37,1] + P[k,37,2])) * sum {k in DIV2} P[k,37,3] = 0;
subject to Prof_Student_37_AtLarge_D3:
	(sum {k in DIV3} (P[k,37,1] + P[k,37,2])) * sum {k in DIV3} P[k,37,3] = 0;
subject to Prof_Student_38_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,38,i] = 1;
subject to Prof_Student_38_Minor:
	sum {k in DEPT9} P[k,38,2] = 1;
subject to Prof_Student_38_AtLarge_D1:
	(sum {k in DIV1} (P[k,38,1] + P[k,38,2])) * sum {k in DIV1} P[k,38,3] = 0;
subject to Prof_Student_38_AtLarge_D2:
	(sum {k in DIV2} (P[k,38,1] + P[k,38,2])) * sum {k in DIV2} P[k,38,3] = 0;
subject to Prof_Student_38_AtLarge_D3:
	(sum {k in DIV3} (P[k,38,1] + P[k,38,2])) * sum {k in DIV3} P[k,38,3] = 0;
subject to Prof_Student_39_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,39,i] = 1;
subject to Prof_Student_39_Minor:
	sum {k in DEPT0} P[k,39,2] = 1;
subject to Prof_Student_39_AtLarge_D1:
	(sum {k in DIV1} (P[k,39,1] + P[k,39,2])) * sum {k in DIV1} P[k,39,3] = 0;
subject to Prof_Student_39_AtLarge_D2:
	(sum {k in DIV2} (P[k,39,1] + P[k,39,2])) * sum {k in DIV2} P[k,39,3] = 0;
subject to Prof_Student_39_AtLarge_D3:
	(sum {k in DIV3} (P[k,39,1] + P[k,39,2])) * sum {k in DIV3} P[k,39,3] = 0;
subject to Prof_Student_40_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,40,i] = 1;
subject to Prof_Student_40_Minor:
	sum {k in DEPT10} P[k,40,2] = 1;
subject to Prof_Student_40_AtLarge_D1:
	(sum {k in DIV1} (P[k,40,1] + P[k,40,2])) * sum {k in DIV1} P[k,40,3] = 0;
subject to Prof_Student_40_AtLarge_D2:
	(sum {k in DIV2} (P[k,40,1] + P[k,40,2])) * sum {k in DIV2} P[k,40,3] = 0;
subject to Prof_Student_40_AtLarge_D3:
	(sum {k in DIV3} (P[k,40,1] + P[k,40,2])) * sum {k in DIV3} P[k,40,3] = 0;
subject to Prof_Student_41_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,41,i] = 1;
subject to Prof_Student_41_Minor:
	sum {k in DEPT22} P[k,41,2] = 1;
subject to Prof_Student_41_AtLarge_D1:
	(sum {k in DIV1} (P[k,41,1] + P[k,41,2])) * sum {k in DIV1} P[k,41,3] = 0;
subject to Prof_Student_41_AtLarge_D2:
	(sum {k in DIV2} (P[k,41,1] + P[k,41,2])) * sum {k in DIV2} P[k,41,3] = 0;
subject to Prof_Student_41_AtLarge_D3:
	(sum {k in DIV3} (P[k,41,1] + P[k,41,2])) * sum {k in DIV3} P[k,41,3] = 0;
subject to Prof_Student_42_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,42,i] = 1;
subject to Prof_Student_42_Minor:
	sum {k in (DEPT18 union DEPT19)} P[k,42,2] = 1;
subject to Prof_Student_42_AtLarge_D1:
	(sum {k in DIV1} (P[k,42,1] + P[k,42,2])) * sum {k in DIV1} P[k,42,3] = 0;
subject to Prof_Student_42_AtLarge_D2:
	(sum {k in DIV2} (P[k,42,1] + P[k,42,2])) * sum {k in DIV2} P[k,42,3] = 0;
subject to Prof_Student_42_AtLarge_D3:
	(sum {k in DIV3} (P[k,42,1] + P[k,42,2])) * sum {k in DIV3} P[k,42,3] = 0;
subject to Prof_Student_43_Dept_23:
	sum {k in DEPT23, i in 1..1} P[k,43,i] = 1;
subject to Prof_Student_43_Minor:
	sum {k in DEPT14} P[k,43,2] = 1;
subject to Prof_Student_43_AtLarge_D1:
	(sum {k in DIV1} (P[k,43,1] + P[k,43,2])) * sum {k in DIV1} P[k,43,3] = 0;
subject to Prof_Student_43_AtLarge_D2:
	(sum {k in DIV2} (P[k,43,1] + P[k,43,2])) * sum {k in DIV2} P[k,43,3] = 0;
subject to Prof_Student_43_AtLarge_D3:
	(sum {k in DIV3} (P[k,43,1] + P[k,43,2])) * sum {k in DIV3} P[k,43,3] = 0;
subject to Prof_Student_44_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,44,i] = 1;
subject to Prof_Student_44_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,44,i] = 1;
subject to Prof_Student_44_AtLarge_D1:
	(sum {k in DIV1} (P[k,44,1] + P[k,44,2])) * sum {k in DIV1} P[k,44,3] = 0;
subject to Prof_Student_44_AtLarge_D2:
	(sum {k in DIV2} (P[k,44,1] + P[k,44,2])) * sum {k in DIV2} P[k,44,3] = 0;
subject to Prof_Student_44_AtLarge_D3:
	(sum {k in DIV3} (P[k,44,1] + P[k,44,2])) * sum {k in DIV3} P[k,44,3] = 0;
subject to Prof_Student_45_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,45,i] = 1;
subject to Prof_Student_45_Minor:
	sum {k in (DEPT9 union DEPT5)} P[k,45,2] = 1;
subject to Prof_Student_45_AtLarge_D1:
	(sum {k in DIV1} (P[k,45,1] + P[k,45,2])) * sum {k in DIV1} P[k,45,3] = 0;
subject to Prof_Student_45_AtLarge_D2:
	(sum {k in DIV2} (P[k,45,1] + P[k,45,2])) * sum {k in DIV2} P[k,45,3] = 0;
subject to Prof_Student_45_AtLarge_D3:
	(sum {k in DIV3} (P[k,45,1] + P[k,45,2])) * sum {k in DIV3} P[k,45,3] = 0;
subject to Prof_Student_46_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,46,i] = 1;
subject to Prof_Student_46_Minor:
	sum {k in DEPT6} P[k,46,2] = 1;
subject to Prof_Student_46_AtLarge_D1:
	(sum {k in DIV1} (P[k,46,1] + P[k,46,2])) * sum {k in DIV1} P[k,46,3] = 0;
subject to Prof_Student_46_AtLarge_D2:
	(sum {k in DIV2} (P[k,46,1] + P[k,46,2])) * sum {k in DIV2} P[k,46,3] = 0;
subject to Prof_Student_46_AtLarge_D3:
	(sum {k in DIV3} (P[k,46,1] + P[k,46,2])) * sum {k in DIV3} P[k,46,3] = 0;
subject to Prof_Student_47_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,47,i] = 1;
subject to Prof_Student_47_Minor:
	sum {k in (DEPT9 union DEPT1)} P[k,47,2] = 1;
subject to Prof_Student_47_AtLarge_D1:
	(sum {k in DIV1} (P[k,47,1] + P[k,47,2])) * sum {k in DIV1} P[k,47,3] = 0;
subject to Prof_Student_47_AtLarge_D2:
	(sum {k in DIV2} (P[k,47,1] + P[k,47,2])) * sum {k in DIV2} P[k,47,3] = 0;
subject to Prof_Student_47_AtLarge_D3:
	(sum {k in DIV3} (P[k,47,1] + P[k,47,2])) * sum {k in DIV3} P[k,47,3] = 0;
subject to Prof_Student_48_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,48,i] = 1;
subject to Prof_Student_48_Minor:
	sum {k in DEPT11} P[k,48,2] = 1;
subject to Prof_Student_48_AtLarge_D1:
	(sum {k in DIV1} (P[k,48,1] + P[k,48,2])) * sum {k in DIV1} P[k,48,3] = 0;
subject to Prof_Student_48_AtLarge_D2:
	(sum {k in DIV2} (P[k,48,1] + P[k,48,2])) * sum {k in DIV2} P[k,48,3] = 0;
subject to Prof_Student_48_AtLarge_D3:
	(sum {k in DIV3} (P[k,48,1] + P[k,48,2])) * sum {k in DIV3} P[k,48,3] = 0;
subject to Prof_Student_49_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,49,i] = 1;
subject to Prof_Student_49_Minor:
	sum {k in DEPT18} P[k,49,2] = 1;
subject to Prof_Student_49_AtLarge_D1:
	(sum {k in DIV1} (P[k,49,1] + P[k,49,2])) * sum {k in DIV1} P[k,49,3] = 0;
subject to Prof_Student_49_AtLarge_D2:
	(sum {k in DIV2} (P[k,49,1] + P[k,49,2])) * sum {k in DIV2} P[k,49,3] = 0;
subject to Prof_Student_49_AtLarge_D3:
	(sum {k in DIV3} (P[k,49,1] + P[k,49,2])) * sum {k in DIV3} P[k,49,3] = 0;
subject to Prof_Student_50_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,50,i] = 1;
subject to Prof_Student_50_Minor:
	sum {k in DEPT3} P[k,50,2] = 1;
subject to Prof_Student_50_AtLarge_D1:
	(sum {k in DIV1} (P[k,50,1] + P[k,50,2])) * sum {k in DIV1} P[k,50,3] = 0;
subject to Prof_Student_50_AtLarge_D2:
	(sum {k in DIV2} (P[k,50,1] + P[k,50,2])) * sum {k in DIV2} P[k,50,3] = 0;
subject to Prof_Student_50_AtLarge_D3:
	(sum {k in DIV3} (P[k,50,1] + P[k,50,2])) * sum {k in DIV3} P[k,50,3] = 0;
subject to Prof_Student_51_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,51,i] = 1;
subject to Prof_Student_51_Minor:
	sum {k in DEPT9} P[k,51,2] = 1;
subject to Prof_Student_51_AtLarge_D1:
	(sum {k in DIV1} (P[k,51,1] + P[k,51,2])) * sum {k in DIV1} P[k,51,3] = 0;
subject to Prof_Student_51_AtLarge_D2:
	(sum {k in DIV2} (P[k,51,1] + P[k,51,2])) * sum {k in DIV2} P[k,51,3] = 0;
subject to Prof_Student_51_AtLarge_D3:
	(sum {k in DIV3} (P[k,51,1] + P[k,51,2])) * sum {k in DIV3} P[k,51,3] = 0;
subject to Prof_Student_52_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,52,i] = 1;
subject to Prof_Student_52_Minor:
	sum {k in (DEPT9 union DEPT1)} P[k,52,2] = 1;
subject to Prof_Student_52_AtLarge_D1:
	(sum {k in DIV1} (P[k,52,1] + P[k,52,2])) * sum {k in DIV1} P[k,52,3] = 0;
subject to Prof_Student_52_AtLarge_D2:
	(sum {k in DIV2} (P[k,52,1] + P[k,52,2])) * sum {k in DIV2} P[k,52,3] = 0;
subject to Prof_Student_52_AtLarge_D3:
	(sum {k in DIV3} (P[k,52,1] + P[k,52,2])) * sum {k in DIV3} P[k,52,3] = 0;
subject to Prof_Student_53_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,53,i] = 1;
subject to Prof_Student_53_Minor:
	sum {k in DEPT21} P[k,53,2] = 1;
subject to Prof_Student_53_AtLarge_D1:
	(sum {k in DIV1} (P[k,53,1] + P[k,53,2])) * sum {k in DIV1} P[k,53,3] = 0;
subject to Prof_Student_53_AtLarge_D2:
	(sum {k in DIV2} (P[k,53,1] + P[k,53,2])) * sum {k in DIV2} P[k,53,3] = 0;
subject to Prof_Student_53_AtLarge_D3:
	(sum {k in DIV3} (P[k,53,1] + P[k,53,2])) * sum {k in DIV3} P[k,53,3] = 0;
subject to Prof_Student_54_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,54,i] = 1;
subject to Prof_Student_54_Minor:
	sum {k in DEPT10} P[k,54,2] = 1;
subject to Prof_Student_54_AtLarge_D1:
	(sum {k in DIV1} (P[k,54,1] + P[k,54,2])) * sum {k in DIV1} P[k,54,3] = 0;
subject to Prof_Student_54_AtLarge_D2:
	(sum {k in DIV2} (P[k,54,1] + P[k,54,2])) * sum {k in DIV2} P[k,54,3] = 0;
subject to Prof_Student_54_AtLarge_D3:
	(sum {k in DIV3} (P[k,54,1] + P[k,54,2])) * sum {k in DIV3} P[k,54,3] = 0;
subject to Prof_Student_55_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,55,i] = 1;
subject to Prof_Student_55_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,55,i] = 1;
subject to Prof_Student_55_AtLarge_D1:
	(sum {k in DIV1} (P[k,55,1] + P[k,55,2])) * sum {k in DIV1} P[k,55,3] = 0;
subject to Prof_Student_55_AtLarge_D2:
	(sum {k in DIV2} (P[k,55,1] + P[k,55,2])) * sum {k in DIV2} P[k,55,3] = 0;
subject to Prof_Student_55_AtLarge_D3:
	(sum {k in DIV3} (P[k,55,1] + P[k,55,2])) * sum {k in DIV3} P[k,55,3] = 0;
subject to Prof_Student_56_Dept_5:
	sum {k in DEPT5, i in 1..2} P[k,56,i] = 1;
subject to Prof_Student_56_Dept_15:
	sum {k in DEPT15, i in 1..2} P[k,56,i] = 1;
subject to Prof_Student_56_AtLarge_D1:
	(sum {k in DIV1} (P[k,56,1] + P[k,56,2])) * sum {k in DIV1} P[k,56,3] = 0;
subject to Prof_Student_56_AtLarge_D2:
	(sum {k in DIV2} (P[k,56,1] + P[k,56,2])) * sum {k in DIV2} P[k,56,3] = 0;
subject to Prof_Student_56_AtLarge_D3:
	(sum {k in DIV3} (P[k,56,1] + P[k,56,2])) * sum {k in DIV3} P[k,56,3] = 0;
subject to Prof_Student_57_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,57,i] = 1;
subject to Prof_Student_57_Minor:
	sum {k in DEPT6} P[k,57,2] = 1;
subject to Prof_Student_57_AtLarge_D1:
	(sum {k in DIV1} (P[k,57,1] + P[k,57,2])) * sum {k in DIV1} P[k,57,3] = 0;
subject to Prof_Student_57_AtLarge_D2:
	(sum {k in DIV2} (P[k,57,1] + P[k,57,2])) * sum {k in DIV2} P[k,57,3] = 0;
subject to Prof_Student_57_AtLarge_D3:
	(sum {k in DIV3} (P[k,57,1] + P[k,57,2])) * sum {k in DIV3} P[k,57,3] = 0;
subject to Prof_Student_58_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,58,i] = 1;
subject to Prof_Student_58_Minor:
	sum {k in DEPT14} P[k,58,2] = 1;
subject to Prof_Student_58_AtLarge_D1:
	(sum {k in DIV1} (P[k,58,1] + P[k,58,2])) * sum {k in DIV1} P[k,58,3] = 0;
subject to Prof_Student_58_AtLarge_D2:
	(sum {k in DIV2} (P[k,58,1] + P[k,58,2])) * sum {k in DIV2} P[k,58,3] = 0;
subject to Prof_Student_58_AtLarge_D3:
	(sum {k in DIV3} (P[k,58,1] + P[k,58,2])) * sum {k in DIV3} P[k,58,3] = 0;
subject to Prof_Student_59_Dept_24:
	sum {k in DEPT24, i in 1..2} P[k,59,i] = 1;
subject to Prof_Student_59_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,59,i] = 1;
subject to Prof_Student_59_AtLarge_D1:
	(sum {k in DIV1} (P[k,59,1] + P[k,59,2])) * sum {k in DIV1} P[k,59,3] = 0;
subject to Prof_Student_59_AtLarge_D2:
	(sum {k in DIV2} (P[k,59,1] + P[k,59,2])) * sum {k in DIV2} P[k,59,3] = 0;
subject to Prof_Student_59_AtLarge_D3:
	(sum {k in DIV3} (P[k,59,1] + P[k,59,2])) * sum {k in DIV3} P[k,59,3] = 0;
subject to Prof_Student_60_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,60,i] = 1;
subject to Prof_Student_60_Minor:
	sum {k in DEPT0} P[k,60,2] = 1;
subject to Prof_Student_60_AtLarge_D1:
	(sum {k in DIV1} (P[k,60,1] + P[k,60,2])) * sum {k in DIV1} P[k,60,3] = 0;
subject to Prof_Student_60_AtLarge_D2:
	(sum {k in DIV2} (P[k,60,1] + P[k,60,2])) * sum {k in DIV2} P[k,60,3] = 0;
subject to Prof_Student_60_AtLarge_D3:
	(sum {k in DIV3} (P[k,60,1] + P[k,60,2])) * sum {k in DIV3} P[k,60,3] = 0;
subject to Prof_Student_61_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,61,i] = 1;
subject to Prof_Student_61_Minor:
	sum {k in DEPT6} P[k,61,2] = 1;
subject to Prof_Student_61_AtLarge_D1:
	(sum {k in DIV1} (P[k,61,1] + P[k,61,2])) * sum {k in DIV1} P[k,61,3] = 0;
subject to Prof_Student_61_AtLarge_D2:
	(sum {k in DIV2} (P[k,61,1] + P[k,61,2])) * sum {k in DIV2} P[k,61,3] = 0;
subject to Prof_Student_61_AtLarge_D3:
	(sum {k in DIV3} (P[k,61,1] + P[k,61,2])) * sum {k in DIV3} P[k,61,3] = 0;
subject to Prof_Student_62_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,62,i] = 1;
subject to Prof_Student_62_Minor:
	sum {k in DEPT9} P[k,62,2] = 1;
subject to Prof_Student_62_AtLarge_D1:
	(sum {k in DIV1} (P[k,62,1] + P[k,62,2])) * sum {k in DIV1} P[k,62,3] = 0;
subject to Prof_Student_62_AtLarge_D2:
	(sum {k in DIV2} (P[k,62,1] + P[k,62,2])) * sum {k in DIV2} P[k,62,3] = 0;
subject to Prof_Student_62_AtLarge_D3:
	(sum {k in DIV3} (P[k,62,1] + P[k,62,2])) * sum {k in DIV3} P[k,62,3] = 0;
subject to Prof_Student_63_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,63,i] = 1;
subject to Prof_Student_63_Minor:
	sum {k in DEPT3} P[k,63,2] = 1;
subject to Prof_Student_63_AtLarge_D1:
	(sum {k in DIV1} (P[k,63,1] + P[k,63,2])) * sum {k in DIV1} P[k,63,3] = 0;
subject to Prof_Student_63_AtLarge_D2:
	(sum {k in DIV2} (P[k,63,1] + P[k,63,2])) * sum {k in DIV2} P[k,63,3] = 0;
subject to Prof_Student_63_AtLarge_D3:
	(sum {k in DIV3} (P[k,63,1] + P[k,63,2])) * sum {k in DIV3} P[k,63,3] = 0;
subject to Prof_Student_64_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,64,i] = 1;
subject to Prof_Student_64_Minor:
	sum {k in DEPT14} P[k,64,2] = 1;
subject to Prof_Student_64_AtLarge_D1:
	(sum {k in DIV1} (P[k,64,1] + P[k,64,2])) * sum {k in DIV1} P[k,64,3] = 0;
subject to Prof_Student_64_AtLarge_D2:
	(sum {k in DIV2} (P[k,64,1] + P[k,64,2])) * sum {k in DIV2} P[k,64,3] = 0;
subject to Prof_Student_64_AtLarge_D3:
	(sum {k in DIV3} (P[k,64,1] + P[k,64,2])) * sum {k in DIV3} P[k,64,3] = 0;
subject to Prof_Student_65_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,65,i] = 1;
subject to Prof_Student_65_Minor:
	sum {k in DEPT18} P[k,65,2] = 1;
subject to Prof_Student_65_AtLarge_D1:
	(sum {k in DIV1} (P[k,65,1] + P[k,65,2])) * sum {k in DIV1} P[k,65,3] = 0;
subject to Prof_Student_65_AtLarge_D2:
	(sum {k in DIV2} (P[k,65,1] + P[k,65,2])) * sum {k in DIV2} P[k,65,3] = 0;
subject to Prof_Student_65_AtLarge_D3:
	(sum {k in DIV3} (P[k,65,1] + P[k,65,2])) * sum {k in DIV3} P[k,65,3] = 0;
subject to Prof_Student_66_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,66,i] = 1;
subject to Prof_Student_66_Minor:
	sum {k in DEPT7} P[k,66,2] = 1;
subject to Prof_Student_66_AtLarge_D1:
	(sum {k in DIV1} (P[k,66,1] + P[k,66,2])) * sum {k in DIV1} P[k,66,3] = 0;
subject to Prof_Student_66_AtLarge_D2:
	(sum {k in DIV2} (P[k,66,1] + P[k,66,2])) * sum {k in DIV2} P[k,66,3] = 0;
subject to Prof_Student_66_AtLarge_D3:
	(sum {k in DIV3} (P[k,66,1] + P[k,66,2])) * sum {k in DIV3} P[k,66,3] = 0;
subject to Prof_Student_67_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,67,i] = 1;
subject to Prof_Student_67_Minor:
	sum {k in DEPT1} P[k,67,2] = 1;
subject to Prof_Student_67_AtLarge_D1:
	(sum {k in DIV1} (P[k,67,1] + P[k,67,2])) * sum {k in DIV1} P[k,67,3] = 0;
subject to Prof_Student_67_AtLarge_D2:
	(sum {k in DIV2} (P[k,67,1] + P[k,67,2])) * sum {k in DIV2} P[k,67,3] = 0;
subject to Prof_Student_67_AtLarge_D3:
	(sum {k in DIV3} (P[k,67,1] + P[k,67,2])) * sum {k in DIV3} P[k,67,3] = 0;
subject to Prof_Student_68_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,68,i] = 1;
subject to Prof_Student_68_Minor:
	sum {k in DEPT0} P[k,68,2] = 1;
subject to Prof_Student_68_AtLarge_D1:
	(sum {k in DIV1} (P[k,68,1] + P[k,68,2])) * sum {k in DIV1} P[k,68,3] = 0;
subject to Prof_Student_68_AtLarge_D2:
	(sum {k in DIV2} (P[k,68,1] + P[k,68,2])) * sum {k in DIV2} P[k,68,3] = 0;
subject to Prof_Student_68_AtLarge_D3:
	(sum {k in DIV3} (P[k,68,1] + P[k,68,2])) * sum {k in DIV3} P[k,68,3] = 0;
subject to Prof_Student_69_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,69,i] = 1;
subject to Prof_Student_69_Minor:
	sum {k in DEPT8} P[k,69,2] = 1;
subject to Prof_Student_69_AtLarge_D1:
	(sum {k in DIV1} (P[k,69,1] + P[k,69,2])) * sum {k in DIV1} P[k,69,3] = 0;
subject to Prof_Student_69_AtLarge_D2:
	(sum {k in DIV2} (P[k,69,1] + P[k,69,2])) * sum {k in DIV2} P[k,69,3] = 0;
subject to Prof_Student_69_AtLarge_D3:
	(sum {k in DIV3} (P[k,69,1] + P[k,69,2])) * sum {k in DIV3} P[k,69,3] = 0;
subject to Prof_Student_70_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,70,i] = 1;
subject to Prof_Student_70_Minor:
	sum {k in DEPT3} P[k,70,2] = 1;
subject to Prof_Student_70_AtLarge_D1:
	(sum {k in DIV1} (P[k,70,1] + P[k,70,2])) * sum {k in DIV1} P[k,70,3] = 0;
subject to Prof_Student_70_AtLarge_D2:
	(sum {k in DIV2} (P[k,70,1] + P[k,70,2])) * sum {k in DIV2} P[k,70,3] = 0;
subject to Prof_Student_70_AtLarge_D3:
	(sum {k in DIV3} (P[k,70,1] + P[k,70,2])) * sum {k in DIV3} P[k,70,3] = 0;
subject to Prof_Student_71_Dept_25:
	sum {k in DEPT25, i in 1..2} P[k,71,i] = 1;
subject to Prof_Student_71_Dept_15:
	sum {k in DEPT15, i in 1..2} P[k,71,i] = 1;
subject to Prof_Student_71_AtLarge_D1:
	(sum {k in DIV1} (P[k,71,1] + P[k,71,2])) * sum {k in DIV1} P[k,71,3] = 0;
subject to Prof_Student_71_AtLarge_D2:
	(sum {k in DIV2} (P[k,71,1] + P[k,71,2])) * sum {k in DIV2} P[k,71,3] = 0;
subject to Prof_Student_71_AtLarge_D3:
	(sum {k in DIV3} (P[k,71,1] + P[k,71,2])) * sum {k in DIV3} P[k,71,3] = 0;
subject to Prof_Student_72_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,72,i] = 1;
subject to Prof_Student_72_Minor:
	sum {k in DEPT21} P[k,72,2] = 1;
subject to Prof_Student_72_AtLarge_D1:
	(sum {k in DIV1} (P[k,72,1] + P[k,72,2])) * sum {k in DIV1} P[k,72,3] = 0;
subject to Prof_Student_72_AtLarge_D2:
	(sum {k in DIV2} (P[k,72,1] + P[k,72,2])) * sum {k in DIV2} P[k,72,3] = 0;
subject to Prof_Student_72_AtLarge_D3:
	(sum {k in DIV3} (P[k,72,1] + P[k,72,2])) * sum {k in DIV3} P[k,72,3] = 0;
subject to Prof_Student_73_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,73,i] = 1;
subject to Prof_Student_73_Minor:
	sum {k in DEPT1} P[k,73,2] = 1;
subject to Prof_Student_73_AtLarge_D1:
	(sum {k in DIV1} (P[k,73,1] + P[k,73,2])) * sum {k in DIV1} P[k,73,3] = 0;
subject to Prof_Student_73_AtLarge_D2:
	(sum {k in DIV2} (P[k,73,1] + P[k,73,2])) * sum {k in DIV2} P[k,73,3] = 0;
subject to Prof_Student_73_AtLarge_D3:
	(sum {k in DIV3} (P[k,73,1] + P[k,73,2])) * sum {k in DIV3} P[k,73,3] = 0;
subject to Prof_Student_74_Dept_7:
	sum {k in DEPT7, i in 1..1} P[k,74,i] = 1;
subject to Prof_Student_74_Minor:
	sum {k in DEPT6} P[k,74,2] = 1;
subject to Prof_Student_74_AtLarge_D1:
	(sum {k in DIV1} (P[k,74,1] + P[k,74,2])) * sum {k in DIV1} P[k,74,3] = 0;
subject to Prof_Student_74_AtLarge_D2:
	(sum {k in DIV2} (P[k,74,1] + P[k,74,2])) * sum {k in DIV2} P[k,74,3] = 0;
subject to Prof_Student_74_AtLarge_D3:
	(sum {k in DIV3} (P[k,74,1] + P[k,74,2])) * sum {k in DIV3} P[k,74,3] = 0;
subject to Prof_Student_75_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,75,i] = 1;
subject to Prof_Student_75_Minor:
	sum {k in DEPT6} P[k,75,2] = 1;
subject to Prof_Student_75_AtLarge_D1:
	(sum {k in DIV1} (P[k,75,1] + P[k,75,2])) * sum {k in DIV1} P[k,75,3] = 0;
subject to Prof_Student_75_AtLarge_D2:
	(sum {k in DIV2} (P[k,75,1] + P[k,75,2])) * sum {k in DIV2} P[k,75,3] = 0;
subject to Prof_Student_75_AtLarge_D3:
	(sum {k in DIV3} (P[k,75,1] + P[k,75,2])) * sum {k in DIV3} P[k,75,3] = 0;
subject to Prof_Student_76_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,76,i] = 1;
subject to Prof_Student_76_Minor:
	sum {k in DEPT17} P[k,76,2] = 1;
subject to Prof_Student_76_AtLarge_D1:
	(sum {k in DIV1} (P[k,76,1] + P[k,76,2])) * sum {k in DIV1} P[k,76,3] = 0;
subject to Prof_Student_76_AtLarge_D2:
	(sum {k in DIV2} (P[k,76,1] + P[k,76,2])) * sum {k in DIV2} P[k,76,3] = 0;
subject to Prof_Student_76_AtLarge_D3:
	(sum {k in DIV3} (P[k,76,1] + P[k,76,2])) * sum {k in DIV3} P[k,76,3] = 0;
subject to Prof_Student_77_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,77,i] = 1;
subject to Prof_Student_77_Minor:
	sum {k in DEPT21} P[k,77,2] = 1;
subject to Prof_Student_77_AtLarge_D1:
	(sum {k in DIV1} (P[k,77,1] + P[k,77,2])) * sum {k in DIV1} P[k,77,3] = 0;
subject to Prof_Student_77_AtLarge_D2:
	(sum {k in DIV2} (P[k,77,1] + P[k,77,2])) * sum {k in DIV2} P[k,77,3] = 0;
subject to Prof_Student_77_AtLarge_D3:
	(sum {k in DIV3} (P[k,77,1] + P[k,77,2])) * sum {k in DIV3} P[k,77,3] = 0;
subject to Prof_Student_78_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,78,i] = 1;
subject to Prof_Student_78_Minor:
	sum {k in DEPT1} P[k,78,2] = 1;
subject to Prof_Student_78_AtLarge_D1:
	(sum {k in DIV1} (P[k,78,1] + P[k,78,2])) * sum {k in DIV1} P[k,78,3] = 0;
subject to Prof_Student_78_AtLarge_D2:
	(sum {k in DIV2} (P[k,78,1] + P[k,78,2])) * sum {k in DIV2} P[k,78,3] = 0;
subject to Prof_Student_78_AtLarge_D3:
	(sum {k in DIV3} (P[k,78,1] + P[k,78,2])) * sum {k in DIV3} P[k,78,3] = 0;
subject to Prof_Student_79_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,79,i] = 1;
subject to Prof_Student_79_Minor:
	sum {k in DEPT6} P[k,79,2] = 1;
subject to Prof_Student_79_AtLarge_D1:
	(sum {k in DIV1} (P[k,79,1] + P[k,79,2])) * sum {k in DIV1} P[k,79,3] = 0;
subject to Prof_Student_79_AtLarge_D2:
	(sum {k in DIV2} (P[k,79,1] + P[k,79,2])) * sum {k in DIV2} P[k,79,3] = 0;
subject to Prof_Student_79_AtLarge_D3:
	(sum {k in DIV3} (P[k,79,1] + P[k,79,2])) * sum {k in DIV3} P[k,79,3] = 0;
subject to Prof_Student_80_Dept_5:
	sum {k in DEPT5, i in 1..2} P[k,80,i] = 1;
subject to Prof_Student_80_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,80,i] = 1;
subject to Prof_Student_80_AtLarge_D1:
	(sum {k in DIV1} (P[k,80,1] + P[k,80,2])) * sum {k in DIV1} P[k,80,3] = 0;
subject to Prof_Student_80_AtLarge_D2:
	(sum {k in DIV2} (P[k,80,1] + P[k,80,2])) * sum {k in DIV2} P[k,80,3] = 0;
subject to Prof_Student_80_AtLarge_D3:
	(sum {k in DIV3} (P[k,80,1] + P[k,80,2])) * sum {k in DIV3} P[k,80,3] = 0;
subject to Prof_Student_81_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,81,i] = 1;
subject to Prof_Student_81_Minor:
	sum {k in DEPT6} P[k,81,2] = 1;
subject to Prof_Student_81_AtLarge_D1:
	(sum {k in DIV1} (P[k,81,1] + P[k,81,2])) * sum {k in DIV1} P[k,81,3] = 0;
subject to Prof_Student_81_AtLarge_D2:
	(sum {k in DIV2} (P[k,81,1] + P[k,81,2])) * sum {k in DIV2} P[k,81,3] = 0;
subject to Prof_Student_81_AtLarge_D3:
	(sum {k in DIV3} (P[k,81,1] + P[k,81,2])) * sum {k in DIV3} P[k,81,3] = 0;
subject to Prof_Student_82_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,82,i] = 1;
subject to Prof_Student_82_Minor:
	sum {k in DEPT14} P[k,82,2] = 1;
subject to Prof_Student_82_AtLarge_D1:
	(sum {k in DIV1} (P[k,82,1] + P[k,82,2])) * sum {k in DIV1} P[k,82,3] = 0;
subject to Prof_Student_82_AtLarge_D2:
	(sum {k in DIV2} (P[k,82,1] + P[k,82,2])) * sum {k in DIV2} P[k,82,3] = 0;
subject to Prof_Student_82_AtLarge_D3:
	(sum {k in DIV3} (P[k,82,1] + P[k,82,2])) * sum {k in DIV3} P[k,82,3] = 0;
subject to Prof_Student_83_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,83,i] = 1;
subject to Prof_Student_83_Minor:
	sum {k in DEPT6} P[k,83,2] = 1;
subject to Prof_Student_83_AtLarge_D1:
	(sum {k in DIV1} (P[k,83,1] + P[k,83,2])) * sum {k in DIV1} P[k,83,3] = 0;
subject to Prof_Student_83_AtLarge_D2:
	(sum {k in DIV2} (P[k,83,1] + P[k,83,2])) * sum {k in DIV2} P[k,83,3] = 0;
subject to Prof_Student_83_AtLarge_D3:
	(sum {k in DIV3} (P[k,83,1] + P[k,83,2])) * sum {k in DIV3} P[k,83,3] = 0;
subject to Prof_Student_84_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,84,i] = 1;
subject to Prof_Student_84_Minor:
	sum {k in DEPT17} P[k,84,2] = 1;
subject to Prof_Student_84_AtLarge_D1:
	(sum {k in DIV1} (P[k,84,1] + P[k,84,2])) * sum {k in DIV1} P[k,84,3] = 0;
subject to Prof_Student_84_AtLarge_D2:
	(sum {k in DIV2} (P[k,84,1] + P[k,84,2])) * sum {k in DIV2} P[k,84,3] = 0;
subject to Prof_Student_84_AtLarge_D3:
	(sum {k in DIV3} (P[k,84,1] + P[k,84,2])) * sum {k in DIV3} P[k,84,3] = 0;
subject to Prof_Student_85_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,85,i] = 1;
subject to Prof_Student_85_Minor:
	sum {k in DEPT2} P[k,85,2] = 1;
subject to Prof_Student_85_AtLarge_D1:
	(sum {k in DIV1} (P[k,85,1] + P[k,85,2])) * sum {k in DIV1} P[k,85,3] = 0;
subject to Prof_Student_85_AtLarge_D2:
	(sum {k in DIV2} (P[k,85,1] + P[k,85,2])) * sum {k in DIV2} P[k,85,3] = 0;
subject to Prof_Student_85_AtLarge_D3:
	(sum {k in DIV3} (P[k,85,1] + P[k,85,2])) * sum {k in DIV3} P[k,85,3] = 0;
subject to Prof_Student_86_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,86,i] = 1;
subject to Prof_Student_86_Minor:
	sum {k in DEPT21} P[k,86,2] = 1;
subject to Prof_Student_86_AtLarge_D1:
	(sum {k in DIV1} (P[k,86,1] + P[k,86,2])) * sum {k in DIV1} P[k,86,3] = 0;
subject to Prof_Student_86_AtLarge_D2:
	(sum {k in DIV2} (P[k,86,1] + P[k,86,2])) * sum {k in DIV2} P[k,86,3] = 0;
subject to Prof_Student_86_AtLarge_D3:
	(sum {k in DIV3} (P[k,86,1] + P[k,86,2])) * sum {k in DIV3} P[k,86,3] = 0;
subject to Prof_Student_87_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,87,i] = 1;
subject to Prof_Student_87_Minor:
	sum {k in DEPT10} P[k,87,2] = 1;
subject to Prof_Student_87_AtLarge_D1:
	(sum {k in DIV1} (P[k,87,1] + P[k,87,2])) * sum {k in DIV1} P[k,87,3] = 0;
subject to Prof_Student_87_AtLarge_D2:
	(sum {k in DIV2} (P[k,87,1] + P[k,87,2])) * sum {k in DIV2} P[k,87,3] = 0;
subject to Prof_Student_87_AtLarge_D3:
	(sum {k in DIV3} (P[k,87,1] + P[k,87,2])) * sum {k in DIV3} P[k,87,3] = 0;
subject to Prof_Student_88_Dept_4:
	sum {k in DEPT4, i in 1..2} P[k,88,i] = 1;
subject to Prof_Student_88_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,88,i] = 1;
subject to Prof_Student_88_AtLarge_D1:
	(sum {k in DIV1} (P[k,88,1] + P[k,88,2])) * sum {k in DIV1} P[k,88,3] = 0;
subject to Prof_Student_88_AtLarge_D2:
	(sum {k in DIV2} (P[k,88,1] + P[k,88,2])) * sum {k in DIV2} P[k,88,3] = 0;
subject to Prof_Student_88_AtLarge_D3:
	(sum {k in DIV3} (P[k,88,1] + P[k,88,2])) * sum {k in DIV3} P[k,88,3] = 0;
subject to Prof_Student_89_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,89,i] = 1;
subject to Prof_Student_89_Minor:
	sum {k in DEPT19} P[k,89,2] = 1;
subject to Prof_Student_89_AtLarge_D1:
	(sum {k in DIV1} (P[k,89,1] + P[k,89,2])) * sum {k in DIV1} P[k,89,3] = 0;
subject to Prof_Student_89_AtLarge_D2:
	(sum {k in DIV2} (P[k,89,1] + P[k,89,2])) * sum {k in DIV2} P[k,89,3] = 0;
subject to Prof_Student_89_AtLarge_D3:
	(sum {k in DIV3} (P[k,89,1] + P[k,89,2])) * sum {k in DIV3} P[k,89,3] = 0;
subject to Prof_Student_90_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,90,i] = 1;
subject to Prof_Student_90_Minor:
	sum {k in (DEPT5 union DEPT26)} P[k,90,2] = 1;
subject to Prof_Student_90_AtLarge_D1:
	(sum {k in DIV1} (P[k,90,1] + P[k,90,2])) * sum {k in DIV1} P[k,90,3] = 0;
subject to Prof_Student_90_AtLarge_D2:
	(sum {k in DIV2} (P[k,90,1] + P[k,90,2])) * sum {k in DIV2} P[k,90,3] = 0;
subject to Prof_Student_90_AtLarge_D3:
	(sum {k in DIV3} (P[k,90,1] + P[k,90,2])) * sum {k in DIV3} P[k,90,3] = 0;
subject to Prof_Student_91_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,91,i] = 1;
subject to Prof_Student_91_Minor:
	sum {k in DEPT9} P[k,91,2] = 1;
subject to Prof_Student_91_AtLarge_D1:
	(sum {k in DIV1} (P[k,91,1] + P[k,91,2])) * sum {k in DIV1} P[k,91,3] = 0;
subject to Prof_Student_91_AtLarge_D2:
	(sum {k in DIV2} (P[k,91,1] + P[k,91,2])) * sum {k in DIV2} P[k,91,3] = 0;
subject to Prof_Student_91_AtLarge_D3:
	(sum {k in DIV3} (P[k,91,1] + P[k,91,2])) * sum {k in DIV3} P[k,91,3] = 0;
subject to Prof_Student_92_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,92,i] = 1;
subject to Prof_Student_92_Minor:
	sum {k in (DEPT6 union DEPT26)} P[k,92,2] = 1;
subject to Prof_Student_92_AtLarge_D1:
	(sum {k in DIV1} (P[k,92,1] + P[k,92,2])) * sum {k in DIV1} P[k,92,3] = 0;
subject to Prof_Student_92_AtLarge_D2:
	(sum {k in DIV2} (P[k,92,1] + P[k,92,2])) * sum {k in DIV2} P[k,92,3] = 0;
subject to Prof_Student_92_AtLarge_D3:
	(sum {k in DIV3} (P[k,92,1] + P[k,92,2])) * sum {k in DIV3} P[k,92,3] = 0;
subject to Prof_Student_93_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,93,i] = 1;
subject to Prof_Student_93_Minor:
	sum {k in DEPT6} P[k,93,2] = 1;
subject to Prof_Student_93_AtLarge_D1:
	(sum {k in DIV1} (P[k,93,1] + P[k,93,2])) * sum {k in DIV1} P[k,93,3] = 0;
subject to Prof_Student_93_AtLarge_D2:
	(sum {k in DIV2} (P[k,93,1] + P[k,93,2])) * sum {k in DIV2} P[k,93,3] = 0;
subject to Prof_Student_93_AtLarge_D3:
	(sum {k in DIV3} (P[k,93,1] + P[k,93,2])) * sum {k in DIV3} P[k,93,3] = 0;
subject to Prof_Student_94_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,94,i] = 1;
subject to Prof_Student_94_Minor:
	sum {k in DEPT6} P[k,94,2] = 1;
subject to Prof_Student_94_AtLarge_D1:
	(sum {k in DIV1} (P[k,94,1] + P[k,94,2])) * sum {k in DIV1} P[k,94,3] = 0;
subject to Prof_Student_94_AtLarge_D2:
	(sum {k in DIV2} (P[k,94,1] + P[k,94,2])) * sum {k in DIV2} P[k,94,3] = 0;
subject to Prof_Student_94_AtLarge_D3:
	(sum {k in DIV3} (P[k,94,1] + P[k,94,2])) * sum {k in DIV3} P[k,94,3] = 0;
subject to Prof_Student_95_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,95,i] = 1;
subject to Prof_Student_95_Minor:
	sum {k in (DEPT9 union DEPT4)} P[k,95,2] = 1;
subject to Prof_Student_95_AtLarge_D1:
	(sum {k in DIV1} (P[k,95,1] + P[k,95,2])) * sum {k in DIV1} P[k,95,3] = 0;
subject to Prof_Student_95_AtLarge_D2:
	(sum {k in DIV2} (P[k,95,1] + P[k,95,2])) * sum {k in DIV2} P[k,95,3] = 0;
subject to Prof_Student_95_AtLarge_D3:
	(sum {k in DIV3} (P[k,95,1] + P[k,95,2])) * sum {k in DIV3} P[k,95,3] = 0;
subject to Prof_Student_96_Dept_2:
	sum {k in DEPT2, i in 1..2} P[k,96,i] = 1;
subject to Prof_Student_96_Dept_3:
	sum {k in DEPT3, i in 1..2} P[k,96,i] = 1;
subject to Prof_Student_96_AtLarge_D1:
	(sum {k in DIV1} (P[k,96,1] + P[k,96,2])) * sum {k in DIV1} P[k,96,3] = 0;
subject to Prof_Student_96_AtLarge_D2:
	(sum {k in DIV2} (P[k,96,1] + P[k,96,2])) * sum {k in DIV2} P[k,96,3] = 0;
subject to Prof_Student_96_AtLarge_D3:
	(sum {k in DIV3} (P[k,96,1] + P[k,96,2])) * sum {k in DIV3} P[k,96,3] = 0;
subject to Prof_Student_97_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,97,i] = 1;
subject to Prof_Student_97_Minor:
	sum {k in DEPT10} P[k,97,2] = 1;
subject to Prof_Student_97_AtLarge_D1:
	(sum {k in DIV1} (P[k,97,1] + P[k,97,2])) * sum {k in DIV1} P[k,97,3] = 0;
subject to Prof_Student_97_AtLarge_D2:
	(sum {k in DIV2} (P[k,97,1] + P[k,97,2])) * sum {k in DIV2} P[k,97,3] = 0;
subject to Prof_Student_97_AtLarge_D3:
	(sum {k in DIV3} (P[k,97,1] + P[k,97,2])) * sum {k in DIV3} P[k,97,3] = 0;
subject to Prof_Student_98_Dept_19:
	sum {k in DEPT19, i in 1..1} P[k,98,i] = 1;
subject to Prof_Student_98_Minor:
	sum {k in (DEPT18 union DEPT23)} P[k,98,2] = 1;
subject to Prof_Student_98_AtLarge_D1:
	(sum {k in DIV1} (P[k,98,1] + P[k,98,2])) * sum {k in DIV1} P[k,98,3] = 0;
subject to Prof_Student_98_AtLarge_D2:
	(sum {k in DIV2} (P[k,98,1] + P[k,98,2])) * sum {k in DIV2} P[k,98,3] = 0;
subject to Prof_Student_98_AtLarge_D3:
	(sum {k in DIV3} (P[k,98,1] + P[k,98,2])) * sum {k in DIV3} P[k,98,3] = 0;
subject to Prof_Student_99_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,99,i] = 1;
subject to Prof_Student_99_Minor:
	sum {k in DEPT6} P[k,99,2] = 1;
subject to Prof_Student_99_AtLarge_D1:
	(sum {k in DIV1} (P[k,99,1] + P[k,99,2])) * sum {k in DIV1} P[k,99,3] = 0;
subject to Prof_Student_99_AtLarge_D2:
	(sum {k in DIV2} (P[k,99,1] + P[k,99,2])) * sum {k in DIV2} P[k,99,3] = 0;
subject to Prof_Student_99_AtLarge_D3:
	(sum {k in DIV3} (P[k,99,1] + P[k,99,2])) * sum {k in DIV3} P[k,99,3] = 0;
subject to Prof_Student_100_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,100,i] = 1;
subject to Prof_Student_100_Minor:
	sum {k in DEPT23} P[k,100,2] = 1;
subject to Prof_Student_100_AtLarge_D1:
	(sum {k in DIV1} (P[k,100,1] + P[k,100,2])) * sum {k in DIV1} P[k,100,3] = 0;
subject to Prof_Student_100_AtLarge_D2:
	(sum {k in DIV2} (P[k,100,1] + P[k,100,2])) * sum {k in DIV2} P[k,100,3] = 0;
subject to Prof_Student_100_AtLarge_D3:
	(sum {k in DIV3} (P[k,100,1] + P[k,100,2])) * sum {k in DIV3} P[k,100,3] = 0;
subject to Prof_Student_101_Dept_23:
	sum {k in DEPT23, i in 1..2} P[k,101,i] = 1;
subject to Prof_Student_101_Dept_0:
	sum {k in DEPT0, i in 1..2} P[k,101,i] = 1;
subject to Prof_Student_101_AtLarge_D1:
	(sum {k in DIV1} (P[k,101,1] + P[k,101,2])) * sum {k in DIV1} P[k,101,3] = 0;
subject to Prof_Student_101_AtLarge_D2:
	(sum {k in DIV2} (P[k,101,1] + P[k,101,2])) * sum {k in DIV2} P[k,101,3] = 0;
subject to Prof_Student_101_AtLarge_D3:
	(sum {k in DIV3} (P[k,101,1] + P[k,101,2])) * sum {k in DIV3} P[k,101,3] = 0;
subject to Prof_Student_102_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,102,i] = 1;
subject to Prof_Student_102_Minor:
	sum {k in DEPT14} P[k,102,2] = 1;
subject to Prof_Student_102_AtLarge_D1:
	(sum {k in DIV1} (P[k,102,1] + P[k,102,2])) * sum {k in DIV1} P[k,102,3] = 0;
subject to Prof_Student_102_AtLarge_D2:
	(sum {k in DIV2} (P[k,102,1] + P[k,102,2])) * sum {k in DIV2} P[k,102,3] = 0;
subject to Prof_Student_102_AtLarge_D3:
	(sum {k in DIV3} (P[k,102,1] + P[k,102,2])) * sum {k in DIV3} P[k,102,3] = 0;
subject to Prof_Student_103_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,103,i] = 1;
subject to Prof_Student_103_Minor:
	sum {k in (DEPT22 union DEPT14)} P[k,103,2] = 1;
subject to Prof_Student_103_AtLarge_D1:
	(sum {k in DIV1} (P[k,103,1] + P[k,103,2])) * sum {k in DIV1} P[k,103,3] = 0;
subject to Prof_Student_103_AtLarge_D2:
	(sum {k in DIV2} (P[k,103,1] + P[k,103,2])) * sum {k in DIV2} P[k,103,3] = 0;
subject to Prof_Student_103_AtLarge_D3:
	(sum {k in DIV3} (P[k,103,1] + P[k,103,2])) * sum {k in DIV3} P[k,103,3] = 0;
subject to Prof_Student_104_Dept_1:
	sum {k in DEPT1, i in 1..2} P[k,104,i] = 1;
subject to Prof_Student_104_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,104,i] = 1;
subject to Prof_Student_104_AtLarge_D1:
	(sum {k in DIV1} (P[k,104,1] + P[k,104,2])) * sum {k in DIV1} P[k,104,3] = 0;
subject to Prof_Student_104_AtLarge_D2:
	(sum {k in DIV2} (P[k,104,1] + P[k,104,2])) * sum {k in DIV2} P[k,104,3] = 0;
subject to Prof_Student_104_AtLarge_D3:
	(sum {k in DIV3} (P[k,104,1] + P[k,104,2])) * sum {k in DIV3} P[k,104,3] = 0;
subject to Prof_Student_105_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,105,i] = 1;
subject to Prof_Student_105_Minor:
	sum {k in (DEPT11 union DEPT6)} P[k,105,2] = 1;
subject to Prof_Student_105_AtLarge_D1:
	(sum {k in DIV1} (P[k,105,1] + P[k,105,2])) * sum {k in DIV1} P[k,105,3] = 0;
subject to Prof_Student_105_AtLarge_D2:
	(sum {k in DIV2} (P[k,105,1] + P[k,105,2])) * sum {k in DIV2} P[k,105,3] = 0;
subject to Prof_Student_105_AtLarge_D3:
	(sum {k in DIV3} (P[k,105,1] + P[k,105,2])) * sum {k in DIV3} P[k,105,3] = 0;
subject to Prof_Student_106_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,106,i] = 1;
subject to Prof_Student_106_Minor:
	sum {k in DEPT11} P[k,106,2] = 1;
subject to Prof_Student_106_AtLarge_D1:
	(sum {k in DIV1} (P[k,106,1] + P[k,106,2])) * sum {k in DIV1} P[k,106,3] = 0;
subject to Prof_Student_106_AtLarge_D2:
	(sum {k in DIV2} (P[k,106,1] + P[k,106,2])) * sum {k in DIV2} P[k,106,3] = 0;
subject to Prof_Student_106_AtLarge_D3:
	(sum {k in DIV3} (P[k,106,1] + P[k,106,2])) * sum {k in DIV3} P[k,106,3] = 0;
subject to Prof_Student_107_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,107,i] = 1;
subject to Prof_Student_107_Minor:
	sum {k in DEPT11} P[k,107,2] = 1;
subject to Prof_Student_107_AtLarge_D1:
	(sum {k in DIV1} (P[k,107,1] + P[k,107,2])) * sum {k in DIV1} P[k,107,3] = 0;
subject to Prof_Student_107_AtLarge_D2:
	(sum {k in DIV2} (P[k,107,1] + P[k,107,2])) * sum {k in DIV2} P[k,107,3] = 0;
subject to Prof_Student_107_AtLarge_D3:
	(sum {k in DIV3} (P[k,107,1] + P[k,107,2])) * sum {k in DIV3} P[k,107,3] = 0;
subject to Prof_Student_108_Dept_4:
	sum {k in DEPT4, i in 1..2} P[k,108,i] = 1;
subject to Prof_Student_108_Dept_7:
	sum {k in DEPT7, i in 1..2} P[k,108,i] = 1;
subject to Prof_Student_108_AtLarge_D1:
	(sum {k in DIV1} (P[k,108,1] + P[k,108,2])) * sum {k in DIV1} P[k,108,3] = 0;
subject to Prof_Student_108_AtLarge_D2:
	(sum {k in DIV2} (P[k,108,1] + P[k,108,2])) * sum {k in DIV2} P[k,108,3] = 0;
subject to Prof_Student_108_AtLarge_D3:
	(sum {k in DIV3} (P[k,108,1] + P[k,108,2])) * sum {k in DIV3} P[k,108,3] = 0;
subject to Prof_Student_109_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,109,i] = 1;
subject to Prof_Student_109_Minor:
	sum {k in DEPT10} P[k,109,2] = 1;
subject to Prof_Student_109_AtLarge_D1:
	(sum {k in DIV1} (P[k,109,1] + P[k,109,2])) * sum {k in DIV1} P[k,109,3] = 0;
subject to Prof_Student_109_AtLarge_D2:
	(sum {k in DIV2} (P[k,109,1] + P[k,109,2])) * sum {k in DIV2} P[k,109,3] = 0;
subject to Prof_Student_109_AtLarge_D3:
	(sum {k in DIV3} (P[k,109,1] + P[k,109,2])) * sum {k in DIV3} P[k,109,3] = 0;
subject to Prof_Student_110_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,110,i] = 1;
subject to Prof_Student_110_Minor:
	sum {k in DEPT15} P[k,110,2] = 1;
subject to Prof_Student_110_AtLarge_D1:
	(sum {k in DIV1} (P[k,110,1] + P[k,110,2])) * sum {k in DIV1} P[k,110,3] = 0;
subject to Prof_Student_110_AtLarge_D2:
	(sum {k in DIV2} (P[k,110,1] + P[k,110,2])) * sum {k in DIV2} P[k,110,3] = 0;
subject to Prof_Student_110_AtLarge_D3:
	(sum {k in DIV3} (P[k,110,1] + P[k,110,2])) * sum {k in DIV3} P[k,110,3] = 0;
subject to Prof_Student_111_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,111,i] = 1;
subject to Prof_Student_111_Minor:
	sum {k in (DEPT18 union DEPT7)} P[k,111,2] = 1;
subject to Prof_Student_111_AtLarge_D1:
	(sum {k in DIV1} (P[k,111,1] + P[k,111,2])) * sum {k in DIV1} P[k,111,3] = 0;
subject to Prof_Student_111_AtLarge_D2:
	(sum {k in DIV2} (P[k,111,1] + P[k,111,2])) * sum {k in DIV2} P[k,111,3] = 0;
subject to Prof_Student_111_AtLarge_D3:
	(sum {k in DIV3} (P[k,111,1] + P[k,111,2])) * sum {k in DIV3} P[k,111,3] = 0;
subject to Prof_Student_112_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,112,i] = 1;
subject to Prof_Student_112_Minor:
	sum {k in DEPT7} P[k,112,2] = 1;
subject to Prof_Student_112_AtLarge_D1:
	(sum {k in DIV1} (P[k,112,1] + P[k,112,2])) * sum {k in DIV1} P[k,112,3] = 0;
subject to Prof_Student_112_AtLarge_D2:
	(sum {k in DIV2} (P[k,112,1] + P[k,112,2])) * sum {k in DIV2} P[k,112,3] = 0;
subject to Prof_Student_112_AtLarge_D3:
	(sum {k in DIV3} (P[k,112,1] + P[k,112,2])) * sum {k in DIV3} P[k,112,3] = 0;
subject to Prof_Student_113_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,113,i] = 1;
subject to Prof_Student_113_Minor:
	sum {k in DEPT18} P[k,113,2] = 1;
subject to Prof_Student_113_AtLarge_D1:
	(sum {k in DIV1} (P[k,113,1] + P[k,113,2])) * sum {k in DIV1} P[k,113,3] = 0;
subject to Prof_Student_113_AtLarge_D2:
	(sum {k in DIV2} (P[k,113,1] + P[k,113,2])) * sum {k in DIV2} P[k,113,3] = 0;
subject to Prof_Student_113_AtLarge_D3:
	(sum {k in DIV3} (P[k,113,1] + P[k,113,2])) * sum {k in DIV3} P[k,113,3] = 0;
subject to Prof_Student_114_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,114,i] = 1;
subject to Prof_Student_114_Minor:
	sum {k in (DEPT26 union DEPT10 union DEPT16)} P[k,114,2] = 1;
subject to Prof_Student_114_AtLarge_D1:
	(sum {k in DIV1} (P[k,114,1] + P[k,114,2])) * sum {k in DIV1} P[k,114,3] = 0;
subject to Prof_Student_114_AtLarge_D2:
	(sum {k in DIV2} (P[k,114,1] + P[k,114,2])) * sum {k in DIV2} P[k,114,3] = 0;
subject to Prof_Student_114_AtLarge_D3:
	(sum {k in DIV3} (P[k,114,1] + P[k,114,2])) * sum {k in DIV3} P[k,114,3] = 0;
subject to Prof_Student_115_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,115,i] = 1;
subject to Prof_Student_115_Minor:
	sum {k in DEPT10} P[k,115,2] = 1;
subject to Prof_Student_115_AtLarge_D1:
	(sum {k in DIV1} (P[k,115,1] + P[k,115,2])) * sum {k in DIV1} P[k,115,3] = 0;
subject to Prof_Student_115_AtLarge_D2:
	(sum {k in DIV2} (P[k,115,1] + P[k,115,2])) * sum {k in DIV2} P[k,115,3] = 0;
subject to Prof_Student_115_AtLarge_D3:
	(sum {k in DIV3} (P[k,115,1] + P[k,115,2])) * sum {k in DIV3} P[k,115,3] = 0;
subject to Prof_Student_116_Dept_9:
	sum {k in DEPT9, i in 1..2} P[k,116,i] = 1;
subject to Prof_Student_116_Dept_15:
	sum {k in DEPT15, i in 1..2} P[k,116,i] = 1;
subject to Prof_Student_116_AtLarge_D1:
	(sum {k in DIV1} (P[k,116,1] + P[k,116,2])) * sum {k in DIV1} P[k,116,3] = 0;
subject to Prof_Student_116_AtLarge_D2:
	(sum {k in DIV2} (P[k,116,1] + P[k,116,2])) * sum {k in DIV2} P[k,116,3] = 0;
subject to Prof_Student_116_AtLarge_D3:
	(sum {k in DIV3} (P[k,116,1] + P[k,116,2])) * sum {k in DIV3} P[k,116,3] = 0;
subject to Prof_Student_117_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,117,i] = 1;
subject to Prof_Student_117_Minor:
	sum {k in DEPT26} P[k,117,2] = 1;
subject to Prof_Student_117_AtLarge_D1:
	(sum {k in DIV1} (P[k,117,1] + P[k,117,2])) * sum {k in DIV1} P[k,117,3] = 0;
subject to Prof_Student_117_AtLarge_D2:
	(sum {k in DIV2} (P[k,117,1] + P[k,117,2])) * sum {k in DIV2} P[k,117,3] = 0;
subject to Prof_Student_117_AtLarge_D3:
	(sum {k in DIV3} (P[k,117,1] + P[k,117,2])) * sum {k in DIV3} P[k,117,3] = 0;
subject to Prof_Student_118_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,118,i] = 1;
subject to Prof_Student_118_Minor:
	sum {k in (DEPT5 union DEPT26)} P[k,118,2] = 1;
subject to Prof_Student_118_AtLarge_D1:
	(sum {k in DIV1} (P[k,118,1] + P[k,118,2])) * sum {k in DIV1} P[k,118,3] = 0;
subject to Prof_Student_118_AtLarge_D2:
	(sum {k in DIV2} (P[k,118,1] + P[k,118,2])) * sum {k in DIV2} P[k,118,3] = 0;
subject to Prof_Student_118_AtLarge_D3:
	(sum {k in DIV3} (P[k,118,1] + P[k,118,2])) * sum {k in DIV3} P[k,118,3] = 0;
subject to Prof_Student_119_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,119,i] = 1;
subject to Prof_Student_119_Minor:
	sum {k in DEPT26} P[k,119,2] = 1;
subject to Prof_Student_119_AtLarge_D1:
	(sum {k in DIV1} (P[k,119,1] + P[k,119,2])) * sum {k in DIV1} P[k,119,3] = 0;
subject to Prof_Student_119_AtLarge_D2:
	(sum {k in DIV2} (P[k,119,1] + P[k,119,2])) * sum {k in DIV2} P[k,119,3] = 0;
subject to Prof_Student_119_AtLarge_D3:
	(sum {k in DIV3} (P[k,119,1] + P[k,119,2])) * sum {k in DIV3} P[k,119,3] = 0;
subject to Prof_Student_120_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,120,i] = 1;
subject to Prof_Student_120_Minor:
	sum {k in (DEPT26 union DEPT4)} P[k,120,2] = 1;
subject to Prof_Student_120_AtLarge_D1:
	(sum {k in DIV1} (P[k,120,1] + P[k,120,2])) * sum {k in DIV1} P[k,120,3] = 0;
subject to Prof_Student_120_AtLarge_D2:
	(sum {k in DIV2} (P[k,120,1] + P[k,120,2])) * sum {k in DIV2} P[k,120,3] = 0;
subject to Prof_Student_120_AtLarge_D3:
	(sum {k in DIV3} (P[k,120,1] + P[k,120,2])) * sum {k in DIV3} P[k,120,3] = 0;
subject to Prof_Student_121_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,121,i] = 1;
subject to Prof_Student_121_Minor:
	sum {k in DEPT17} P[k,121,2] = 1;
subject to Prof_Student_121_AtLarge_D1:
	(sum {k in DIV1} (P[k,121,1] + P[k,121,2])) * sum {k in DIV1} P[k,121,3] = 0;
subject to Prof_Student_121_AtLarge_D2:
	(sum {k in DIV2} (P[k,121,1] + P[k,121,2])) * sum {k in DIV2} P[k,121,3] = 0;
subject to Prof_Student_121_AtLarge_D3:
	(sum {k in DIV3} (P[k,121,1] + P[k,121,2])) * sum {k in DIV3} P[k,121,3] = 0;
subject to Prof_Student_122_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,122,i] = 1;
subject to Prof_Student_122_Minor:
	sum {k in DEPT9} P[k,122,2] = 1;
subject to Prof_Student_122_AtLarge_D1:
	(sum {k in DIV1} (P[k,122,1] + P[k,122,2])) * sum {k in DIV1} P[k,122,3] = 0;
subject to Prof_Student_122_AtLarge_D2:
	(sum {k in DIV2} (P[k,122,1] + P[k,122,2])) * sum {k in DIV2} P[k,122,3] = 0;
subject to Prof_Student_122_AtLarge_D3:
	(sum {k in DIV3} (P[k,122,1] + P[k,122,2])) * sum {k in DIV3} P[k,122,3] = 0;
subject to Prof_Student_123_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,123,i] = 1;
subject to Prof_Student_123_Minor:
	sum {k in DEPT21} P[k,123,2] = 1;
subject to Prof_Student_123_AtLarge_D1:
	(sum {k in DIV1} (P[k,123,1] + P[k,123,2])) * sum {k in DIV1} P[k,123,3] = 0;
subject to Prof_Student_123_AtLarge_D2:
	(sum {k in DIV2} (P[k,123,1] + P[k,123,2])) * sum {k in DIV2} P[k,123,3] = 0;
subject to Prof_Student_123_AtLarge_D3:
	(sum {k in DIV3} (P[k,123,1] + P[k,123,2])) * sum {k in DIV3} P[k,123,3] = 0;
subject to Prof_Student_124_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,124,i] = 1;
subject to Prof_Student_124_Minor:
	sum {k in DEPT1} P[k,124,2] = 1;
subject to Prof_Student_124_AtLarge_D1:
	(sum {k in DIV1} (P[k,124,1] + P[k,124,2])) * sum {k in DIV1} P[k,124,3] = 0;
subject to Prof_Student_124_AtLarge_D2:
	(sum {k in DIV2} (P[k,124,1] + P[k,124,2])) * sum {k in DIV2} P[k,124,3] = 0;
subject to Prof_Student_124_AtLarge_D3:
	(sum {k in DIV3} (P[k,124,1] + P[k,124,2])) * sum {k in DIV3} P[k,124,3] = 0;
subject to Prof_Student_125_Dept_3:
	sum {k in DEPT3, i in 1..2} P[k,125,i] = 1;
subject to Prof_Student_125_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,125,i] = 1;
subject to Prof_Student_125_AtLarge_D1:
	(sum {k in DIV1} (P[k,125,1] + P[k,125,2])) * sum {k in DIV1} P[k,125,3] = 0;
subject to Prof_Student_125_AtLarge_D2:
	(sum {k in DIV2} (P[k,125,1] + P[k,125,2])) * sum {k in DIV2} P[k,125,3] = 0;
subject to Prof_Student_125_AtLarge_D3:
	(sum {k in DIV3} (P[k,125,1] + P[k,125,2])) * sum {k in DIV3} P[k,125,3] = 0;
subject to Prof_Student_126_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,126,i] = 1;
subject to Prof_Student_126_Minor:
	sum {k in DEPT9} P[k,126,2] = 1;
subject to Prof_Student_126_AtLarge_D1:
	(sum {k in DIV1} (P[k,126,1] + P[k,126,2])) * sum {k in DIV1} P[k,126,3] = 0;
subject to Prof_Student_126_AtLarge_D2:
	(sum {k in DIV2} (P[k,126,1] + P[k,126,2])) * sum {k in DIV2} P[k,126,3] = 0;
subject to Prof_Student_126_AtLarge_D3:
	(sum {k in DIV3} (P[k,126,1] + P[k,126,2])) * sum {k in DIV3} P[k,126,3] = 0;
subject to Prof_Student_127_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,127,i] = 1;
subject to Prof_Student_127_Minor:
	sum {k in DEPT11} P[k,127,2] = 1;
subject to Prof_Student_127_AtLarge_D1:
	(sum {k in DIV1} (P[k,127,1] + P[k,127,2])) * sum {k in DIV1} P[k,127,3] = 0;
subject to Prof_Student_127_AtLarge_D2:
	(sum {k in DIV2} (P[k,127,1] + P[k,127,2])) * sum {k in DIV2} P[k,127,3] = 0;
subject to Prof_Student_127_AtLarge_D3:
	(sum {k in DIV3} (P[k,127,1] + P[k,127,2])) * sum {k in DIV3} P[k,127,3] = 0;
subject to Prof_Student_128_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,128,i] = 1;
subject to Prof_Student_128_Minor:
	sum {k in DEPT4} P[k,128,2] = 1;
subject to Prof_Student_128_AtLarge_D1:
	(sum {k in DIV1} (P[k,128,1] + P[k,128,2])) * sum {k in DIV1} P[k,128,3] = 0;
subject to Prof_Student_128_AtLarge_D2:
	(sum {k in DIV2} (P[k,128,1] + P[k,128,2])) * sum {k in DIV2} P[k,128,3] = 0;
subject to Prof_Student_128_AtLarge_D3:
	(sum {k in DIV3} (P[k,128,1] + P[k,128,2])) * sum {k in DIV3} P[k,128,3] = 0;
subject to Prof_Student_129_Dept_7:
	sum {k in DEPT7, i in 1..1} P[k,129,i] = 1;
subject to Prof_Student_129_Minor:
	sum {k in DEPT10} P[k,129,2] = 1;
subject to Prof_Student_129_AtLarge_D1:
	(sum {k in DIV1} (P[k,129,1] + P[k,129,2])) * sum {k in DIV1} P[k,129,3] = 0;
subject to Prof_Student_129_AtLarge_D2:
	(sum {k in DIV2} (P[k,129,1] + P[k,129,2])) * sum {k in DIV2} P[k,129,3] = 0;
subject to Prof_Student_129_AtLarge_D3:
	(sum {k in DIV3} (P[k,129,1] + P[k,129,2])) * sum {k in DIV3} P[k,129,3] = 0;
subject to Prof_Student_130_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,130,i] = 1;
subject to Prof_Student_130_Minor:
	sum {k in DEPT0} P[k,130,2] = 1;
subject to Prof_Student_130_AtLarge_D1:
	(sum {k in DIV1} (P[k,130,1] + P[k,130,2])) * sum {k in DIV1} P[k,130,3] = 0;
subject to Prof_Student_130_AtLarge_D2:
	(sum {k in DIV2} (P[k,130,1] + P[k,130,2])) * sum {k in DIV2} P[k,130,3] = 0;
subject to Prof_Student_130_AtLarge_D3:
	(sum {k in DIV3} (P[k,130,1] + P[k,130,2])) * sum {k in DIV3} P[k,130,3] = 0;
subject to Prof_Student_131_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,131,i] = 1;
subject to Prof_Student_131_Minor:
	sum {k in DEPT1} P[k,131,2] = 1;
subject to Prof_Student_131_AtLarge_D1:
	(sum {k in DIV1} (P[k,131,1] + P[k,131,2])) * sum {k in DIV1} P[k,131,3] = 0;
subject to Prof_Student_131_AtLarge_D2:
	(sum {k in DIV2} (P[k,131,1] + P[k,131,2])) * sum {k in DIV2} P[k,131,3] = 0;
subject to Prof_Student_131_AtLarge_D3:
	(sum {k in DIV3} (P[k,131,1] + P[k,131,2])) * sum {k in DIV3} P[k,131,3] = 0;
subject to Prof_Student_132_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,132,i] = 1;
subject to Prof_Student_132_Minor:
	sum {k in DEPT10} P[k,132,2] = 1;
subject to Prof_Student_132_AtLarge_D1:
	(sum {k in DIV1} (P[k,132,1] + P[k,132,2])) * sum {k in DIV1} P[k,132,3] = 0;
subject to Prof_Student_132_AtLarge_D2:
	(sum {k in DIV2} (P[k,132,1] + P[k,132,2])) * sum {k in DIV2} P[k,132,3] = 0;
subject to Prof_Student_132_AtLarge_D3:
	(sum {k in DIV3} (P[k,132,1] + P[k,132,2])) * sum {k in DIV3} P[k,132,3] = 0;
subject to Prof_Student_133_Dept_12:
	sum {k in DEPT12, i in 1..2} P[k,133,i] = 1;
subject to Prof_Student_133_Dept_6:
	sum {k in DEPT6, i in 1..2} P[k,133,i] = 1;
subject to Prof_Student_133_AtLarge_D1:
	(sum {k in DIV1} (P[k,133,1] + P[k,133,2])) * sum {k in DIV1} P[k,133,3] = 0;
subject to Prof_Student_133_AtLarge_D2:
	(sum {k in DIV2} (P[k,133,1] + P[k,133,2])) * sum {k in DIV2} P[k,133,3] = 0;
subject to Prof_Student_133_AtLarge_D3:
	(sum {k in DIV3} (P[k,133,1] + P[k,133,2])) * sum {k in DIV3} P[k,133,3] = 0;
subject to Prof_Student_134_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,134,i] = 1;
subject to Prof_Student_134_Minor:
	sum {k in DEPT15} P[k,134,2] = 1;
subject to Prof_Student_134_AtLarge_D1:
	(sum {k in DIV1} (P[k,134,1] + P[k,134,2])) * sum {k in DIV1} P[k,134,3] = 0;
subject to Prof_Student_134_AtLarge_D2:
	(sum {k in DIV2} (P[k,134,1] + P[k,134,2])) * sum {k in DIV2} P[k,134,3] = 0;
subject to Prof_Student_134_AtLarge_D3:
	(sum {k in DIV3} (P[k,134,1] + P[k,134,2])) * sum {k in DIV3} P[k,134,3] = 0;
subject to Prof_Student_135_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,135,i] = 1;
subject to Prof_Student_135_Minor:
	sum {k in DEPT9} P[k,135,2] = 1;
subject to Prof_Student_135_AtLarge_D1:
	(sum {k in DIV1} (P[k,135,1] + P[k,135,2])) * sum {k in DIV1} P[k,135,3] = 0;
subject to Prof_Student_135_AtLarge_D2:
	(sum {k in DIV2} (P[k,135,1] + P[k,135,2])) * sum {k in DIV2} P[k,135,3] = 0;
subject to Prof_Student_135_AtLarge_D3:
	(sum {k in DIV3} (P[k,135,1] + P[k,135,2])) * sum {k in DIV3} P[k,135,3] = 0;
subject to Prof_Student_136_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,136,i] = 1;
subject to Prof_Student_136_Minor:
	sum {k in (DEPT9 union DEPT27)} P[k,136,2] = 1;
subject to Prof_Student_136_AtLarge_D1:
	(sum {k in DIV1} (P[k,136,1] + P[k,136,2])) * sum {k in DIV1} P[k,136,3] = 0;
subject to Prof_Student_136_AtLarge_D2:
	(sum {k in DIV2} (P[k,136,1] + P[k,136,2])) * sum {k in DIV2} P[k,136,3] = 0;
subject to Prof_Student_136_AtLarge_D3:
	(sum {k in DIV3} (P[k,136,1] + P[k,136,2])) * sum {k in DIV3} P[k,136,3] = 0;
subject to Prof_Student_137_Dept_19:
	sum {k in DEPT19, i in 1..1} P[k,137,i] = 1;
subject to Prof_Student_137_Minor:
	sum {k in DEPT18} P[k,137,2] = 1;
subject to Prof_Student_137_AtLarge_D1:
	(sum {k in DIV1} (P[k,137,1] + P[k,137,2])) * sum {k in DIV1} P[k,137,3] = 0;
subject to Prof_Student_137_AtLarge_D2:
	(sum {k in DIV2} (P[k,137,1] + P[k,137,2])) * sum {k in DIV2} P[k,137,3] = 0;
subject to Prof_Student_137_AtLarge_D3:
	(sum {k in DIV3} (P[k,137,1] + P[k,137,2])) * sum {k in DIV3} P[k,137,3] = 0;
subject to Prof_Student_138_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,138,i] = 1;
subject to Prof_Student_138_Minor:
	sum {k in DEPT4} P[k,138,2] = 1;
subject to Prof_Student_138_AtLarge_D1:
	(sum {k in DIV1} (P[k,138,1] + P[k,138,2])) * sum {k in DIV1} P[k,138,3] = 0;
subject to Prof_Student_138_AtLarge_D2:
	(sum {k in DIV2} (P[k,138,1] + P[k,138,2])) * sum {k in DIV2} P[k,138,3] = 0;
subject to Prof_Student_138_AtLarge_D3:
	(sum {k in DIV3} (P[k,138,1] + P[k,138,2])) * sum {k in DIV3} P[k,138,3] = 0;
subject to Prof_Student_139_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,139,i] = 1;
subject to Prof_Student_139_Minor:
	sum {k in DEPT9} P[k,139,2] = 1;
subject to Prof_Student_139_AtLarge_D1:
	(sum {k in DIV1} (P[k,139,1] + P[k,139,2])) * sum {k in DIV1} P[k,139,3] = 0;
subject to Prof_Student_139_AtLarge_D2:
	(sum {k in DIV2} (P[k,139,1] + P[k,139,2])) * sum {k in DIV2} P[k,139,3] = 0;
subject to Prof_Student_139_AtLarge_D3:
	(sum {k in DIV3} (P[k,139,1] + P[k,139,2])) * sum {k in DIV3} P[k,139,3] = 0;
subject to Prof_Student_140_Dept_24:
	sum {k in DEPT24, i in 1..1} P[k,140,i] = 1;
subject to Prof_Student_140_Minor:
	sum {k in DEPT11} P[k,140,2] = 1;
subject to Prof_Student_140_AtLarge_D1:
	(sum {k in DIV1} (P[k,140,1] + P[k,140,2])) * sum {k in DIV1} P[k,140,3] = 0;
subject to Prof_Student_140_AtLarge_D2:
	(sum {k in DIV2} (P[k,140,1] + P[k,140,2])) * sum {k in DIV2} P[k,140,3] = 0;
subject to Prof_Student_140_AtLarge_D3:
	(sum {k in DIV3} (P[k,140,1] + P[k,140,2])) * sum {k in DIV3} P[k,140,3] = 0;
subject to Prof_Student_141_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,141,i] = 1;
subject to Prof_Student_141_Minor:
	sum {k in DEPT14} P[k,141,2] = 1;
subject to Prof_Student_141_AtLarge_D1:
	(sum {k in DIV1} (P[k,141,1] + P[k,141,2])) * sum {k in DIV1} P[k,141,3] = 0;
subject to Prof_Student_141_AtLarge_D2:
	(sum {k in DIV2} (P[k,141,1] + P[k,141,2])) * sum {k in DIV2} P[k,141,3] = 0;
subject to Prof_Student_141_AtLarge_D3:
	(sum {k in DIV3} (P[k,141,1] + P[k,141,2])) * sum {k in DIV3} P[k,141,3] = 0;
subject to Prof_Student_142_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,142,i] = 1;
subject to Prof_Student_142_Minor:
	sum {k in DEPT14} P[k,142,2] = 1;
subject to Prof_Student_142_AtLarge_D1:
	(sum {k in DIV1} (P[k,142,1] + P[k,142,2])) * sum {k in DIV1} P[k,142,3] = 0;
subject to Prof_Student_142_AtLarge_D2:
	(sum {k in DIV2} (P[k,142,1] + P[k,142,2])) * sum {k in DIV2} P[k,142,3] = 0;
subject to Prof_Student_142_AtLarge_D3:
	(sum {k in DIV3} (P[k,142,1] + P[k,142,2])) * sum {k in DIV3} P[k,142,3] = 0;
subject to Prof_Student_143_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,143,i] = 1;
subject to Prof_Student_143_Minor:
	sum {k in DEPT11} P[k,143,2] = 1;
subject to Prof_Student_143_AtLarge_D1:
	(sum {k in DIV1} (P[k,143,1] + P[k,143,2])) * sum {k in DIV1} P[k,143,3] = 0;
subject to Prof_Student_143_AtLarge_D2:
	(sum {k in DIV2} (P[k,143,1] + P[k,143,2])) * sum {k in DIV2} P[k,143,3] = 0;
subject to Prof_Student_143_AtLarge_D3:
	(sum {k in DIV3} (P[k,143,1] + P[k,143,2])) * sum {k in DIV3} P[k,143,3] = 0;
subject to Prof_Student_144_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,144,i] = 1;
subject to Prof_Student_144_Minor:
	sum {k in DEPT19} P[k,144,2] = 1;
subject to Prof_Student_144_AtLarge_D1:
	(sum {k in DIV1} (P[k,144,1] + P[k,144,2])) * sum {k in DIV1} P[k,144,3] = 0;
subject to Prof_Student_144_AtLarge_D2:
	(sum {k in DIV2} (P[k,144,1] + P[k,144,2])) * sum {k in DIV2} P[k,144,3] = 0;
subject to Prof_Student_144_AtLarge_D3:
	(sum {k in DIV3} (P[k,144,1] + P[k,144,2])) * sum {k in DIV3} P[k,144,3] = 0;
subject to Prof_Student_145_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,145,i] = 1;
subject to Prof_Student_145_Minor:
	sum {k in DEPT14} P[k,145,2] = 1;
subject to Prof_Student_145_AtLarge_D1:
	(sum {k in DIV1} (P[k,145,1] + P[k,145,2])) * sum {k in DIV1} P[k,145,3] = 0;
subject to Prof_Student_145_AtLarge_D2:
	(sum {k in DIV2} (P[k,145,1] + P[k,145,2])) * sum {k in DIV2} P[k,145,3] = 0;
subject to Prof_Student_145_AtLarge_D3:
	(sum {k in DIV3} (P[k,145,1] + P[k,145,2])) * sum {k in DIV3} P[k,145,3] = 0;
subject to Prof_Student_146_Dept_0:
	sum {k in DEPT0, i in 1..2} P[k,146,i] = 1;
subject to Prof_Student_146_Dept_12:
	sum {k in DEPT12, i in 1..2} P[k,146,i] = 1;
subject to Prof_Student_146_AtLarge_D1:
	(sum {k in DIV1} (P[k,146,1] + P[k,146,2])) * sum {k in DIV1} P[k,146,3] = 0;
subject to Prof_Student_146_AtLarge_D2:
	(sum {k in DIV2} (P[k,146,1] + P[k,146,2])) * sum {k in DIV2} P[k,146,3] = 0;
subject to Prof_Student_146_AtLarge_D3:
	(sum {k in DIV3} (P[k,146,1] + P[k,146,2])) * sum {k in DIV3} P[k,146,3] = 0;
subject to Prof_Student_147_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,147,i] = 1;
subject to Prof_Student_147_Minor:
	sum {k in DEPT17} P[k,147,2] = 1;
subject to Prof_Student_147_AtLarge_D1:
	(sum {k in DIV1} (P[k,147,1] + P[k,147,2])) * sum {k in DIV1} P[k,147,3] = 0;
subject to Prof_Student_147_AtLarge_D2:
	(sum {k in DIV2} (P[k,147,1] + P[k,147,2])) * sum {k in DIV2} P[k,147,3] = 0;
subject to Prof_Student_147_AtLarge_D3:
	(sum {k in DIV3} (P[k,147,1] + P[k,147,2])) * sum {k in DIV3} P[k,147,3] = 0;
subject to Prof_Student_148_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,148,i] = 1;
subject to Prof_Student_148_Minor:
	sum {k in DEPT14} P[k,148,2] = 1;
subject to Prof_Student_148_AtLarge_D1:
	(sum {k in DIV1} (P[k,148,1] + P[k,148,2])) * sum {k in DIV1} P[k,148,3] = 0;
subject to Prof_Student_148_AtLarge_D2:
	(sum {k in DIV2} (P[k,148,1] + P[k,148,2])) * sum {k in DIV2} P[k,148,3] = 0;
subject to Prof_Student_148_AtLarge_D3:
	(sum {k in DIV3} (P[k,148,1] + P[k,148,2])) * sum {k in DIV3} P[k,148,3] = 0;
subject to Prof_Student_149_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,149,i] = 1;
subject to Prof_Student_149_Minor:
	sum {k in DEPT26} P[k,149,2] = 1;
subject to Prof_Student_149_AtLarge_D1:
	(sum {k in DIV1} (P[k,149,1] + P[k,149,2])) * sum {k in DIV1} P[k,149,3] = 0;
subject to Prof_Student_149_AtLarge_D2:
	(sum {k in DIV2} (P[k,149,1] + P[k,149,2])) * sum {k in DIV2} P[k,149,3] = 0;
subject to Prof_Student_149_AtLarge_D3:
	(sum {k in DIV3} (P[k,149,1] + P[k,149,2])) * sum {k in DIV3} P[k,149,3] = 0;
subject to Prof_Student_150_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,150,i] = 1;
subject to Prof_Student_150_Minor:
	sum {k in DEPT26} P[k,150,2] = 1;
subject to Prof_Student_150_AtLarge_D1:
	(sum {k in DIV1} (P[k,150,1] + P[k,150,2])) * sum {k in DIV1} P[k,150,3] = 0;
subject to Prof_Student_150_AtLarge_D2:
	(sum {k in DIV2} (P[k,150,1] + P[k,150,2])) * sum {k in DIV2} P[k,150,3] = 0;
subject to Prof_Student_150_AtLarge_D3:
	(sum {k in DIV3} (P[k,150,1] + P[k,150,2])) * sum {k in DIV3} P[k,150,3] = 0;
subject to Prof_Student_151_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,151,i] = 1;
subject to Prof_Student_151_Minor:
	sum {k in DEPT10} P[k,151,2] = 1;
subject to Prof_Student_151_AtLarge_D1:
	(sum {k in DIV1} (P[k,151,1] + P[k,151,2])) * sum {k in DIV1} P[k,151,3] = 0;
subject to Prof_Student_151_AtLarge_D2:
	(sum {k in DIV2} (P[k,151,1] + P[k,151,2])) * sum {k in DIV2} P[k,151,3] = 0;
subject to Prof_Student_151_AtLarge_D3:
	(sum {k in DIV3} (P[k,151,1] + P[k,151,2])) * sum {k in DIV3} P[k,151,3] = 0;
subject to Prof_Student_152_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,152,i] = 1;
subject to Prof_Student_152_Minor:
	sum {k in (DEPT23 union DEPT7)} P[k,152,2] = 1;
subject to Prof_Student_152_AtLarge_D1:
	(sum {k in DIV1} (P[k,152,1] + P[k,152,2])) * sum {k in DIV1} P[k,152,3] = 0;
subject to Prof_Student_152_AtLarge_D2:
	(sum {k in DIV2} (P[k,152,1] + P[k,152,2])) * sum {k in DIV2} P[k,152,3] = 0;
subject to Prof_Student_152_AtLarge_D3:
	(sum {k in DIV3} (P[k,152,1] + P[k,152,2])) * sum {k in DIV3} P[k,152,3] = 0;
subject to Prof_Student_153_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,153,i] = 1;
subject to Prof_Student_153_Minor:
	sum {k in DEPT0} P[k,153,2] = 1;
subject to Prof_Student_153_AtLarge_D1:
	(sum {k in DIV1} (P[k,153,1] + P[k,153,2])) * sum {k in DIV1} P[k,153,3] = 0;
subject to Prof_Student_153_AtLarge_D2:
	(sum {k in DIV2} (P[k,153,1] + P[k,153,2])) * sum {k in DIV2} P[k,153,3] = 0;
subject to Prof_Student_153_AtLarge_D3:
	(sum {k in DIV3} (P[k,153,1] + P[k,153,2])) * sum {k in DIV3} P[k,153,3] = 0;
subject to Prof_Student_154_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,154,i] = 1;
subject to Prof_Student_154_Minor:
	sum {k in DEPT0} P[k,154,2] = 1;
subject to Prof_Student_154_AtLarge_D1:
	(sum {k in DIV1} (P[k,154,1] + P[k,154,2])) * sum {k in DIV1} P[k,154,3] = 0;
subject to Prof_Student_154_AtLarge_D2:
	(sum {k in DIV2} (P[k,154,1] + P[k,154,2])) * sum {k in DIV2} P[k,154,3] = 0;
subject to Prof_Student_154_AtLarge_D3:
	(sum {k in DIV3} (P[k,154,1] + P[k,154,2])) * sum {k in DIV3} P[k,154,3] = 0;
subject to Prof_Student_155_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,155,i] = 1;
subject to Prof_Student_155_Minor:
	sum {k in DEPT1} P[k,155,2] = 1;
subject to Prof_Student_155_AtLarge_D1:
	(sum {k in DIV1} (P[k,155,1] + P[k,155,2])) * sum {k in DIV1} P[k,155,3] = 0;
subject to Prof_Student_155_AtLarge_D2:
	(sum {k in DIV2} (P[k,155,1] + P[k,155,2])) * sum {k in DIV2} P[k,155,3] = 0;
subject to Prof_Student_155_AtLarge_D3:
	(sum {k in DIV3} (P[k,155,1] + P[k,155,2])) * sum {k in DIV3} P[k,155,3] = 0;
subject to Prof_Student_156_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,156,i] = 1;
subject to Prof_Student_156_Minor:
	sum {k in DEPT4} P[k,156,2] = 1;
subject to Prof_Student_156_AtLarge_D1:
	(sum {k in DIV1} (P[k,156,1] + P[k,156,2])) * sum {k in DIV1} P[k,156,3] = 0;
subject to Prof_Student_156_AtLarge_D2:
	(sum {k in DIV2} (P[k,156,1] + P[k,156,2])) * sum {k in DIV2} P[k,156,3] = 0;
subject to Prof_Student_156_AtLarge_D3:
	(sum {k in DIV3} (P[k,156,1] + P[k,156,2])) * sum {k in DIV3} P[k,156,3] = 0;
subject to Prof_Student_157_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,157,i] = 1;
subject to Prof_Student_157_Minor:
	sum {k in DEPT6} P[k,157,2] = 1;
subject to Prof_Student_157_AtLarge_D1:
	(sum {k in DIV1} (P[k,157,1] + P[k,157,2])) * sum {k in DIV1} P[k,157,3] = 0;
subject to Prof_Student_157_AtLarge_D2:
	(sum {k in DIV2} (P[k,157,1] + P[k,157,2])) * sum {k in DIV2} P[k,157,3] = 0;
subject to Prof_Student_157_AtLarge_D3:
	(sum {k in DIV3} (P[k,157,1] + P[k,157,2])) * sum {k in DIV3} P[k,157,3] = 0;
subject to Prof_Student_158_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,158,i] = 1;
subject to Prof_Student_158_Minor:
	sum {k in DEPT11} P[k,158,2] = 1;
subject to Prof_Student_158_AtLarge_D1:
	(sum {k in DIV1} (P[k,158,1] + P[k,158,2])) * sum {k in DIV1} P[k,158,3] = 0;
subject to Prof_Student_158_AtLarge_D2:
	(sum {k in DIV2} (P[k,158,1] + P[k,158,2])) * sum {k in DIV2} P[k,158,3] = 0;
subject to Prof_Student_158_AtLarge_D3:
	(sum {k in DIV3} (P[k,158,1] + P[k,158,2])) * sum {k in DIV3} P[k,158,3] = 0;
subject to Prof_Student_159_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,159,i] = 1;
subject to Prof_Student_159_Minor:
	sum {k in DEPT24} P[k,159,2] = 1;
subject to Prof_Student_159_AtLarge_D1:
	(sum {k in DIV1} (P[k,159,1] + P[k,159,2])) * sum {k in DIV1} P[k,159,3] = 0;
subject to Prof_Student_159_AtLarge_D2:
	(sum {k in DIV2} (P[k,159,1] + P[k,159,2])) * sum {k in DIV2} P[k,159,3] = 0;
subject to Prof_Student_159_AtLarge_D3:
	(sum {k in DIV3} (P[k,159,1] + P[k,159,2])) * sum {k in DIV3} P[k,159,3] = 0;
subject to Prof_Student_160_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,160,i] = 1;
subject to Prof_Student_160_Minor:
	sum {k in (DEPT12 union DEPT14)} P[k,160,2] = 1;
subject to Prof_Student_160_AtLarge_D1:
	(sum {k in DIV1} (P[k,160,1] + P[k,160,2])) * sum {k in DIV1} P[k,160,3] = 0;
subject to Prof_Student_160_AtLarge_D2:
	(sum {k in DIV2} (P[k,160,1] + P[k,160,2])) * sum {k in DIV2} P[k,160,3] = 0;
subject to Prof_Student_160_AtLarge_D3:
	(sum {k in DIV3} (P[k,160,1] + P[k,160,2])) * sum {k in DIV3} P[k,160,3] = 0;
subject to Prof_Student_161_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,161,i] = 1;
subject to Prof_Student_161_Minor:
	sum {k in (DEPT9 union DEPT5)} P[k,161,2] = 1;
subject to Prof_Student_161_AtLarge_D1:
	(sum {k in DIV1} (P[k,161,1] + P[k,161,2])) * sum {k in DIV1} P[k,161,3] = 0;
subject to Prof_Student_161_AtLarge_D2:
	(sum {k in DIV2} (P[k,161,1] + P[k,161,2])) * sum {k in DIV2} P[k,161,3] = 0;
subject to Prof_Student_161_AtLarge_D3:
	(sum {k in DIV3} (P[k,161,1] + P[k,161,2])) * sum {k in DIV3} P[k,161,3] = 0;
subject to Prof_Student_162_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,162,i] = 1;
subject to Prof_Student_162_Minor:
	sum {k in DEPT0} P[k,162,2] = 1;
subject to Prof_Student_162_AtLarge_D1:
	(sum {k in DIV1} (P[k,162,1] + P[k,162,2])) * sum {k in DIV1} P[k,162,3] = 0;
subject to Prof_Student_162_AtLarge_D2:
	(sum {k in DIV2} (P[k,162,1] + P[k,162,2])) * sum {k in DIV2} P[k,162,3] = 0;
subject to Prof_Student_162_AtLarge_D3:
	(sum {k in DIV3} (P[k,162,1] + P[k,162,2])) * sum {k in DIV3} P[k,162,3] = 0;
subject to Prof_Student_163_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,163,i] = 1;
subject to Prof_Student_163_Minor:
	sum {k in DEPT1} P[k,163,2] = 1;
subject to Prof_Student_163_AtLarge_D1:
	(sum {k in DIV1} (P[k,163,1] + P[k,163,2])) * sum {k in DIV1} P[k,163,3] = 0;
subject to Prof_Student_163_AtLarge_D2:
	(sum {k in DIV2} (P[k,163,1] + P[k,163,2])) * sum {k in DIV2} P[k,163,3] = 0;
subject to Prof_Student_163_AtLarge_D3:
	(sum {k in DIV3} (P[k,163,1] + P[k,163,2])) * sum {k in DIV3} P[k,163,3] = 0;
subject to Prof_Student_164_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,164,i] = 1;
subject to Prof_Student_164_Minor:
	sum {k in DEPT10} P[k,164,2] = 1;
subject to Prof_Student_164_AtLarge_D1:
	(sum {k in DIV1} (P[k,164,1] + P[k,164,2])) * sum {k in DIV1} P[k,164,3] = 0;
subject to Prof_Student_164_AtLarge_D2:
	(sum {k in DIV2} (P[k,164,1] + P[k,164,2])) * sum {k in DIV2} P[k,164,3] = 0;
subject to Prof_Student_164_AtLarge_D3:
	(sum {k in DIV3} (P[k,164,1] + P[k,164,2])) * sum {k in DIV3} P[k,164,3] = 0;
subject to Prof_Student_165_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,165,i] = 1;
subject to Prof_Student_165_Minor:
	sum {k in DEPT6} P[k,165,2] = 1;
subject to Prof_Student_165_AtLarge_D1:
	(sum {k in DIV1} (P[k,165,1] + P[k,165,2])) * sum {k in DIV1} P[k,165,3] = 0;
subject to Prof_Student_165_AtLarge_D2:
	(sum {k in DIV2} (P[k,165,1] + P[k,165,2])) * sum {k in DIV2} P[k,165,3] = 0;
subject to Prof_Student_165_AtLarge_D3:
	(sum {k in DIV3} (P[k,165,1] + P[k,165,2])) * sum {k in DIV3} P[k,165,3] = 0;
subject to Prof_Student_166_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,166,i] = 1;
subject to Prof_Student_166_Minor:
	sum {k in (DEPT5 union DEPT4)} P[k,166,2] = 1;
subject to Prof_Student_166_AtLarge_D1:
	(sum {k in DIV1} (P[k,166,1] + P[k,166,2])) * sum {k in DIV1} P[k,166,3] = 0;
subject to Prof_Student_166_AtLarge_D2:
	(sum {k in DIV2} (P[k,166,1] + P[k,166,2])) * sum {k in DIV2} P[k,166,3] = 0;
subject to Prof_Student_166_AtLarge_D3:
	(sum {k in DIV3} (P[k,166,1] + P[k,166,2])) * sum {k in DIV3} P[k,166,3] = 0;
subject to Prof_Student_167_Dept_15:
	sum {k in DEPT15, i in 1..1} P[k,167,i] = 1;
subject to Prof_Student_167_Minor:
	sum {k in (DEPT14 union DEPT0)} P[k,167,2] = 1;
subject to Prof_Student_167_AtLarge_D1:
	(sum {k in DIV1} (P[k,167,1] + P[k,167,2])) * sum {k in DIV1} P[k,167,3] = 0;
subject to Prof_Student_167_AtLarge_D2:
	(sum {k in DIV2} (P[k,167,1] + P[k,167,2])) * sum {k in DIV2} P[k,167,3] = 0;
subject to Prof_Student_167_AtLarge_D3:
	(sum {k in DIV3} (P[k,167,1] + P[k,167,2])) * sum {k in DIV3} P[k,167,3] = 0;
subject to Prof_Student_168_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,168,i] = 1;
subject to Prof_Student_168_Minor:
	sum {k in DEPT15} P[k,168,2] = 1;
subject to Prof_Student_168_AtLarge_D1:
	(sum {k in DIV1} (P[k,168,1] + P[k,168,2])) * sum {k in DIV1} P[k,168,3] = 0;
subject to Prof_Student_168_AtLarge_D2:
	(sum {k in DIV2} (P[k,168,1] + P[k,168,2])) * sum {k in DIV2} P[k,168,3] = 0;
subject to Prof_Student_168_AtLarge_D3:
	(sum {k in DIV3} (P[k,168,1] + P[k,168,2])) * sum {k in DIV3} P[k,168,3] = 0;
subject to Prof_Student_169_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,169,i] = 1;
subject to Prof_Student_169_Minor:
	sum {k in DEPT21} P[k,169,2] = 1;
subject to Prof_Student_169_AtLarge_D1:
	(sum {k in DIV1} (P[k,169,1] + P[k,169,2])) * sum {k in DIV1} P[k,169,3] = 0;
subject to Prof_Student_169_AtLarge_D2:
	(sum {k in DIV2} (P[k,169,1] + P[k,169,2])) * sum {k in DIV2} P[k,169,3] = 0;
subject to Prof_Student_169_AtLarge_D3:
	(sum {k in DIV3} (P[k,169,1] + P[k,169,2])) * sum {k in DIV3} P[k,169,3] = 0;
subject to Prof_Student_170_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,170,i] = 1;
subject to Prof_Student_170_Minor:
	sum {k in (DEPT1 union DEPT21)} P[k,170,2] = 1;
subject to Prof_Student_170_AtLarge_D1:
	(sum {k in DIV1} (P[k,170,1] + P[k,170,2])) * sum {k in DIV1} P[k,170,3] = 0;
subject to Prof_Student_170_AtLarge_D2:
	(sum {k in DIV2} (P[k,170,1] + P[k,170,2])) * sum {k in DIV2} P[k,170,3] = 0;
subject to Prof_Student_170_AtLarge_D3:
	(sum {k in DIV3} (P[k,170,1] + P[k,170,2])) * sum {k in DIV3} P[k,170,3] = 0;
subject to Prof_Student_171_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,171,i] = 1;
subject to Prof_Student_171_Minor:
	sum {k in DEPT6} P[k,171,2] = 1;
subject to Prof_Student_171_AtLarge_D1:
	(sum {k in DIV1} (P[k,171,1] + P[k,171,2])) * sum {k in DIV1} P[k,171,3] = 0;
subject to Prof_Student_171_AtLarge_D2:
	(sum {k in DIV2} (P[k,171,1] + P[k,171,2])) * sum {k in DIV2} P[k,171,3] = 0;
subject to Prof_Student_171_AtLarge_D3:
	(sum {k in DIV3} (P[k,171,1] + P[k,171,2])) * sum {k in DIV3} P[k,171,3] = 0;
subject to Prof_Student_172_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,172,i] = 1;
subject to Prof_Student_172_Minor:
	sum {k in DEPT4} P[k,172,2] = 1;
subject to Prof_Student_172_AtLarge_D1:
	(sum {k in DIV1} (P[k,172,1] + P[k,172,2])) * sum {k in DIV1} P[k,172,3] = 0;
subject to Prof_Student_172_AtLarge_D2:
	(sum {k in DIV2} (P[k,172,1] + P[k,172,2])) * sum {k in DIV2} P[k,172,3] = 0;
subject to Prof_Student_172_AtLarge_D3:
	(sum {k in DIV3} (P[k,172,1] + P[k,172,2])) * sum {k in DIV3} P[k,172,3] = 0;
subject to Prof_Student_173_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,173,i] = 1;
subject to Prof_Student_173_Minor:
	sum {k in DEPT3} P[k,173,2] = 1;
subject to Prof_Student_173_AtLarge_D1:
	(sum {k in DIV1} (P[k,173,1] + P[k,173,2])) * sum {k in DIV1} P[k,173,3] = 0;
subject to Prof_Student_173_AtLarge_D2:
	(sum {k in DIV2} (P[k,173,1] + P[k,173,2])) * sum {k in DIV2} P[k,173,3] = 0;
subject to Prof_Student_173_AtLarge_D3:
	(sum {k in DIV3} (P[k,173,1] + P[k,173,2])) * sum {k in DIV3} P[k,173,3] = 0;
subject to Prof_Student_174_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,174,i] = 1;
subject to Prof_Student_174_Minor:
	sum {k in DEPT1} P[k,174,2] = 1;
subject to Prof_Student_174_AtLarge_D1:
	(sum {k in DIV1} (P[k,174,1] + P[k,174,2])) * sum {k in DIV1} P[k,174,3] = 0;
subject to Prof_Student_174_AtLarge_D2:
	(sum {k in DIV2} (P[k,174,1] + P[k,174,2])) * sum {k in DIV2} P[k,174,3] = 0;
subject to Prof_Student_174_AtLarge_D3:
	(sum {k in DIV3} (P[k,174,1] + P[k,174,2])) * sum {k in DIV3} P[k,174,3] = 0;
subject to Prof_Student_175_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,175,i] = 1;
subject to Prof_Student_175_Minor:
	sum {k in DEPT6} P[k,175,2] = 1;
subject to Prof_Student_175_AtLarge_D1:
	(sum {k in DIV1} (P[k,175,1] + P[k,175,2])) * sum {k in DIV1} P[k,175,3] = 0;
subject to Prof_Student_175_AtLarge_D2:
	(sum {k in DIV2} (P[k,175,1] + P[k,175,2])) * sum {k in DIV2} P[k,175,3] = 0;
subject to Prof_Student_175_AtLarge_D3:
	(sum {k in DIV3} (P[k,175,1] + P[k,175,2])) * sum {k in DIV3} P[k,175,3] = 0;
subject to Prof_Student_176_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,176,i] = 1;
subject to Prof_Student_176_Minor:
	sum {k in DEPT6} P[k,176,2] = 1;
subject to Prof_Student_176_AtLarge_D1:
	(sum {k in DIV1} (P[k,176,1] + P[k,176,2])) * sum {k in DIV1} P[k,176,3] = 0;
subject to Prof_Student_176_AtLarge_D2:
	(sum {k in DIV2} (P[k,176,1] + P[k,176,2])) * sum {k in DIV2} P[k,176,3] = 0;
subject to Prof_Student_176_AtLarge_D3:
	(sum {k in DIV3} (P[k,176,1] + P[k,176,2])) * sum {k in DIV3} P[k,176,3] = 0;
subject to Prof_Student_177_Dept_9:
	sum {k in DEPT9, i in 1..2} P[k,177,i] = 1;
subject to Prof_Student_177_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,177,i] = 1;
subject to Prof_Student_177_AtLarge_D1:
	(sum {k in DIV1} (P[k,177,1] + P[k,177,2])) * sum {k in DIV1} P[k,177,3] = 0;
subject to Prof_Student_177_AtLarge_D2:
	(sum {k in DIV2} (P[k,177,1] + P[k,177,2])) * sum {k in DIV2} P[k,177,3] = 0;
subject to Prof_Student_177_AtLarge_D3:
	(sum {k in DIV3} (P[k,177,1] + P[k,177,2])) * sum {k in DIV3} P[k,177,3] = 0;
subject to Prof_Student_178_Dept_4:
	sum {k in DEPT4, i in 1..2} P[k,178,i] = 1;
subject to Prof_Student_178_Dept_2:
	sum {k in DEPT2, i in 1..2} P[k,178,i] = 1;
subject to Prof_Student_178_AtLarge_D1:
	(sum {k in DIV1} (P[k,178,1] + P[k,178,2])) * sum {k in DIV1} P[k,178,3] = 0;
subject to Prof_Student_178_AtLarge_D2:
	(sum {k in DIV2} (P[k,178,1] + P[k,178,2])) * sum {k in DIV2} P[k,178,3] = 0;
subject to Prof_Student_178_AtLarge_D3:
	(sum {k in DIV3} (P[k,178,1] + P[k,178,2])) * sum {k in DIV3} P[k,178,3] = 0;
subject to Prof_Student_179_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,179,i] = 1;
subject to Prof_Student_179_Minor:
	sum {k in DEPT20} P[k,179,2] = 1;
subject to Prof_Student_179_AtLarge_D1:
	(sum {k in DIV1} (P[k,179,1] + P[k,179,2])) * sum {k in DIV1} P[k,179,3] = 0;
subject to Prof_Student_179_AtLarge_D2:
	(sum {k in DIV2} (P[k,179,1] + P[k,179,2])) * sum {k in DIV2} P[k,179,3] = 0;
subject to Prof_Student_179_AtLarge_D3:
	(sum {k in DIV3} (P[k,179,1] + P[k,179,2])) * sum {k in DIV3} P[k,179,3] = 0;
subject to Prof_Student_180_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,180,i] = 1;
subject to Prof_Student_180_Minor:
	sum {k in (DEPT2 union DEPT5)} P[k,180,2] = 1;
subject to Prof_Student_180_AtLarge_D1:
	(sum {k in DIV1} (P[k,180,1] + P[k,180,2])) * sum {k in DIV1} P[k,180,3] = 0;
subject to Prof_Student_180_AtLarge_D2:
	(sum {k in DIV2} (P[k,180,1] + P[k,180,2])) * sum {k in DIV2} P[k,180,3] = 0;
subject to Prof_Student_180_AtLarge_D3:
	(sum {k in DIV3} (P[k,180,1] + P[k,180,2])) * sum {k in DIV3} P[k,180,3] = 0;
subject to Prof_Student_181_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,181,i] = 1;
subject to Prof_Student_181_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,181,i] = 1;
subject to Prof_Student_181_AtLarge_D1:
	(sum {k in DIV1} (P[k,181,1] + P[k,181,2])) * sum {k in DIV1} P[k,181,3] = 0;
subject to Prof_Student_181_AtLarge_D2:
	(sum {k in DIV2} (P[k,181,1] + P[k,181,2])) * sum {k in DIV2} P[k,181,3] = 0;
subject to Prof_Student_181_AtLarge_D3:
	(sum {k in DIV3} (P[k,181,1] + P[k,181,2])) * sum {k in DIV3} P[k,181,3] = 0;
subject to Prof_Student_182_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,182,i] = 1;
subject to Prof_Student_182_Minor:
	sum {k in DEPT22} P[k,182,2] = 1;
subject to Prof_Student_182_AtLarge_D1:
	(sum {k in DIV1} (P[k,182,1] + P[k,182,2])) * sum {k in DIV1} P[k,182,3] = 0;
subject to Prof_Student_182_AtLarge_D2:
	(sum {k in DIV2} (P[k,182,1] + P[k,182,2])) * sum {k in DIV2} P[k,182,3] = 0;
subject to Prof_Student_182_AtLarge_D3:
	(sum {k in DIV3} (P[k,182,1] + P[k,182,2])) * sum {k in DIV3} P[k,182,3] = 0;
subject to Prof_Student_183_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,183,i] = 1;
subject to Prof_Student_183_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,183,i] = 1;
subject to Prof_Student_183_AtLarge_D1:
	(sum {k in DIV1} (P[k,183,1] + P[k,183,2])) * sum {k in DIV1} P[k,183,3] = 0;
subject to Prof_Student_183_AtLarge_D2:
	(sum {k in DIV2} (P[k,183,1] + P[k,183,2])) * sum {k in DIV2} P[k,183,3] = 0;
subject to Prof_Student_183_AtLarge_D3:
	(sum {k in DIV3} (P[k,183,1] + P[k,183,2])) * sum {k in DIV3} P[k,183,3] = 0;
subject to Prof_Student_184_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,184,i] = 1;
subject to Prof_Student_184_Minor:
	sum {k in DEPT18} P[k,184,2] = 1;
subject to Prof_Student_184_AtLarge_D1:
	(sum {k in DIV1} (P[k,184,1] + P[k,184,2])) * sum {k in DIV1} P[k,184,3] = 0;
subject to Prof_Student_184_AtLarge_D2:
	(sum {k in DIV2} (P[k,184,1] + P[k,184,2])) * sum {k in DIV2} P[k,184,3] = 0;
subject to Prof_Student_184_AtLarge_D3:
	(sum {k in DIV3} (P[k,184,1] + P[k,184,2])) * sum {k in DIV3} P[k,184,3] = 0;
subject to Prof_Student_185_Dept_3:
	sum {k in DEPT3, i in 1..2} P[k,185,i] = 1;
subject to Prof_Student_185_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,185,i] = 1;
subject to Prof_Student_185_AtLarge_D1:
	(sum {k in DIV1} (P[k,185,1] + P[k,185,2])) * sum {k in DIV1} P[k,185,3] = 0;
subject to Prof_Student_185_AtLarge_D2:
	(sum {k in DIV2} (P[k,185,1] + P[k,185,2])) * sum {k in DIV2} P[k,185,3] = 0;
subject to Prof_Student_185_AtLarge_D3:
	(sum {k in DIV3} (P[k,185,1] + P[k,185,2])) * sum {k in DIV3} P[k,185,3] = 0;
subject to Prof_Student_186_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,186,i] = 1;
subject to Prof_Student_186_Minor:
	sum {k in DEPT1} P[k,186,2] = 1;
subject to Prof_Student_186_AtLarge_D1:
	(sum {k in DIV1} (P[k,186,1] + P[k,186,2])) * sum {k in DIV1} P[k,186,3] = 0;
subject to Prof_Student_186_AtLarge_D2:
	(sum {k in DIV2} (P[k,186,1] + P[k,186,2])) * sum {k in DIV2} P[k,186,3] = 0;
subject to Prof_Student_186_AtLarge_D3:
	(sum {k in DIV3} (P[k,186,1] + P[k,186,2])) * sum {k in DIV3} P[k,186,3] = 0;
subject to Prof_Student_187_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,187,i] = 1;
subject to Prof_Student_187_Minor:
	sum {k in DEPT1} P[k,187,2] = 1;
subject to Prof_Student_187_AtLarge_D1:
	(sum {k in DIV1} (P[k,187,1] + P[k,187,2])) * sum {k in DIV1} P[k,187,3] = 0;
subject to Prof_Student_187_AtLarge_D2:
	(sum {k in DIV2} (P[k,187,1] + P[k,187,2])) * sum {k in DIV2} P[k,187,3] = 0;
subject to Prof_Student_187_AtLarge_D3:
	(sum {k in DIV3} (P[k,187,1] + P[k,187,2])) * sum {k in DIV3} P[k,187,3] = 0;
subject to Prof_Student_188_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,188,i] = 1;
subject to Prof_Student_188_Minor:
	sum {k in DEPT1} P[k,188,2] = 1;
subject to Prof_Student_188_AtLarge_D1:
	(sum {k in DIV1} (P[k,188,1] + P[k,188,2])) * sum {k in DIV1} P[k,188,3] = 0;
subject to Prof_Student_188_AtLarge_D2:
	(sum {k in DIV2} (P[k,188,1] + P[k,188,2])) * sum {k in DIV2} P[k,188,3] = 0;
subject to Prof_Student_188_AtLarge_D3:
	(sum {k in DIV3} (P[k,188,1] + P[k,188,2])) * sum {k in DIV3} P[k,188,3] = 0;
subject to Prof_Student_189_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,189,i] = 1;
subject to Prof_Student_189_Minor:
	sum {k in DEPT1} P[k,189,2] = 1;
subject to Prof_Student_189_AtLarge_D1:
	(sum {k in DIV1} (P[k,189,1] + P[k,189,2])) * sum {k in DIV1} P[k,189,3] = 0;
subject to Prof_Student_189_AtLarge_D2:
	(sum {k in DIV2} (P[k,189,1] + P[k,189,2])) * sum {k in DIV2} P[k,189,3] = 0;
subject to Prof_Student_189_AtLarge_D3:
	(sum {k in DIV3} (P[k,189,1] + P[k,189,2])) * sum {k in DIV3} P[k,189,3] = 0;
subject to No_New_1st_Major_Students:
	sum {k in TEACHER, l in STUDENT} P[k,l,1] * SNR[k,1] = 0;
subject to Maj_Prof_2ndYr_Then_No_New {l in STUDENT}:
	(sum {k in TEACHER, i in 2..4} (P[k,l,i] * SNR[k,1])) + 3 * (sum {k in TEACHER} (P[k,l,1] * SNR[k,2])) <= 3;
