#!/usr/bin/env python
'''
Initialize data, either bridging from Wabash's database or input file.
'''
import pandas as pd

def import_data(s = 'data'):
    '''
    Import data from given files, like csv from mock_data folder.
    '''
    # open student file
    s_csv = pd.read_csv(s + '/student.csv')
    t_csv = pd.read_csv(s + '/teacher.csv')

    return s_csv, t_csv

depts = []

# do imports here
# initialize output file for parse_output.py
# write it directly to student/teacher.csv
    # st = students DataFrame
    # ID, SID, Mj, Mn
    # ts = teachers DataFrame
    # ID, SID, DP, 1Y, 2Y
# TODO WRITE THINGS TO CSV