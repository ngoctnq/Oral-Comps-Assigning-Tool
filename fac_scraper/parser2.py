#!/usr/bin/env python

# load department names
depf = open('dep.txt', 'r')
lines = depf.readlines()
depname = []
depcode = []
for i in range(len(lines)):
    temp=lines[i].split(',')
    depname.append(temp[0])
    depcode.append(temp[1][:-1:])

# trim irrelevant department
dirf = open('dir_e.txt', 'r')
lines = dirf.readlines()
dirf.close
dirf = open('dir.txt', 'w')
dept = ''
for line in lines:
    if ',' not in line:
        dept = line
    else:
        dirf.write(line[:-1:])
        dirf.write(',')
        deplist = '"'
        for i in range(len(depname)):
            if depname[i] in dept:
                deplist += depcode[i]
                deplist += ','
        dirf.write(deplist[:-1:]+'"')
        dirf.write('\n')
dirf.close()

# then some more custom editing