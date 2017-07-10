/* A simple client in the internet domain using TCP
   The port number and IP address is passed as an argument
   > g++ -Wall openSimpati_client.cpp -o openSimpati_client
   > sudo ./openSimpati_client 127.0.0.1 2080
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

/* special characters */
#define STX 2 /* start of text */
#define ETX 3 /* end of text */
#define DLIM 182 /* delimiter */

void error(const char *msg)
{
    perror(msg);
    exit(0);
}

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


int send_command (int *sockfd, char *cmd)
{
    int n;
    n = write(*sockfd,cmd,strlen(cmd));
    if (n < 0)
        error("ERROR writing to socket");
    sleep(1);

    return 0;
}

/* function: receive answer
   reads characters from socket
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

    return 0;

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

    /* Send ASCII-1 protocol command */

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    open_socket(portno, &sockfd, argv);
    printf("\nASCII-1 protocol");
    printf ("\n----------");
    sprintf(Command , "%c1?8E%c", STX, ETX);
    send_command(&sockfd, Command);
    receive_answer(&sockfd);
    close(sockfd);
    sleep(1);

    // /* Send ASCII-2 protocol command */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    open_socket(portno, &sockfd, argv);
    printf("\nASCII-2 protocol");
    printf("\n----------------");
    sprintf (Command , "$01I\r");
    send_command(&sockfd, Command);
    receive_answer(&sockfd);
    close(sockfd);
    sleep(1);

    /*  Send SimServ command */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    open_socket(portno, &sockfd, argv);
    printf("\nSend SimServ command");
    printf("\n----------------");
    sprintf (Command, "11004%c1%c%d\r", DLIM, DLIM, 1);
    send_command(&sockfd, Command);
    receive_answer(&sockfd);
    close(sockfd);

    return 0;
}
