#make -f ser.make 
#make -f ser.make clean
CFLAGS=-g -Wall
lotto: main.o
	gcc main.o -o lotto -lm
# -lm for math library
main.o: main.c
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
	gcc -c -Wall -Wno-multichar -ansi -pedantic -funsigned-char main.c
clean:
	rm *.o lotto