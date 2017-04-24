#!/usr/bin/env python2
'''
Set of functions to import.
'''
import pandas as pd

def get_date_and_time(path):
    valid = pd.read_excel(path, "Validations")
    date_list = ['','','']
    session_list = ['','','','','','','']
    # usernames and actual name are pulled from the processed csv
    for i in range(3):
        date_list[i] = valid.get_value(i, 'Comp Dates')
    for i in range(7):
        session_list[i] = valid.get_value(i, 'Time Slots')
    return date_list, session_list

def import_data():
    '''
    Import data from given files, like csv from mock_data folder.
    '''
    # open student file
    s_csv = pd.read_csv('data/student.csv')
    t_csv = pd.read_csv('data/teacher.csv')

    return s_csv, t_csv

def newline(f):
    '''
    Take a opened file stream and write a newline.
    '''
    f.write('\n')

def get_div(path, path2):
    '''
    Get the list of departments and faculties of divisions.
    '''
    dept_list = get_depts(path)
    div_dept = [[],[],[]]
    div_prof = [[],[],[]]
    dept_dat = pd.read_excel(path2, "dept")
    prof_dat = pd.read_excel(path2, "prof")
    t_csv = pd.read_csv('data/teacher.csv')

    temp = dept_dat.loc[dept_dat['Division I'].notnull(), 'Division I'].values
    for i in temp:
        if i in dept_list:
            div_dept[0].append(dept_list.index(i))
    temp = dept_dat.loc[dept_dat['Division II'].notnull(), 'Division II'].values
    for i in temp:
        if i in dept_list:
            div_dept[1].append(dept_list.index(i))
    temp = dept_dat.loc[dept_dat['Division III'].notnull(), 'Division III'].values
    for i in temp:
        if i in dept_list:
            div_dept[2].append(dept_list.index(i))

    temp = prof_dat.loc[prof_dat['Division I'].notnull(), 'Division I'].values
    for i in temp:
        div_prof[0].append(t_csv.loc[t_csv['SID'] == i, 'ID'].values[0])
    temp = prof_dat.loc[prof_dat['Division II'].notnull(), 'Division II'].values
    for i in temp:
        div_prof[1].append(t_csv.loc[t_csv['SID'] == i, 'ID'].values[0])
    temp = prof_dat.loc[prof_dat['Division III'].notnull(), 'Division III'].values
    for i in temp:
        div_prof[2].append(t_csv.loc[t_csv['SID'] == i, 'ID'].values[0])

    return div_dept, div_prof

def get_depts(path):    
    '''
    Get the list of departments.
    '''
    depts = []
    stud = pd.read_excel(path, "Student Data")
    s_count = len(stud)
    for i in range(s_count):
        dept_data = stud.get_value(i, "Major 1")
        if type(dept_data) == type(u'')  and dept_data not in depts:
            depts.append(dept_data)
        dept_data = stud.get_value(i, "Major 2")
        if type(dept_data) == type(u'')  and dept_data not in depts:
            depts.append(dept_data)
        dept_data = stud.get_value(i, "Major 3")
        if type(dept_data) == type(u'')  and dept_data not in depts:
            depts.append(dept_data)
        dept_data = stud.get_value(i, "Minor 1")
        if type(dept_data) == type(u'')  and dept_data not in depts:
            depts.append(dept_data)
        dept_data = stud.get_value(i, "Minor 2")
        if type(dept_data) == type(u'')  and dept_data not in depts:
            depts.append(dept_data)
        dept_data = stud.get_value(i, "Minor 3")
        if type(dept_data) == type(u'')  and dept_data not in depts:
            depts.append(dept_data)
    return depts

def three_depted(major_list, div_dept):
    '''
    Check if three majors of the student is in 3 different departments.
    Assume the student has exactly 3 majors. If some majors are not in the list,
        be safe and assume the worst case and return True.
    '''
    mj = [-1, -1, -1]
    for i in range(3):
        for j in range(3):
            if int(major_list[i]) in div_dept[j]:
                mj[i] = j
                break
    return (-1 in mj) or (0 in mj) and (1 in mj) and (2 in mj)