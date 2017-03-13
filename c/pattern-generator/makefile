#make -f ser.make 
#make -f ser.make clean
CFLAGS=-g -Wall
gen_pat: main.o
	gcc main.o -o gen_pat
main.o: main.c
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
	gcc -c -Wall -ansi -pedantic  -funsigned-char main.c
clean:
	rm *.o gen_pat