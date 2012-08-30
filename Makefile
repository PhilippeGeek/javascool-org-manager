#############################################################################################################

######################################
###    TABLEAU DE BORD DE JVS5
######################################

######## nouveaux Questionnnements de vthierry à philou : ########

#- Ajoute d´extension jvs

#- Implémentation du focus sur la console qd on compile

#- Mettre en place le reformatage de code à code mirror

#- ProgletApplet merde joyeusement


######## nouveaux Questionnnements de vthierry à philou : ########

# Comment encapsuler http://javascool.github.com/javascool-framework/doc/overview-summary.html 
## La javadoc est désormais générée avec ce que nous avons fait au niveau du ProgletBuilder
### Mais le style, du coup, est à revoir ensemble . . 

# Ca marche sous windows ton interface ?

# Bon on se fait http://javascool.github.com/doc/framework/index.html ?
# Comment compléter http://javascool.github.com/doc/developper/index.html finalement ?

######## anciens Questionnnements de vthierry à philou : ########

# Quid de la proposition de répertoires locaux ./{win32,i686,amd64,macos} dans les proglets ?
## NB : Les librairies ne sont pas les mêmes sous mac et linux, donc à ajouter
## Comment implementer ca . .?

# A propos du mécanisme de complétion, 
## à implémenter http://javascool.github.com/doc/developper/completion-json.html est ok ?

######## Travail à faire pour vthierry : ########

# Docs des proglets
## Ajouter les styles des sections du help.html avec des titres
## Retravailler la conversion des liens vers http://javascool.gforge.inria.fr ou des liens de types ../<autreproglet>

######################################################################################################################

######################################################################################################################
# Ici sont qq commandes pour le développement/test
######################################################################################################################

ifeq ($(USER),vthierry)
now : tst1
endif

# test de Java'sCool 5

run :
	cd javascool-5 ; make fweb

# test du ProgletBuilder

prun = java -cp ./javascool-proglet-builder/javascool-proglet-builder.jar ProgletBuilder

tst1 : 
	$(MAKE) -C javascool-proglet-builder jar
#	export PATH="/usr/java/default/bin:$$PATH"  ; d="`pwd`/proglet-codagePixels" ; ${prun} compile $$d ; cd $$d/applet ; java -cp .:./javascool.jar org.javascool.core.ProgletApplet org.javascool.proglets.codagePixels.Panel
	export PATH="/usr/java/default/bin:$$PATH"  ; d="`pwd`/proglet-codagePixels" ; ${prun} compile $$d ; firefox $$d/applet/index.html
#	export PATH="/usr/java/default/bin:$$PATH"  ; d="/tmp/proglet-sample" ; rm -rf $$d ; ${prun} create $$d ; ${prun} compile $$d ; firefox $$d/applet/index.html
#	export PATH="/usr/java/default/bin:$$PATH"  ; ${prun}
#	export PATH="/usr/java/default/bin:$$PATH"  ; ./javascool-proglet-builder/lib/proglets-update.sh $GH_USER:$GH_PASS compile
	cd proglet-codagePixels ; git commit -a -m 'test' ; git push -q ; rm applet/javascool.jar

# test de la javadoc

tst2 :
	$(MAKE) -C javascool-proglet-builder jar ; rm -rf javascool-framework/doc ; $(MAKE) -C javascool-framework doc

# test du ProgletApplet

tst3 : 
	$(MAKE) -C javascool-framework jar
	export PATH="/usr/java/default/bin:$$PATH" ; java -cp javascool-framework/javascool.jar org.javascool.core.ProgletApplet "un test" "kk-applet"

# Gestion des proglets

tst4 :
	$(MAKE) -C javascool-proglet-builder jar
	export PATH="/usr/java/default/bin:$$PATH"  ; ./javascool-proglet-builder/lib/proglets-update.sh $GH_USER:$GH_PASS compile


######################################################################################################################
# Gestion des dépots de javascool 
######################################################################################################################

pull :
	.javascool-scripts/git.sh pull

push :
	.javascool-scripts/git.sh push -m "Mise à jour depuis le Makefile"

clean :
	/bin/rm -rf {javascool-framework,javascool-proglet-builder}/doc javascool-framework/javascool.jar javascool-proglet-builder/javascool-proglet-builder.jar `find . -name '*~'`
	echo jvs5 ; git status -s ; for f in web-documents javascool.github.com javascool-* proglet-* ; do cd $$f ; s="`git status -s`" ; if [ \! -z "$$s" ] ; then echo $$f ; echo $$s ; fi ; cd .. ; done

install :
	.javascool-scripts/install.sh
#	i.e. : https://github.com/PhilippeGeek/javascool-org-manager/blob/master/.javascool-scripts/install.sh

######################################################################################################################
