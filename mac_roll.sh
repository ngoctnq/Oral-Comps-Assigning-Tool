CODE_DIR="/Users/ngoc/Documents/code/"
# go to the actual directory
cd $CODE_DIR"Oral-Comps-Assigning-Tool"

# create initial csv
python init.py "$1"

# generate the ampl script
python ampl_gen.py "$1"

# run ampl
cd ampl
cp mock.* $CODE_DIR"amplide.macosx64"
cd $CODE_DIR"amplide.macosx64"
./ampl mock.prod
cp *_data $CODE_DIR"Oral-Comps-Assigning-Tool/data"
cd $CODE_DIR"Oral-Comps-Assigning-Tool"

# parse the output out
python parse_output.py "$1"