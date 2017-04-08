#!/usr/bin/env python
'''
Initialize data, either bridging from Wabash's database or input file.
'''
import pandas as pd

def import_data(s):
    '''
    Import data from given files, like csv from mock_data folder.
    '''
    # open student file
    s_csv = pd.read_csv(s + '/student.csv')
    t_csv = pd.read_csv(s + '/teacher.csv')
    return s_csv, t_csv
