#!/usr/bin/env python
'''
Oral Comprehensive Assigning Tool
MAT-226 Final Project
'''
# imports
import init

# format number to put in variable name
def frmt(i):
    return str(i)

# initializations
# st = students DataFrame
# ID, Mj1, Mj2, Mn
# ts = teachers DataFrame
# ID, DP, 1Y, 2Y
st, ts = init.import_data()

# cache
s_count = 9
t_count = 5
d_count = 2
i_count = 3
depts_c = 4

# caching the list of professors for each dept
t_cache = []
for i in range(depts_c):
    t_cache.append([])
    for j in range(t_count):
        if str(i) in ts.get_value(j,'DP'):
            t_cache[i].append(j)

f = open('lingo_file.txt','w')
f.write('Min = 1;\n')
# legend: v%d%i%p%s
# %d: day of oral
# %i: session in day
# %p: professor ID
# %s: student ID

# no same timeslot for a teacher
# for each prof
for l in range(t_count):
    # everyday
    for i in range(d_count):
        # for each session
        for j in range(i_count):
            # for each student
            for k in range(s_count):
                # no same timeslot
                f.write('v'+frmt(i)+frmt(j)+frmt(k)+frmt(l)+' + ')
    f.write('0 <= 1;\n')
                
# exact 1 timeslots/3 profs for a student
# for each student
for k in range(s_count):
    # everyday
    for i in range(d_count):
        # for each session
        for j in range(i_count):
            # for each prof
            for l in range(t_count):
                # exactly 3 profs
                f.write('v'+frmt(i)+frmt(j)+frmt(k)+frmt(l)+' + ')
    f.write('0 = 3;\n')

# each student field has exactly one teacher
        
f.close()

# list of variables
