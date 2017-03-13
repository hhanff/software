CFLAGS=-g -Wall
qwest: main.o
	gcc main.o -o qwest -lm
# -lm for math library
main.o: main.c
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
	gcc -c -Wall -Wno-multichar -ansi -pedantic -funsigned-char main.c
clean:
	rm *.o qwest
