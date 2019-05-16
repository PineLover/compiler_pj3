#
# Makefile for C- language (a.k.a Cminus)
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc

CFLAGS = 

OBJS = main.o util.o lex.yy.o cm.tab.o analyze.o symtab.o

20141599: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -lm -lfl -o 20141599

cm.tab.o: cm.tab.c 
	$(CC) $(CFLAGS) -c cm.tab.c

cm.tab.c :
cm.tab.h : cm.y
	bison -d -v cm.y 

symtab.o : symtab.c symtab.h
	$(CC) $(CFLAGS) -c symtab.c

analyze.o : analyze.c analyze.h globals.h symtab.h
	$(CC) $(CFLAGS) -c analyze.c

main.o: main.c globals.h util.h lex.yy.c analyze.h
	$(CC) $(CFLAGS) -c main.c

util.o: util.c util.h globals.h cm.tab.h
	$(CC) $(CFLAGS) -c util.c
lex.yy.o: lex.yy.c scan.h util.h globals.h
	$(CC) $(CFLAGS) -c lex.yy.c


lex.yy.c: cminus.l
	lex cminus.l
clean:
	-rm 20141599
	-rm $(OBJS)
	-rm lex.yy.c
	-rm cm.output
	-rm cm.tab.c
	-rm cm.tab.h


