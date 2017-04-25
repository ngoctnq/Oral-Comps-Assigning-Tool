#!/usr/bin/env python2
'''
    Oral Comprehensive Assigning Tool
    MAT-226 Final Project
    '''
# imports
import tools
import sys
import pandas as pd

path = sys.argv[1] if len(sys.argv) > 1 else '2016.xlsx'
path2 = sys.argv[2] if len(sys.argv) > 2 else 'divisions.xlsx'
# true: find the minimum total no of seshs for all faculties
# false: find the most even schedule for all
tALLfEVEN = False

# initializations
# st = students DataFrame
# ID, SID, Mj, Mn
# ts = teachers DataFrame
# ID, SID, DP, 1Y, 2Y, UB
st, ts = tools.import_data()
modfile = open('ampl/mock.mod', 'w')
datfile = open('ampl/mock.dat', 'w')

dept_list = tools.get_depts(path)
div_dept, div_prof = tools.get_div(path, path2)

# cache
s_count = len(st) # number of students
t_count = len(ts) # number of teachers
d_count = 3 # number of days
i_count = 7 # number of sesh/day
depts_c = len(dept_list) # number of depts
maxpday = 4 # max no of sesh/day
if tALLfEVEN:
    maxpall = 12 # max no of sesh/all
else:
    maxpall = 9 # minimized with AMPL

# cache major/minor list of students
major = []
minor = []
for i in range(s_count):
    major.append([])
    minor.append([])
    major_list = str(st.get_value(i, 'Mj'))
    minor_list = str(st.get_value(i, 'Mn'))
    if minor_list == 'nan':
        minor_list = ''
    major[i] = major_list.split(',')
    for j in range(len(major[i])):
        if major[i][j] != '':
            major[i][j] = str(int(float(major[i][j])))
        else:
            del major[i][j]
    minor[i] = minor_list.split(',')
    for j in range(len(minor[i])):
        if minor[i][j] != '':
            minor[i][j] = str(int(float(minor[i][j])))
        else:
            del minor[i][j]

datfile.write('data;\n\n')
# days and sessions
modfile.write('param DAY;\n')
datfile.write('param DAY := '+ str(d_count) +';\n')
modfile.write('param SESSION;\n')
datfile.write('param SESSION := '+ str(i_count) +';\n')

# initial student/teacher set
modfile.write('set STUDENT;\nset TEACHER;\n')
datfile.write('set STUDENT :=')
for i in range(s_count):
    datfile.write(' ' + str(i))
datfile.write(';\n')
datfile.write('set TEACHER :=')
for i in range(t_count):
    datfile.write(' ' + str(i))
datfile.write(';\n')

# caching the list of division faculty
modfile.write('set DIV1;\nset DIV2;\nset DIV3;\n')
# TODO ACTUAL DATFILE WRITING
for j in range(3):
    datfile.write('set DIV' + str(j+1) +' :=')
    for i in div_prof[j]:
        datfile.write(' ' + str(i))
    datfile.write(';\n')

# caching the list of professors for each dept
for i in range(depts_c):
    datfile.write('set DEPT' + str(i) + " :=")
    for j in range(t_count):
        if str(i) in ts.get_value(j,'DP').split(','):
            datfile.write(' ' + str(j))
    datfile.write(';\n')
    modfile.write('set DEPT' + str(i) + ';\n')
tools.newline(datfile)
tools.newline(modfile)

# declare variables and parameters
# if the teachers are first or second year (else = not associate)
modfile.write('param SNR {TEACHER, 1..2} binary\n\tdefault 0;\n')
tools.newline(modfile)
datfile.write('param SNR :=')
for i in range(t_count):
    for j in range(1,3):
        snr_i = int(ts.get_value(i, str(j)+'Y'))
        if snr_i == 1:
            datfile.write('\n%7d %3d %-3d' % (i, j, snr_i))
datfile.write(';\n')

# if the teacher had a cap on no of meets
modfile.write('param UCAP {TEACHER} integer\n\tdefault ' + str(maxpall) + ';\n')
datfile.write('param UCAP :=')
for i in range(t_count):
    ucap = str(ts.get_value(i, 'UB'))
    if ucap != 'nan':
        datfile.write('\n%12d  %-2d' % (i, int(float(ucap))))
datfile.write(';\n')

# if the teacher are free sometimes
# TODO import actual prof's schedule
modfile.write('param BUSY {1..DAY, 1..SESSION, TEACHER} binary\n\tdefault 0;\n')
modfile.write('param BUSZ {1..DAY, 1..SESSION, STUDENT} binary\n\tdefault 0;\n')
date_list, session_list = tools.get_date_and_time(path)

# faculty busy schedule
prof = pd.read_excel(path, "Faculty Unavailability")
datfile.write('param BUSY :=')
for i in range(len(prof)):
    pid = prof.get_value(i, 'Person Id')
    dt = date_list.index(prof.get_value(i, 'Date')) + 1
    sesh = session_list.index(prof.get_value(i, 'Time Slot')) + 1
    pid = ts.loc[ts['SID'] == pid, 'ID'].values[0]
    datfile.write('\n%4d %3d %3d %-3d' % (dt, sesh, pid, 1))
datfile.write(';\n')

# student busy schedule
stud = pd.read_excel(path, "Student Unavailability")
datfile.write('param BUSZ :=')
for i in range(len(stud)):
    pid = stud.get_value(i, 'Person Id')
    dt = date_list.index(stud.get_value(i, 'Date')) + 1
    sesh = session_list.index(stud.get_value(i, 'Time Slot')) + 1
    pid = st.loc[st['SID'] == pid, 'ID'].values[0]
    datfile.write('\n%4d %3d %3d %-3d' % (dt, sesh, pid, 1))
datfile.write(';\n')

# if the student has 3 majors
modfile.write('param TRIPLE {STUDENT} binary\n\tdefault 0;\n')
datfile.write('param TRIPLE :=')
# for i in range(s_count):
#     datfile.write('%5d' % i)
# datfile.write(' :=\n')
# datfile.write('             ')
# for i in range(s_count):
#     mj_c = len(major[i])
#     j = 1 if (mj_c == 3) else 0
#     datfile.write('%5d' % j)
# datfile.write(' ;\n')
for i in range(s_count):
    mj_c = len(major[i])
    if mj_c == 3:
        datfile.write('\n%14d  %-2d' % (i, 1))
datfile.write(';\n')

# only one Y per student = 1, rest = 0, denote what session hes in
modfile.write('var Y {1..DAY, 1..SESSION, STUDENT} binary;\n')
# only 3-4 Cs per student, denoting number of chairs of a student
modfile.write('var C {TEACHER, STUDENT} binary;\n')
# the order of student's profs
modfile.write('var P {TEACHER, STUDENT, 1..4} binary;\n')

# number of prof in at-large in each divisions
modfile.write('var U {STUDENT, 1..3} binary;\n')
# number of prof in majors/minors in each divisions
modfile.write('var V {STUDENT, 1..3} integer;\n')

if tALLfEVEN:
    # TO MINIMIZE: THE MAXIMUM NUMBER OF SESSIONS PER ALL
    modfile.write('var MAXPALL integer;\n')
else:
    modfile.write('var Z {k in TEACHER} integer;\n')

modfile.write('var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;\n')
tools.newline(modfile)

if not tALLfEVEN:
    modfile.write('#')
modfile.write('minimize OBJ: MAXPALL;\n')
if tALLfEVEN:
    modfile.write('#')
modfile.write('minimize OBJ: sum {k in TEACHER} Z[k];\n')
tools.newline(modfile)

avg = str(int(s_count * 3 / t_count))
#print avg
if not tALLfEVEN:
    modfile.write('subject to Zdefn1 {k in TEACHER}:\n\t')
    modfile.write('sum {l in STUDENT} C[k,l] - ' + avg + ' <= Z[k];\n')
    modfile.write('subject to Zdefn2 {k in TEACHER}:\n\t')
    modfile.write(avg + ' - sum {l in STUDENT} C[k,l] <= Z[k];\n')

# legend: v%d%i%p%s
    # %d: day of oral
    # %i: session in day
    # %p: professor ID
    # %s: student ID

# each student has exactly one timeslot
modfile.write('subject to Student_Timeslot_Binary {l in STUDENT}:\n\t')
modfile.write('sum {i in 1..DAY, j in 1..SESSION} Y[i,j,l] = 1;\n')
modfile.write('subject to Student_Timeslot_Count {i in 1..DAY, j in 1..SESSION, l in STUDENT}:\n\t')
modfile.write('sum {k in TEACHER} X[i,j,k,l] = (3 + TRIPLE[l]) * Y[i,j,l];\n')

# teacher only appear at one place anytime
modfile.write('subject to Teacher_Clone_Jutsu {i in 1..DAY, j in 1..SESSION, k in TEACHER}:\n\t')
modfile.write('sum {l in STUDENT} X[i,j,k,l] <= 1;\n')

# no consecutive sessions
modfile.write('subject to Prof_No_Consecutive_Sesh {i in 1..DAY, j in 1..SESSION-1, k in TEACHER}:\n\t')
modfile.write('sum {l in STUDENT} (X[i,j,k,l] + X[i,j+1,k,l]) <= 1;\n')

# at most $maxpday seshs per day per professor
modfile.write('subject to Prof_Max_Per_Day {i in 1..DAY, k in TEACHER}:\n\t')
modfile.write('sum {j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= '+ str(maxpday) + ';\n')
modfile.write('subject to Prof_Max_All {k in TEACHER}:\n\t')
modfile.write('sum {i in 1..DAY, j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= UCAP[k];\n')
if tALLfEVEN:
    modfile.write('subject to Prof_Max_All_REAL {k in TEACHER}:\n\t')
    modfile.write('sum {i in 1..DAY, j in 1..SESSION, l in STUDENT} X[i,j,k,l] <= MAXPALL;\n')

# profs cannot attend if busy *taps head meme*
# NOTE cannot be optimized as sum of products equal zero
modfile.write('subject to Prof_Is_Busy {i in 1..DAY, j in 1..SESSION, k in TEACHER}:\n\t')
modfile.write('BUSY[i,j,k] * sum {l in STUDENT} X[i,j,k,l] = 0;\n')
modfile.write('subject to Stud_Is_Busy {i in 1..DAY, j in 1..SESSION, l in STUDENT}:\n\t')
modfile.write('BUSZ[i,j,l] * sum {k in TEACHER} X[i,j,k,l] = 0;\n')

# define C - denoting if a prof is a student chair
modfile.write('subject to Is_Prof_Student_Pair {k in TEACHER, l in STUDENT}:\n\t')
modfile.write('sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = C[k,l];\n')

# integrity of P
# NOTE unlikely would need this, so delete if too many constraint
modfile.write('subject to Integrity_P_Nontriple {l in STUDENT, i in 1..3}:\n\t')
modfile.write('sum {k in TEACHER} P[k,l,i] = 1;\n')
modfile.write('subject to Integrity_P_Triple {l in STUDENT}:\n\t')
modfile.write('sum {k in TEACHER} P[k,l,4] = TRIPLE[l];\n')

# timeslot of Ps
modfile.write('subject to Prof_Student_Timeslot {k in TEACHER, l in STUDENT}:\n\t')
modfile.write('sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = sum {i in 1..4} P[k,l,i];\n')

# department oral chair
for i in range(s_count):
    mj_c = len(major[i])
    # 3-major students case handled
    for j in range(mj_c):
        modfile.write('subject to Prof_Student_' + str(i) + '_Dept_' + str(major[i][j]) + ':\n\t')
        modfile.write('sum {k in DEPT' + str(major[i][j]) + ', i in 1..' + str(mj_c) + '} P[k,' +
            str(i) + ',i] = 1;\n')

    # if only one major -> u hab da minor
    mn_c = len(minor[i])
    if mj_c == 1:
        modfile.write('subject to Prof_Student_' + str(i) + '_Minor:\n\t')
        modfile.write('sum {k in ')
        if mn_c > 1:
            modfile.write('(')
        modfile.write('DEPT' + str(minor[i][0]))
        if mn_c > 1:
            for j in range(1,mn_c):
                modfile.write(' union DEPT' + str(minor[i][j]))
            modfile.write(')')
        modfile.write('} P[k,' + str(i) + ',2] = 1;\n')

    # # OLD WORKING CODE, MORE CONSTRAINED
    # # you will always have 1 at-large regardless of no of Maj/min
    # modfile.write('subject to Prof_Student_' + str(i) + '_AtLarge:\n\t')
    # modfile.write('sum {k in (TEACHER')
    # for j in range(mj_c):
    #     modfile.write(' diff DEPT' + str(major[i][j]))
    # for j in range(mn_c):
    #     modfile.write(' diff DEPT' + str(minor[i][j]))
    # modfile.write(')} P[k,' + str(i) + ',3 + TRIPLE[' + str(i) + ']] = 1;\n')

    ### EXPERIMENTAL CODE FROM HERE
    # if you are a triple major, you have special treatment
    if mj_c == 3:
        if tools.three_depted(major[i], div_dept):
            modfile.write('subject to Prof_Student_' + str(i) + '_AtLarge:\n\t')
            modfile.write('sum {k in (TEACHER')
            for j in range(mj_c):
                modfile.write(' diff DEPT' + str(major[i][j]))
            for j in range(mn_c):
                modfile.write(' diff DEPT' + str(minor[i][j]))
            modfile.write(')} P[k,' + str(i) + ',3 + TRIPLE[' + str(i) + ']] = 1;\n')
        else:
            modfile.write('subject to Prof_Student_' + str(i) + '_AtLarge {i in 1..3}:\n\t')
            modfile.write('U['+str(i)+',i] * 3 + V['+str(i)+',i] <= 3;\n')
    # else, you have 2 cherry picked fac and now the 3rd
    else:
        modfile.write('subject to Prof_Student_' + str(i) + '_AtLarge {i in 1..3}:\n\t')
        modfile.write('U['+str(i)+',i] * 2 + V['+str(i)+',i] <= 2;\n')
    ### END OF NEW EXPERIMENTAL CODE

modfile.write('subject to Udef1 {l in STUDENT}:\n\t')
modfile.write('sum {k in DIV1} P[k,l,3+TRIPLE[l]] = U[l,1];\n')
modfile.write('subject to Udef2 {l in STUDENT}:\n\t')
modfile.write('sum {k in DIV2} P[k,l,3+TRIPLE[l]] = U[l,2];\n')
modfile.write('subject to Udef3 {l in STUDENT}:\n\t')
modfile.write('sum {k in DIV3} P[k,l,3+TRIPLE[l]] = U[l,3];\n')

modfile.write('subject to Vdef1 {l in STUDENT}:\n\t')
modfile.write('sum {k in DIV1, i in 1..2+TRIPLE[l]} P[k,l,i] = V[l,1];\n')
modfile.write('subject to Vdef2 {l in STUDENT}:\n\t')
modfile.write('sum {k in DIV2, i in 1..2+TRIPLE[l]} P[k,l,i] = V[l,2];\n')
modfile.write('subject to Vdef3 {l in STUDENT}:\n\t')
modfile.write('sum {k in DIV3, i in 1..2+TRIPLE[l]} P[k,l,i] = V[l,3];\n')

# not new 1st major chair
modfile.write('subject to No_New_1st_Major_Students:\n\t')
modfile.write('sum {k in TEACHER, l in STUDENT} P[k,l,1] * SNR[k,1] = 0;\n')

# if 2nd yr major chair -> no new anythin
modfile.write('subject to Maj_Prof_2ndYr_Then_No_New {l in STUDENT}:\n\t')
# either there is no first year (then the sum = 0)
modfile.write('(sum {k in TEACHER, i in 2..4} (P[k,l,i] * SNR[k,1])) + ')
# or there is a 3rd year mj
modfile.write('3 * (sum {k in TEACHER} (P[k,l,1] * SNR[k,2]))')
modfile.write(' <= 3;\n')

modfile.close()
datfile.close()
