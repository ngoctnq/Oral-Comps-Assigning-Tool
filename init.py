#!/usr/bin/env python
'''
Initialize data, either bridging from Wabash's database or input file.
'''
import pandas as pd
import tools
import sys

path = sys.argv[1] if len(sys.argv) > 1 else '2016.xlsx'

# do imports here
# initialize output file for parse_output.py
# write it directly to student/teacher.csv
    # s_outDF = students DataFrame
    # ID, SID, Mj, Mn
    # t_outDF = teachers DataFrame
    # ID, SID, DP, 1Y, 2Y, UB (upper bound)
# TODO WRITE THINGS TO CSV
depts = tools.get_depts(path)
stud = []
prof = []
st = pd.read_excel(path, "Student Data")
ts = pd.read_excel(path, "Faculty Data")
s_count = len(st)
t_count = len(ts)
for i in range(s_count):
    row = [i]
    row.append(st.get_value(i,'Person Id'))
    row.append(str(depts.index(st.get_value(i, 'Major 1'))))
    maj = str(st.get_value(i, 'Major 2'))
    if maj != 'nan':
        row[2] = row[2] + ',' + str(depts.index(maj))
        maj = str(st.get_value(i, 'Major 3'))
        if maj != 'nan':
            row[2] = row[2] + ',' + str(depts.index(maj))
    mnr = str(st.get_value(i, 'Minor 1'))
    if mnr == 'nan':
        row.append(None)
    else:
        row.append(str(depts.index(mnr)))
        mnr = str(st.get_value(i, 'Minor 2'))
        if mnr != 'nan':
            row[3] = row[3] + ',' + str(depts.index(mnr))
            mnr = str(st.get_value(i, 'Minor 3'))
            if mnr != 'nan':
                row[3] = row[3] + ',' + str(depts.index(mnr))
    stud.append(row)

# test
    
s_outDF = pd.DataFrame.from_records(stud, columns=['ID','SID','Mj','Mn'])
t_outDF = pd.DataFrame.from_records(prof, columns=['ID','SID','DP','1Y','2Y','UB'])
s_outDF.to_csv('data/student.csv', index=False)
t_outDF.to_csv('data/teacher.csv', index=False)
print 'Initial parse phase done.'