#!/usr/bin/env python
'''
Initialize data, either bridging from Wabash's database or input file.
'''
import pandas as pd

def import_data():
    # open student file
    s_csv = pd.read_csv('mock_data/student.csv')
    t_csv = pd.read_csv('mock_data/teacher.csv')
    return s_csv, t_csv