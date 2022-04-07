#!/bin/bash

faStabilo='\033[7m'
fcRouge='\033[31m'
fcJaune='\033[33;1m'
fcCyan='\033[36m'
fcGreen='\033[32m'


#-------------------------------------------------------------------
# ccontrôle si projet nim
#-------------------------------------------------------------------
if [[ ! "$2" =~ '.ui' ]]; then
echo -en $faStabilo$fcJaune"$2 -->"$faStabilo$fcRouge"ce n'est pas un fichier .ui \033[0;0m\\n"
exit 0 
fi

dir_ui=$1
glade_ui=$2
glade_inc=${projet_src%.*}.inc


#-------------------------------------------------------------------
# clean
#-------------------------------------------------------------------
if test -f $glade_inc ; then
	rm -f $glade_inc
fi

	/home/soleil/T_LIB/srcbuildnim  -p  $dir_ui/ -f  $glade_ui
#-------------------------------------------------------------------
# resultat
#-------------------------------------------------------------------

	echo -en '\033[0;0m'	# video normal
	echo " "
	if test -f "$glade_inc"; then
		echo -en $faStabilo$fcCyan"CONV "$mode"\033[0;0m  "$fcJaun$glade_ui"->\033[0;0m  "$fcGreen $glade_inc "\033[0;0m"
	else
		echo -en $faStabilo$fcCyan"BUILD "$mode"\033[0;0m  "$fcJaune$glade_ui"->\033[0;0m  "$faStabilo$fcRouge"not conv\033[0;0m\n"
	fi
	echo " "

exit
