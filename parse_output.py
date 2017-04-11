#!/usr/bin/env python2
'''
Take in the output from APML and then yield out human readable output.
'''
import init
import pandas as pd

# day i + 1
# list of time
session_list = ['08:00','09:15','10:30','11:45','13:30','14:45','16:00']
# usernames and actual name are pulled from the processed csv

st, ts = init.import_data()
# number of student/professor
s_count = len(st)
t_count = len(ts)
y_file = open('data/y_data', 'r')
p_file = open('data/p_data', 'r')
y_data = y_file.readlines()
p_data = p_file.readlines()
y_file.close()
p_file.close()

del y_data[0]
del y_data[-2:]
y_cursor = 0
while y_cursor < len(y_data):
    if y_data[y_cursor][-2] == '0':
        del y_data[y_cursor]
    else:
        y_data[y_cursor] = y_data[y_cursor][:-5].split()
        y_cursor += 1
yDF = pd.DataFrame.from_records(y_data, columns=['day','sesh','stu'], index='stu')
yDF.sort_index()

y_cursor = 0
p_cursor = 0

records = []

# parse each student // keep appending records
for i in range(s_count):
    row = ['','','','','','','','','','','','']
    # do things
    row[2] = int(yDF.get_value(str(i), 'day')) + 1
    row[3] = session_list[int(yDF.get_value(str(i), 'sesh'))]
    records.append(row)

# packing em all in
outDF = pd.DataFrame.from_records(records, columns=['Student ID', 'Student Name','Day','Timeslot',
    'Chair 1 ID','Chair 1 Name','Chair 2 ID','Chair 2 Name',
    'Chair 3 ID','Chair 3 Name','Chair 4 ID','Chair 4 Name'])

# export
outDF.to_csv('schedule.csv')
print 'Schedule written out to "schedule.csv", quitting...'