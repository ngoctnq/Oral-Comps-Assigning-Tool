# OCaT // Oral Comps Assigning Tool
Assigning oral comprehensive exam chairs for Wabash seniors.

## Introduction:
The problem is wellknown to Wabash students. The actual prompt is in the file `prompt.pdf`.

This solver is basically a proof-of-concept - that is why CPLEX/Gurobi is used for a considerable boost in speed; CBC is recommended, since it is open-source, and thus denotes that a free solution is available to create. However, if the school decides to use AMPL everytime it needs, be my guest.

## How it works:
`init.py` takes in the two csv files and parse the data out - this serves as a connector to any data container and form. Then, `ampl_gen.py` takes in 2 pandas DataFrame and yield a AMPL script. Then, use AMPL/AMPLIDE to solve the file. Finally, run `parse_output.py`. Each of the python script takes an optional parameter that is the location of the Excel spreadsheet to be supplied by the school - by default it is set to '2016.xlsx.'

This is a completely linear BIP problem, after turning quadratic/cubic constraints into weighted linear ones. The objective function is to minimize sum of squares, but since it is too slow for this project, I decided to minimize sum of absolute values (norm-1 instead of norm-2).

## Howto:
<b>Step 0:</b>
Manually remove bad data: for example, Allen M. Betts and his unavailability, Jensen A. Kirch his EMU minor (corrected to EDU). Manually add data: list of departments division-wise, and list of faculties' IDs division-wise, in the format of `academic_divisions.xlsx`.

<sub>Note: The department names are truncated to the last 3 characters to deal with MLL faculties - unforeseen side effects might occur if departments are named weirdly. Also, faculties in departments that no current senior is in will be ignored.</sub>

<b>Step 0.5:</b>
Install AMPL, with CBC solver if you somehow don't like super-fast but propriety solvers.

<b>Step 1:</b>
Open Terminal and run `git clone https://github.com/ngoctnq/Oral-Comps-Assigning-Tool.git`. The file is made so that you can run on any Mac at the school and be good to go.

<sub>Note: you have to install Xcode (it will happen automatically), which takes ~2min.</sub>

<b>Step 2:</b>
Run the following code

```bash
cd Oral-Comps-Assigning-Tool
bash ensure_python.sh
```
<sub>Note: This script, by default, will not use superuser privilege, and thus only install python modules locally for the current user. If this is were to install globally, `sudo` it. If you know how to use `virtualenv`, this project uses Python 2, and all the modules this needs are `pandas` and `xlrd`.</sub>

<b>Step 3:</b>
Run `init.py`, `ampl_gen.py`, then `ampl` with `mock.mod` and `mock.dat`, and finally `parse_output.py`. Run AMPL with CPLEX (or Gurobi, or CBC), or just use `cplex.run` or `gurobi.run`. All the parameters are optional, and the python calls are:

```bash
python2 init.py [/path/to/ppl/data='2016.xlsx']
python2 ampl_gen.py [/path/to/ppl/data='2016.xlsx'] [/path/to/div/data='divisions.xlsx']
python2 parse_output.py [/path/to/ppl/data='2016.xlsx']
```

<sub>Consult `main.sh` for a short example - it is a retired script that does not work because I don't know how to use `bash`.</sub>

<b>Step 4:</b>
Voila - It's easy as 1-2-3(-4?)! Do what you want with the new generated `schedule.csv`.

## Notes
- Anything other than CPLEX or Gurobi will be too slow for this.
- CPLEX linearizes quadratic objective, triggering a bug or such that says there are no feasible solutions - necessary flags are needed to prevent this. See this for more info: https://groups.google.com/forum/#!topic/ampl/YO65Sr0rwL4
