line="Endicott, Rochella ....................... ENDICOTR........... 6273\n"
delimited = line.split('.')
print delimited
l = len(delimited)
i = 0
while i < l:
    while delimited[i] == '':
        del delimited[i]
        l -= 1
    i += 1
delimited[-1] = delimited[-1][-1]
print delimited