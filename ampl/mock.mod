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
	default 9;
param BUSY {1..DAY, 1..SESSION, TEACHER} binary
	default 0;
param BUSZ {1..DAY, 1..SESSION, STUDENT} binary
	default 0;
param TRIPLE {STUDENT} binary
	default 0;
var Y {1..DAY, 1..SESSION, STUDENT} binary;
var C {TEACHER, STUDENT} binary;
var P {TEACHER, STUDENT, 1..4} binary;
var U {STUDENT, 1..3} binary;
var V {STUDENT, 1..3} integer;
var Z {k in TEACHER} integer;
var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;

#minimize OBJ: MAXPALL;
minimize OBJ: sum {k in TEACHER} Z[k];

subject to Zdefn1 {k in TEACHER}:
	sum {l in STUDENT} C[k,l] - 7 <= Z[k];
subject to Zdefn2 {k in TEACHER}:
	7 - sum {l in STUDENT} C[k,l] <= Z[k];
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
subject to Prof_Student_0_AtLarge {i in 1..3}:
	U[0,i] * 2 + V[0,i] <= 2;
subject to Prof_Student_1_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,1,i] = 1;
subject to Prof_Student_1_Minor:
	sum {k in DEPT1} P[k,1,2] = 1;
subject to Prof_Student_1_AtLarge {i in 1..3}:
	U[1,i] * 2 + V[1,i] <= 2;
subject to Prof_Student_2_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,2,i] = 1;
subject to Prof_Student_2_Minor:
	sum {k in DEPT5} P[k,2,2] = 1;
subject to Prof_Student_2_AtLarge {i in 1..3}:
	U[2,i] * 2 + V[2,i] <= 2;
subject to Prof_Student_3_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,3,i] = 1;
subject to Prof_Student_3_Minor:
	sum {k in DEPT1} P[k,3,2] = 1;
subject to Prof_Student_3_AtLarge {i in 1..3}:
	U[3,i] * 2 + V[3,i] <= 2;
subject to Prof_Student_4_Dept_7:
	sum {k in DEPT7, i in 1..1} P[k,4,i] = 1;
subject to Prof_Student_4_Minor:
	sum {k in DEPT5} P[k,4,2] = 1;
subject to Prof_Student_4_AtLarge {i in 1..3}:
	U[4,i] * 2 + V[4,i] <= 2;
subject to Prof_Student_5_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,5,i] = 1;
subject to Prof_Student_5_Minor:
	sum {k in DEPT4} P[k,5,2] = 1;
subject to Prof_Student_5_AtLarge {i in 1..3}:
	U[5,i] * 2 + V[5,i] <= 2;
subject to Prof_Student_6_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,6,i] = 1;
subject to Prof_Student_6_Minor:
	sum {k in DEPT10} P[k,6,2] = 1;
subject to Prof_Student_6_AtLarge {i in 1..3}:
	U[6,i] * 2 + V[6,i] <= 2;
subject to Prof_Student_7_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,7,i] = 1;
subject to Prof_Student_7_Minor:
	sum {k in DEPT2} P[k,7,2] = 1;
subject to Prof_Student_7_AtLarge {i in 1..3}:
	U[7,i] * 2 + V[7,i] <= 2;
subject to Prof_Student_8_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,8,i] = 1;
subject to Prof_Student_8_Minor:
	sum {k in DEPT11} P[k,8,2] = 1;
subject to Prof_Student_8_AtLarge {i in 1..3}:
	U[8,i] * 2 + V[8,i] <= 2;
subject to Prof_Student_9_Dept_12:
	sum {k in DEPT12, i in 1..3} P[k,9,i] = 1;
subject to Prof_Student_9_Dept_3:
	sum {k in DEPT3, i in 1..3} P[k,9,i] = 1;
subject to Prof_Student_9_Dept_0:
	sum {k in DEPT0, i in 1..3} P[k,9,i] = 1;
subject to Prof_Student_9_AtLarge {i in 1..3}:
	U[9,i] * 3 + V[9,i] <= 3;
subject to Prof_Student_10_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,10,i] = 1;
subject to Prof_Student_10_Minor:
	sum {k in DEPT14} P[k,10,2] = 1;
subject to Prof_Student_10_AtLarge {i in 1..3}:
	U[10,i] * 2 + V[10,i] <= 2;
subject to Prof_Student_11_Dept_15:
	sum {k in DEPT15, i in 1..1} P[k,11,i] = 1;
subject to Prof_Student_11_Minor:
	sum {k in DEPT16} P[k,11,2] = 1;
subject to Prof_Student_11_AtLarge {i in 1..3}:
	U[11,i] * 2 + V[11,i] <= 2;
subject to Prof_Student_12_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,12,i] = 1;
subject to Prof_Student_12_Minor:
	sum {k in DEPT10} P[k,12,2] = 1;
subject to Prof_Student_12_AtLarge {i in 1..3}:
	U[12,i] * 2 + V[12,i] <= 2;
subject to Prof_Student_13_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,13,i] = 1;
subject to Prof_Student_13_Minor:
	sum {k in DEPT11} P[k,13,2] = 1;
subject to Prof_Student_13_AtLarge {i in 1..3}:
	U[13,i] * 2 + V[13,i] <= 2;
subject to Prof_Student_14_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,14,i] = 1;
subject to Prof_Student_14_Minor:
	sum {k in DEPT9} P[k,14,2] = 1;
subject to Prof_Student_14_AtLarge {i in 1..3}:
	U[14,i] * 2 + V[14,i] <= 2;
subject to Prof_Student_15_Dept_17:
	sum {k in DEPT17, i in 1..2} P[k,15,i] = 1;
subject to Prof_Student_15_Dept_8:
	sum {k in DEPT8, i in 1..2} P[k,15,i] = 1;
subject to Prof_Student_15_AtLarge {i in 1..3}:
	U[15,i] * 2 + V[15,i] <= 2;
subject to Prof_Student_16_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,16,i] = 1;
subject to Prof_Student_16_Minor:
	sum {k in DEPT18} P[k,16,2] = 1;
subject to Prof_Student_16_AtLarge {i in 1..3}:
	U[16,i] * 2 + V[16,i] <= 2;
subject to Prof_Student_17_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,17,i] = 1;
subject to Prof_Student_17_Minor:
	sum {k in DEPT1} P[k,17,2] = 1;
subject to Prof_Student_17_AtLarge {i in 1..3}:
	U[17,i] * 2 + V[17,i] <= 2;
subject to Prof_Student_18_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,18,i] = 1;
subject to Prof_Student_18_Minor:
	sum {k in DEPT15} P[k,18,2] = 1;
subject to Prof_Student_18_AtLarge {i in 1..3}:
	U[18,i] * 2 + V[18,i] <= 2;
subject to Prof_Student_19_Dept_12:
	sum {k in DEPT12, i in 1..1} P[k,19,i] = 1;
subject to Prof_Student_19_Minor:
	sum {k in (DEPT0 union DEPT6)} P[k,19,2] = 1;
subject to Prof_Student_19_AtLarge {i in 1..3}:
	U[19,i] * 2 + V[19,i] <= 2;
subject to Prof_Student_20_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,20,i] = 1;
subject to Prof_Student_20_Minor:
	sum {k in DEPT6} P[k,20,2] = 1;
subject to Prof_Student_20_AtLarge {i in 1..3}:
	U[20,i] * 2 + V[20,i] <= 2;
subject to Prof_Student_21_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,21,i] = 1;
subject to Prof_Student_21_Minor:
	sum {k in DEPT0} P[k,21,2] = 1;
subject to Prof_Student_21_AtLarge {i in 1..3}:
	U[21,i] * 2 + V[21,i] <= 2;
subject to Prof_Student_22_Dept_9:
	sum {k in DEPT9, i in 1..2} P[k,22,i] = 1;
subject to Prof_Student_22_Dept_7:
	sum {k in DEPT7, i in 1..2} P[k,22,i] = 1;
subject to Prof_Student_22_AtLarge {i in 1..3}:
	U[22,i] * 2 + V[22,i] <= 2;
subject to Prof_Student_23_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,23,i] = 1;
subject to Prof_Student_23_Minor:
	sum {k in DEPT7} P[k,23,2] = 1;
subject to Prof_Student_23_AtLarge {i in 1..3}:
	U[23,i] * 2 + V[23,i] <= 2;
subject to Prof_Student_24_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,24,i] = 1;
subject to Prof_Student_24_Minor:
	sum {k in DEPT0} P[k,24,2] = 1;
subject to Prof_Student_24_AtLarge {i in 1..3}:
	U[24,i] * 2 + V[24,i] <= 2;
subject to Prof_Student_25_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,25,i] = 1;
subject to Prof_Student_25_Minor:
	sum {k in DEPT19} P[k,25,2] = 1;
subject to Prof_Student_25_AtLarge {i in 1..3}:
	U[25,i] * 2 + V[25,i] <= 2;
subject to Prof_Student_26_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,26,i] = 1;
subject to Prof_Student_26_Minor:
	sum {k in DEPT0} P[k,26,2] = 1;
subject to Prof_Student_26_AtLarge {i in 1..3}:
	U[26,i] * 2 + V[26,i] <= 2;
subject to Prof_Student_27_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,27,i] = 1;
subject to Prof_Student_27_Minor:
	sum {k in DEPT14} P[k,27,2] = 1;
subject to Prof_Student_27_AtLarge {i in 1..3}:
	U[27,i] * 2 + V[27,i] <= 2;
subject to Prof_Student_28_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,28,i] = 1;
subject to Prof_Student_28_Minor:
	sum {k in DEPT14} P[k,28,2] = 1;
subject to Prof_Student_28_AtLarge {i in 1..3}:
	U[28,i] * 2 + V[28,i] <= 2;
subject to Prof_Student_29_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,29,i] = 1;
subject to Prof_Student_29_Minor:
	sum {k in (DEPT0 union DEPT10)} P[k,29,2] = 1;
subject to Prof_Student_29_AtLarge {i in 1..3}:
	U[29,i] * 2 + V[29,i] <= 2;
subject to Prof_Student_30_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,30,i] = 1;
subject to Prof_Student_30_Minor:
	sum {k in DEPT20} P[k,30,2] = 1;
subject to Prof_Student_30_AtLarge {i in 1..3}:
	U[30,i] * 2 + V[30,i] <= 2;
subject to Prof_Student_31_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,31,i] = 1;
subject to Prof_Student_31_Minor:
	sum {k in DEPT21} P[k,31,2] = 1;
subject to Prof_Student_31_AtLarge {i in 1..3}:
	U[31,i] * 2 + V[31,i] <= 2;
subject to Prof_Student_32_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,32,i] = 1;
subject to Prof_Student_32_Minor:
	sum {k in DEPT18} P[k,32,2] = 1;
subject to Prof_Student_32_AtLarge {i in 1..3}:
	U[32,i] * 2 + V[32,i] <= 2;
subject to Prof_Student_33_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,33,i] = 1;
subject to Prof_Student_33_Minor:
	sum {k in DEPT3} P[k,33,2] = 1;
subject to Prof_Student_33_AtLarge {i in 1..3}:
	U[33,i] * 2 + V[33,i] <= 2;
subject to Prof_Student_34_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,34,i] = 1;
subject to Prof_Student_34_Minor:
	sum {k in DEPT1} P[k,34,2] = 1;
subject to Prof_Student_34_AtLarge {i in 1..3}:
	U[34,i] * 2 + V[34,i] <= 2;
subject to Prof_Student_35_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,35,i] = 1;
subject to Prof_Student_35_Minor:
	sum {k in DEPT10} P[k,35,2] = 1;
subject to Prof_Student_35_AtLarge {i in 1..3}:
	U[35,i] * 2 + V[35,i] <= 2;
subject to Prof_Student_36_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,36,i] = 1;
subject to Prof_Student_36_Minor:
	sum {k in DEPT7} P[k,36,2] = 1;
subject to Prof_Student_36_AtLarge {i in 1..3}:
	U[36,i] * 2 + V[36,i] <= 2;
subject to Prof_Student_37_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,37,i] = 1;
subject to Prof_Student_37_Minor:
	sum {k in DEPT0} P[k,37,2] = 1;
subject to Prof_Student_37_AtLarge {i in 1..3}:
	U[37,i] * 2 + V[37,i] <= 2;
subject to Prof_Student_38_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,38,i] = 1;
subject to Prof_Student_38_Minor:
	sum {k in DEPT9} P[k,38,2] = 1;
subject to Prof_Student_38_AtLarge {i in 1..3}:
	U[38,i] * 2 + V[38,i] <= 2;
subject to Prof_Student_39_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,39,i] = 1;
subject to Prof_Student_39_Minor:
	sum {k in DEPT0} P[k,39,2] = 1;
subject to Prof_Student_39_AtLarge {i in 1..3}:
	U[39,i] * 2 + V[39,i] <= 2;
subject to Prof_Student_40_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,40,i] = 1;
subject to Prof_Student_40_Minor:
	sum {k in DEPT10} P[k,40,2] = 1;
subject to Prof_Student_40_AtLarge {i in 1..3}:
	U[40,i] * 2 + V[40,i] <= 2;
subject to Prof_Student_41_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,41,i] = 1;
subject to Prof_Student_41_Minor:
	sum {k in DEPT22} P[k,41,2] = 1;
subject to Prof_Student_41_AtLarge {i in 1..3}:
	U[41,i] * 2 + V[41,i] <= 2;
subject to Prof_Student_42_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,42,i] = 1;
subject to Prof_Student_42_Minor:
	sum {k in (DEPT18 union DEPT19)} P[k,42,2] = 1;
subject to Prof_Student_42_AtLarge {i in 1..3}:
	U[42,i] * 2 + V[42,i] <= 2;
subject to Prof_Student_43_Dept_23:
	sum {k in DEPT23, i in 1..1} P[k,43,i] = 1;
subject to Prof_Student_43_Minor:
	sum {k in DEPT14} P[k,43,2] = 1;
subject to Prof_Student_43_AtLarge {i in 1..3}:
	U[43,i] * 2 + V[43,i] <= 2;
subject to Prof_Student_44_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,44,i] = 1;
subject to Prof_Student_44_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,44,i] = 1;
subject to Prof_Student_44_AtLarge {i in 1..3}:
	U[44,i] * 2 + V[44,i] <= 2;
subject to Prof_Student_45_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,45,i] = 1;
subject to Prof_Student_45_Minor:
	sum {k in (DEPT9 union DEPT5)} P[k,45,2] = 1;
subject to Prof_Student_45_AtLarge {i in 1..3}:
	U[45,i] * 2 + V[45,i] <= 2;
subject to Prof_Student_46_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,46,i] = 1;
subject to Prof_Student_46_Minor:
	sum {k in DEPT6} P[k,46,2] = 1;
subject to Prof_Student_46_AtLarge {i in 1..3}:
	U[46,i] * 2 + V[46,i] <= 2;
subject to Prof_Student_47_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,47,i] = 1;
subject to Prof_Student_47_Minor:
	sum {k in (DEPT9 union DEPT1)} P[k,47,2] = 1;
subject to Prof_Student_47_AtLarge {i in 1..3}:
	U[47,i] * 2 + V[47,i] <= 2;
subject to Prof_Student_48_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,48,i] = 1;
subject to Prof_Student_48_Minor:
	sum {k in DEPT11} P[k,48,2] = 1;
subject to Prof_Student_48_AtLarge {i in 1..3}:
	U[48,i] * 2 + V[48,i] <= 2;
subject to Prof_Student_49_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,49,i] = 1;
subject to Prof_Student_49_Minor:
	sum {k in DEPT18} P[k,49,2] = 1;
subject to Prof_Student_49_AtLarge {i in 1..3}:
	U[49,i] * 2 + V[49,i] <= 2;
subject to Prof_Student_50_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,50,i] = 1;
subject to Prof_Student_50_Minor:
	sum {k in DEPT3} P[k,50,2] = 1;
subject to Prof_Student_50_AtLarge {i in 1..3}:
	U[50,i] * 2 + V[50,i] <= 2;
subject to Prof_Student_51_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,51,i] = 1;
subject to Prof_Student_51_Minor:
	sum {k in DEPT9} P[k,51,2] = 1;
subject to Prof_Student_51_AtLarge {i in 1..3}:
	U[51,i] * 2 + V[51,i] <= 2;
subject to Prof_Student_52_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,52,i] = 1;
subject to Prof_Student_52_Minor:
	sum {k in (DEPT9 union DEPT1)} P[k,52,2] = 1;
subject to Prof_Student_52_AtLarge {i in 1..3}:
	U[52,i] * 2 + V[52,i] <= 2;
subject to Prof_Student_53_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,53,i] = 1;
subject to Prof_Student_53_Minor:
	sum {k in DEPT21} P[k,53,2] = 1;
subject to Prof_Student_53_AtLarge {i in 1..3}:
	U[53,i] * 2 + V[53,i] <= 2;
subject to Prof_Student_54_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,54,i] = 1;
subject to Prof_Student_54_Minor:
	sum {k in DEPT10} P[k,54,2] = 1;
subject to Prof_Student_54_AtLarge {i in 1..3}:
	U[54,i] * 2 + V[54,i] <= 2;
subject to Prof_Student_55_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,55,i] = 1;
subject to Prof_Student_55_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,55,i] = 1;
subject to Prof_Student_55_AtLarge {i in 1..3}:
	U[55,i] * 2 + V[55,i] <= 2;
subject to Prof_Student_56_Dept_5:
	sum {k in DEPT5, i in 1..2} P[k,56,i] = 1;
subject to Prof_Student_56_Dept_15:
	sum {k in DEPT15, i in 1..2} P[k,56,i] = 1;
subject to Prof_Student_56_AtLarge {i in 1..3}:
	U[56,i] * 2 + V[56,i] <= 2;
subject to Prof_Student_57_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,57,i] = 1;
subject to Prof_Student_57_Minor:
	sum {k in DEPT6} P[k,57,2] = 1;
subject to Prof_Student_57_AtLarge {i in 1..3}:
	U[57,i] * 2 + V[57,i] <= 2;
subject to Prof_Student_58_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,58,i] = 1;
subject to Prof_Student_58_Minor:
	sum {k in DEPT14} P[k,58,2] = 1;
subject to Prof_Student_58_AtLarge {i in 1..3}:
	U[58,i] * 2 + V[58,i] <= 2;
subject to Prof_Student_59_Dept_24:
	sum {k in DEPT24, i in 1..2} P[k,59,i] = 1;
subject to Prof_Student_59_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,59,i] = 1;
subject to Prof_Student_59_AtLarge {i in 1..3}:
	U[59,i] * 2 + V[59,i] <= 2;
subject to Prof_Student_60_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,60,i] = 1;
subject to Prof_Student_60_Minor:
	sum {k in DEPT0} P[k,60,2] = 1;
subject to Prof_Student_60_AtLarge {i in 1..3}:
	U[60,i] * 2 + V[60,i] <= 2;
subject to Prof_Student_61_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,61,i] = 1;
subject to Prof_Student_61_Minor:
	sum {k in DEPT6} P[k,61,2] = 1;
subject to Prof_Student_61_AtLarge {i in 1..3}:
	U[61,i] * 2 + V[61,i] <= 2;
subject to Prof_Student_62_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,62,i] = 1;
subject to Prof_Student_62_Minor:
	sum {k in DEPT9} P[k,62,2] = 1;
subject to Prof_Student_62_AtLarge {i in 1..3}:
	U[62,i] * 2 + V[62,i] <= 2;
subject to Prof_Student_63_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,63,i] = 1;
subject to Prof_Student_63_Minor:
	sum {k in DEPT3} P[k,63,2] = 1;
subject to Prof_Student_63_AtLarge {i in 1..3}:
	U[63,i] * 2 + V[63,i] <= 2;
subject to Prof_Student_64_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,64,i] = 1;
subject to Prof_Student_64_Minor:
	sum {k in DEPT14} P[k,64,2] = 1;
subject to Prof_Student_64_AtLarge {i in 1..3}:
	U[64,i] * 2 + V[64,i] <= 2;
subject to Prof_Student_65_Dept_9:
	sum {k in DEPT9, i in 1..1} P[k,65,i] = 1;
subject to Prof_Student_65_Minor:
	sum {k in DEPT18} P[k,65,2] = 1;
subject to Prof_Student_65_AtLarge {i in 1..3}:
	U[65,i] * 2 + V[65,i] <= 2;
subject to Prof_Student_66_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,66,i] = 1;
subject to Prof_Student_66_Minor:
	sum {k in DEPT7} P[k,66,2] = 1;
subject to Prof_Student_66_AtLarge {i in 1..3}:
	U[66,i] * 2 + V[66,i] <= 2;
subject to Prof_Student_67_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,67,i] = 1;
subject to Prof_Student_67_Minor:
	sum {k in DEPT1} P[k,67,2] = 1;
subject to Prof_Student_67_AtLarge {i in 1..3}:
	U[67,i] * 2 + V[67,i] <= 2;
subject to Prof_Student_68_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,68,i] = 1;
subject to Prof_Student_68_Minor:
	sum {k in DEPT0} P[k,68,2] = 1;
subject to Prof_Student_68_AtLarge {i in 1..3}:
	U[68,i] * 2 + V[68,i] <= 2;
subject to Prof_Student_69_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,69,i] = 1;
subject to Prof_Student_69_Minor:
	sum {k in DEPT8} P[k,69,2] = 1;
subject to Prof_Student_69_AtLarge {i in 1..3}:
	U[69,i] * 2 + V[69,i] <= 2;
subject to Prof_Student_70_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,70,i] = 1;
subject to Prof_Student_70_Minor:
	sum {k in DEPT3} P[k,70,2] = 1;
subject to Prof_Student_70_AtLarge {i in 1..3}:
	U[70,i] * 2 + V[70,i] <= 2;
subject to Prof_Student_71_Dept_25:
	sum {k in DEPT25, i in 1..2} P[k,71,i] = 1;
subject to Prof_Student_71_Dept_15:
	sum {k in DEPT15, i in 1..2} P[k,71,i] = 1;
subject to Prof_Student_71_AtLarge {i in 1..3}:
	U[71,i] * 2 + V[71,i] <= 2;
subject to Prof_Student_72_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,72,i] = 1;
subject to Prof_Student_72_Minor:
	sum {k in DEPT21} P[k,72,2] = 1;
subject to Prof_Student_72_AtLarge {i in 1..3}:
	U[72,i] * 2 + V[72,i] <= 2;
subject to Prof_Student_73_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,73,i] = 1;
subject to Prof_Student_73_Minor:
	sum {k in DEPT1} P[k,73,2] = 1;
subject to Prof_Student_73_AtLarge {i in 1..3}:
	U[73,i] * 2 + V[73,i] <= 2;
subject to Prof_Student_74_Dept_7:
	sum {k in DEPT7, i in 1..1} P[k,74,i] = 1;
subject to Prof_Student_74_Minor:
	sum {k in DEPT6} P[k,74,2] = 1;
subject to Prof_Student_74_AtLarge {i in 1..3}:
	U[74,i] * 2 + V[74,i] <= 2;
subject to Prof_Student_75_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,75,i] = 1;
subject to Prof_Student_75_Minor:
	sum {k in DEPT6} P[k,75,2] = 1;
subject to Prof_Student_75_AtLarge {i in 1..3}:
	U[75,i] * 2 + V[75,i] <= 2;
subject to Prof_Student_76_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,76,i] = 1;
subject to Prof_Student_76_Minor:
	sum {k in DEPT17} P[k,76,2] = 1;
subject to Prof_Student_76_AtLarge {i in 1..3}:
	U[76,i] * 2 + V[76,i] <= 2;
subject to Prof_Student_77_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,77,i] = 1;
subject to Prof_Student_77_Minor:
	sum {k in DEPT21} P[k,77,2] = 1;
subject to Prof_Student_77_AtLarge {i in 1..3}:
	U[77,i] * 2 + V[77,i] <= 2;
subject to Prof_Student_78_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,78,i] = 1;
subject to Prof_Student_78_Minor:
	sum {k in DEPT1} P[k,78,2] = 1;
subject to Prof_Student_78_AtLarge {i in 1..3}:
	U[78,i] * 2 + V[78,i] <= 2;
subject to Prof_Student_79_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,79,i] = 1;
subject to Prof_Student_79_Minor:
	sum {k in DEPT6} P[k,79,2] = 1;
subject to Prof_Student_79_AtLarge {i in 1..3}:
	U[79,i] * 2 + V[79,i] <= 2;
subject to Prof_Student_80_Dept_5:
	sum {k in DEPT5, i in 1..2} P[k,80,i] = 1;
subject to Prof_Student_80_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,80,i] = 1;
subject to Prof_Student_80_AtLarge {i in 1..3}:
	U[80,i] * 2 + V[80,i] <= 2;
subject to Prof_Student_81_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,81,i] = 1;
subject to Prof_Student_81_Minor:
	sum {k in DEPT6} P[k,81,2] = 1;
subject to Prof_Student_81_AtLarge {i in 1..3}:
	U[81,i] * 2 + V[81,i] <= 2;
subject to Prof_Student_82_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,82,i] = 1;
subject to Prof_Student_82_Minor:
	sum {k in DEPT14} P[k,82,2] = 1;
subject to Prof_Student_82_AtLarge {i in 1..3}:
	U[82,i] * 2 + V[82,i] <= 2;
subject to Prof_Student_83_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,83,i] = 1;
subject to Prof_Student_83_Minor:
	sum {k in DEPT6} P[k,83,2] = 1;
subject to Prof_Student_83_AtLarge {i in 1..3}:
	U[83,i] * 2 + V[83,i] <= 2;
subject to Prof_Student_84_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,84,i] = 1;
subject to Prof_Student_84_Minor:
	sum {k in DEPT17} P[k,84,2] = 1;
subject to Prof_Student_84_AtLarge {i in 1..3}:
	U[84,i] * 2 + V[84,i] <= 2;
subject to Prof_Student_85_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,85,i] = 1;
subject to Prof_Student_85_Minor:
	sum {k in DEPT2} P[k,85,2] = 1;
subject to Prof_Student_85_AtLarge {i in 1..3}:
	U[85,i] * 2 + V[85,i] <= 2;
subject to Prof_Student_86_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,86,i] = 1;
subject to Prof_Student_86_Minor:
	sum {k in DEPT21} P[k,86,2] = 1;
subject to Prof_Student_86_AtLarge {i in 1..3}:
	U[86,i] * 2 + V[86,i] <= 2;
subject to Prof_Student_87_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,87,i] = 1;
subject to Prof_Student_87_Minor:
	sum {k in DEPT10} P[k,87,2] = 1;
subject to Prof_Student_87_AtLarge {i in 1..3}:
	U[87,i] * 2 + V[87,i] <= 2;
subject to Prof_Student_88_Dept_4:
	sum {k in DEPT4, i in 1..2} P[k,88,i] = 1;
subject to Prof_Student_88_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,88,i] = 1;
subject to Prof_Student_88_AtLarge {i in 1..3}:
	U[88,i] * 2 + V[88,i] <= 2;
subject to Prof_Student_89_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,89,i] = 1;
subject to Prof_Student_89_Minor:
	sum {k in DEPT19} P[k,89,2] = 1;
subject to Prof_Student_89_AtLarge {i in 1..3}:
	U[89,i] * 2 + V[89,i] <= 2;
subject to Prof_Student_90_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,90,i] = 1;
subject to Prof_Student_90_Minor:
	sum {k in (DEPT5 union DEPT26)} P[k,90,2] = 1;
subject to Prof_Student_90_AtLarge {i in 1..3}:
	U[90,i] * 2 + V[90,i] <= 2;
subject to Prof_Student_91_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,91,i] = 1;
subject to Prof_Student_91_Minor:
	sum {k in DEPT9} P[k,91,2] = 1;
subject to Prof_Student_91_AtLarge {i in 1..3}:
	U[91,i] * 2 + V[91,i] <= 2;
subject to Prof_Student_92_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,92,i] = 1;
subject to Prof_Student_92_Minor:
	sum {k in (DEPT6 union DEPT26)} P[k,92,2] = 1;
subject to Prof_Student_92_AtLarge {i in 1..3}:
	U[92,i] * 2 + V[92,i] <= 2;
subject to Prof_Student_93_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,93,i] = 1;
subject to Prof_Student_93_Minor:
	sum {k in DEPT6} P[k,93,2] = 1;
subject to Prof_Student_93_AtLarge {i in 1..3}:
	U[93,i] * 2 + V[93,i] <= 2;
subject to Prof_Student_94_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,94,i] = 1;
subject to Prof_Student_94_Minor:
	sum {k in DEPT6} P[k,94,2] = 1;
subject to Prof_Student_94_AtLarge {i in 1..3}:
	U[94,i] * 2 + V[94,i] <= 2;
subject to Prof_Student_95_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,95,i] = 1;
subject to Prof_Student_95_Minor:
	sum {k in (DEPT9 union DEPT4)} P[k,95,2] = 1;
subject to Prof_Student_95_AtLarge {i in 1..3}:
	U[95,i] * 2 + V[95,i] <= 2;
subject to Prof_Student_96_Dept_2:
	sum {k in DEPT2, i in 1..2} P[k,96,i] = 1;
subject to Prof_Student_96_Dept_3:
	sum {k in DEPT3, i in 1..2} P[k,96,i] = 1;
subject to Prof_Student_96_AtLarge {i in 1..3}:
	U[96,i] * 2 + V[96,i] <= 2;
subject to Prof_Student_97_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,97,i] = 1;
subject to Prof_Student_97_Minor:
	sum {k in DEPT10} P[k,97,2] = 1;
subject to Prof_Student_97_AtLarge {i in 1..3}:
	U[97,i] * 2 + V[97,i] <= 2;
subject to Prof_Student_98_Dept_19:
	sum {k in DEPT19, i in 1..1} P[k,98,i] = 1;
subject to Prof_Student_98_Minor:
	sum {k in (DEPT18 union DEPT23)} P[k,98,2] = 1;
subject to Prof_Student_98_AtLarge {i in 1..3}:
	U[98,i] * 2 + V[98,i] <= 2;
subject to Prof_Student_99_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,99,i] = 1;
subject to Prof_Student_99_Minor:
	sum {k in DEPT6} P[k,99,2] = 1;
subject to Prof_Student_99_AtLarge {i in 1..3}:
	U[99,i] * 2 + V[99,i] <= 2;
subject to Prof_Student_100_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,100,i] = 1;
subject to Prof_Student_100_Minor:
	sum {k in DEPT23} P[k,100,2] = 1;
subject to Prof_Student_100_AtLarge {i in 1..3}:
	U[100,i] * 2 + V[100,i] <= 2;
subject to Prof_Student_101_Dept_23:
	sum {k in DEPT23, i in 1..2} P[k,101,i] = 1;
subject to Prof_Student_101_Dept_0:
	sum {k in DEPT0, i in 1..2} P[k,101,i] = 1;
subject to Prof_Student_101_AtLarge {i in 1..3}:
	U[101,i] * 2 + V[101,i] <= 2;
subject to Prof_Student_102_Dept_8:
	sum {k in DEPT8, i in 1..1} P[k,102,i] = 1;
subject to Prof_Student_102_Minor:
	sum {k in DEPT14} P[k,102,2] = 1;
subject to Prof_Student_102_AtLarge {i in 1..3}:
	U[102,i] * 2 + V[102,i] <= 2;
subject to Prof_Student_103_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,103,i] = 1;
subject to Prof_Student_103_Minor:
	sum {k in (DEPT22 union DEPT14)} P[k,103,2] = 1;
subject to Prof_Student_103_AtLarge {i in 1..3}:
	U[103,i] * 2 + V[103,i] <= 2;
subject to Prof_Student_104_Dept_1:
	sum {k in DEPT1, i in 1..2} P[k,104,i] = 1;
subject to Prof_Student_104_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,104,i] = 1;
subject to Prof_Student_104_AtLarge {i in 1..3}:
	U[104,i] * 2 + V[104,i] <= 2;
subject to Prof_Student_105_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,105,i] = 1;
subject to Prof_Student_105_Minor:
	sum {k in (DEPT11 union DEPT6)} P[k,105,2] = 1;
subject to Prof_Student_105_AtLarge {i in 1..3}:
	U[105,i] * 2 + V[105,i] <= 2;
subject to Prof_Student_106_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,106,i] = 1;
subject to Prof_Student_106_Minor:
	sum {k in DEPT11} P[k,106,2] = 1;
subject to Prof_Student_106_AtLarge {i in 1..3}:
	U[106,i] * 2 + V[106,i] <= 2;
subject to Prof_Student_107_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,107,i] = 1;
subject to Prof_Student_107_Minor:
	sum {k in DEPT11} P[k,107,2] = 1;
subject to Prof_Student_107_AtLarge {i in 1..3}:
	U[107,i] * 2 + V[107,i] <= 2;
subject to Prof_Student_108_Dept_4:
	sum {k in DEPT4, i in 1..2} P[k,108,i] = 1;
subject to Prof_Student_108_Dept_7:
	sum {k in DEPT7, i in 1..2} P[k,108,i] = 1;
subject to Prof_Student_108_AtLarge {i in 1..3}:
	U[108,i] * 2 + V[108,i] <= 2;
subject to Prof_Student_109_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,109,i] = 1;
subject to Prof_Student_109_Minor:
	sum {k in DEPT10} P[k,109,2] = 1;
subject to Prof_Student_109_AtLarge {i in 1..3}:
	U[109,i] * 2 + V[109,i] <= 2;
subject to Prof_Student_110_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,110,i] = 1;
subject to Prof_Student_110_Minor:
	sum {k in DEPT15} P[k,110,2] = 1;
subject to Prof_Student_110_AtLarge {i in 1..3}:
	U[110,i] * 2 + V[110,i] <= 2;
subject to Prof_Student_111_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,111,i] = 1;
subject to Prof_Student_111_Minor:
	sum {k in (DEPT18 union DEPT7)} P[k,111,2] = 1;
subject to Prof_Student_111_AtLarge {i in 1..3}:
	U[111,i] * 2 + V[111,i] <= 2;
subject to Prof_Student_112_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,112,i] = 1;
subject to Prof_Student_112_Minor:
	sum {k in DEPT7} P[k,112,2] = 1;
subject to Prof_Student_112_AtLarge {i in 1..3}:
	U[112,i] * 2 + V[112,i] <= 2;
subject to Prof_Student_113_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,113,i] = 1;
subject to Prof_Student_113_Minor:
	sum {k in DEPT18} P[k,113,2] = 1;
subject to Prof_Student_113_AtLarge {i in 1..3}:
	U[113,i] * 2 + V[113,i] <= 2;
subject to Prof_Student_114_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,114,i] = 1;
subject to Prof_Student_114_Minor:
	sum {k in (DEPT26 union DEPT10 union DEPT16)} P[k,114,2] = 1;
subject to Prof_Student_114_AtLarge {i in 1..3}:
	U[114,i] * 2 + V[114,i] <= 2;
subject to Prof_Student_115_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,115,i] = 1;
subject to Prof_Student_115_Minor:
	sum {k in DEPT10} P[k,115,2] = 1;
subject to Prof_Student_115_AtLarge {i in 1..3}:
	U[115,i] * 2 + V[115,i] <= 2;
subject to Prof_Student_116_Dept_9:
	sum {k in DEPT9, i in 1..2} P[k,116,i] = 1;
subject to Prof_Student_116_Dept_15:
	sum {k in DEPT15, i in 1..2} P[k,116,i] = 1;
subject to Prof_Student_116_AtLarge {i in 1..3}:
	U[116,i] * 2 + V[116,i] <= 2;
subject to Prof_Student_117_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,117,i] = 1;
subject to Prof_Student_117_Minor:
	sum {k in DEPT26} P[k,117,2] = 1;
subject to Prof_Student_117_AtLarge {i in 1..3}:
	U[117,i] * 2 + V[117,i] <= 2;
subject to Prof_Student_118_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,118,i] = 1;
subject to Prof_Student_118_Minor:
	sum {k in (DEPT5 union DEPT26)} P[k,118,2] = 1;
subject to Prof_Student_118_AtLarge {i in 1..3}:
	U[118,i] * 2 + V[118,i] <= 2;
subject to Prof_Student_119_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,119,i] = 1;
subject to Prof_Student_119_Minor:
	sum {k in DEPT26} P[k,119,2] = 1;
subject to Prof_Student_119_AtLarge {i in 1..3}:
	U[119,i] * 2 + V[119,i] <= 2;
subject to Prof_Student_120_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,120,i] = 1;
subject to Prof_Student_120_Minor:
	sum {k in (DEPT26 union DEPT4)} P[k,120,2] = 1;
subject to Prof_Student_120_AtLarge {i in 1..3}:
	U[120,i] * 2 + V[120,i] <= 2;
subject to Prof_Student_121_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,121,i] = 1;
subject to Prof_Student_121_Minor:
	sum {k in DEPT17} P[k,121,2] = 1;
subject to Prof_Student_121_AtLarge {i in 1..3}:
	U[121,i] * 2 + V[121,i] <= 2;
subject to Prof_Student_122_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,122,i] = 1;
subject to Prof_Student_122_Minor:
	sum {k in DEPT9} P[k,122,2] = 1;
subject to Prof_Student_122_AtLarge {i in 1..3}:
	U[122,i] * 2 + V[122,i] <= 2;
subject to Prof_Student_123_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,123,i] = 1;
subject to Prof_Student_123_Minor:
	sum {k in DEPT21} P[k,123,2] = 1;
subject to Prof_Student_123_AtLarge {i in 1..3}:
	U[123,i] * 2 + V[123,i] <= 2;
subject to Prof_Student_124_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,124,i] = 1;
subject to Prof_Student_124_Minor:
	sum {k in DEPT1} P[k,124,2] = 1;
subject to Prof_Student_124_AtLarge {i in 1..3}:
	U[124,i] * 2 + V[124,i] <= 2;
subject to Prof_Student_125_Dept_3:
	sum {k in DEPT3, i in 1..2} P[k,125,i] = 1;
subject to Prof_Student_125_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,125,i] = 1;
subject to Prof_Student_125_AtLarge {i in 1..3}:
	U[125,i] * 2 + V[125,i] <= 2;
subject to Prof_Student_126_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,126,i] = 1;
subject to Prof_Student_126_Minor:
	sum {k in DEPT9} P[k,126,2] = 1;
subject to Prof_Student_126_AtLarge {i in 1..3}:
	U[126,i] * 2 + V[126,i] <= 2;
subject to Prof_Student_127_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,127,i] = 1;
subject to Prof_Student_127_Minor:
	sum {k in DEPT11} P[k,127,2] = 1;
subject to Prof_Student_127_AtLarge {i in 1..3}:
	U[127,i] * 2 + V[127,i] <= 2;
subject to Prof_Student_128_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,128,i] = 1;
subject to Prof_Student_128_Minor:
	sum {k in DEPT4} P[k,128,2] = 1;
subject to Prof_Student_128_AtLarge {i in 1..3}:
	U[128,i] * 2 + V[128,i] <= 2;
subject to Prof_Student_129_Dept_7:
	sum {k in DEPT7, i in 1..1} P[k,129,i] = 1;
subject to Prof_Student_129_Minor:
	sum {k in DEPT10} P[k,129,2] = 1;
subject to Prof_Student_129_AtLarge {i in 1..3}:
	U[129,i] * 2 + V[129,i] <= 2;
subject to Prof_Student_130_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,130,i] = 1;
subject to Prof_Student_130_Minor:
	sum {k in DEPT0} P[k,130,2] = 1;
subject to Prof_Student_130_AtLarge {i in 1..3}:
	U[130,i] * 2 + V[130,i] <= 2;
subject to Prof_Student_131_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,131,i] = 1;
subject to Prof_Student_131_Minor:
	sum {k in DEPT1} P[k,131,2] = 1;
subject to Prof_Student_131_AtLarge {i in 1..3}:
	U[131,i] * 2 + V[131,i] <= 2;
subject to Prof_Student_132_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,132,i] = 1;
subject to Prof_Student_132_Minor:
	sum {k in DEPT10} P[k,132,2] = 1;
subject to Prof_Student_132_AtLarge {i in 1..3}:
	U[132,i] * 2 + V[132,i] <= 2;
subject to Prof_Student_133_Dept_12:
	sum {k in DEPT12, i in 1..2} P[k,133,i] = 1;
subject to Prof_Student_133_Dept_6:
	sum {k in DEPT6, i in 1..2} P[k,133,i] = 1;
subject to Prof_Student_133_AtLarge {i in 1..3}:
	U[133,i] * 2 + V[133,i] <= 2;
subject to Prof_Student_134_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,134,i] = 1;
subject to Prof_Student_134_Minor:
	sum {k in DEPT15} P[k,134,2] = 1;
subject to Prof_Student_134_AtLarge {i in 1..3}:
	U[134,i] * 2 + V[134,i] <= 2;
subject to Prof_Student_135_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,135,i] = 1;
subject to Prof_Student_135_Minor:
	sum {k in DEPT9} P[k,135,2] = 1;
subject to Prof_Student_135_AtLarge {i in 1..3}:
	U[135,i] * 2 + V[135,i] <= 2;
subject to Prof_Student_136_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,136,i] = 1;
subject to Prof_Student_136_Minor:
	sum {k in (DEPT9 union DEPT27)} P[k,136,2] = 1;
subject to Prof_Student_136_AtLarge {i in 1..3}:
	U[136,i] * 2 + V[136,i] <= 2;
subject to Prof_Student_137_Dept_19:
	sum {k in DEPT19, i in 1..1} P[k,137,i] = 1;
subject to Prof_Student_137_Minor:
	sum {k in DEPT18} P[k,137,2] = 1;
subject to Prof_Student_137_AtLarge {i in 1..3}:
	U[137,i] * 2 + V[137,i] <= 2;
subject to Prof_Student_138_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,138,i] = 1;
subject to Prof_Student_138_Minor:
	sum {k in DEPT4} P[k,138,2] = 1;
subject to Prof_Student_138_AtLarge {i in 1..3}:
	U[138,i] * 2 + V[138,i] <= 2;
subject to Prof_Student_139_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,139,i] = 1;
subject to Prof_Student_139_Minor:
	sum {k in DEPT9} P[k,139,2] = 1;
subject to Prof_Student_139_AtLarge {i in 1..3}:
	U[139,i] * 2 + V[139,i] <= 2;
subject to Prof_Student_140_Dept_24:
	sum {k in DEPT24, i in 1..1} P[k,140,i] = 1;
subject to Prof_Student_140_Minor:
	sum {k in DEPT11} P[k,140,2] = 1;
subject to Prof_Student_140_AtLarge {i in 1..3}:
	U[140,i] * 2 + V[140,i] <= 2;
subject to Prof_Student_141_Dept_17:
	sum {k in DEPT17, i in 1..1} P[k,141,i] = 1;
subject to Prof_Student_141_Minor:
	sum {k in DEPT14} P[k,141,2] = 1;
subject to Prof_Student_141_AtLarge {i in 1..3}:
	U[141,i] * 2 + V[141,i] <= 2;
subject to Prof_Student_142_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,142,i] = 1;
subject to Prof_Student_142_Minor:
	sum {k in DEPT14} P[k,142,2] = 1;
subject to Prof_Student_142_AtLarge {i in 1..3}:
	U[142,i] * 2 + V[142,i] <= 2;
subject to Prof_Student_143_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,143,i] = 1;
subject to Prof_Student_143_Minor:
	sum {k in DEPT11} P[k,143,2] = 1;
subject to Prof_Student_143_AtLarge {i in 1..3}:
	U[143,i] * 2 + V[143,i] <= 2;
subject to Prof_Student_144_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,144,i] = 1;
subject to Prof_Student_144_Minor:
	sum {k in DEPT19} P[k,144,2] = 1;
subject to Prof_Student_144_AtLarge {i in 1..3}:
	U[144,i] * 2 + V[144,i] <= 2;
subject to Prof_Student_145_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,145,i] = 1;
subject to Prof_Student_145_Minor:
	sum {k in DEPT14} P[k,145,2] = 1;
subject to Prof_Student_145_AtLarge {i in 1..3}:
	U[145,i] * 2 + V[145,i] <= 2;
subject to Prof_Student_146_Dept_0:
	sum {k in DEPT0, i in 1..2} P[k,146,i] = 1;
subject to Prof_Student_146_Dept_12:
	sum {k in DEPT12, i in 1..2} P[k,146,i] = 1;
subject to Prof_Student_146_AtLarge {i in 1..3}:
	U[146,i] * 2 + V[146,i] <= 2;
subject to Prof_Student_147_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,147,i] = 1;
subject to Prof_Student_147_Minor:
	sum {k in DEPT17} P[k,147,2] = 1;
subject to Prof_Student_147_AtLarge {i in 1..3}:
	U[147,i] * 2 + V[147,i] <= 2;
subject to Prof_Student_148_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,148,i] = 1;
subject to Prof_Student_148_Minor:
	sum {k in DEPT14} P[k,148,2] = 1;
subject to Prof_Student_148_AtLarge {i in 1..3}:
	U[148,i] * 2 + V[148,i] <= 2;
subject to Prof_Student_149_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,149,i] = 1;
subject to Prof_Student_149_Minor:
	sum {k in DEPT26} P[k,149,2] = 1;
subject to Prof_Student_149_AtLarge {i in 1..3}:
	U[149,i] * 2 + V[149,i] <= 2;
subject to Prof_Student_150_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,150,i] = 1;
subject to Prof_Student_150_Minor:
	sum {k in DEPT26} P[k,150,2] = 1;
subject to Prof_Student_150_AtLarge {i in 1..3}:
	U[150,i] * 2 + V[150,i] <= 2;
subject to Prof_Student_151_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,151,i] = 1;
subject to Prof_Student_151_Minor:
	sum {k in DEPT10} P[k,151,2] = 1;
subject to Prof_Student_151_AtLarge {i in 1..3}:
	U[151,i] * 2 + V[151,i] <= 2;
subject to Prof_Student_152_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,152,i] = 1;
subject to Prof_Student_152_Minor:
	sum {k in (DEPT23 union DEPT7)} P[k,152,2] = 1;
subject to Prof_Student_152_AtLarge {i in 1..3}:
	U[152,i] * 2 + V[152,i] <= 2;
subject to Prof_Student_153_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,153,i] = 1;
subject to Prof_Student_153_Minor:
	sum {k in DEPT0} P[k,153,2] = 1;
subject to Prof_Student_153_AtLarge {i in 1..3}:
	U[153,i] * 2 + V[153,i] <= 2;
subject to Prof_Student_154_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,154,i] = 1;
subject to Prof_Student_154_Minor:
	sum {k in DEPT0} P[k,154,2] = 1;
subject to Prof_Student_154_AtLarge {i in 1..3}:
	U[154,i] * 2 + V[154,i] <= 2;
subject to Prof_Student_155_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,155,i] = 1;
subject to Prof_Student_155_Minor:
	sum {k in DEPT1} P[k,155,2] = 1;
subject to Prof_Student_155_AtLarge {i in 1..3}:
	U[155,i] * 2 + V[155,i] <= 2;
subject to Prof_Student_156_Dept_2:
	sum {k in DEPT2, i in 1..1} P[k,156,i] = 1;
subject to Prof_Student_156_Minor:
	sum {k in DEPT4} P[k,156,2] = 1;
subject to Prof_Student_156_AtLarge {i in 1..3}:
	U[156,i] * 2 + V[156,i] <= 2;
subject to Prof_Student_157_Dept_5:
	sum {k in DEPT5, i in 1..1} P[k,157,i] = 1;
subject to Prof_Student_157_Minor:
	sum {k in DEPT6} P[k,157,2] = 1;
subject to Prof_Student_157_AtLarge {i in 1..3}:
	U[157,i] * 2 + V[157,i] <= 2;
subject to Prof_Student_158_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,158,i] = 1;
subject to Prof_Student_158_Minor:
	sum {k in DEPT11} P[k,158,2] = 1;
subject to Prof_Student_158_AtLarge {i in 1..3}:
	U[158,i] * 2 + V[158,i] <= 2;
subject to Prof_Student_159_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,159,i] = 1;
subject to Prof_Student_159_Minor:
	sum {k in DEPT24} P[k,159,2] = 1;
subject to Prof_Student_159_AtLarge {i in 1..3}:
	U[159,i] * 2 + V[159,i] <= 2;
subject to Prof_Student_160_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,160,i] = 1;
subject to Prof_Student_160_Minor:
	sum {k in (DEPT12 union DEPT14)} P[k,160,2] = 1;
subject to Prof_Student_160_AtLarge {i in 1..3}:
	U[160,i] * 2 + V[160,i] <= 2;
subject to Prof_Student_161_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,161,i] = 1;
subject to Prof_Student_161_Minor:
	sum {k in (DEPT9 union DEPT5)} P[k,161,2] = 1;
subject to Prof_Student_161_AtLarge {i in 1..3}:
	U[161,i] * 2 + V[161,i] <= 2;
subject to Prof_Student_162_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,162,i] = 1;
subject to Prof_Student_162_Minor:
	sum {k in DEPT0} P[k,162,2] = 1;
subject to Prof_Student_162_AtLarge {i in 1..3}:
	U[162,i] * 2 + V[162,i] <= 2;
subject to Prof_Student_163_Dept_11:
	sum {k in DEPT11, i in 1..1} P[k,163,i] = 1;
subject to Prof_Student_163_Minor:
	sum {k in DEPT1} P[k,163,2] = 1;
subject to Prof_Student_163_AtLarge {i in 1..3}:
	U[163,i] * 2 + V[163,i] <= 2;
subject to Prof_Student_164_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,164,i] = 1;
subject to Prof_Student_164_Minor:
	sum {k in DEPT10} P[k,164,2] = 1;
subject to Prof_Student_164_AtLarge {i in 1..3}:
	U[164,i] * 2 + V[164,i] <= 2;
subject to Prof_Student_165_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,165,i] = 1;
subject to Prof_Student_165_Minor:
	sum {k in DEPT6} P[k,165,2] = 1;
subject to Prof_Student_165_AtLarge {i in 1..3}:
	U[165,i] * 2 + V[165,i] <= 2;
subject to Prof_Student_166_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,166,i] = 1;
subject to Prof_Student_166_Minor:
	sum {k in (DEPT5 union DEPT4)} P[k,166,2] = 1;
subject to Prof_Student_166_AtLarge {i in 1..3}:
	U[166,i] * 2 + V[166,i] <= 2;
subject to Prof_Student_167_Dept_15:
	sum {k in DEPT15, i in 1..1} P[k,167,i] = 1;
subject to Prof_Student_167_Minor:
	sum {k in (DEPT14 union DEPT0)} P[k,167,2] = 1;
subject to Prof_Student_167_AtLarge {i in 1..3}:
	U[167,i] * 2 + V[167,i] <= 2;
subject to Prof_Student_168_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,168,i] = 1;
subject to Prof_Student_168_Minor:
	sum {k in DEPT15} P[k,168,2] = 1;
subject to Prof_Student_168_AtLarge {i in 1..3}:
	U[168,i] * 2 + V[168,i] <= 2;
subject to Prof_Student_169_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,169,i] = 1;
subject to Prof_Student_169_Minor:
	sum {k in DEPT21} P[k,169,2] = 1;
subject to Prof_Student_169_AtLarge {i in 1..3}:
	U[169,i] * 2 + V[169,i] <= 2;
subject to Prof_Student_170_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,170,i] = 1;
subject to Prof_Student_170_Minor:
	sum {k in (DEPT1 union DEPT21)} P[k,170,2] = 1;
subject to Prof_Student_170_AtLarge {i in 1..3}:
	U[170,i] * 2 + V[170,i] <= 2;
subject to Prof_Student_171_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,171,i] = 1;
subject to Prof_Student_171_Minor:
	sum {k in DEPT6} P[k,171,2] = 1;
subject to Prof_Student_171_AtLarge {i in 1..3}:
	U[171,i] * 2 + V[171,i] <= 2;
subject to Prof_Student_172_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,172,i] = 1;
subject to Prof_Student_172_Minor:
	sum {k in DEPT4} P[k,172,2] = 1;
subject to Prof_Student_172_AtLarge {i in 1..3}:
	U[172,i] * 2 + V[172,i] <= 2;
subject to Prof_Student_173_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,173,i] = 1;
subject to Prof_Student_173_Minor:
	sum {k in DEPT3} P[k,173,2] = 1;
subject to Prof_Student_173_AtLarge {i in 1..3}:
	U[173,i] * 2 + V[173,i] <= 2;
subject to Prof_Student_174_Dept_4:
	sum {k in DEPT4, i in 1..1} P[k,174,i] = 1;
subject to Prof_Student_174_Minor:
	sum {k in DEPT1} P[k,174,2] = 1;
subject to Prof_Student_174_AtLarge {i in 1..3}:
	U[174,i] * 2 + V[174,i] <= 2;
subject to Prof_Student_175_Dept_0:
	sum {k in DEPT0, i in 1..1} P[k,175,i] = 1;
subject to Prof_Student_175_Minor:
	sum {k in DEPT6} P[k,175,2] = 1;
subject to Prof_Student_175_AtLarge {i in 1..3}:
	U[175,i] * 2 + V[175,i] <= 2;
subject to Prof_Student_176_Dept_13:
	sum {k in DEPT13, i in 1..1} P[k,176,i] = 1;
subject to Prof_Student_176_Minor:
	sum {k in DEPT6} P[k,176,2] = 1;
subject to Prof_Student_176_AtLarge {i in 1..3}:
	U[176,i] * 2 + V[176,i] <= 2;
subject to Prof_Student_177_Dept_9:
	sum {k in DEPT9, i in 1..2} P[k,177,i] = 1;
subject to Prof_Student_177_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,177,i] = 1;
subject to Prof_Student_177_AtLarge {i in 1..3}:
	U[177,i] * 2 + V[177,i] <= 2;
subject to Prof_Student_178_Dept_4:
	sum {k in DEPT4, i in 1..2} P[k,178,i] = 1;
subject to Prof_Student_178_Dept_2:
	sum {k in DEPT2, i in 1..2} P[k,178,i] = 1;
subject to Prof_Student_178_AtLarge {i in 1..3}:
	U[178,i] * 2 + V[178,i] <= 2;
subject to Prof_Student_179_Dept_10:
	sum {k in DEPT10, i in 1..1} P[k,179,i] = 1;
subject to Prof_Student_179_Minor:
	sum {k in DEPT20} P[k,179,2] = 1;
subject to Prof_Student_179_AtLarge {i in 1..3}:
	U[179,i] * 2 + V[179,i] <= 2;
subject to Prof_Student_180_Dept_3:
	sum {k in DEPT3, i in 1..1} P[k,180,i] = 1;
subject to Prof_Student_180_Minor:
	sum {k in (DEPT2 union DEPT5)} P[k,180,2] = 1;
subject to Prof_Student_180_AtLarge {i in 1..3}:
	U[180,i] * 2 + V[180,i] <= 2;
subject to Prof_Student_181_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,181,i] = 1;
subject to Prof_Student_181_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,181,i] = 1;
subject to Prof_Student_181_AtLarge {i in 1..3}:
	U[181,i] * 2 + V[181,i] <= 2;
subject to Prof_Student_182_Dept_6:
	sum {k in DEPT6, i in 1..1} P[k,182,i] = 1;
subject to Prof_Student_182_Minor:
	sum {k in DEPT22} P[k,182,2] = 1;
subject to Prof_Student_182_AtLarge {i in 1..3}:
	U[182,i] * 2 + V[182,i] <= 2;
subject to Prof_Student_183_Dept_18:
	sum {k in DEPT18, i in 1..2} P[k,183,i] = 1;
subject to Prof_Student_183_Dept_19:
	sum {k in DEPT19, i in 1..2} P[k,183,i] = 1;
subject to Prof_Student_183_AtLarge {i in 1..3}:
	U[183,i] * 2 + V[183,i] <= 2;
subject to Prof_Student_184_Dept_1:
	sum {k in DEPT1, i in 1..1} P[k,184,i] = 1;
subject to Prof_Student_184_Minor:
	sum {k in DEPT18} P[k,184,2] = 1;
subject to Prof_Student_184_AtLarge {i in 1..3}:
	U[184,i] * 2 + V[184,i] <= 2;
subject to Prof_Student_185_Dept_3:
	sum {k in DEPT3, i in 1..2} P[k,185,i] = 1;
subject to Prof_Student_185_Dept_11:
	sum {k in DEPT11, i in 1..2} P[k,185,i] = 1;
subject to Prof_Student_185_AtLarge {i in 1..3}:
	U[185,i] * 2 + V[185,i] <= 2;
subject to Prof_Student_186_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,186,i] = 1;
subject to Prof_Student_186_Minor:
	sum {k in DEPT1} P[k,186,2] = 1;
subject to Prof_Student_186_AtLarge {i in 1..3}:
	U[186,i] * 2 + V[186,i] <= 2;
subject to Prof_Student_187_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,187,i] = 1;
subject to Prof_Student_187_Minor:
	sum {k in DEPT1} P[k,187,2] = 1;
subject to Prof_Student_187_AtLarge {i in 1..3}:
	U[187,i] * 2 + V[187,i] <= 2;
subject to Prof_Student_188_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,188,i] = 1;
subject to Prof_Student_188_Minor:
	sum {k in DEPT1} P[k,188,2] = 1;
subject to Prof_Student_188_AtLarge {i in 1..3}:
	U[188,i] * 2 + V[188,i] <= 2;
subject to Prof_Student_189_Dept_18:
	sum {k in DEPT18, i in 1..1} P[k,189,i] = 1;
subject to Prof_Student_189_Minor:
	sum {k in DEPT1} P[k,189,2] = 1;
subject to Prof_Student_189_AtLarge {i in 1..3}:
	U[189,i] * 2 + V[189,i] <= 2;
subject to Udef1 {l in STUDENT}:
	sum {k in DIV1} P[k,l,3+TRIPLE[l]] = U[l,1];
subject to Udef2 {l in STUDENT}:
	sum {k in DIV2} P[k,l,3+TRIPLE[l]] = U[l,2];
subject to Udef3 {l in STUDENT}:
	sum {k in DIV3} P[k,l,3+TRIPLE[l]] = U[l,3];
subject to Vdef1 {l in STUDENT}:
	sum {k in DIV1, i in 1..2+TRIPLE[l]} P[k,l,i] = V[l,1];
subject to Vdef2 {l in STUDENT}:
	sum {k in DIV2, i in 1..2+TRIPLE[l]} P[k,l,i] = V[l,2];
subject to Vdef3 {l in STUDENT}:
	sum {k in DIV3, i in 1..2+TRIPLE[l]} P[k,l,i] = V[l,3];
subject to No_New_1st_Major_Students:
	sum {k in TEACHER, l in STUDENT} P[k,l,1] * SNR[k,1] = 0;
subject to Maj_Prof_2ndYr_Then_No_New {l in STUDENT}:
	(sum {k in TEACHER, i in 2..4} (P[k,l,i] * SNR[k,1])) + 3 * (sum {k in TEACHER} (P[k,l,1] * SNR[k,2])) <= 3;
