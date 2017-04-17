# OCaT // Oral Comps Assigning Tool
Assigning oral comprehensive exam chairs for Wabash seniors.

## Introduction:
The problem is wellknown to Wabash students. The actual prompt is in the file `prompt.pdf`.

This solver is basically a proof-of-concept - that is why GeCode is used, since it is open-source, and thus denotes that a free solution is available to create. However, if the school decides to use AMPL everytime it needs, be my guest.

## How it works:
`init.py` takes in the two csv files and parse the data out - this serves as a connector to any data container and form. Then, `ampl_gen.py` takes in 2 pandas DataFrame and yield a AMPL script. Finally, use AMPL/AMPLIDE to solve the file - it's a complete BIP problem, not completely linear however.

The `LOGICAL_FLAG` denotes if the script is to create a problem with logical constraints - else, everything is arithmetic. Set `LOGICAL_FLAG = False` - this gives a full arithmetic constraint, and the previous solvers work magically.

## Howto:
<i>Step 0:</i> Manually remove bad data: for example, Allen M. Betts and his unavailability, Jensen A. Kirch his EMU minor (corrected to EDU).

<sub>Note: The department names are truncated to the last 3 characters to deal with MLL faculties - unforeseen side effects might occur if departments are named weirdly. Also, faculties in departments that no current senior is in will be ignored.</sub>

<i>Step 0.5:</i> Install AMPL, with GeCode solver. The directory of AMPL can be changed in `main.sh`, and the replacement for GeCode can be changed in `ampl/mock.prod`.

<i>Step 1:</i> Open Terminal and run `git clone https://github.com/ngoctnq/Oral-Comps-Assigning-Tool.git`. The file is made so that you can run on any Mac at the school and be good to go.

<sub>Note: you have to install Xcode (it will happen automatically), which takes ~2min.</sub>

<i>Step 2:</i> Run the following code

```bash
cd Oral-Comps-Assigning-Tool
./main.sh [path/to/xlsx]
```
<sub>Note: This script, by default, will not use superuser privilege, and thus only install python modules locally for the current user. If this is were to install globally, `sudo` it. If you know how to use `virtualenv`, please fork.</sub>

<i> Step 3:</i>
Voila - It's easy as 1-2-3! Do what you want with the new generated `schedule.csv`.

## Notes
- no verification of constraint satisfaction for `locsol`
- `ipopt` looks nice but treats everything as continuous
- `knitro` took 4 days and no solutions
- `gecode`, `baron`, `bonmin` will be tried later