# constant of directory
LOC=""
CHC=""
if [[ $UID != 0 ]]; then
   echo "Right now you are in userland. You can rerun this with admin privilege to install package systemwide."
   printf "Proceed? (Y/N) "
   read CHC
   if [[ $CHC == "Y" || $CHC == "y" ]]; then
      LOC=" --user"
   elif [[ $CHC == "N" || $CHC == "n" ]]; then
      printf "Please run this instead: "
      echo "sudo $0 $*"
      exit 1
   else
      echo "Invalid response received, quitting..."
      exit 1
   fi
else
   sudo echo "testing sudo..."
fi
if not hash pip 2>/dev/null; then
   echo "pip installed"
else
   python -m ensurepip $LOC
fi
python -m pip install -U pip $LOC

# installing NumPy and SciPy
# python -m pip install numpy $LOC
# NumPy is a dependency of SciPy, so no need to uncomment the above
# python -m pip install scipy $LOC

# for DataFrame manipulation
python -m pip install pandas $LOC
python -m pip install xlrd $LOC