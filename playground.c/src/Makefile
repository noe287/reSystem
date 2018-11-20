# vpath %.c src:txt
# VPATH = src

routes: routes.c
	gcc -o ../bin/$@ $^

.PHONY: cleanall cleanobj cleandiff subdirs

cleanall: cleanobj cleandiff
	rm ../bin/routes

#only works when there are an .o and .diff files
# cleanobj:
# 	rm *.o
#
# cleandiff:
# 	rm *.diff
#
