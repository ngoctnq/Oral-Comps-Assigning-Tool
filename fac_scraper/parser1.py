#!/usr/bin/env python

# trim irrelevant directory
depf = open('dep_o.txt', 'r')
lines = depf.readlines()
depf.close()
depf = open('dep.txt', 'w')
for line in lines:
    if len(line)>2: # a char and new line
        s = line.split('(')
        s[0] = s[0][:-1:]
        s[1] = s[1][:-2:]
        depf.write(s[0])
        depf.write(',')
        depf.write(s[1])
        depf.write('\n')
depf.close()

# trim irrelevant department
dirf = open('dir_o.txt', 'r')
lines = dirf.readlines()
dirf.close
dirf = open('dir_e.txt', 'w')
emeritus = False
for line in lines:
    if ',' not in line:
        # division assistant are excluded
        if line[:-1:] == 'Emeritus' or 'Division' in line[:-1:]:
            emeritus = True
            continue
        else:
            emeritus = False
            dirf.write(line)
    else:
        if emeritus:
            continue
        delimited = line.split('.')
        l = len(delimited)
        i = 0
        while i < l:
            while delimited[i] == '':
                del delimited[i]
                l -= 1
            i += 1
        delimited[-1] = delimited[-1][-1]
        delimited[0] = delimited[0].replace(' ','')
        name = delimited[0].split('(')
        if len(name) > 1:
            name[1] = name[1][:-1:]
            # include only if the prof is on sabbatical in spring
            if name[1] != 'spring':
                continue
        delimited[1] = delimited[1].replace(' ','')
        dirf.write(delimited[1])
        dirf.write(',')
        dirf.write(name[0])
        #dirf.write(',')
        dirf.write(delimited[2]) # newline
dirf.close()

# then some manual fixes here BECAUSE TURNER'S NAME BROKE MY CODE