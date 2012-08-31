#!/bin/bash

is_quite=-q

if [ '$1' == '-h' ]
     then
         echo 'Usage: [-v]\n\tMet à jours la version en ligne de javascool'
         exit 1
fi

args=`getopt vm: $*`
set -- $args
for i
do
  case "$i" in
        -v) shift;is_quite=-v;shift;;
  esac
done

# On se place dans Java's Cool
cd `dirname $0`/../

#make pull;
cd javascool-5;
make clean;
sh js/ls2var.sh;
cd ..;
cd javascool-framework;
make clean;
make jar;
cd ..;
cd javascool-proglet-builder;
make clean;
make jar;
sh lib/proglets-update.sh all;
cd ..;
cd javascool-5;
cd proglets;
ls=`find .  -maxdepth 1 -mindepth 1 -type d | sort | sed 's/\.\///' | sed 's/\(.*\)/"\1",/' `
echo "[`echo $ls | sed 's/,$//'`]" > proglets.json
cd ..;
cd ..;
cd javascool-launcher;
make clean;
make jar;
cp javascool-launcher.jar ../javascool.github.com;
cd ..;
cd javascool.github.com/repo/;
mkdir build;
cd build;
cp -r ../../../javascool-5/* .;
find . -name ".*" -exec rm {}\; ;
zip -rq javascool.zip .;
rm ../javascool.zip;
mv javascool.zip ../javascool.zip;
cd ..;
rm -rf build;
echo -e "http://javascool.github.com/repo/javascool.zip\n5.0." ${build_number} > repo.data;
cd ../..;
echo "--------------------------------";
echo "--------------------------------";
echo "            Terminé             ";
echo "--------------------------------";
echo "--------------------------------";
