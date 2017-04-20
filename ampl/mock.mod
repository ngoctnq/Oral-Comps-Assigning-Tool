param DAY;
param SESSION;
set STUDENT;
set TEACHER;
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
	default 10;
param BUSY {1..DAY, 1..SESSION, TEACHER} binary
	default 0;
param BUSZ {1..DAY, 1..SESSION, STUDENT} binary
	default 0;
param TRIPLE {STUDENT} binary
	default 0;
var Y {1..DAY, 1..SESSION, STUDENT} binary;
var C {TEACHER, STUDENT} binary;
var P {TEACHER, STUDENT, 1..4} binary;
var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;

minimize OBJ: 1;
#minimize OBJ: sum {k in TEACHER} (((sum {l in STUDENT} C[k,l])-6)^2)/80;

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
	sum {k in TEACHER} P[k,l,4] <= 1;
subject to Prof_Student_Timeslot {k in TEACHER, l in STUDENT}:
	sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = sum {i in 1..4} P[k,l,i];
subject to Prof_Student_0_Dept_0:
	sum {k in DEPT0} P[k,0,1] = 1;
subject to Prof_Student_0_Minor:
	sum {k in (DEPT1 union DEPT1 union DEPT2)} P[k,0,2] = 1;
subject to Prof_Student_0_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT1 diff DEPT2)} P[k,0,3 + TRIPLE[0]] = 1;
subject to Prof_Student_1_Dept_3:
	sum {k in DEPT3} P[k,1,1] = 1;
subject to Prof_Student_1_Minor:
	sum {k in DEPT1} P[k,1,2] = 1;
subject to Prof_Student_1_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT1)} P[k,1,3 + TRIPLE[1]] = 1;
subject to Prof_Student_2_Dept_4:
	sum {k in DEPT4} P[k,2,1] = 1;
subject to Prof_Student_2_Minor:
	sum {k in DEPT5} P[k,2,2] = 1;
subject to Prof_Student_2_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT5)} P[k,2,3 + TRIPLE[2]] = 1;
subject to Prof_Student_3_Dept_6:
	sum {k in DEPT6} P[k,3,1] = 1;
subject to Prof_Student_3_Minor:
	sum {k in DEPT1} P[k,3,2] = 1;
subject to Prof_Student_3_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT1)} P[k,3,3 + TRIPLE[3]] = 1;
subject to Prof_Student_4_Dept_7:
	sum {k in DEPT7} P[k,4,1] = 1;
subject to Prof_Student_4_Minor:
	sum {k in DEPT5} P[k,4,2] = 1;
subject to Prof_Student_4_AtLarge:
	sum {k in (TEACHER diff DEPT7 diff DEPT5)} P[k,4,3 + TRIPLE[4]] = 1;
subject to Prof_Student_5_Dept_8:
	sum {k in DEPT8} P[k,5,1] = 1;
subject to Prof_Student_5_Minor:
	sum {k in DEPT4} P[k,5,2] = 1;
subject to Prof_Student_5_AtLarge:
	sum {k in (TEACHER diff DEPT8 diff DEPT4)} P[k,5,3 + TRIPLE[5]] = 1;
subject to Prof_Student_6_Dept_9:
	sum {k in DEPT9} P[k,6,1] = 1;
subject to Prof_Student_6_Minor:
	sum {k in DEPT10} P[k,6,2] = 1;
subject to Prof_Student_6_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT10)} P[k,6,3 + TRIPLE[6]] = 1;
subject to Prof_Student_7_Dept_8:
	sum {k in DEPT8} P[k,7,1] = 1;
subject to Prof_Student_7_Minor:
	sum {k in DEPT2} P[k,7,2] = 1;
subject to Prof_Student_7_AtLarge:
	sum {k in (TEACHER diff DEPT8 diff DEPT2)} P[k,7,3 + TRIPLE[7]] = 1;
subject to Prof_Student_8_Dept_0:
	sum {k in DEPT0} P[k,8,1] = 1;
subject to Prof_Student_8_Minor:
	sum {k in DEPT11} P[k,8,2] = 1;
subject to Prof_Student_8_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT11)} P[k,8,3 + TRIPLE[8]] = 1;
subject to Prof_Student_9_Dept_12:
	sum {k in DEPT12} P[k,9,1] = 1;
subject to Prof_Student_9_Dept_3:
	sum {k in DEPT3} P[k,9,2] = 1;
subject to Prof_Student_9_Dept_0:
	sum {k in DEPT0} P[k,9,3] = 1;
subject to Prof_Student_9_AtLarge:
	sum {k in (TEACHER diff DEPT12 diff DEPT3 diff DEPT0)} P[k,9,3 + TRIPLE[9]] = 1;
subject to Prof_Student_10_Dept_13:
	sum {k in DEPT13} P[k,10,1] = 1;
subject to Prof_Student_10_Minor:
	sum {k in DEPT14} P[k,10,2] = 1;
subject to Prof_Student_10_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT14)} P[k,10,3 + TRIPLE[10]] = 1;
subject to Prof_Student_11_Dept_15:
	sum {k in DEPT15} P[k,11,1] = 1;
subject to Prof_Student_11_Minor:
	sum {k in DEPT16} P[k,11,2] = 1;
subject to Prof_Student_11_AtLarge:
	sum {k in (TEACHER diff DEPT15 diff DEPT16)} P[k,11,3 + TRIPLE[11]] = 1;
subject to Prof_Student_12_Dept_6:
	sum {k in DEPT6} P[k,12,1] = 1;
subject to Prof_Student_12_Minor:
	sum {k in DEPT10} P[k,12,2] = 1;
subject to Prof_Student_12_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT10)} P[k,12,3 + TRIPLE[12]] = 1;
subject to Prof_Student_13_Dept_6:
	sum {k in DEPT6} P[k,13,1] = 1;
subject to Prof_Student_13_Minor:
	sum {k in DEPT11} P[k,13,2] = 1;
subject to Prof_Student_13_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT11)} P[k,13,3 + TRIPLE[13]] = 1;
subject to Prof_Student_14_Dept_5:
	sum {k in DEPT5} P[k,14,1] = 1;
subject to Prof_Student_14_Minor:
	sum {k in DEPT9} P[k,14,2] = 1;
subject to Prof_Student_14_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,14,3 + TRIPLE[14]] = 1;
subject to Prof_Student_15_Dept_17:
	sum {k in DEPT17} P[k,15,1] = 1;
subject to Prof_Student_15_Dept_8:
	sum {k in DEPT8} P[k,15,2] = 1;
subject to Prof_Student_15_AtLarge:
	sum {k in (TEACHER diff DEPT17 diff DEPT8)} P[k,15,3 + TRIPLE[15]] = 1;
subject to Prof_Student_16_Dept_1:
	sum {k in DEPT1} P[k,16,1] = 1;
subject to Prof_Student_16_Minor:
	sum {k in DEPT18} P[k,16,2] = 1;
subject to Prof_Student_16_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT18)} P[k,16,3 + TRIPLE[16]] = 1;
subject to Prof_Student_17_Dept_3:
	sum {k in DEPT3} P[k,17,1] = 1;
subject to Prof_Student_17_Minor:
	sum {k in DEPT1} P[k,17,2] = 1;
subject to Prof_Student_17_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT1)} P[k,17,3 + TRIPLE[17]] = 1;
subject to Prof_Student_18_Dept_17:
	sum {k in DEPT17} P[k,18,1] = 1;
subject to Prof_Student_18_Minor:
	sum {k in DEPT15} P[k,18,2] = 1;
subject to Prof_Student_18_AtLarge:
	sum {k in (TEACHER diff DEPT17 diff DEPT15)} P[k,18,3 + TRIPLE[18]] = 1;
subject to Prof_Student_19_Dept_12:
	sum {k in DEPT12} P[k,19,1] = 1;
subject to Prof_Student_19_Minor:
	sum {k in (DEPT0 union DEPT0 union DEPT6)} P[k,19,2] = 1;
subject to Prof_Student_19_AtLarge:
	sum {k in (TEACHER diff DEPT12 diff DEPT0 diff DEPT6)} P[k,19,3 + TRIPLE[19]] = 1;
subject to Prof_Student_20_Dept_1:
	sum {k in DEPT1} P[k,20,1] = 1;
subject to Prof_Student_20_Minor:
	sum {k in DEPT6} P[k,20,2] = 1;
subject to Prof_Student_20_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT6)} P[k,20,3 + TRIPLE[20]] = 1;
subject to Prof_Student_21_Dept_10:
	sum {k in DEPT10} P[k,21,1] = 1;
subject to Prof_Student_21_Minor:
	sum {k in DEPT0} P[k,21,2] = 1;
subject to Prof_Student_21_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT0)} P[k,21,3 + TRIPLE[21]] = 1;
subject to Prof_Student_22_Dept_9:
	sum {k in DEPT9} P[k,22,1] = 1;
subject to Prof_Student_22_Dept_7:
	sum {k in DEPT7} P[k,22,2] = 1;
subject to Prof_Student_22_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT7 diff DEPT18)} P[k,22,3 + TRIPLE[22]] = 1;
subject to Prof_Student_23_Dept_5:
	sum {k in DEPT5} P[k,23,1] = 1;
subject to Prof_Student_23_Minor:
	sum {k in DEPT7} P[k,23,2] = 1;
subject to Prof_Student_23_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT7)} P[k,23,3 + TRIPLE[23]] = 1;
subject to Prof_Student_24_Dept_6:
	sum {k in DEPT6} P[k,24,1] = 1;
subject to Prof_Student_24_Minor:
	sum {k in DEPT0} P[k,24,2] = 1;
subject to Prof_Student_24_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT0)} P[k,24,3 + TRIPLE[24]] = 1;
subject to Prof_Student_25_Dept_18:
	sum {k in DEPT18} P[k,25,1] = 1;
subject to Prof_Student_25_Minor:
	sum {k in DEPT19} P[k,25,2] = 1;
subject to Prof_Student_25_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT19)} P[k,25,3 + TRIPLE[25]] = 1;
subject to Prof_Student_26_Dept_1:
	sum {k in DEPT1} P[k,26,1] = 1;
subject to Prof_Student_26_Minor:
	sum {k in DEPT0} P[k,26,2] = 1;
subject to Prof_Student_26_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT0)} P[k,26,3 + TRIPLE[26]] = 1;
subject to Prof_Student_27_Dept_1:
	sum {k in DEPT1} P[k,27,1] = 1;
subject to Prof_Student_27_Minor:
	sum {k in DEPT14} P[k,27,2] = 1;
subject to Prof_Student_27_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT14)} P[k,27,3 + TRIPLE[27]] = 1;
subject to Prof_Student_28_Dept_1:
	sum {k in DEPT1} P[k,28,1] = 1;
subject to Prof_Student_28_Minor:
	sum {k in DEPT14} P[k,28,2] = 1;
subject to Prof_Student_28_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT14)} P[k,28,3 + TRIPLE[28]] = 1;
subject to Prof_Student_29_Dept_3:
	sum {k in DEPT3} P[k,29,1] = 1;
subject to Prof_Student_29_Minor:
	sum {k in (DEPT0 union DEPT0 union DEPT10)} P[k,29,2] = 1;
subject to Prof_Student_29_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT0 diff DEPT10)} P[k,29,3 + TRIPLE[29]] = 1;
subject to Prof_Student_30_Dept_4:
	sum {k in DEPT4} P[k,30,1] = 1;
subject to Prof_Student_30_Minor:
	sum {k in DEPT20} P[k,30,2] = 1;
subject to Prof_Student_30_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT20)} P[k,30,3 + TRIPLE[30]] = 1;
subject to Prof_Student_31_Dept_1:
	sum {k in DEPT1} P[k,31,1] = 1;
subject to Prof_Student_31_Minor:
	sum {k in DEPT21} P[k,31,2] = 1;
subject to Prof_Student_31_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT21)} P[k,31,3 + TRIPLE[31]] = 1;
subject to Prof_Student_32_Dept_9:
	sum {k in DEPT9} P[k,32,1] = 1;
subject to Prof_Student_32_Minor:
	sum {k in DEPT18} P[k,32,2] = 1;
subject to Prof_Student_32_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT18)} P[k,32,3 + TRIPLE[32]] = 1;
subject to Prof_Student_33_Dept_0:
	sum {k in DEPT0} P[k,33,1] = 1;
subject to Prof_Student_33_Minor:
	sum {k in DEPT3} P[k,33,2] = 1;
subject to Prof_Student_33_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT3)} P[k,33,3 + TRIPLE[33]] = 1;
subject to Prof_Student_34_Dept_3:
	sum {k in DEPT3} P[k,34,1] = 1;
subject to Prof_Student_34_Minor:
	sum {k in DEPT1} P[k,34,2] = 1;
subject to Prof_Student_34_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT1)} P[k,34,3 + TRIPLE[34]] = 1;
subject to Prof_Student_35_Dept_3:
	sum {k in DEPT3} P[k,35,1] = 1;
subject to Prof_Student_35_Minor:
	sum {k in DEPT10} P[k,35,2] = 1;
subject to Prof_Student_35_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT10)} P[k,35,3 + TRIPLE[35]] = 1;
subject to Prof_Student_36_Dept_5:
	sum {k in DEPT5} P[k,36,1] = 1;
subject to Prof_Student_36_Minor:
	sum {k in DEPT7} P[k,36,2] = 1;
subject to Prof_Student_36_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT7)} P[k,36,3 + TRIPLE[36]] = 1;
subject to Prof_Student_37_Dept_17:
	sum {k in DEPT17} P[k,37,1] = 1;
subject to Prof_Student_37_Minor:
	sum {k in DEPT0} P[k,37,2] = 1;
subject to Prof_Student_37_AtLarge:
	sum {k in (TEACHER diff DEPT17 diff DEPT0)} P[k,37,3 + TRIPLE[37]] = 1;
subject to Prof_Student_38_Dept_5:
	sum {k in DEPT5} P[k,38,1] = 1;
subject to Prof_Student_38_Minor:
	sum {k in DEPT9} P[k,38,2] = 1;
subject to Prof_Student_38_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,38,3 + TRIPLE[38]] = 1;
subject to Prof_Student_39_Dept_3:
	sum {k in DEPT3} P[k,39,1] = 1;
subject to Prof_Student_39_Minor:
	sum {k in DEPT0} P[k,39,2] = 1;
subject to Prof_Student_39_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT0)} P[k,39,3 + TRIPLE[39]] = 1;
subject to Prof_Student_40_Dept_3:
	sum {k in DEPT3} P[k,40,1] = 1;
subject to Prof_Student_40_Minor:
	sum {k in DEPT10} P[k,40,2] = 1;
subject to Prof_Student_40_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT10)} P[k,40,3 + TRIPLE[40]] = 1;
subject to Prof_Student_41_Dept_1:
	sum {k in DEPT1} P[k,41,1] = 1;
subject to Prof_Student_41_Minor:
	sum {k in DEPT22} P[k,41,2] = 1;
subject to Prof_Student_41_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT22)} P[k,41,3 + TRIPLE[41]] = 1;
subject to Prof_Student_42_Dept_9:
	sum {k in DEPT9} P[k,42,1] = 1;
subject to Prof_Student_42_Minor:
	sum {k in (DEPT18 union DEPT18 union DEPT19)} P[k,42,2] = 1;
subject to Prof_Student_42_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT18 diff DEPT19)} P[k,42,3 + TRIPLE[42]] = 1;
subject to Prof_Student_43_Dept_23:
	sum {k in DEPT23} P[k,43,1] = 1;
subject to Prof_Student_43_Minor:
	sum {k in DEPT14} P[k,43,2] = 1;
subject to Prof_Student_43_AtLarge:
	sum {k in (TEACHER diff DEPT23 diff DEPT14)} P[k,43,3 + TRIPLE[43]] = 1;
subject to Prof_Student_44_Dept_18:
	sum {k in DEPT18} P[k,44,1] = 1;
subject to Prof_Student_44_Dept_19:
	sum {k in DEPT19} P[k,44,2] = 1;
subject to Prof_Student_44_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT19 diff DEPT1)} P[k,44,3 + TRIPLE[44]] = 1;
subject to Prof_Student_45_Dept_4:
	sum {k in DEPT4} P[k,45,1] = 1;
subject to Prof_Student_45_Minor:
	sum {k in (DEPT9 union DEPT9 union DEPT5)} P[k,45,2] = 1;
subject to Prof_Student_45_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT9 diff DEPT5)} P[k,45,3 + TRIPLE[45]] = 1;
subject to Prof_Student_46_Dept_0:
	sum {k in DEPT0} P[k,46,1] = 1;
subject to Prof_Student_46_Minor:
	sum {k in DEPT6} P[k,46,2] = 1;
subject to Prof_Student_46_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,46,3 + TRIPLE[46]] = 1;
subject to Prof_Student_47_Dept_11:
	sum {k in DEPT11} P[k,47,1] = 1;
subject to Prof_Student_47_Minor:
	sum {k in (DEPT9 union DEPT9 union DEPT1)} P[k,47,2] = 1;
subject to Prof_Student_47_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT9 diff DEPT1)} P[k,47,3 + TRIPLE[47]] = 1;
subject to Prof_Student_48_Dept_9:
	sum {k in DEPT9} P[k,48,1] = 1;
subject to Prof_Student_48_Minor:
	sum {k in DEPT11} P[k,48,2] = 1;
subject to Prof_Student_48_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT11)} P[k,48,3 + TRIPLE[48]] = 1;
subject to Prof_Student_49_Dept_13:
	sum {k in DEPT13} P[k,49,1] = 1;
subject to Prof_Student_49_Minor:
	sum {k in DEPT18} P[k,49,2] = 1;
subject to Prof_Student_49_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT18)} P[k,49,3 + TRIPLE[49]] = 1;
subject to Prof_Student_50_Dept_11:
	sum {k in DEPT11} P[k,50,1] = 1;
subject to Prof_Student_50_Minor:
	sum {k in DEPT3} P[k,50,2] = 1;
subject to Prof_Student_50_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT3)} P[k,50,3 + TRIPLE[50]] = 1;
subject to Prof_Student_51_Dept_5:
	sum {k in DEPT5} P[k,51,1] = 1;
subject to Prof_Student_51_Minor:
	sum {k in DEPT9} P[k,51,2] = 1;
subject to Prof_Student_51_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,51,3 + TRIPLE[51]] = 1;
subject to Prof_Student_52_Dept_5:
	sum {k in DEPT5} P[k,52,1] = 1;
subject to Prof_Student_52_Minor:
	sum {k in (DEPT9 union DEPT9 union DEPT1)} P[k,52,2] = 1;
subject to Prof_Student_52_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9 diff DEPT1)} P[k,52,3 + TRIPLE[52]] = 1;
subject to Prof_Student_53_Dept_18:
	sum {k in DEPT18} P[k,53,1] = 1;
subject to Prof_Student_53_Minor:
	sum {k in DEPT21} P[k,53,2] = 1;
subject to Prof_Student_53_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT21)} P[k,53,3 + TRIPLE[53]] = 1;
subject to Prof_Student_54_Dept_0:
	sum {k in DEPT0} P[k,54,1] = 1;
subject to Prof_Student_54_Minor:
	sum {k in DEPT10} P[k,54,2] = 1;
subject to Prof_Student_54_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT10)} P[k,54,3 + TRIPLE[54]] = 1;
subject to Prof_Student_55_Dept_19:
	sum {k in DEPT19} P[k,55,1] = 1;
subject to Prof_Student_55_Dept_11:
	sum {k in DEPT11} P[k,55,2] = 1;
subject to Prof_Student_55_AtLarge:
	sum {k in (TEACHER diff DEPT19 diff DEPT11 diff DEPT18)} P[k,55,3 + TRIPLE[55]] = 1;
subject to Prof_Student_56_Dept_5:
	sum {k in DEPT5} P[k,56,1] = 1;
subject to Prof_Student_56_Dept_15:
	sum {k in DEPT15} P[k,56,2] = 1;
subject to Prof_Student_56_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT15)} P[k,56,3 + TRIPLE[56]] = 1;
subject to Prof_Student_57_Dept_0:
	sum {k in DEPT0} P[k,57,1] = 1;
subject to Prof_Student_57_Minor:
	sum {k in DEPT6} P[k,57,2] = 1;
subject to Prof_Student_57_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,57,3 + TRIPLE[57]] = 1;
subject to Prof_Student_58_Dept_10:
	sum {k in DEPT10} P[k,58,1] = 1;
subject to Prof_Student_58_Minor:
	sum {k in DEPT14} P[k,58,2] = 1;
subject to Prof_Student_58_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT14)} P[k,58,3 + TRIPLE[58]] = 1;
subject to Prof_Student_59_Dept_24:
	sum {k in DEPT24} P[k,59,1] = 1;
subject to Prof_Student_59_Dept_11:
	sum {k in DEPT11} P[k,59,2] = 1;
subject to Prof_Student_59_AtLarge:
	sum {k in (TEACHER diff DEPT24 diff DEPT11)} P[k,59,3 + TRIPLE[59]] = 1;
subject to Prof_Student_60_Dept_3:
	sum {k in DEPT3} P[k,60,1] = 1;
subject to Prof_Student_60_Minor:
	sum {k in DEPT0} P[k,60,2] = 1;
subject to Prof_Student_60_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT0)} P[k,60,3 + TRIPLE[60]] = 1;
subject to Prof_Student_61_Dept_0:
	sum {k in DEPT0} P[k,61,1] = 1;
subject to Prof_Student_61_Minor:
	sum {k in DEPT6} P[k,61,2] = 1;
subject to Prof_Student_61_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,61,3 + TRIPLE[61]] = 1;
subject to Prof_Student_62_Dept_5:
	sum {k in DEPT5} P[k,62,1] = 1;
subject to Prof_Student_62_Minor:
	sum {k in DEPT9} P[k,62,2] = 1;
subject to Prof_Student_62_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,62,3 + TRIPLE[62]] = 1;
subject to Prof_Student_63_Dept_5:
	sum {k in DEPT5} P[k,63,1] = 1;
subject to Prof_Student_63_Minor:
	sum {k in DEPT3} P[k,63,2] = 1;
subject to Prof_Student_63_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT3)} P[k,63,3 + TRIPLE[63]] = 1;
subject to Prof_Student_64_Dept_5:
	sum {k in DEPT5} P[k,64,1] = 1;
subject to Prof_Student_64_Minor:
	sum {k in DEPT14} P[k,64,2] = 1;
subject to Prof_Student_64_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT14)} P[k,64,3 + TRIPLE[64]] = 1;
subject to Prof_Student_65_Dept_9:
	sum {k in DEPT9} P[k,65,1] = 1;
subject to Prof_Student_65_Minor:
	sum {k in DEPT18} P[k,65,2] = 1;
subject to Prof_Student_65_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT18)} P[k,65,3 + TRIPLE[65]] = 1;
subject to Prof_Student_66_Dept_1:
	sum {k in DEPT1} P[k,66,1] = 1;
subject to Prof_Student_66_Minor:
	sum {k in DEPT7} P[k,66,2] = 1;
subject to Prof_Student_66_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT7)} P[k,66,3 + TRIPLE[66]] = 1;
subject to Prof_Student_67_Dept_18:
	sum {k in DEPT18} P[k,67,1] = 1;
subject to Prof_Student_67_Minor:
	sum {k in DEPT1} P[k,67,2] = 1;
subject to Prof_Student_67_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1)} P[k,67,3 + TRIPLE[67]] = 1;
subject to Prof_Student_68_Dept_11:
	sum {k in DEPT11} P[k,68,1] = 1;
subject to Prof_Student_68_Minor:
	sum {k in DEPT0} P[k,68,2] = 1;
subject to Prof_Student_68_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT0)} P[k,68,3 + TRIPLE[68]] = 1;
subject to Prof_Student_69_Dept_10:
	sum {k in DEPT10} P[k,69,1] = 1;
subject to Prof_Student_69_Minor:
	sum {k in DEPT8} P[k,69,2] = 1;
subject to Prof_Student_69_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT8)} P[k,69,3 + TRIPLE[69]] = 1;
subject to Prof_Student_70_Dept_13:
	sum {k in DEPT13} P[k,70,1] = 1;
subject to Prof_Student_70_Minor:
	sum {k in DEPT3} P[k,70,2] = 1;
subject to Prof_Student_70_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT3)} P[k,70,3 + TRIPLE[70]] = 1;
subject to Prof_Student_71_Dept_25:
	sum {k in DEPT25} P[k,71,1] = 1;
subject to Prof_Student_71_Dept_15:
	sum {k in DEPT15} P[k,71,2] = 1;
subject to Prof_Student_71_AtLarge:
	sum {k in (TEACHER diff DEPT25 diff DEPT15)} P[k,71,3 + TRIPLE[71]] = 1;
subject to Prof_Student_72_Dept_18:
	sum {k in DEPT18} P[k,72,1] = 1;
subject to Prof_Student_72_Minor:
	sum {k in DEPT21} P[k,72,2] = 1;
subject to Prof_Student_72_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT21)} P[k,72,3 + TRIPLE[72]] = 1;
subject to Prof_Student_73_Dept_8:
	sum {k in DEPT8} P[k,73,1] = 1;
subject to Prof_Student_73_Minor:
	sum {k in DEPT1} P[k,73,2] = 1;
subject to Prof_Student_73_AtLarge:
	sum {k in (TEACHER diff DEPT8 diff DEPT1)} P[k,73,3 + TRIPLE[73]] = 1;
subject to Prof_Student_74_Dept_7:
	sum {k in DEPT7} P[k,74,1] = 1;
subject to Prof_Student_74_Minor:
	sum {k in DEPT6} P[k,74,2] = 1;
subject to Prof_Student_74_AtLarge:
	sum {k in (TEACHER diff DEPT7 diff DEPT6)} P[k,74,3 + TRIPLE[74]] = 1;
subject to Prof_Student_75_Dept_0:
	sum {k in DEPT0} P[k,75,1] = 1;
subject to Prof_Student_75_Minor:
	sum {k in DEPT6} P[k,75,2] = 1;
subject to Prof_Student_75_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,75,3 + TRIPLE[75]] = 1;
subject to Prof_Student_76_Dept_18:
	sum {k in DEPT18} P[k,76,1] = 1;
subject to Prof_Student_76_Minor:
	sum {k in DEPT17} P[k,76,2] = 1;
subject to Prof_Student_76_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT17)} P[k,76,3 + TRIPLE[76]] = 1;
subject to Prof_Student_77_Dept_18:
	sum {k in DEPT18} P[k,77,1] = 1;
subject to Prof_Student_77_Minor:
	sum {k in DEPT21} P[k,77,2] = 1;
subject to Prof_Student_77_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT21)} P[k,77,3 + TRIPLE[77]] = 1;
subject to Prof_Student_78_Dept_18:
	sum {k in DEPT18} P[k,78,1] = 1;
subject to Prof_Student_78_Minor:
	sum {k in DEPT1} P[k,78,2] = 1;
subject to Prof_Student_78_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1)} P[k,78,3 + TRIPLE[78]] = 1;
subject to Prof_Student_79_Dept_0:
	sum {k in DEPT0} P[k,79,1] = 1;
subject to Prof_Student_79_Minor:
	sum {k in DEPT6} P[k,79,2] = 1;
subject to Prof_Student_79_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,79,3 + TRIPLE[79]] = 1;
subject to Prof_Student_80_Dept_5:
	sum {k in DEPT5} P[k,80,1] = 1;
subject to Prof_Student_80_Dept_11:
	sum {k in DEPT11} P[k,80,2] = 1;
subject to Prof_Student_80_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT11 diff DEPT9)} P[k,80,3 + TRIPLE[80]] = 1;
subject to Prof_Student_81_Dept_13:
	sum {k in DEPT13} P[k,81,1] = 1;
subject to Prof_Student_81_Minor:
	sum {k in DEPT6} P[k,81,2] = 1;
subject to Prof_Student_81_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT6)} P[k,81,3 + TRIPLE[81]] = 1;
subject to Prof_Student_82_Dept_1:
	sum {k in DEPT1} P[k,82,1] = 1;
subject to Prof_Student_82_Minor:
	sum {k in DEPT14} P[k,82,2] = 1;
subject to Prof_Student_82_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT14)} P[k,82,3 + TRIPLE[82]] = 1;
subject to Prof_Student_83_Dept_4:
	sum {k in DEPT4} P[k,83,1] = 1;
subject to Prof_Student_83_Minor:
	sum {k in DEPT6} P[k,83,2] = 1;
subject to Prof_Student_83_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT6)} P[k,83,3 + TRIPLE[83]] = 1;
subject to Prof_Student_84_Dept_11:
	sum {k in DEPT11} P[k,84,1] = 1;
subject to Prof_Student_84_Minor:
	sum {k in DEPT17} P[k,84,2] = 1;
subject to Prof_Student_84_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT17)} P[k,84,3 + TRIPLE[84]] = 1;
subject to Prof_Student_85_Dept_5:
	sum {k in DEPT5} P[k,85,1] = 1;
subject to Prof_Student_85_Minor:
	sum {k in DEPT2} P[k,85,2] = 1;
subject to Prof_Student_85_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT2)} P[k,85,3 + TRIPLE[85]] = 1;
subject to Prof_Student_86_Dept_18:
	sum {k in DEPT18} P[k,86,1] = 1;
subject to Prof_Student_86_Minor:
	sum {k in DEPT21} P[k,86,2] = 1;
subject to Prof_Student_86_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT21)} P[k,86,3 + TRIPLE[86]] = 1;
subject to Prof_Student_87_Dept_1:
	sum {k in DEPT1} P[k,87,1] = 1;
subject to Prof_Student_87_Minor:
	sum {k in DEPT10} P[k,87,2] = 1;
subject to Prof_Student_87_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT10)} P[k,87,3 + TRIPLE[87]] = 1;
subject to Prof_Student_88_Dept_4:
	sum {k in DEPT4} P[k,88,1] = 1;
subject to Prof_Student_88_Dept_11:
	sum {k in DEPT11} P[k,88,2] = 1;
subject to Prof_Student_88_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT11)} P[k,88,3 + TRIPLE[88]] = 1;
subject to Prof_Student_89_Dept_18:
	sum {k in DEPT18} P[k,89,1] = 1;
subject to Prof_Student_89_Minor:
	sum {k in DEPT19} P[k,89,2] = 1;
subject to Prof_Student_89_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT19)} P[k,89,3 + TRIPLE[89]] = 1;
subject to Prof_Student_90_Dept_13:
	sum {k in DEPT13} P[k,90,1] = 1;
subject to Prof_Student_90_Minor:
	sum {k in (DEPT5 union DEPT5 union DEPT26)} P[k,90,2] = 1;
subject to Prof_Student_90_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT5 diff DEPT26)} P[k,90,3 + TRIPLE[90]] = 1;
subject to Prof_Student_91_Dept_5:
	sum {k in DEPT5} P[k,91,1] = 1;
subject to Prof_Student_91_Minor:
	sum {k in DEPT9} P[k,91,2] = 1;
subject to Prof_Student_91_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,91,3 + TRIPLE[91]] = 1;
subject to Prof_Student_92_Dept_10:
	sum {k in DEPT10} P[k,92,1] = 1;
subject to Prof_Student_92_Minor:
	sum {k in (DEPT6 union DEPT6 union DEPT26)} P[k,92,2] = 1;
subject to Prof_Student_92_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT6 diff DEPT26)} P[k,92,3 + TRIPLE[92]] = 1;
subject to Prof_Student_93_Dept_17:
	sum {k in DEPT17} P[k,93,1] = 1;
subject to Prof_Student_93_Minor:
	sum {k in DEPT6} P[k,93,2] = 1;
subject to Prof_Student_93_AtLarge:
	sum {k in (TEACHER diff DEPT17 diff DEPT6)} P[k,93,3 + TRIPLE[93]] = 1;
subject to Prof_Student_94_Dept_1:
	sum {k in DEPT1} P[k,94,1] = 1;
subject to Prof_Student_94_Minor:
	sum {k in DEPT6} P[k,94,2] = 1;
subject to Prof_Student_94_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT6)} P[k,94,3 + TRIPLE[94]] = 1;
subject to Prof_Student_95_Dept_5:
	sum {k in DEPT5} P[k,95,1] = 1;
subject to Prof_Student_95_Minor:
	sum {k in (DEPT9 union DEPT9 union DEPT4)} P[k,95,2] = 1;
subject to Prof_Student_95_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9 diff DEPT4)} P[k,95,3 + TRIPLE[95]] = 1;
subject to Prof_Student_96_Dept_2:
	sum {k in DEPT2} P[k,96,1] = 1;
subject to Prof_Student_96_Dept_3:
	sum {k in DEPT3} P[k,96,2] = 1;
subject to Prof_Student_96_AtLarge:
	sum {k in (TEACHER diff DEPT2 diff DEPT3)} P[k,96,3 + TRIPLE[96]] = 1;
subject to Prof_Student_97_Dept_6:
	sum {k in DEPT6} P[k,97,1] = 1;
subject to Prof_Student_97_Minor:
	sum {k in DEPT10} P[k,97,2] = 1;
subject to Prof_Student_97_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT10)} P[k,97,3 + TRIPLE[97]] = 1;
subject to Prof_Student_98_Dept_19:
	sum {k in DEPT19} P[k,98,1] = 1;
subject to Prof_Student_98_Minor:
	sum {k in (DEPT18 union DEPT18 union DEPT23)} P[k,98,2] = 1;
subject to Prof_Student_98_AtLarge:
	sum {k in (TEACHER diff DEPT19 diff DEPT18 diff DEPT23)} P[k,98,3 + TRIPLE[98]] = 1;
subject to Prof_Student_99_Dept_0:
	sum {k in DEPT0} P[k,99,1] = 1;
subject to Prof_Student_99_Minor:
	sum {k in DEPT6} P[k,99,2] = 1;
subject to Prof_Student_99_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,99,3 + TRIPLE[99]] = 1;
subject to Prof_Student_100_Dept_0:
	sum {k in DEPT0} P[k,100,1] = 1;
subject to Prof_Student_100_Minor:
	sum {k in DEPT23} P[k,100,2] = 1;
subject to Prof_Student_100_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT23)} P[k,100,3 + TRIPLE[100]] = 1;
subject to Prof_Student_101_Dept_23:
	sum {k in DEPT23} P[k,101,1] = 1;
subject to Prof_Student_101_Dept_0:
	sum {k in DEPT0} P[k,101,2] = 1;
subject to Prof_Student_101_AtLarge:
	sum {k in (TEACHER diff DEPT23 diff DEPT0)} P[k,101,3 + TRIPLE[101]] = 1;
subject to Prof_Student_102_Dept_8:
	sum {k in DEPT8} P[k,102,1] = 1;
subject to Prof_Student_102_Minor:
	sum {k in DEPT14} P[k,102,2] = 1;
subject to Prof_Student_102_AtLarge:
	sum {k in (TEACHER diff DEPT8 diff DEPT14)} P[k,102,3 + TRIPLE[102]] = 1;
subject to Prof_Student_103_Dept_1:
	sum {k in DEPT1} P[k,103,1] = 1;
subject to Prof_Student_103_Minor:
	sum {k in (DEPT22 union DEPT22 union DEPT14)} P[k,103,2] = 1;
subject to Prof_Student_103_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT22 diff DEPT14)} P[k,103,3 + TRIPLE[103]] = 1;
subject to Prof_Student_104_Dept_1:
	sum {k in DEPT1} P[k,104,1] = 1;
subject to Prof_Student_104_Dept_18:
	sum {k in DEPT18} P[k,104,2] = 1;
subject to Prof_Student_104_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT18 diff DEPT21)} P[k,104,3 + TRIPLE[104]] = 1;
subject to Prof_Student_105_Dept_0:
	sum {k in DEPT0} P[k,105,1] = 1;
subject to Prof_Student_105_Minor:
	sum {k in (DEPT11 union DEPT11 union DEPT6)} P[k,105,2] = 1;
subject to Prof_Student_105_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT11 diff DEPT6)} P[k,105,3 + TRIPLE[105]] = 1;
subject to Prof_Student_106_Dept_1:
	sum {k in DEPT1} P[k,106,1] = 1;
subject to Prof_Student_106_Minor:
	sum {k in DEPT11} P[k,106,2] = 1;
subject to Prof_Student_106_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT11)} P[k,106,3 + TRIPLE[106]] = 1;
subject to Prof_Student_107_Dept_18:
	sum {k in DEPT18} P[k,107,1] = 1;
subject to Prof_Student_107_Minor:
	sum {k in DEPT11} P[k,107,2] = 1;
subject to Prof_Student_107_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT11)} P[k,107,3 + TRIPLE[107]] = 1;
subject to Prof_Student_108_Dept_4:
	sum {k in DEPT4} P[k,108,1] = 1;
subject to Prof_Student_108_Dept_7:
	sum {k in DEPT7} P[k,108,2] = 1;
subject to Prof_Student_108_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT7)} P[k,108,3 + TRIPLE[108]] = 1;
subject to Prof_Student_109_Dept_2:
	sum {k in DEPT2} P[k,109,1] = 1;
subject to Prof_Student_109_Minor:
	sum {k in DEPT10} P[k,109,2] = 1;
subject to Prof_Student_109_AtLarge:
	sum {k in (TEACHER diff DEPT2 diff DEPT10)} P[k,109,3 + TRIPLE[109]] = 1;
subject to Prof_Student_110_Dept_2:
	sum {k in DEPT2} P[k,110,1] = 1;
subject to Prof_Student_110_Minor:
	sum {k in DEPT15} P[k,110,2] = 1;
subject to Prof_Student_110_AtLarge:
	sum {k in (TEACHER diff DEPT2 diff DEPT15)} P[k,110,3 + TRIPLE[110]] = 1;
subject to Prof_Student_111_Dept_6:
	sum {k in DEPT6} P[k,111,1] = 1;
subject to Prof_Student_111_Minor:
	sum {k in (DEPT18 union DEPT18 union DEPT7)} P[k,111,2] = 1;
subject to Prof_Student_111_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT18 diff DEPT7)} P[k,111,3 + TRIPLE[111]] = 1;
subject to Prof_Student_112_Dept_4:
	sum {k in DEPT4} P[k,112,1] = 1;
subject to Prof_Student_112_Minor:
	sum {k in DEPT7} P[k,112,2] = 1;
subject to Prof_Student_112_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT7)} P[k,112,3 + TRIPLE[112]] = 1;
subject to Prof_Student_113_Dept_1:
	sum {k in DEPT1} P[k,113,1] = 1;
subject to Prof_Student_113_Minor:
	sum {k in DEPT18} P[k,113,2] = 1;
subject to Prof_Student_113_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT18)} P[k,113,3 + TRIPLE[113]] = 1;
subject to Prof_Student_114_Dept_17:
	sum {k in DEPT17} P[k,114,1] = 1;
subject to Prof_Student_114_Minor:
	sum {k in (DEPT26 union DEPT26 union DEPT10 union DEPT16)} P[k,114,2] = 1;
subject to Prof_Student_114_AtLarge:
	sum {k in (TEACHER diff DEPT17 diff DEPT26 diff DEPT10 diff DEPT16)} P[k,114,3 + TRIPLE[114]] = 1;
subject to Prof_Student_115_Dept_6:
	sum {k in DEPT6} P[k,115,1] = 1;
subject to Prof_Student_115_Minor:
	sum {k in DEPT10} P[k,115,2] = 1;
subject to Prof_Student_115_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT10)} P[k,115,3 + TRIPLE[115]] = 1;
subject to Prof_Student_116_Dept_9:
	sum {k in DEPT9} P[k,116,1] = 1;
subject to Prof_Student_116_Dept_15:
	sum {k in DEPT15} P[k,116,2] = 1;
subject to Prof_Student_116_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT15 diff DEPT5)} P[k,116,3 + TRIPLE[116]] = 1;
subject to Prof_Student_117_Dept_6:
	sum {k in DEPT6} P[k,117,1] = 1;
subject to Prof_Student_117_Minor:
	sum {k in DEPT26} P[k,117,2] = 1;
subject to Prof_Student_117_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT26)} P[k,117,3 + TRIPLE[117]] = 1;
subject to Prof_Student_118_Dept_18:
	sum {k in DEPT18} P[k,118,1] = 1;
subject to Prof_Student_118_Minor:
	sum {k in (DEPT5 union DEPT5 union DEPT26)} P[k,118,2] = 1;
subject to Prof_Student_118_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT5 diff DEPT26)} P[k,118,3 + TRIPLE[118]] = 1;
subject to Prof_Student_119_Dept_6:
	sum {k in DEPT6} P[k,119,1] = 1;
subject to Prof_Student_119_Minor:
	sum {k in DEPT26} P[k,119,2] = 1;
subject to Prof_Student_119_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT26)} P[k,119,3 + TRIPLE[119]] = 1;
subject to Prof_Student_120_Dept_10:
	sum {k in DEPT10} P[k,120,1] = 1;
subject to Prof_Student_120_Minor:
	sum {k in (DEPT26 union DEPT26 union DEPT4)} P[k,120,2] = 1;
subject to Prof_Student_120_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT26 diff DEPT4)} P[k,120,3 + TRIPLE[120]] = 1;
subject to Prof_Student_121_Dept_2:
	sum {k in DEPT2} P[k,121,1] = 1;
subject to Prof_Student_121_Minor:
	sum {k in DEPT17} P[k,121,2] = 1;
subject to Prof_Student_121_AtLarge:
	sum {k in (TEACHER diff DEPT2 diff DEPT17)} P[k,121,3 + TRIPLE[121]] = 1;
subject to Prof_Student_122_Dept_18:
	sum {k in DEPT18} P[k,122,1] = 1;
subject to Prof_Student_122_Minor:
	sum {k in DEPT9} P[k,122,2] = 1;
subject to Prof_Student_122_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT9)} P[k,122,3 + TRIPLE[122]] = 1;
subject to Prof_Student_123_Dept_18:
	sum {k in DEPT18} P[k,123,1] = 1;
subject to Prof_Student_123_Minor:
	sum {k in DEPT21} P[k,123,2] = 1;
subject to Prof_Student_123_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT21)} P[k,123,3 + TRIPLE[123]] = 1;
subject to Prof_Student_124_Dept_4:
	sum {k in DEPT4} P[k,124,1] = 1;
subject to Prof_Student_124_Minor:
	sum {k in DEPT1} P[k,124,2] = 1;
subject to Prof_Student_124_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT1)} P[k,124,3 + TRIPLE[124]] = 1;
subject to Prof_Student_125_Dept_3:
	sum {k in DEPT3} P[k,125,1] = 1;
subject to Prof_Student_125_Dept_11:
	sum {k in DEPT11} P[k,125,2] = 1;
subject to Prof_Student_125_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT11)} P[k,125,3 + TRIPLE[125]] = 1;
subject to Prof_Student_126_Dept_5:
	sum {k in DEPT5} P[k,126,1] = 1;
subject to Prof_Student_126_Minor:
	sum {k in DEPT9} P[k,126,2] = 1;
subject to Prof_Student_126_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,126,3 + TRIPLE[126]] = 1;
subject to Prof_Student_127_Dept_0:
	sum {k in DEPT0} P[k,127,1] = 1;
subject to Prof_Student_127_Minor:
	sum {k in DEPT11} P[k,127,2] = 1;
subject to Prof_Student_127_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT11)} P[k,127,3 + TRIPLE[127]] = 1;
subject to Prof_Student_128_Dept_11:
	sum {k in DEPT11} P[k,128,1] = 1;
subject to Prof_Student_128_Minor:
	sum {k in DEPT4} P[k,128,2] = 1;
subject to Prof_Student_128_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT4)} P[k,128,3 + TRIPLE[128]] = 1;
subject to Prof_Student_129_Dept_7:
	sum {k in DEPT7} P[k,129,1] = 1;
subject to Prof_Student_129_Minor:
	sum {k in DEPT10} P[k,129,2] = 1;
subject to Prof_Student_129_AtLarge:
	sum {k in (TEACHER diff DEPT7 diff DEPT10)} P[k,129,3 + TRIPLE[129]] = 1;
subject to Prof_Student_130_Dept_6:
	sum {k in DEPT6} P[k,130,1] = 1;
subject to Prof_Student_130_Minor:
	sum {k in DEPT0} P[k,130,2] = 1;
subject to Prof_Student_130_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT0)} P[k,130,3 + TRIPLE[130]] = 1;
subject to Prof_Student_131_Dept_3:
	sum {k in DEPT3} P[k,131,1] = 1;
subject to Prof_Student_131_Minor:
	sum {k in DEPT1} P[k,131,2] = 1;
subject to Prof_Student_131_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT1)} P[k,131,3 + TRIPLE[131]] = 1;
subject to Prof_Student_132_Dept_6:
	sum {k in DEPT6} P[k,132,1] = 1;
subject to Prof_Student_132_Minor:
	sum {k in DEPT10} P[k,132,2] = 1;
subject to Prof_Student_132_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT10)} P[k,132,3 + TRIPLE[132]] = 1;
subject to Prof_Student_133_Dept_12:
	sum {k in DEPT12} P[k,133,1] = 1;
subject to Prof_Student_133_Dept_6:
	sum {k in DEPT6} P[k,133,2] = 1;
subject to Prof_Student_133_AtLarge:
	sum {k in (TEACHER diff DEPT12 diff DEPT6 diff DEPT1)} P[k,133,3 + TRIPLE[133]] = 1;
subject to Prof_Student_134_Dept_18:
	sum {k in DEPT18} P[k,134,1] = 1;
subject to Prof_Student_134_Minor:
	sum {k in DEPT15} P[k,134,2] = 1;
subject to Prof_Student_134_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT15)} P[k,134,3 + TRIPLE[134]] = 1;
subject to Prof_Student_135_Dept_0:
	sum {k in DEPT0} P[k,135,1] = 1;
subject to Prof_Student_135_Minor:
	sum {k in DEPT9} P[k,135,2] = 1;
subject to Prof_Student_135_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT9)} P[k,135,3 + TRIPLE[135]] = 1;
subject to Prof_Student_136_Dept_5:
	sum {k in DEPT5} P[k,136,1] = 1;
subject to Prof_Student_136_Minor:
	sum {k in (DEPT9 union DEPT9 union DEPT27)} P[k,136,2] = 1;
subject to Prof_Student_136_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9 diff DEPT27)} P[k,136,3 + TRIPLE[136]] = 1;
subject to Prof_Student_137_Dept_19:
	sum {k in DEPT19} P[k,137,1] = 1;
subject to Prof_Student_137_Minor:
	sum {k in DEPT18} P[k,137,2] = 1;
subject to Prof_Student_137_AtLarge:
	sum {k in (TEACHER diff DEPT19 diff DEPT18)} P[k,137,3 + TRIPLE[137]] = 1;
subject to Prof_Student_138_Dept_5:
	sum {k in DEPT5} P[k,138,1] = 1;
subject to Prof_Student_138_Minor:
	sum {k in DEPT4} P[k,138,2] = 1;
subject to Prof_Student_138_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT4)} P[k,138,3 + TRIPLE[138]] = 1;
subject to Prof_Student_139_Dept_5:
	sum {k in DEPT5} P[k,139,1] = 1;
subject to Prof_Student_139_Minor:
	sum {k in DEPT9} P[k,139,2] = 1;
subject to Prof_Student_139_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT9)} P[k,139,3 + TRIPLE[139]] = 1;
subject to Prof_Student_140_Dept_24:
	sum {k in DEPT24} P[k,140,1] = 1;
subject to Prof_Student_140_Minor:
	sum {k in DEPT11} P[k,140,2] = 1;
subject to Prof_Student_140_AtLarge:
	sum {k in (TEACHER diff DEPT24 diff DEPT11)} P[k,140,3 + TRIPLE[140]] = 1;
subject to Prof_Student_141_Dept_17:
	sum {k in DEPT17} P[k,141,1] = 1;
subject to Prof_Student_141_Minor:
	sum {k in DEPT14} P[k,141,2] = 1;
subject to Prof_Student_141_AtLarge:
	sum {k in (TEACHER diff DEPT17 diff DEPT14)} P[k,141,3 + TRIPLE[141]] = 1;
subject to Prof_Student_142_Dept_3:
	sum {k in DEPT3} P[k,142,1] = 1;
subject to Prof_Student_142_Minor:
	sum {k in DEPT14} P[k,142,2] = 1;
subject to Prof_Student_142_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT14)} P[k,142,3 + TRIPLE[142]] = 1;
subject to Prof_Student_143_Dept_18:
	sum {k in DEPT18} P[k,143,1] = 1;
subject to Prof_Student_143_Minor:
	sum {k in DEPT11} P[k,143,2] = 1;
subject to Prof_Student_143_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT11)} P[k,143,3 + TRIPLE[143]] = 1;
subject to Prof_Student_144_Dept_18:
	sum {k in DEPT18} P[k,144,1] = 1;
subject to Prof_Student_144_Minor:
	sum {k in DEPT19} P[k,144,2] = 1;
subject to Prof_Student_144_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT19)} P[k,144,3 + TRIPLE[144]] = 1;
subject to Prof_Student_145_Dept_1:
	sum {k in DEPT1} P[k,145,1] = 1;
subject to Prof_Student_145_Minor:
	sum {k in DEPT14} P[k,145,2] = 1;
subject to Prof_Student_145_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT14)} P[k,145,3 + TRIPLE[145]] = 1;
subject to Prof_Student_146_Dept_0:
	sum {k in DEPT0} P[k,146,1] = 1;
subject to Prof_Student_146_Dept_12:
	sum {k in DEPT12} P[k,146,2] = 1;
subject to Prof_Student_146_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT12)} P[k,146,3 + TRIPLE[146]] = 1;
subject to Prof_Student_147_Dept_18:
	sum {k in DEPT18} P[k,147,1] = 1;
subject to Prof_Student_147_Minor:
	sum {k in DEPT17} P[k,147,2] = 1;
subject to Prof_Student_147_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT17)} P[k,147,3 + TRIPLE[147]] = 1;
subject to Prof_Student_148_Dept_13:
	sum {k in DEPT13} P[k,148,1] = 1;
subject to Prof_Student_148_Minor:
	sum {k in DEPT14} P[k,148,2] = 1;
subject to Prof_Student_148_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT14)} P[k,148,3 + TRIPLE[148]] = 1;
subject to Prof_Student_149_Dept_11:
	sum {k in DEPT11} P[k,149,1] = 1;
subject to Prof_Student_149_Minor:
	sum {k in DEPT26} P[k,149,2] = 1;
subject to Prof_Student_149_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT26)} P[k,149,3 + TRIPLE[149]] = 1;
subject to Prof_Student_150_Dept_18:
	sum {k in DEPT18} P[k,150,1] = 1;
subject to Prof_Student_150_Minor:
	sum {k in DEPT26} P[k,150,2] = 1;
subject to Prof_Student_150_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT26)} P[k,150,3 + TRIPLE[150]] = 1;
subject to Prof_Student_151_Dept_0:
	sum {k in DEPT0} P[k,151,1] = 1;
subject to Prof_Student_151_Minor:
	sum {k in DEPT10} P[k,151,2] = 1;
subject to Prof_Student_151_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT10)} P[k,151,3 + TRIPLE[151]] = 1;
subject to Prof_Student_152_Dept_1:
	sum {k in DEPT1} P[k,152,1] = 1;
subject to Prof_Student_152_Minor:
	sum {k in (DEPT23 union DEPT23 union DEPT7)} P[k,152,2] = 1;
subject to Prof_Student_152_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT23 diff DEPT7)} P[k,152,3 + TRIPLE[152]] = 1;
subject to Prof_Student_153_Dept_3:
	sum {k in DEPT3} P[k,153,1] = 1;
subject to Prof_Student_153_Minor:
	sum {k in DEPT0} P[k,153,2] = 1;
subject to Prof_Student_153_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT0)} P[k,153,3 + TRIPLE[153]] = 1;
subject to Prof_Student_154_Dept_3:
	sum {k in DEPT3} P[k,154,1] = 1;
subject to Prof_Student_154_Minor:
	sum {k in DEPT0} P[k,154,2] = 1;
subject to Prof_Student_154_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT0)} P[k,154,3 + TRIPLE[154]] = 1;
subject to Prof_Student_155_Dept_6:
	sum {k in DEPT6} P[k,155,1] = 1;
subject to Prof_Student_155_Minor:
	sum {k in DEPT1} P[k,155,2] = 1;
subject to Prof_Student_155_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT1)} P[k,155,3 + TRIPLE[155]] = 1;
subject to Prof_Student_156_Dept_2:
	sum {k in DEPT2} P[k,156,1] = 1;
subject to Prof_Student_156_Minor:
	sum {k in DEPT4} P[k,156,2] = 1;
subject to Prof_Student_156_AtLarge:
	sum {k in (TEACHER diff DEPT2 diff DEPT4)} P[k,156,3 + TRIPLE[156]] = 1;
subject to Prof_Student_157_Dept_5:
	sum {k in DEPT5} P[k,157,1] = 1;
subject to Prof_Student_157_Minor:
	sum {k in DEPT6} P[k,157,2] = 1;
subject to Prof_Student_157_AtLarge:
	sum {k in (TEACHER diff DEPT5 diff DEPT6)} P[k,157,3 + TRIPLE[157]] = 1;
subject to Prof_Student_158_Dept_0:
	sum {k in DEPT0} P[k,158,1] = 1;
subject to Prof_Student_158_Minor:
	sum {k in DEPT11} P[k,158,2] = 1;
subject to Prof_Student_158_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT11)} P[k,158,3 + TRIPLE[158]] = 1;
subject to Prof_Student_159_Dept_4:
	sum {k in DEPT4} P[k,159,1] = 1;
subject to Prof_Student_159_Minor:
	sum {k in DEPT24} P[k,159,2] = 1;
subject to Prof_Student_159_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT24)} P[k,159,3 + TRIPLE[159]] = 1;
subject to Prof_Student_160_Dept_4:
	sum {k in DEPT4} P[k,160,1] = 1;
subject to Prof_Student_160_Minor:
	sum {k in (DEPT12 union DEPT12 union DEPT14)} P[k,160,2] = 1;
subject to Prof_Student_160_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT12 diff DEPT14)} P[k,160,3 + TRIPLE[160]] = 1;
subject to Prof_Student_161_Dept_3:
	sum {k in DEPT3} P[k,161,1] = 1;
subject to Prof_Student_161_Minor:
	sum {k in (DEPT9 union DEPT9 union DEPT5)} P[k,161,2] = 1;
subject to Prof_Student_161_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT9 diff DEPT5)} P[k,161,3 + TRIPLE[161]] = 1;
subject to Prof_Student_162_Dept_6:
	sum {k in DEPT6} P[k,162,1] = 1;
subject to Prof_Student_162_Minor:
	sum {k in DEPT0} P[k,162,2] = 1;
subject to Prof_Student_162_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT0)} P[k,162,3 + TRIPLE[162]] = 1;
subject to Prof_Student_163_Dept_11:
	sum {k in DEPT11} P[k,163,1] = 1;
subject to Prof_Student_163_Minor:
	sum {k in DEPT1} P[k,163,2] = 1;
subject to Prof_Student_163_AtLarge:
	sum {k in (TEACHER diff DEPT11 diff DEPT1)} P[k,163,3 + TRIPLE[163]] = 1;
subject to Prof_Student_164_Dept_3:
	sum {k in DEPT3} P[k,164,1] = 1;
subject to Prof_Student_164_Minor:
	sum {k in DEPT10} P[k,164,2] = 1;
subject to Prof_Student_164_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT10)} P[k,164,3 + TRIPLE[164]] = 1;
subject to Prof_Student_165_Dept_10:
	sum {k in DEPT10} P[k,165,1] = 1;
subject to Prof_Student_165_Minor:
	sum {k in DEPT6} P[k,165,2] = 1;
subject to Prof_Student_165_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT6)} P[k,165,3 + TRIPLE[165]] = 1;
subject to Prof_Student_166_Dept_18:
	sum {k in DEPT18} P[k,166,1] = 1;
subject to Prof_Student_166_Minor:
	sum {k in (DEPT5 union DEPT5 union DEPT4)} P[k,166,2] = 1;
subject to Prof_Student_166_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT5 diff DEPT4)} P[k,166,3 + TRIPLE[166]] = 1;
subject to Prof_Student_167_Dept_15:
	sum {k in DEPT15} P[k,167,1] = 1;
subject to Prof_Student_167_Minor:
	sum {k in (DEPT14 union DEPT14 union DEPT0)} P[k,167,2] = 1;
subject to Prof_Student_167_AtLarge:
	sum {k in (TEACHER diff DEPT15 diff DEPT14 diff DEPT0)} P[k,167,3 + TRIPLE[167]] = 1;
subject to Prof_Student_168_Dept_0:
	sum {k in DEPT0} P[k,168,1] = 1;
subject to Prof_Student_168_Minor:
	sum {k in DEPT15} P[k,168,2] = 1;
subject to Prof_Student_168_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT15)} P[k,168,3 + TRIPLE[168]] = 1;
subject to Prof_Student_169_Dept_18:
	sum {k in DEPT18} P[k,169,1] = 1;
subject to Prof_Student_169_Minor:
	sum {k in DEPT21} P[k,169,2] = 1;
subject to Prof_Student_169_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT21)} P[k,169,3 + TRIPLE[169]] = 1;
subject to Prof_Student_170_Dept_18:
	sum {k in DEPT18} P[k,170,1] = 1;
subject to Prof_Student_170_Minor:
	sum {k in (DEPT1 union DEPT1 union DEPT21)} P[k,170,2] = 1;
subject to Prof_Student_170_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1 diff DEPT21)} P[k,170,3 + TRIPLE[170]] = 1;
subject to Prof_Student_171_Dept_4:
	sum {k in DEPT4} P[k,171,1] = 1;
subject to Prof_Student_171_Minor:
	sum {k in DEPT6} P[k,171,2] = 1;
subject to Prof_Student_171_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT6)} P[k,171,3 + TRIPLE[171]] = 1;
subject to Prof_Student_172_Dept_18:
	sum {k in DEPT18} P[k,172,1] = 1;
subject to Prof_Student_172_Minor:
	sum {k in DEPT4} P[k,172,2] = 1;
subject to Prof_Student_172_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT4)} P[k,172,3 + TRIPLE[172]] = 1;
subject to Prof_Student_173_Dept_13:
	sum {k in DEPT13} P[k,173,1] = 1;
subject to Prof_Student_173_Minor:
	sum {k in DEPT3} P[k,173,2] = 1;
subject to Prof_Student_173_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT3)} P[k,173,3 + TRIPLE[173]] = 1;
subject to Prof_Student_174_Dept_4:
	sum {k in DEPT4} P[k,174,1] = 1;
subject to Prof_Student_174_Minor:
	sum {k in DEPT1} P[k,174,2] = 1;
subject to Prof_Student_174_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT1)} P[k,174,3 + TRIPLE[174]] = 1;
subject to Prof_Student_175_Dept_0:
	sum {k in DEPT0} P[k,175,1] = 1;
subject to Prof_Student_175_Minor:
	sum {k in DEPT6} P[k,175,2] = 1;
subject to Prof_Student_175_AtLarge:
	sum {k in (TEACHER diff DEPT0 diff DEPT6)} P[k,175,3 + TRIPLE[175]] = 1;
subject to Prof_Student_176_Dept_13:
	sum {k in DEPT13} P[k,176,1] = 1;
subject to Prof_Student_176_Minor:
	sum {k in DEPT6} P[k,176,2] = 1;
subject to Prof_Student_176_AtLarge:
	sum {k in (TEACHER diff DEPT13 diff DEPT6)} P[k,176,3 + TRIPLE[176]] = 1;
subject to Prof_Student_177_Dept_9:
	sum {k in DEPT9} P[k,177,1] = 1;
subject to Prof_Student_177_Dept_18:
	sum {k in DEPT18} P[k,177,2] = 1;
subject to Prof_Student_177_AtLarge:
	sum {k in (TEACHER diff DEPT9 diff DEPT18)} P[k,177,3 + TRIPLE[177]] = 1;
subject to Prof_Student_178_Dept_4:
	sum {k in DEPT4} P[k,178,1] = 1;
subject to Prof_Student_178_Dept_2:
	sum {k in DEPT2} P[k,178,2] = 1;
subject to Prof_Student_178_AtLarge:
	sum {k in (TEACHER diff DEPT4 diff DEPT2 diff DEPT18)} P[k,178,3 + TRIPLE[178]] = 1;
subject to Prof_Student_179_Dept_10:
	sum {k in DEPT10} P[k,179,1] = 1;
subject to Prof_Student_179_Minor:
	sum {k in DEPT20} P[k,179,2] = 1;
subject to Prof_Student_179_AtLarge:
	sum {k in (TEACHER diff DEPT10 diff DEPT20)} P[k,179,3 + TRIPLE[179]] = 1;
subject to Prof_Student_180_Dept_3:
	sum {k in DEPT3} P[k,180,1] = 1;
subject to Prof_Student_180_Minor:
	sum {k in (DEPT2 union DEPT2 union DEPT5)} P[k,180,2] = 1;
subject to Prof_Student_180_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT2 diff DEPT5)} P[k,180,3 + TRIPLE[180]] = 1;
subject to Prof_Student_181_Dept_19:
	sum {k in DEPT19} P[k,181,1] = 1;
subject to Prof_Student_181_Dept_18:
	sum {k in DEPT18} P[k,181,2] = 1;
subject to Prof_Student_181_AtLarge:
	sum {k in (TEACHER diff DEPT19 diff DEPT18)} P[k,181,3 + TRIPLE[181]] = 1;
subject to Prof_Student_182_Dept_6:
	sum {k in DEPT6} P[k,182,1] = 1;
subject to Prof_Student_182_Minor:
	sum {k in DEPT22} P[k,182,2] = 1;
subject to Prof_Student_182_AtLarge:
	sum {k in (TEACHER diff DEPT6 diff DEPT22)} P[k,182,3 + TRIPLE[182]] = 1;
subject to Prof_Student_183_Dept_18:
	sum {k in DEPT18} P[k,183,1] = 1;
subject to Prof_Student_183_Dept_19:
	sum {k in DEPT19} P[k,183,2] = 1;
subject to Prof_Student_183_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT19 diff DEPT11 diff DEPT23)} P[k,183,3 + TRIPLE[183]] = 1;
subject to Prof_Student_184_Dept_1:
	sum {k in DEPT1} P[k,184,1] = 1;
subject to Prof_Student_184_Minor:
	sum {k in DEPT18} P[k,184,2] = 1;
subject to Prof_Student_184_AtLarge:
	sum {k in (TEACHER diff DEPT1 diff DEPT18)} P[k,184,3 + TRIPLE[184]] = 1;
subject to Prof_Student_185_Dept_3:
	sum {k in DEPT3} P[k,185,1] = 1;
subject to Prof_Student_185_Dept_11:
	sum {k in DEPT11} P[k,185,2] = 1;
subject to Prof_Student_185_AtLarge:
	sum {k in (TEACHER diff DEPT3 diff DEPT11 diff DEPT21)} P[k,185,3 + TRIPLE[185]] = 1;
subject to Prof_Student_186_Dept_18:
	sum {k in DEPT18} P[k,186,1] = 1;
subject to Prof_Student_186_Minor:
	sum {k in DEPT1} P[k,186,2] = 1;
subject to Prof_Student_186_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1)} P[k,186,3 + TRIPLE[186]] = 1;
subject to Prof_Student_187_Dept_18:
	sum {k in DEPT18} P[k,187,1] = 1;
subject to Prof_Student_187_Minor:
	sum {k in DEPT1} P[k,187,2] = 1;
subject to Prof_Student_187_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1)} P[k,187,3 + TRIPLE[187]] = 1;
subject to Prof_Student_188_Dept_18:
	sum {k in DEPT18} P[k,188,1] = 1;
subject to Prof_Student_188_Minor:
	sum {k in DEPT1} P[k,188,2] = 1;
subject to Prof_Student_188_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1)} P[k,188,3 + TRIPLE[188]] = 1;
subject to Prof_Student_189_Dept_18:
	sum {k in DEPT18} P[k,189,1] = 1;
subject to Prof_Student_189_Minor:
	sum {k in DEPT1} P[k,189,2] = 1;
subject to Prof_Student_189_AtLarge:
	sum {k in (TEACHER diff DEPT18 diff DEPT1)} P[k,189,3 + TRIPLE[189]] = 1;
subject to No_New_Major_Board_Student_0:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_1:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_2:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_3:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_4:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_5:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_6:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_7:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_8:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_9:
	sum {k in TEACHER, l in STUDENT, i in 1..3} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_10:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_11:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_12:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_13:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_14:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_15:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_16:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_17:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_18:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_19:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_20:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_21:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_22:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_23:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_24:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_25:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_26:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_27:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_28:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_29:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_30:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_31:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_32:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_33:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_34:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_35:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_36:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_37:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_38:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_39:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_40:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_41:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_42:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_43:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_44:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_45:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_46:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_47:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_48:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_49:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_50:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_51:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_52:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_53:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_54:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_55:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_56:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_57:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_58:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_59:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_60:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_61:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_62:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_63:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_64:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_65:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_66:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_67:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_68:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_69:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_70:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_71:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_72:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_73:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_74:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_75:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_76:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_77:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_78:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_79:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_80:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_81:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_82:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_83:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_84:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_85:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_86:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_87:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_88:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_89:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_90:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_91:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_92:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_93:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_94:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_95:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_96:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_97:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_98:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_99:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_100:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_101:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_102:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_103:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_104:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_105:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_106:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_107:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_108:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_109:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_110:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_111:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_112:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_113:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_114:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_115:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_116:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_117:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_118:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_119:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_120:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_121:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_122:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_123:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_124:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_125:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_126:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_127:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_128:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_129:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_130:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_131:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_132:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_133:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_134:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_135:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_136:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_137:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_138:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_139:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_140:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_141:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_142:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_143:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_144:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_145:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_146:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_147:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_148:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_149:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_150:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_151:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_152:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_153:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_154:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_155:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_156:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_157:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_158:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_159:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_160:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_161:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_162:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_163:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_164:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_165:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_166:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_167:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_168:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_169:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_170:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_171:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_172:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_173:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_174:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_175:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_176:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_177:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_178:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_179:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_180:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_181:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_182:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_183:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_184:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_185:
	sum {k in TEACHER, l in STUDENT, i in 1..2} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_186:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_187:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_188:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to No_New_Major_Board_Student_189:
	sum {k in TEACHER, l in STUDENT, i in 1..1} P[k,l,i] * SNR[k,1] = 0;
subject to Maj_Prof_2ndYr_Then_No_New_0:
	(sum {k in TEACHER, i in 2..4} (P[k,0,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,0,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_1:
	(sum {k in TEACHER, i in 2..4} (P[k,1,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,1,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_2:
	(sum {k in TEACHER, i in 2..4} (P[k,2,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,2,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_3:
	(sum {k in TEACHER, i in 2..4} (P[k,3,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,3,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_4:
	(sum {k in TEACHER, i in 2..4} (P[k,4,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,4,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_5:
	(sum {k in TEACHER, i in 2..4} (P[k,5,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,5,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_6:
	(sum {k in TEACHER, i in 2..4} (P[k,6,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,6,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_7:
	(sum {k in TEACHER, i in 2..4} (P[k,7,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,7,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_8:
	(sum {k in TEACHER, i in 2..4} (P[k,8,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,8,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_9:
	(sum {k in TEACHER, i in 4..4} (P[k,9,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..3} (P[k,9,i] * SNR[k,2])) <= 9;
subject to Maj_Prof_2ndYr_Then_No_New_10:
	(sum {k in TEACHER, i in 2..4} (P[k,10,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,10,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_11:
	(sum {k in TEACHER, i in 2..4} (P[k,11,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,11,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_12:
	(sum {k in TEACHER, i in 2..4} (P[k,12,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,12,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_13:
	(sum {k in TEACHER, i in 2..4} (P[k,13,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,13,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_14:
	(sum {k in TEACHER, i in 2..4} (P[k,14,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,14,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_15:
	(sum {k in TEACHER, i in 3..4} (P[k,15,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,15,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_16:
	(sum {k in TEACHER, i in 2..4} (P[k,16,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,16,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_17:
	(sum {k in TEACHER, i in 2..4} (P[k,17,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,17,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_18:
	(sum {k in TEACHER, i in 2..4} (P[k,18,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,18,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_19:
	(sum {k in TEACHER, i in 2..4} (P[k,19,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,19,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_20:
	(sum {k in TEACHER, i in 2..4} (P[k,20,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,20,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_21:
	(sum {k in TEACHER, i in 2..4} (P[k,21,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,21,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_22:
	(sum {k in TEACHER, i in 3..4} (P[k,22,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,22,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_23:
	(sum {k in TEACHER, i in 2..4} (P[k,23,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,23,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_24:
	(sum {k in TEACHER, i in 2..4} (P[k,24,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,24,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_25:
	(sum {k in TEACHER, i in 2..4} (P[k,25,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,25,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_26:
	(sum {k in TEACHER, i in 2..4} (P[k,26,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,26,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_27:
	(sum {k in TEACHER, i in 2..4} (P[k,27,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,27,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_28:
	(sum {k in TEACHER, i in 2..4} (P[k,28,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,28,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_29:
	(sum {k in TEACHER, i in 2..4} (P[k,29,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,29,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_30:
	(sum {k in TEACHER, i in 2..4} (P[k,30,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,30,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_31:
	(sum {k in TEACHER, i in 2..4} (P[k,31,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,31,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_32:
	(sum {k in TEACHER, i in 2..4} (P[k,32,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,32,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_33:
	(sum {k in TEACHER, i in 2..4} (P[k,33,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,33,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_34:
	(sum {k in TEACHER, i in 2..4} (P[k,34,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,34,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_35:
	(sum {k in TEACHER, i in 2..4} (P[k,35,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,35,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_36:
	(sum {k in TEACHER, i in 2..4} (P[k,36,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,36,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_37:
	(sum {k in TEACHER, i in 2..4} (P[k,37,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,37,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_38:
	(sum {k in TEACHER, i in 2..4} (P[k,38,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,38,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_39:
	(sum {k in TEACHER, i in 2..4} (P[k,39,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,39,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_40:
	(sum {k in TEACHER, i in 2..4} (P[k,40,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,40,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_41:
	(sum {k in TEACHER, i in 2..4} (P[k,41,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,41,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_42:
	(sum {k in TEACHER, i in 2..4} (P[k,42,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,42,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_43:
	(sum {k in TEACHER, i in 2..4} (P[k,43,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,43,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_44:
	(sum {k in TEACHER, i in 3..4} (P[k,44,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,44,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_45:
	(sum {k in TEACHER, i in 2..4} (P[k,45,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,45,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_46:
	(sum {k in TEACHER, i in 2..4} (P[k,46,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,46,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_47:
	(sum {k in TEACHER, i in 2..4} (P[k,47,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,47,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_48:
	(sum {k in TEACHER, i in 2..4} (P[k,48,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,48,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_49:
	(sum {k in TEACHER, i in 2..4} (P[k,49,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,49,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_50:
	(sum {k in TEACHER, i in 2..4} (P[k,50,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,50,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_51:
	(sum {k in TEACHER, i in 2..4} (P[k,51,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,51,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_52:
	(sum {k in TEACHER, i in 2..4} (P[k,52,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,52,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_53:
	(sum {k in TEACHER, i in 2..4} (P[k,53,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,53,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_54:
	(sum {k in TEACHER, i in 2..4} (P[k,54,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,54,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_55:
	(sum {k in TEACHER, i in 3..4} (P[k,55,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,55,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_56:
	(sum {k in TEACHER, i in 3..4} (P[k,56,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,56,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_57:
	(sum {k in TEACHER, i in 2..4} (P[k,57,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,57,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_58:
	(sum {k in TEACHER, i in 2..4} (P[k,58,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,58,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_59:
	(sum {k in TEACHER, i in 3..4} (P[k,59,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,59,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_60:
	(sum {k in TEACHER, i in 2..4} (P[k,60,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,60,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_61:
	(sum {k in TEACHER, i in 2..4} (P[k,61,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,61,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_62:
	(sum {k in TEACHER, i in 2..4} (P[k,62,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,62,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_63:
	(sum {k in TEACHER, i in 2..4} (P[k,63,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,63,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_64:
	(sum {k in TEACHER, i in 2..4} (P[k,64,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,64,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_65:
	(sum {k in TEACHER, i in 2..4} (P[k,65,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,65,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_66:
	(sum {k in TEACHER, i in 2..4} (P[k,66,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,66,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_67:
	(sum {k in TEACHER, i in 2..4} (P[k,67,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,67,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_68:
	(sum {k in TEACHER, i in 2..4} (P[k,68,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,68,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_69:
	(sum {k in TEACHER, i in 2..4} (P[k,69,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,69,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_70:
	(sum {k in TEACHER, i in 2..4} (P[k,70,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,70,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_71:
	(sum {k in TEACHER, i in 3..4} (P[k,71,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,71,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_72:
	(sum {k in TEACHER, i in 2..4} (P[k,72,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,72,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_73:
	(sum {k in TEACHER, i in 2..4} (P[k,73,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,73,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_74:
	(sum {k in TEACHER, i in 2..4} (P[k,74,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,74,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_75:
	(sum {k in TEACHER, i in 2..4} (P[k,75,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,75,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_76:
	(sum {k in TEACHER, i in 2..4} (P[k,76,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,76,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_77:
	(sum {k in TEACHER, i in 2..4} (P[k,77,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,77,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_78:
	(sum {k in TEACHER, i in 2..4} (P[k,78,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,78,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_79:
	(sum {k in TEACHER, i in 2..4} (P[k,79,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,79,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_80:
	(sum {k in TEACHER, i in 3..4} (P[k,80,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,80,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_81:
	(sum {k in TEACHER, i in 2..4} (P[k,81,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,81,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_82:
	(sum {k in TEACHER, i in 2..4} (P[k,82,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,82,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_83:
	(sum {k in TEACHER, i in 2..4} (P[k,83,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,83,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_84:
	(sum {k in TEACHER, i in 2..4} (P[k,84,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,84,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_85:
	(sum {k in TEACHER, i in 2..4} (P[k,85,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,85,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_86:
	(sum {k in TEACHER, i in 2..4} (P[k,86,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,86,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_87:
	(sum {k in TEACHER, i in 2..4} (P[k,87,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,87,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_88:
	(sum {k in TEACHER, i in 3..4} (P[k,88,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,88,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_89:
	(sum {k in TEACHER, i in 2..4} (P[k,89,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,89,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_90:
	(sum {k in TEACHER, i in 2..4} (P[k,90,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,90,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_91:
	(sum {k in TEACHER, i in 2..4} (P[k,91,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,91,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_92:
	(sum {k in TEACHER, i in 2..4} (P[k,92,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,92,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_93:
	(sum {k in TEACHER, i in 2..4} (P[k,93,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,93,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_94:
	(sum {k in TEACHER, i in 2..4} (P[k,94,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,94,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_95:
	(sum {k in TEACHER, i in 2..4} (P[k,95,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,95,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_96:
	(sum {k in TEACHER, i in 3..4} (P[k,96,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,96,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_97:
	(sum {k in TEACHER, i in 2..4} (P[k,97,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,97,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_98:
	(sum {k in TEACHER, i in 2..4} (P[k,98,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,98,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_99:
	(sum {k in TEACHER, i in 2..4} (P[k,99,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,99,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_100:
	(sum {k in TEACHER, i in 2..4} (P[k,100,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,100,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_101:
	(sum {k in TEACHER, i in 3..4} (P[k,101,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,101,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_102:
	(sum {k in TEACHER, i in 2..4} (P[k,102,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,102,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_103:
	(sum {k in TEACHER, i in 2..4} (P[k,103,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,103,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_104:
	(sum {k in TEACHER, i in 3..4} (P[k,104,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,104,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_105:
	(sum {k in TEACHER, i in 2..4} (P[k,105,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,105,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_106:
	(sum {k in TEACHER, i in 2..4} (P[k,106,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,106,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_107:
	(sum {k in TEACHER, i in 2..4} (P[k,107,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,107,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_108:
	(sum {k in TEACHER, i in 3..4} (P[k,108,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,108,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_109:
	(sum {k in TEACHER, i in 2..4} (P[k,109,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,109,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_110:
	(sum {k in TEACHER, i in 2..4} (P[k,110,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,110,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_111:
	(sum {k in TEACHER, i in 2..4} (P[k,111,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,111,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_112:
	(sum {k in TEACHER, i in 2..4} (P[k,112,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,112,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_113:
	(sum {k in TEACHER, i in 2..4} (P[k,113,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,113,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_114:
	(sum {k in TEACHER, i in 2..4} (P[k,114,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,114,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_115:
	(sum {k in TEACHER, i in 2..4} (P[k,115,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,115,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_116:
	(sum {k in TEACHER, i in 3..4} (P[k,116,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,116,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_117:
	(sum {k in TEACHER, i in 2..4} (P[k,117,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,117,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_118:
	(sum {k in TEACHER, i in 2..4} (P[k,118,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,118,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_119:
	(sum {k in TEACHER, i in 2..4} (P[k,119,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,119,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_120:
	(sum {k in TEACHER, i in 2..4} (P[k,120,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,120,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_121:
	(sum {k in TEACHER, i in 2..4} (P[k,121,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,121,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_122:
	(sum {k in TEACHER, i in 2..4} (P[k,122,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,122,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_123:
	(sum {k in TEACHER, i in 2..4} (P[k,123,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,123,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_124:
	(sum {k in TEACHER, i in 2..4} (P[k,124,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,124,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_125:
	(sum {k in TEACHER, i in 3..4} (P[k,125,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,125,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_126:
	(sum {k in TEACHER, i in 2..4} (P[k,126,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,126,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_127:
	(sum {k in TEACHER, i in 2..4} (P[k,127,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,127,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_128:
	(sum {k in TEACHER, i in 2..4} (P[k,128,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,128,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_129:
	(sum {k in TEACHER, i in 2..4} (P[k,129,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,129,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_130:
	(sum {k in TEACHER, i in 2..4} (P[k,130,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,130,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_131:
	(sum {k in TEACHER, i in 2..4} (P[k,131,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,131,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_132:
	(sum {k in TEACHER, i in 2..4} (P[k,132,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,132,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_133:
	(sum {k in TEACHER, i in 3..4} (P[k,133,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,133,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_134:
	(sum {k in TEACHER, i in 2..4} (P[k,134,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,134,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_135:
	(sum {k in TEACHER, i in 2..4} (P[k,135,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,135,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_136:
	(sum {k in TEACHER, i in 2..4} (P[k,136,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,136,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_137:
	(sum {k in TEACHER, i in 2..4} (P[k,137,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,137,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_138:
	(sum {k in TEACHER, i in 2..4} (P[k,138,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,138,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_139:
	(sum {k in TEACHER, i in 2..4} (P[k,139,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,139,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_140:
	(sum {k in TEACHER, i in 2..4} (P[k,140,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,140,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_141:
	(sum {k in TEACHER, i in 2..4} (P[k,141,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,141,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_142:
	(sum {k in TEACHER, i in 2..4} (P[k,142,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,142,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_143:
	(sum {k in TEACHER, i in 2..4} (P[k,143,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,143,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_144:
	(sum {k in TEACHER, i in 2..4} (P[k,144,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,144,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_145:
	(sum {k in TEACHER, i in 2..4} (P[k,145,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,145,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_146:
	(sum {k in TEACHER, i in 3..4} (P[k,146,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,146,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_147:
	(sum {k in TEACHER, i in 2..4} (P[k,147,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,147,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_148:
	(sum {k in TEACHER, i in 2..4} (P[k,148,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,148,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_149:
	(sum {k in TEACHER, i in 2..4} (P[k,149,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,149,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_150:
	(sum {k in TEACHER, i in 2..4} (P[k,150,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,150,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_151:
	(sum {k in TEACHER, i in 2..4} (P[k,151,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,151,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_152:
	(sum {k in TEACHER, i in 2..4} (P[k,152,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,152,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_153:
	(sum {k in TEACHER, i in 2..4} (P[k,153,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,153,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_154:
	(sum {k in TEACHER, i in 2..4} (P[k,154,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,154,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_155:
	(sum {k in TEACHER, i in 2..4} (P[k,155,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,155,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_156:
	(sum {k in TEACHER, i in 2..4} (P[k,156,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,156,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_157:
	(sum {k in TEACHER, i in 2..4} (P[k,157,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,157,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_158:
	(sum {k in TEACHER, i in 2..4} (P[k,158,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,158,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_159:
	(sum {k in TEACHER, i in 2..4} (P[k,159,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,159,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_160:
	(sum {k in TEACHER, i in 2..4} (P[k,160,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,160,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_161:
	(sum {k in TEACHER, i in 2..4} (P[k,161,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,161,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_162:
	(sum {k in TEACHER, i in 2..4} (P[k,162,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,162,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_163:
	(sum {k in TEACHER, i in 2..4} (P[k,163,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,163,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_164:
	(sum {k in TEACHER, i in 2..4} (P[k,164,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,164,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_165:
	(sum {k in TEACHER, i in 2..4} (P[k,165,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,165,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_166:
	(sum {k in TEACHER, i in 2..4} (P[k,166,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,166,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_167:
	(sum {k in TEACHER, i in 2..4} (P[k,167,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,167,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_168:
	(sum {k in TEACHER, i in 2..4} (P[k,168,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,168,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_169:
	(sum {k in TEACHER, i in 2..4} (P[k,169,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,169,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_170:
	(sum {k in TEACHER, i in 2..4} (P[k,170,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,170,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_171:
	(sum {k in TEACHER, i in 2..4} (P[k,171,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,171,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_172:
	(sum {k in TEACHER, i in 2..4} (P[k,172,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,172,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_173:
	(sum {k in TEACHER, i in 2..4} (P[k,173,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,173,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_174:
	(sum {k in TEACHER, i in 2..4} (P[k,174,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,174,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_175:
	(sum {k in TEACHER, i in 2..4} (P[k,175,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,175,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_176:
	(sum {k in TEACHER, i in 2..4} (P[k,176,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,176,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_177:
	(sum {k in TEACHER, i in 3..4} (P[k,177,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,177,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_178:
	(sum {k in TEACHER, i in 3..4} (P[k,178,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,178,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_179:
	(sum {k in TEACHER, i in 2..4} (P[k,179,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,179,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_180:
	(sum {k in TEACHER, i in 2..4} (P[k,180,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,180,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_181:
	(sum {k in TEACHER, i in 3..4} (P[k,181,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,181,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_182:
	(sum {k in TEACHER, i in 2..4} (P[k,182,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,182,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_183:
	(sum {k in TEACHER, i in 3..4} (P[k,183,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,183,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_184:
	(sum {k in TEACHER, i in 2..4} (P[k,184,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,184,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_185:
	(sum {k in TEACHER, i in 3..4} (P[k,185,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..2} (P[k,185,i] * SNR[k,2])) <= 6;
subject to Maj_Prof_2ndYr_Then_No_New_186:
	(sum {k in TEACHER, i in 2..4} (P[k,186,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,186,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_187:
	(sum {k in TEACHER, i in 2..4} (P[k,187,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,187,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_188:
	(sum {k in TEACHER, i in 2..4} (P[k,188,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,188,i] * SNR[k,2])) <= 2;
subject to Maj_Prof_2ndYr_Then_No_New_189:
	(sum {k in TEACHER, i in 2..4} (P[k,189,i] * SNR[k,1])) + 3 * (sum {k in TEACHER, i in 1..1} (P[k,189,i] * SNR[k,2])) <= 2;
