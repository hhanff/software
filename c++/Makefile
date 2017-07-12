CFLAGS=-g -Wall -Wextra -Wformat -ansi -pedantic -funsigned-char
ser.out: openSimpati_client.o 
	g++ $(CFLAGS) -o openSimpati_client openSimpati_client.o
main.o: main.cpp header_linux.h #get_sCmd_read.h
# -ansi -pedantic: strict ansi conform 
# -funsigned-char: declares character S as unsigned. 
	g++ -c -Wall -Wextra -Wformat -ansi -pedantic  -funsigned-char openSimpati_client.cpp
clean:
	rm *.o openSimpati_client
