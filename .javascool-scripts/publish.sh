#!/bin/bash

function pause {
  local dummy;
  read -s -r -p "Appuyer sur une touche pour continuer (ctrl-c pour annuler) ..." -n 1 dummy;
}

MASTERVERSIONTIME=1346401940; # à changer à chaque grosse nouvelle version
TIME=`date +"%s"`;
DIFFTIME=$((${TIME} - ${MASTERVERSIONTIME}));
VERSION="5.0.$((${DIFFTIME}/86400)).$(($DIFFTIME%86400))";
clear;
echo "Bienvenu dans le script de publication de Java's Cool";
echo "Il est prêt à propager la version $VERSION";
echo "Êtes-vous sûr que cette version fonctionne ?"
pause;
echo "";

# On se place dans Java's Cool
cd `dirname $0`/../

cd javascool.github.com/repo/;
mkdir build;
cd build;
cp -r ../../../javascool-5/* .;
zip -rq javascool.zip .;
rm ../javascool.zip;
mv javascool.zip ../javascool.zip;
cd ..;
rm -rf build;
echo "`echo "http://javascool.github.com/repo/javascool.zip"; echo $VERSION`" > repo.data;
cd ..;
git commit -a -m "Publication de la version $VERSION";git push;
cd ..;
clear;
echo "--------------------------------";
echo "--------------------------------";
echo "             Publié             ";
echo "--------------------------------";
echo "--------------------------------";
