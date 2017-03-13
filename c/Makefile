#make -f ser.make 
#make -f ser.make clean
CFLAGS=-g -Wall
ser.out: main.o header_linux.o #get_sCmd_read.o
	g++ -o ser.out main.o header_linux.o #get_sCmd_read.o
main.o: main.cpp header_linux.h #get_sCmd_read.h
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
	g++ -c -Wall -Wextra -Wformat -ansi -pedantic  -funsigned-char main.cpp
header_linux.o: header_linux.cpp header_linux.h
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
	g++ -c -Wall -ansi -pedantic -funsigned-char header_linux.cpp
#get_sCmd_read.o: get_sCmd_read.cpp get_sCmd_read.h
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
#	g++ -c -Wall -ansi -pedantic -funsigned-char get_sCmd_read.cpp
clean:
	rm *.o ser.out
