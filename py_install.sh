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
fi
if not hash pip 2>/dev/null; then
   python -m ensurepip
else
   echo "pip installed"
fi
#python -m pip update
