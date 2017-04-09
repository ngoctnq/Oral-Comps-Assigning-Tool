# OCaT // Oral Comps Assigning Tool
Assigning oral comprehensive exam chairs for Wabash seniors

## How it works:
`init.py` takes in the two csv files and parse the data out - this serves as a connector to any data container and form. Then, `ampl_gen.py` takes in 2 pandas DataFrame and yield a AMPL script. Finally, use AMPL/AMPLIDE to solve the file - it's a complete BIP problem, not completely linear however.

## Howto:
<i>Step 0:</i> Open Terminal and run `git clone https://github.com/ngoctnq/Oral-Comps-Assigning-Tool.git`. The file is made so that you can run on any Mac at the school and be good to go.

<sub>Note: you have to install Xcode (it will happen automatically), which takes ~2min.</sub>

<i>Step 0.5:</i> Run the following code

```bash
cd Oral-Comps-Assigning-Tool
./py_install.sh
```

to install <i>pip</i> and module dependencies. If you want to install the dependencies globally, respond "<i>n</i>" at the prompt, and follow instruction.

<i>Step ∞-2:</i> Run `./ampl_gen.py`. This will generate the AMPL script files.

<i>Step ∞-1:</i> Run `cd ampl; [path/to/ampl] mock.run`. This will yield non-human-readable data in the 'output' file.

<sup>Note: I don't think this works lol lemme double check</sup>

<i>Step ∞:</i> Run `./parse_output.py`. This will translated that nonreadable file into human format.

<sup>Note: I will implement this step after I can prove my AMPL code can actually work :(</sup>
