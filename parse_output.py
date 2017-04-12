#!/usr/bin/env python2
'''
Take in the output from APML and then yield out human readable output.
'''
import init
import pandas as pd
import sys

path = sys.argv[1] if len(sys.argv) > 1 else '2016.xlsx'
valid = pd.read_excel(path, "Validations")
# day i + 1
date_list = ['1/11/2017', '1/12/2017', '1/13/2017']
# list of time
session_list = ['8:00 AM - 9:00 AM',
                '9:15 AM - 10:15 AM',
                '10:30 AM - 11:30 AM',
                '11:45 AM - 12:45 PM',
                '1:30 PM - 2:30 PM',
                '2:45 PM - 3:45 PM',
                '4:00 PM - 5:00 PM']
# usernames and actual name are pulled from the processed csv
for i in range(3):
    date_list[i] = valid.get_value(i,'Comp Dates')
for i in range(7):
    session_list[i] = valid.get_value(i,'Time Slots')

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

records = []
stud_sheet = pd.read_excel(path, "Student Data")
prof_sheet = pd.read_excel(path, "Faculty Data")

# parse each student // keep appending records
for i in range(s_count):
    row = ['','','','','','','','','','','','']
    # get time
    row[2] = date_list[int(yDF.get_value(str(i), 'day'))-1]
    row[3] = session_list[int(yDF.get_value(str(i), 'sesh'))]
    # get assignment
    del p_data[0:2]
    temp_data = p_data[0:t_count]
    tempDF = pd.Series(temp_data).str.split().apply(pd.Series)
    sid = st.get_value(i, 'SID')
    row[0] = sid
    name = stud_sheet.loc[stud_sheet['Person Id'] == sid, 'Student Name'].values[0]
    row[1] = name
    for k in range(t_count):
        for l in range(1,5):
            if tempDF.get_value(k, l) == '1':
                sid = ts.get_value(k, 'SID')
                row[2 * l + 2] = sid
                name = prof_sheet.loc[prof_sheet['Person Id'] == sid, 'Faculty Name'].values[0]
                row[2 * l + 3] = name
                break
    del p_data[0:t_count + 1]
    records.append(row)

# packing em all in
outDF = pd.DataFrame.from_records(records, columns=['Student ID', 'Student Name','Date','Timeslot',
    'Chair 1 ID','Chair 1 Name','Chair 2 ID','Chair 2 Name',
    'Chair 3 ID','Chair 3 Name','Chair 4 ID','Chair 4 Name'])

# export
outDF.to_csv('schedule.csv', index=False)
print 'Schedule written out to "schedule.csv", Done!'
