#!/bin/sh

faStabilo='\033[7m'
fcRouge='\033[31m'
fcJaune='\033[33;1m'
fcCyan='\033[36m'
fcGreen='\033[32m'

set +x

#fullpath=$2
#projet_src="${fullpath##*/}"                      # Strip longest match of */ from start

projet_typ=$2
projet_src=$3
projet_lib=$4

#-------------------------------------------------------------------
# ccontrôle si projet nim
#-------------------------------------------------------------------
if [[ ! "$projet_src" =~ '.nim' ]]; then
echo -en $faStabilo$fcJaune"$projet_src -->"$faStabilo$fcRouge"ce n'est pas un fichier .nim \033[0;0m\\n"
exit 0
fi


mode=$1



projet_bin=${projet_src%.*}



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
				nim c -f --gc:orc -d:forceGtk --debugger:native \
			-d:useMalloc  --panics:on \
			--verbosity:1 \
			--warning[UnusedImport]:on --hint[Performance]:off --warning[Deprecated]:on --warning[EachIdentIsTuple]:on \
			--threads:on \
			--passL:-no-pie --app:GUI  \
			--passL:-lX11 \
			--passL:-lstdc++ \
			-o:$projet_bin   $projet_lib/$projet_src ; \
	)
  else
	( set -x ; \
				nim  c  -f --gc:orc -d:useMalloc  --panics:on \
			--debugger:native \
			--verbosity:1 \
			--warning[UnusedImport]:on --hint[Performance]:off  --warning[Deprecated]:on --warning[EachIdentIsTuple]:on \
			--threads:on \
			--passL:-lX11 \
			--passL:-lstdc++ \
			-o:$projet_bin   $projet_lib/$projet_src ; \
	)
  fi
fi

# --passL:-Wno-stringop-overflow   or --passC:-fno-builtin-memcpy solution temporaire problème GCC


if [ "$mode" == "PROD" ] ; then
  if [ "$projet_typ" == "PIE" ] ; then
		( set -x ; \
				nim  c -f --gc:orc -d:forceGtk -d:useMalloc \
			--passc:-flto --passC:-fno-builtin-memcpy \
			--verbosity:0 --hints:off  \
			--threads:on  --app:GUI  \
			--passL:-no-pie -d:release \
			-o:$projet_bin   $projet_lib/$projet_src ; \
	)
  else
		( set -x ; \
			  nim  c -f --gc:orc -d:useMalloc \
			--passc:-flto --passC:-fno-builtin-memcpy \
			--verbosity:0 --hints:off  \
			--threads:on \
			 -d:release  \
			-o:$projet_bin   $projet_lib/$projet_src ; \
	)
  fi
fi

if [ "$mode" == "TEST" ] ; then
	( set -x ; \
				nim  c -f --gc:orc  -d:useMalloc  --warning[Deprecated]:off \
			--hint[Performance]:off  --warning[Deprecated]:on --warning[EachIdentIsTuple]:on \
			--threads:on \
			--passL:-no-pie \
     	--passL:-lrt \
			-o:$projet_bin   $projet_lib/$projet_src ; \
	)
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
