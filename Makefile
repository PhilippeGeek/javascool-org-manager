######################################################################################################################

######################################
###    TABLEAU DE BORD DE JVS5
######################################

######## les News de vthierry à philou : ########

# La vie est belle en java7 : 
## mon problème "firefox" est soldé si je "force" l'usage du plugin java-oracle-7 . . donc à spécifier dans la doc
## les javascool-framework/lib/javac.jar javascool-proglet-builder/lib/javadoc.jar 
### . . sont désormais construites à partir de java7 et ca devient clean
## ProgletBuilder est adapté pour gérer le format de javadoc7
## La javadoc est désormais générée avec ce que nous avons fait au niveau du ProgletBuilder
### Mais le style, du coup, est à revoir ensemble . . 

# ProgletApplet est prêt :
## J'ai créé les macros de wrapping sur les panel dans javascool-framework/src/org/javascool/macros/Pane.java 
### qui nous libère des liens avec les éléments du gui de jvs4

# ProgletBuilder me semble prêt aussi, modulo les notes de ce makefile

# Une variable $P12_PASS a été ajoutée au mécanisme de . . et non, Philippe, on ne prononce pas le 'd' à la fin de «connard». 

# http://javascool.github.com/javascool-framework/doc/org/javascool/core/JarManager.html 
## a désormais une méthode downloadFile() pour gérer les téléchargements

######## nouveaux Questionnnements de vthierry à philou : ########

# A mon avis javascool-framework/out est à virer ; javascool-framework/index.html qui semble etre un doc du Polyfile a deplacer . . 

# Les lignes import javax.swing.*;import java.awt.*; ont été ajoutées à toutes les classes . . 
## A disgnistiquer puis je virerai avec sedgrep

# Lors de tes copies des classes org.javascool.macros.*; tu as viré des portions et commentées d'autres : 
## à voir ensemble avce des @todo là où il y a des pbs.

# Est-ce que javascool-framework/lib/jarsigner.jar sert à qq chose ?

# Comment encapsuler http://javascool.github.com/javascool-framework/doc/overview-summary.html 
## dans bootstatrp maintenant qu'on a les éléments en place
## Par exemple comme http://javascool.github.com/javascool-5/doc

# Ca marche sous windows ton interface ?

# Bon on se fait http://javascool.github.com/doc/framework/index.html ?

# Comment compléter http://javascool.github.com/doc/developper/index.html finalement ?

######## anciens Questionnnements de vthierry à philou : ########

# Comment générer le panneau de choix des proglets dont la liste est dans wproglets/*/ 
##à partir du listDirectory de PolyFileWriter.

## A bien piger : où se trouve les pages des proglets sur le WEB du coup.

# Quid de la proposition de répertoires locaux ./{win32,i686,amd64,macos} dans les proglets ?
## NB : Les librairies ne sont pas les mêmes sous mac et linux, donc à ajouter
## Comment implementer ca . .?

# A propos du mécanisme de complétion, 
## à implémenter http://javascool.github.com/doc/developper/completion-json.html est ok ?

# On pourrait avoir une applet signée dans une WebPage pour le javascool-builder

######## Travail à faire pour vthierry : ########

# Ajouter les styles des sections du help.html avec des titres

# Retravailler la conversion des liens vers http://javascool.gforge.inria.fr ou des liens de types ../<auterproglet>

######################################################################################################################

######################################################################################################################
# Ici sont qq commandes (à vthierry, et les autres ?) pour le développement/test
######################################################################################################################

ifeq ($(USER),vthierry)
GIT_COMMIT_MESSAGE ?= Mise à jour depuis le Makefile
now : tst3
endif

# test de Java'sCool 5

run :
	cd javascool-5 ; make fweb

# test du ProgletApplet

tst0 : 
	$(MAKE) -C javascool-framework jar
	export PATH="/usr/java/default/bin:$$PATH" ; java -cp javascool-framework/javascool.jar org.javascool.core.ProgletApplet "un test" "kk-applet"

# test du ProgletBuilder

prun = java -cp ./javascool-proglet-builder/javascool-proglet-builder.jar ProgletBuilder

tst1 : 
	$(MAKE) -C javascool-proglet-builder jar
	export PATH="/usr/java/default/bin:$$PATH"  ; d="`pwd`/proglet-codagePixels" ; ${prun} compile $$d ; firefox $$d/applet/index.html
#	export PATH="/usr/java/default/bin:$$PATH"  ; d="/tmp/proglet-sample" ; rm -rf $$d ; ${prun} create $$d ; ${prun} compile $$d ; firefox $$d/applet/index.html
#	export PATH="/usr/java/default/bin:$$PATH"  ; ${prun}

tst2 :
	$(MAKE) -C javascool-proglet-builder jar
	./javascool-proglet-builder/lib/proglets-update.sh $GH_USER:$GH_PASS compile

# test de la javadoc

tst3 :
	$(MAKE) -C javascool-proglet-builder jar ; rm -rf javascool-framework/doc ; $(MAKE) -C javascool-framework doc

######################################################################################################################
# Gestion des dépots de javascool 
######################################################################################################################

git_repos = javascool-5 javascool-framework javascool-proglet-builder javascool.github.com # web-documents

pull :
	echo "pull makefile" ; git pull -q
	for f in $(git_repos) ; do echo "pull $$f" ; cd $$f ; git pull -q ; cd .. ; done

ppull :
	./javascool-proglet-builder/lib/proglets-update.sh $GH_USER:$GH_PASS pull

GIT_COMMIT_MESSAGE ?= committed from makefile

push :
	echo "push makefile" ; git commit -a -m '$(GIT_COMMIT_MESSAGE)' ; git push -q 
	for f in $(git_repos) ; do echo "push $$f" ; cd $$f ; git commit -a -m '$(GIT_COMMIT_MESSAGE)' ; git pull -q ; git push -q ; cd .. ; done

ppush :
	./javascool-proglet-builder/lib/proglets-update.sh $GH_USER:$GH_PASS push

clean :
	/bin/rm -rf {javascool-framework,javascool-proglet-builder}/doc `find . -name '*~'`
	echo jvs5 ; git status -s ; for f in $(git_repos) proglet-* ; do cd $$f ; s="`git status -s`" ; if [ \! -z "$$s" ] ; then echo $$f ; echo $$s ; fi ; cd .. ; done

install :
	echo "Commandes à ne lancer qu'une seule fois à l'install !"
	echo 'git clone git@gist.github.com:3292843.git ; mv 3292843/{.git,makefile} . ; rmdir 3292843'
	echo 'for f in $(depots) ; do git clone git@github.com:javascool/$$f.git ; done'

######################################################################################################################
