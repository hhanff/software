/*
  A simple client in the internet domain using TCP
  The port number and IP address is passed as an argument

  > g++ -Wall openSimpati_client.cpp -o openSimpati_client
  > sudo ./openSimpati_client 127.0.0.1 2080

  The core of this program was taken from the manual of the clima chamber
  standing in RH5. Purpose of this program is to send a command to the
  climachamber in which the current temperature is requeste. As a response we
  get a string containing the current temperature. This string is written to a
  logfilefile. Each entry in the logfile also contains the current date as Unix
  epoch timestamp in integer. Sockets over TCP are used for communication
  between the climachamber and the PC. The current IP address of the
  climachamber can be obtained via the touchpad mounted on the clima chamber.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <iostream>
#include <fstream>


// We do not want the program to request data continously because this would
// bloat the logfile.
#define SLEEP_FOR_MICROSECONDS 1000000
/* special characters obtained from the climachamber manual */
#define STX 2 /* start of text */
#define ETX 3 /* end of text */
#define DLIM 182 /* delimiter */
#define ACK 6 /* Acknowledge */
#define NCK 15 /* not Acknowledge */

/*
  What to do in case of an error
 */
void error(const char *msg)
{
    perror(msg);
    exit(0);
}

/*
  As we use sockets for communication, we have to open them at some point. This
  is done here.
 */
int open_socket (unsigned short portno, int *sockfd, char *hostname[] )
{
    struct hostent *server;
    struct sockaddr_in serv_addr;

    if (*sockfd < 0)
        error("ERROR opening socket");
    server = gethostbyname(hostname[1]);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }


    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr,
          (char *)&serv_addr.sin_addr.s_addr,
          server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(*sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0)
        error("ERROR connecting");
    return 0;
}

/*
  Send a command to the climachamber.
 */
int send_command (int *sockfd, char *cmd)
{
    int n;
    n = write(*sockfd,cmd,strlen(cmd));
    if (n < 0)
        error("ERROR writing to socket");
    usleep(SLEEP_FOR_MICROSECONDS);

    return 0;
}

/*
  Fill the logfile
 */
int printArray(char * array, int MAX_CHAR)
{
    int i;
    FILE* fout = fopen("openSimpati_client.log","a+");      /* open the file in append mode */

    // Write current time in UNIX epoch integer representation to log file
    fprintf(fout , "%lu ", (unsigned long)time(NULL));

    // Write received string to logfile
    for (i=0; i<MAX_CHAR; i++)
    fprintf(fout,"%c",*(array+i)); /* write */
    fclose(fout);                       /* close the file pointer */

    return 0;
}

/*
  Receive answer, reads characters from socket.
*/
int receive_answer (int *sockfd)
{
    // char RecString [1000]; /* receive buffer */
    // int numrec; /* number of received characters */
    int n = 0;
    char buffer[256];

    bzero((char *) &buffer, sizeof(buffer));

    n = read(*sockfd,buffer,255);
    if (n < 0)
        error("ERROR reading from socket");

    buffer[n] = '\n'; /* terminate string" */
    printf ("\nAnswer from server: %s\n", buffer);
    printArray(buffer, sizeof(buffer));

    return 0;

}

/*
  Calculate the checksum. Taken from clima chamber manual
 */
char *Pruefsumme (char *buffer)
{
    const char ASCII[]="0123456789ABCDEF";
    static char Hex[10];
    static int a1, a2;
    register unsigned int i;
    int sum;

    sum = 256;
    for (i=0; i<strlen(buffer); i++)
    {
        sum -= buffer[i];
        if (sum<0)
            sum +=256;


    }
    a1 = (sum & 0xf0) >> 4;
    a2 = sum & 0x0f;
    Hex[0] = ASCII[a1];
    Hex[1] = ASCII[a2];
    Hex[2] = 0;

    // printf("\na1: %u, a2: %u, Hex String: %s",a1, a2, Hex);
    return(Hex);

}

int main(int argc, char *argv[])
{
    int sockfd, portno;
    char Command [100];

    if (argc < 3) {
       fprintf(stderr,"usage %s hostname port\n", argv[1]);
       exit(0);
    }
    portno = atoi(argv[2]);

    // /* Send ASCII-1 protocol command */
    // sockfd = socket(AF_INET, SOCK_STREAM, 0);
    // open_socket(portno, &sockfd, argv);
    // printf("\nASCII-1 protocol");
    // printf ("\n----------");
    // sprintf(Command , "%c1?", STX);
    // sprintf(Command , "%c1?%s%c", STX, Pruefsumme(Command), ETX);
    // printf("\nCommand: %s", Command);
    // send_command(&sockfd, Command);
    // receive_answer(&sockfd);
    // close(sockfd);
    // usleep(SLEEP_FOR_MICROSECONDS);

    while(1)
    {
    // /* Send ASCII-2 protocol command */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    open_socket(portno, &sockfd, argv);
    printf("\nASCII-2 protocol");
    printf("\n----------------");
    sprintf (Command , "$01I\r");
    send_command(&sockfd, Command);
    receive_answer(&sockfd);
    close(sockfd);
    usleep(SLEEP_FOR_MICROSECONDS);
    }

    // /*  Send SimServ command */
    // sockfd = socket(AF_INET, SOCK_STREAM, 0);
    // open_socket(portno, &sockfd, argv);
    // printf("\nSend SimServ command");
    // printf("\n----------------");
    // sprintf (Command, "11004%c1%c%d\r", DLIM, DLIM, 1);
    // send_command(&sockfd, Command);
    // receive_answer(&sockfd);
    // close(sockfd);

    return 0;
}
