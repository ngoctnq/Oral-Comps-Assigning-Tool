#!/usr/bin/env python2
'''
    Oral Comprehensive Assigning Tool
    MAT-226 Final Project
    '''
# imports
import init

LOGICAL_FLAG = False

def newline(f):
    '''
    Take a opened file stream and write a newline.
    '''
    f.write('\n')

# initializations
# st = students DataFrame
# ID, Mj, Mn
# ts = teachers DataFrame
# ID, DP, 1Y, 2Y
st, ts = init.import_data('mock1')
modfile = open('ampl/mock.mod', 'w')
datfile = open('ampl/mock.dat', 'w')

# cache
s_count = len(st) # number of students
t_count = len(ts) # number of teachers
d_count = 2 # number of days
i_count = 3 # number of sesh/day
depts_c = 4 # number of depts
maxpday = 2 # max no of sesh/day

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

# caching the list of professors for each dept
for i in range(depts_c):
    datfile.write('set DEPT' + str(i) + " :=")
    for j in range(t_count):
        if str(i) in ts.get_value(j,'DP'):
            datfile.write(' ' + str(j))
    datfile.write(';\n')
    modfile.write('set DEPT' + str(i) + ';\n')
newline(datfile)
newline(modfile)

# declare variables and parameters
# if the teachers are first or second year (else = not associate)
# TODO import actual profs' profile
modfile.write('param SNR {TEACHER, 1..2} binary\n\tdefault 0;\n')
newline(modfile)
# datfile.write('param SNR {i in TEACHER, j in 1..2} = 0;\n')
# newline(datfile)

# if the teacher are free sometimes
# TODO import actual prof's schedule
modfile.write('param BUSY {1..DAY, 1..SESSION, TEACHER} binary\n\tdefault 0;\n')

# if the student has 3 majors
# TODO import actual student major status
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
# only 3/4 Cs per student, denoting number of chairs of a student
modfile.write('var C {TEACHER, STUDENT} binary;\n')
# the order of student's profs
modfile.write('var P {TEACHER, STUDENT, 1..4} binary;\n')

modfile.write('var X {1..DAY, 1..SESSION, TEACHER, STUDENT} binary;\n')
newline(modfile)
modfile.write('minimize CONST: 1;\n')
newline(modfile)

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

# profs cannot attend if busy *taps head meme*
# TODO cannot be optimized as sum of products equal zero
modfile.write('subject to Prof_Is_Busy {i in 1..DAY, j in 1..SESSION, k in TEACHER}:\n\t')
modfile.write('BUSY[i,j,k] * sum {l in STUDENT} X[i,j,k,l] = 0;\n')

# define C - denoting if a prof is a student chair
modfile.write('subject to Is_Prof_Student_Pair {k in TEACHER, l in STUDENT}:\n\t')
modfile.write('sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = C[k,l];\n')

# integrity of P
# NOTE unlikely would need this, so delete if too many constraint
modfile.write('subject to Integrity_P_Nontriple {l in STUDENT, i in 1..3}:\n\t')
modfile.write('sum {k in TEACHER} P[k,l,i] = 1;\n')
modfile.write('subject to Integrity_P_Triple {l in STUDENT}:\n\t')
modfile.write('sum {k in TEACHER} P[k,l,4] <= 1;\n')

# timeslot of Ps
modfile.write('subject to Prof_Student_Timeslot {k in TEACHER, l in STUDENT}:\n\t')
modfile.write('sum {i in 1..DAY, j in 1..SESSION} X[i,j,k,l] = sum {i in 1..4} P[k,l,i];\n')

# department oral chair
for i in range(s_count):
    mj_c = len(major[i])
    # sick em on da majors
    # NOTE WOULD ALREADY INCLUDE A 3RD POSSIBLE MAJOR
    for j in range(mj_c):
        modfile.write('subject to Prof_Student_' + str(i) + '_Dept_' + str(major[i][j]) + ':\n\t')
        modfile.write('sum {k in DEPT' + str(major[i][j]) + '} P[k,' +
            str(i) + ',' + str(j+1) + '] = 1;\n')

    # if only one major -> u hab da minor
    mn_c = len(minor[i])
    if mj_c == 1:
        modfile.write('subject to Prof_Student_' + str(i) + '_Minor:\n\t')
        modfile.write('sum {k in ')
        if mn_c > 1:
            modfile.write('(')
        modfile.write('DEPT' + str(minor[i][0]))
        if mn_c > 1:
            for j in range(mn_c):
                modfile.write(' union DEPT' + str(minor[i][j]))
            modfile.write(')')
        modfile.write('} P[k,' + str(i) + ',2] = 1;\n')
    # you will always have 1 at-large regardless of no of Maj/min
    modfile.write('subject to Prof_Student_' + str(i) + '_AtLarge:\n\t')
    modfile.write('sum {k in (TEACHER')
    for j in range(mj_c):
        modfile.write(' diff DEPT' + str(major[i][j]))
    for j in range(mn_c):
        modfile.write(' diff DEPT' + str(minor[i][j]))
    modfile.write(')} P[k,' + str(i) + ',3 + TRIPLE[' + str(i) + ']] = 1;\n')

# not all new major chair
for l in range(s_count):
    mj_c = len(major[l])
    modfile.write('subject to No_New_Major_Board_Student_' + str(l) + ':\n\t')
    modfile.write('sum {k in TEACHER, l in STUDENT, i in 1..' + str(mj_c) + '} P[k,l,i] * SNR[k,1] < ' + str(mj_c) + ';\n')

# if 2nd yr major chair -> no new anythin
# if use AMPL logic flags
if LOGICAL_FLAG:
    for l in range(s_count):
        mj_c = len(major[l])
        modfile.write('subject to Maj_Prof_2ndYr_Then_No_New_' + str(l) + ':\n\t')
        # either there is a 3rd yr prof in the majors
        modfile.write('(numberof 1 in ({k in TEACHER, i in 1..' + str(mj_c) + '} P[k,' + str(l) + ',i]) > 0) or ')
        # or there must be no first year
        modfile.write('(numberof 1 in ({k in TEACHER, i in 1..4} (P[k,' + str(l) + ',i] * SNR[k,1])) = 0);')
        newline(modfile)
else:
    for l in range(s_count):
        mj_c = len(major[l])
        modfile.write('subject to Maj_Prof_2ndYr_Then_No_New_' + str(l) + ':\n\t')
        # either there is no first year (then the sum = 0)
        modfile.write('(sum {k in TEACHER, i in 1..4} (P[k,' + str(l) + ',i] * SNR[k,1]))')
        # or there is a 3rd year mj
        for i in range(mj_c):
            modfile.write(' * (product {k in TEACHER} (P[k,' + str(l) + ',' + str(i + 1) + '] - SNR[k,1] - SNR[k,2] - 1))')
        modfile.write(' = 0;')

modfile.close()
datfile.close()

# list of variables
