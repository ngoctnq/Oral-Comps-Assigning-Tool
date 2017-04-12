#!/usr/bin/env python2
'''
Set of functions to import.
'''
import pandas as pd

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

def get_depts(path='2016.xlsx'):
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