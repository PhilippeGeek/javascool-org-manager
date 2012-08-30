#!/bin/bash

DEPOTS=$($PWD/*/.git|grep $PWD|sed 's/'$(echo $PWD|sed 's/\//\\\//g')'\///g'|sed 's/\/.git://g')

is_quite=-q

for arg in $@
do
	if [ $arg == -v ] 
	then 
		is_quite=-v
	fi
done

args=`getopt vm: $*`
if test $? != 0
     then
         echo 'Usage: [push|pull] [-v] [-m COMMIT_MESSAGE]'
         exit 1
fi
commit_message="Sans message de commit"
set -- $args
for i
do
  case "$i" in
	"push"|"pull"|"addAll") git_command=$i;;
        -v) shift;is_quite=-v;shift;;
        -m) shift;commit_message=$@;shift;;
  esac
done

for dep in . $DEPOTS
do
	if [ $dep != '.' ] ; then pushd $dep > /dev/null ; fi
	case "$git_command" in
		"pull") 
			echo "Pull de" $dep;
			git pull $is_quite||echo "Conflit à régler dans" $dep;;
		"push")
			echo "Push de" $dep;
			git commit -a -m "$commit_message"; git push $is_quite;;
		*)
			echo "Rien a faire pour" $dep;
	esac
	if [ $dep != '.' ] ; then popd > /dev/null ; fi
done
