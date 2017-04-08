#!/usr/bin/env python2
'''
Oral Comprehensive Assigning Tool
MAT-226 Final Project
'''
# imports
import init

def frmt(i):
    '''
    Format a number into a string (with zero-padding, for eg)
    '''
    return str(i)

def newline(f):
    '''
    Take a opened file stream and write a newline.
    '''
    f.write('\n')

# initializations
# st = students DataFrame
# ID, Mj1, Mj2, Mn
# ts = teachers DataFrame
# ID, DP, 1Y, 2Y
st, ts = init.import_data()
modfile = open('ampl/mock.mod', 'w')
datfile = open('ampl/mock.dat', 'w')

# cache
s_count = 9 # number of students
t_count = 5 # number of teachers
d_count = 2 # number of days
i_count = 3 # number of sesh/day
depts_c = 4 # number of depts

datfile.write('data;\n\n')
# days and sessions
modfile.write('set DAY;\n')
datfile.write('set DAY :=')
for i in range(d_count):
    datfile.write(' ' + str(i))
datfile.write(';\n')
modfile.write('set SESSION;\n')
datfile.write('set SESSION :=')
for i in range(i_count):
    datfile.write(' ' + str(i))
datfile.write(';\n')

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
modfile.write('var X {DAY, SESSION, STUDENT, TEACHER} binary;\n')
newline(modfile)
modfile.write('minimize CONST\n\t1;\n')
newline(modfile)

# legend: v%d%i%p%s
    # %d: day of oral
    # %i: session in day
    # %p: professor ID
    # %s: student ID

# no same timeslot for a teacher
# for each prof
# for l in range(t_count):
#     # everyday
#     for i in range(d_count):
#         # for each session
#         for j in range(i_count):
#             # for each student
#             for k in range(s_count):
#                 # no same timeslot
#                 modfile.write('v'+frmt(i)+frmt(j)+frmt(k)+frmt(l)+' + ')
#     modfile.write('0 <= 1;\n')

# exact 1 timeslots/3 profs for a student
# for each student
# for k in range(s_count):
#     # everyday
#     for i in range(d_count):
#         # for each session
#         for j in range(i_count):
#             # for each prof
#             for l in range(t_count):
#                 # exactly 3 profs
#                 modfile.write('v'+frmt(i)+frmt(j)+frmt(k)+frmt(l)+' + ')
#     modfile.write('0 = 3;\n')

# each student field has exactly one teacher

modfile.close()
datfile.close()

# list of variables
