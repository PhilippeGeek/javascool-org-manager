#!/bin/bash

DEPOTS=$(ls $PWD/*/.git|grep $PWD|sed 's/'$(echo $PWD|sed 's/\//\\\//g')'\///g'|sed 's/\/.git://g')

function usage(){
         echo 'Usage: [-a push|pull] [-m COMMIT_MESSAGE]';
         exit 1
}

is_quite="";
git_command=pull;
git_message="Commit de $USER sans message"

while getopts  "qva:m:" flag
do
  case $flag in
		a) git_command=$OPTARG;;
		m) git_message=$OPTARG;;
		q) is_quite=" -q ";;
		v) is_quite=" -v ";;
		:) usage;;
		\?) usage;;
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
			git commit -a -m "$git_message"; git push $is_quite;;
		*)
			usage;
	esac
	if [ $dep != '.' ] ; then popd > /dev/null ; fi
done
