# OCaT // Oral Comps Assigning Tool
Assigning oral comprehensive exam chairs for Wabash seniors

## Introduction:
The problem is wellknown to Wabash students. The actual prompt is in the file `prompt.pdf`.

This solver is basically a proof-of-concept - that is why GeCode is used, since it is open-source, and thus denotes that a free solution is available to create. However, if the school decides to use AMPL everytime it needs, be my guest.

## How it works:
`init.py` takes in the two csv files and parse the data out - this serves as a connector to any data container and form. Then, `ampl_gen.py` takes in 2 pandas DataFrame and yield a AMPL script. Finally, use AMPL/AMPLIDE to solve the file - it's a complete BIP problem, not completely linear however.

The `LOGICAL_FLAG` denotes if the script is to create a problem with logical constraints - else, everything is arithmetic. Set `LOGICAL_FLAG = False` - this gives a full arithmetic constraint, and the previous solvers work magically.

## Howto:
<i>Step 0:</i> Open Terminal and run `git clone https://github.com/ngoctnq/Oral-Comps-Assigning-Tool.git`. The file is made so that you can run on any Mac at the school and be good to go.

<sub>Note: you have to install Xcode (it will happen automatically), which takes ~2min.</sub>

<i> Step 0.5:</i> Install AMPL, with GeCode solver. The directory of AMPL can be changed in `main.sh`, and the replacement for GeCode can be changed in `ampl/mock.prod`.

<i>Step 1:</i> Run the following code

```bash
cd Oral-Comps-Assigning-Tool
./main.sh
```
<sub>Note: This script, by default, will not use superuser privilege, and thus only install python modules locally for the current user. If this is were to install globally, `sudo` it. If you know how to use virtualenv, please fork.</sub>

<i> Step 2:</i>
Voila. Do what you want with the new generated `schedule.csv`.

## Known unhandled problems/edge cases
- Does NOT work if someone has MORE than 3 majors.