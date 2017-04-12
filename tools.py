#!/usr/bin/env python2
'''
Set of functions to import.
'''

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

def get_depts():
    '''
    Get the list of departments.
    '''
    pass