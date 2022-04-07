#!/bin/sh

faStabilo='\033[7m'
fcRouge='\033[31m'
fcJaune='\033[33;1m'
fcCyan='\033[36m'
fcGreen='\033[32m'

echo $4
set +x

#fullpath=$2
#projet_src="${fullpath##*/}"                      # Strip longest match of */ from start

projet_typ=$2
projet_src=$3
projet_bin=$4
projet_lib=$5


----------------------------------------
# ccontrôle si projet nim
#-------------------------------------------------------------------
if [[ ! "$projet_src" =~ '.cpp' ]]; then
echo -en $faStabilo$fcJaune"$projet_src -->"$faStabilo$fcRouge"ce n'est pas un fichier .nim \033[0;0m\\n"
exit 0
fi


mode=$1





#-------------------------------------------------------------------
# clean
#-------------------------------------------------------------------
if test -f $projet_bin ; then
	rm -f $projet_bin
fi

#-------------------------------------------------------------------
# compile
#-------------------------------------------------------------------

if [ "$mode" == "DEBUG" ] ; then
  if [ "$projet_typ" == "PIE" ] ; then
		( set -x ; \
				make -f ./Makefile PROD=false --trace clean all PGM=$projet_bin \
	)
  fi
fi

# --passL:-Wno-stringop-overflow   or --passC:-fno-builtin-memcpy solution temporaire problème GCC


if [ "$mode" == "PROD" ] ; then
  if [ "$projet_typ" == "PIE" ] ; then
		( set -x ; \
				make -f ./Makefile PROD=true clean all PGM=$projet_bin \
	)
  fi
fi

#-------------------------------------------------------------------
# resultat
#-------------------------------------------------------------------

	echo -en '\033[0;0m'	# video normal
	echo " "
	if test -f "$projet_bin"; then
		echo -en $faStabilo$fcCyan"BUILD "$mode"\033[0;0m  "$fcJaune$projet_src"->\033[0;0m  "$fcGreen $projet_bin "\033[0;0m"
		echo -en "  size : "
		ls -lrtsh $projet_bin | cut -d " " -f6
	fi
exit
