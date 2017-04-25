#!/usr/bin/env python2
'''
First, verify the integrity of the solution. TODO
Then, take in the output from APML and then yield out human readable output.
'''
import tools
import pandas as pd
import sys

path = sys.argv[1] if len(sys.argv) > 1 else '2016.xlsx'
date_list, session_list = tools.get_date_and_time(path)

st, ts = tools.import_data()
# number of student/professor
s_count = len(st)
t_count = len(ts)
y_file = open('ampl/y_data', 'r')
p_file = open('ampl/p_data', 'r')
y_data = y_file.readlines()
p_data = p_file.readlines()
y_file.close()
p_file.close()

del y_data[0]
del p_data[0]

y_list = []
p_list = []

def process(s, l):
    '''
    Process AMPL output into list.
    '''
    catcher = ''
    opened = False
    while len(s)>0 and s[0] != ';':
        if s[0] == ' ':
            pass
        elif s[0] == '(':
            opened = True
            catcher = ''
        elif s[0] == ')':
            opened = False
            l.append(map(int, catcher.split(',')))
        else:
            catcher += s[0]
        s = s[1:]

while len(y_data)>0:
    process(y_data[0], y_list)
    del y_data[0]

while len(p_data)>0:
    process(p_data[0], p_list)
    del p_data[0]
    
y_list.sort(key=lambda x: x[2])

# print y_list
# print p_list
    
records = []
stud_sheet = pd.read_excel(path, "Student Data")
prof_sheet = pd.read_excel(path, "Faculty Data")

# parse each student // keep appending records
for i in range(s_count):
    row = ['','','','','','','','','','','','']
    y_entry = y_list[i]
    # get time
    row[2] = date_list[y_entry[0] - 1]
    row[3] = session_list[y_entry[1] - 1]
    # get assignment
    tempDF = pd.DataFrame.from_records(p_list, columns=['ts','st','c'])
    sid = st.get_value(i, 'SID')
    row[0] = '%07d' % sid
    name = stud_sheet.loc[stud_sheet['Person Id'] == sid, 'Student Name'].values[0]
    row[1] = name
    for l in range(1,5):
        cid = tempDF[(tempDF['st'] == i) & (tempDF['c'] == l)]['ts']
        if len(cid) != 0:
            sid = ts.get_value(cid.values[0], 'SID')
            row[2 * l + 2] = '%07d' % sid
            name = prof_sheet.loc[prof_sheet['Person Id'] == sid, 'Faculty Name'].values[0]
            row[2 * l + 3] = name
    records.append(row)

# packing em all in
outDF = pd.DataFrame.from_records(records, columns=['Student ID', 'Student Name','Date','Timeslot',
    'Chair 1 ID','Chair 1 Name','Chair 2 ID','Chair 2 Name',
    'Chair 3 ID','Chair 3 Name','Chair 4 ID','Chair 4 Name'])

# export
outDF.to_csv('schedule.csv', index=False)
print 'Schedule written out to "schedule.csv", Done!'
