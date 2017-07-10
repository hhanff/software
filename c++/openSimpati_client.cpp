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

int send_command (int *sockfd, char *cmd)
{
    int n;

    char buffer[256];

    n = write(*sockfd,cmd,strlen(cmd));
    if (n < 0)
        error("ERROR writing to socket");

    n = read(*sockfd,buffer,255);
    if (n < 0)
        error("ERROR reading from socket");
    printf("%s\n",buffer);

    return 0;
}

int main(int argc, char *argv[])
{
    int sockfd, portno;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    char Command [100];

    if (argc < 3) {
       fprintf(stderr,"usage %s hostname port\n", argv[0]);
       exit(0);
    }
    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
        error("ERROR opening socket");
    server = gethostbyname(argv[1]);
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
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0)
        error("ERROR connecting");

    sprintf(Command , "%c1?8E%c", STX, ETX);
    send_command(&sockfd, Command);

    close(sockfd);
    return 0;
}
