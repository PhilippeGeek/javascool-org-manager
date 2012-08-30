#!/bin/sh

# installJavascoolDevspace.sh
# 
#: Usage:
#:     ./installJavascoolDevspace.sh DOSSIER_RACINE_POUR_LE_JAVASCOOL_DEVSPACE
#     options :
#          --read-only  Clone les dépots en lecture seul
#          --clone-webdocs [Java's Cool seulement] Ajoute le dépot web-documents au clone


original_directory=$PWD;

if [ -z "$1" ]; then
	cat $0|grep '^#:'|sed 's/#://';
	exit 0;
fi

if [ -e "$1" ]; then
	echo $1 ' existe déjà, attention aux erreurs';
	#exit 1;
fi

if [ -z "$(which git)" ]; then
	echo "Vous n'avez pas installé git. Il est necessaire dans ce script";
	exit 1;
fi

mkdir -p $1;

cd $1; # On entre dans le dossier racine

GH_API="https://api.github.com"

GITCMD="git clone -q "
#if [ "$2" == "--read-only" ]; then
	#GITCMD="git clone -q --mirror git://github.com/"
#fi

# crudely get list of repositories in the organisation
echo "On liste les dépot à prendre"
REPOLIST=`curl -silent $GH_API/orgs/javascool/repos | grep \"name\" | awk -F': "' '{print $2}' | sed -e 's/",//g'`

# for each repository, backit and forks up
for REPO in $REPOLIST; do
	
	if [ ! -e $REPO ];then
		#if [ $REPO != "web-documents" ]; then
		   echo "Clonnage de javascool/${REPO}"
		   ${GITCMD} git@github.com:javascool/${REPO}.git > /dev/null &> /dev/null
		#else
		#   echo $REPO " n'as pas été cloné car il est trop volumineux"
		#fi
	else
		echo "$REPO est déjà cloné"
	fi

done

if [ "$(ls)" == "" ]; then
	echo "Aucun dépot cloné, il y a du avoir un bug.";
	cd $original_directory; rm -r $1;
	exit 2;
fi

if [ ! -e .git ];then
	echo "Clonnage de PhilippeGeek/javascool-org-manager"
	${GITCMD} git@github.com:PhilippeGeek/javascool-org-manager.git javascool-org-manager-$$ > /dev/null &> /dev/null
	oldPWD=$PWD;cd javascool-org-manager-$$;
	cp -r $(ls -A .) $oldPWD;
	cd $oldPWD;
	rm -rf javascool-org-manager-$$;
else
	echo "Le Makefile de gestion général est déjà cloné"
fi

cd $original_directory; # On a finit, retour à la maison
